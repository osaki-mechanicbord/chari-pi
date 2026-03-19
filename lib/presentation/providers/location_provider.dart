import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../data/models/ride_record.dart';
import '../../data/models/osm_node.dart';
import '../../core/utils/distance_calculator.dart' as utils;
import '../../core/services/osm_service.dart';
import '../../core/services/tts_service.dart';
import '../../core/services/vibration_service.dart';
import '../../core/utils/gps_kalman_filter.dart';

enum RideStatus { idle, tracking, paused }
enum GpsStatus { unavailable, searching, lowAccuracy, mediumAccuracy, highAccuracy }

class LocationProvider extends ChangeNotifier {
  // Current position
  double _latitude = 35.6812;
  double _longitude = 139.7671;
  double _accuracy = 0;
  double _speed = 0; // m/s
  double _heading = 0;

  // Ride state
  RideStatus _rideStatus = RideStatus.idle;
  GpsStatus _gpsStatus = GpsStatus.unavailable;
  double _totalDistance = 0;
  DateTime? _rideStartTime;
  int _warningsCount = 0;
  int _stopSignCount = 0;
  int _trafficSignalCount = 0;

  // OSM data
  final OSMService _osmService = OSMService();
  List<OSMNode> _nearbyNodes = [];
  List<OSMNode> _warningNodes = [];
  DateTime? _lastOsmFetch;
  static const Duration _osmFetchInterval = Duration(seconds: 10);
  static const double _osmFetchMinDistance = 50.0;
  double? _lastOsmFetchLat;
  double? _lastOsmFetchLon;

  // Warning deduplication: nodeId -> last alert stage
  final Map<int, int> _warnedNodeStages = {};
  static const double _warningResetDistance = 150.0;

  // Route tracking
  List<LatLng> _routePoints = [];
  double? _prevLat;
  double? _prevLon;
  DateTime? _lastPositionTime;

  // Storage
  Box<String>? _rideBox;

  // Settings (injected from SettingsProvider)
  double _alertDistance = 80.0;
  bool _voiceAlertEnabled = true;
  bool _vibrationAlertEnabled = true;
  String _localeCode = 'ja';

  // Alert services
  final TtsService _ttsService = TtsService();
  final VibrationService _vibrationService = VibrationService();

  // GPS Kalman filter for position smoothing
  final GpsKalmanFilter _kalmanFilter = GpsKalmanFilter();

  // GPS stream subscription
  StreamSubscription? _gpsSubscription;

  // Demo mode
  Timer? _demoTimer;
  int _demoStep = 0;
  bool _isDemoMode = false;

  // --- Getters ---
  double get latitude => _latitude;
  double get longitude => _longitude;
  double get accuracy => _accuracy;
  double get speed => _speed;
  double get speedKmh => _speed * 3.6;
  double get heading => _heading;
  RideStatus get rideStatus => _rideStatus;
  GpsStatus get gpsStatus => _gpsStatus;
  double get totalDistance => _totalDistance;
  DateTime? get rideStartTime => _rideStartTime;
  int get warningsCount => _warningsCount;
  List<OSMNode> get nearbyNodes => _nearbyNodes;
  List<OSMNode> get warningNodes => _warningNodes;
  List<LatLng> get routePoints => _routePoints;
  bool get isDemoMode => _isDemoMode;
  LatLng get currentPosition => LatLng(_latitude, _longitude);

  Duration get rideDuration {
    if (_rideStartTime == null) return Duration.zero;
    return DateTime.now().difference(_rideStartTime!);
  }

  // --- Initialization ---
  Future<void> initialize() async {
    _rideBox = await Hive.openBox<String>('ride_history');
    await _ttsService.initialize();
  }

  void setAlertDistance(double distance) {
    _alertDistance = distance;
  }

  void setVoiceAlert(bool enabled) {
    _voiceAlertEnabled = enabled;
  }

  void setVibrationAlert(bool enabled) {
    _vibrationAlertEnabled = enabled;
  }

  void setLocaleCode(String code) {
    _localeCode = code;
    _ttsService.setLanguage(code);
  }

  // --- GPS Position Handling ---
  void onPositionUpdate(double lat, double lon, double accuracy, double speed, double heading) {
    final now = DateTime.now();

    _gpsStatus = _classifyAccuracy(accuracy);

    // Filter jitter: ignore updates with >100m accuracy
    if (accuracy > 100) return;

    // Apply Kalman filter for position smoothing
    final filtered = _kalmanFilter.process(
      rawLat: lat,
      rawLon: lon,
      accuracy: accuracy,
      rawSpeed: speed.isNaN || speed < 0 ? 0 : speed,
      rawHeading: heading.isNaN ? _heading : heading,
    );

    final smoothLat = filtered.lat;
    final smoothLon = filtered.lon;
    final smoothHeading = filtered.heading;
    final smoothSpeed = filtered.speed;

    // Calculate distance from previous point
    if (_prevLat != null && _prevLon != null) {
      final dist = utils.DistanceCalculator.calculateDistance(
        _prevLat!, _prevLon!, smoothLat, smoothLon,
      );

      final timeDiff = _lastPositionTime != null
          ? now.difference(_lastPositionTime!).inMilliseconds
          : 5000;
      if (dist < 1.0 && timeDiff < 3000) return;

      if (_rideStatus == RideStatus.tracking) {
        if (dist < 500) {
          _totalDistance += dist;
        }
      }
    }

    _prevLat = smoothLat;
    _prevLon = smoothLon;
    _lastPositionTime = now;

    _latitude = smoothLat;
    _longitude = smoothLon;
    _accuracy = accuracy;
    _speed = smoothSpeed;
    _heading = smoothHeading;

    // Add route point when tracking
    if (_rideStatus == RideStatus.tracking) {
      if (_routePoints.isEmpty) {
        _routePoints.add(LatLng(smoothLat, smoothLon));
      } else {
        final lastPt = _routePoints.last;
        final distFromLast = utils.DistanceCalculator.calculateDistance(
          lastPt.latitude, lastPt.longitude, smoothLat, smoothLon,
        );
        if (distFromLast >= 5.0) {
          _routePoints.add(LatLng(smoothLat, smoothLon));
        }
      }
    }

    _fetchOsmDataIfNeeded(smoothLat, smoothLon);
    _updateWarnings(smoothLat, smoothLon);

    notifyListeners();
  }

  GpsStatus _classifyAccuracy(double accuracy) {
    if (accuracy <= 5) return GpsStatus.highAccuracy;
    if (accuracy <= 15) return GpsStatus.mediumAccuracy;
    if (accuracy <= 50) return GpsStatus.lowAccuracy;
    return GpsStatus.searching;
  }

  // --- OSM Data Fetching ---
  Future<void> _fetchOsmDataIfNeeded(double lat, double lon) async {
    final now = DateTime.now();

    if (_lastOsmFetch != null && now.difference(_lastOsmFetch!) < _osmFetchInterval) {
      return;
    }

    if (_lastOsmFetchLat != null && _lastOsmFetchLon != null) {
      final dist = utils.DistanceCalculator.calculateDistance(
        _lastOsmFetchLat!, _lastOsmFetchLon!, lat, lon,
      );
      if (dist < _osmFetchMinDistance) return;
    }

    _lastOsmFetch = now;
    _lastOsmFetchLat = lat;
    _lastOsmFetchLon = lon;

    try {
      final nodes = await _osmService.fetchNearbyNodes(lat, lon);
      _nearbyNodes = nodes;
      _updateWarnings(lat, lon);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('OSM fetch error: $e');
      }
    }
  }

  Future<void> refreshOsmData() async {
    _lastOsmFetch = null;
    _lastOsmFetchLat = null;
    _lastOsmFetchLon = null;
    await _fetchOsmDataIfNeeded(_latitude, _longitude);
  }

  // --- Enhanced Warning System with 3-stage alerts + wrong-way detection ---
  void _updateWarnings(double lat, double lon) {
    final userPos = LatLng(lat, lon);

    // Update distances and perform wrong-way detection for all nearby nodes
    final updatedNodes = _nearbyNodes.map((node) {
      double distance;
      // Use way-based distance for linear features (more accurate)
      if (node.wayNodes != null && node.wayNodes!.length >= 2) {
        distance = OSMNode.distanceToWay(userPos, node.wayNodes!);
      } else {
        distance = utils.DistanceCalculator.calculateDistance(
          lat, lon, node.position.latitude, node.position.longitude,
        );
      }

      // Wrong-way detection for oneway roads
      bool wrongWay = node.isWrongWay;
      WarningLevel? level = node.warningLevel;

      if (node.type == OSMNodeType.oneway && node.wayBearing != null) {
        // Only check wrong-way if user is close to the road (<15m)
        if (distance < 15 && _heading > 0) {
          wrongWay = OSMNode.isGoingWrongWay(_heading, node.wayBearing!);
        } else {
          wrongWay = false;
        }
      }

      // Determine warning level based on type and distance
      level = _classifyWarningLevel(node.type, distance, wrongWay);

      return node.copyWith(
        distanceFromUser: distance,
        isWrongWay: wrongWay,
        warningLevel: level,
      );
    }).toList()
      ..sort((a, b) => (a.distanceFromUser ?? 0).compareTo(b.distanceFromUser ?? 0));

    _nearbyNodes = updatedNodes;

    // Collect all active warnings (within extended alert distance)
    final maxAlertDist = _alertDistance * 1.6; // wider detection radius
    final activeWarnings = updatedNodes.where((n) {
      final dist = n.distanceFromUser ?? double.infinity;
      if (dist > maxAlertDist) return false;
      // Must have an alert stage > 0
      final stage = _ttsService.getAlertStage(dist, n.type);
      return stage > 0;
    }).toList();

    // Sort by penalty risk (highest first), then distance
    activeWarnings.sort((a, b) {
      final riskCmp = b.penaltyRisk.compareTo(a.penaltyRisk);
      if (riskCmp != 0) return riskCmp;
      return (a.distanceFromUser ?? 0).compareTo(b.distanceFromUser ?? 0);
    });

    // 3-stage alert triggers for tracking mode
    if (_rideStatus == RideStatus.tracking) {
      for (final node in activeWarnings) {
        final dist = node.distanceFromUser ?? double.infinity;
        final stage = _ttsService.getAlertStage(dist, node.type);
        if (stage <= 0) continue;

        final prevStage = _warnedNodeStages[node.id] ?? 0;

        // Trigger alert only when entering a new (higher) stage
        if (stage > prevStage) {
          _warnedNodeStages[node.id] = stage;
          _triggerAlerts(node, stage);

          if (prevStage == 0) {
            _warningsCount++;
            if (node.type == OSMNodeType.stopSign) _stopSignCount++;
            if (node.type == OSMNodeType.trafficSignal) _trafficSignalCount++;
          }
        }
      }
    }

    // Reset alerts for nodes the user has moved far away from
    _warnedNodeStages.removeWhere((id, _) {
      final node = updatedNodes.where((n) => n.id == id).firstOrNull;
      if (node == null) return true;
      return (node.distanceFromUser ?? double.infinity) > _warningResetDistance;
    });

    // Show top warnings in banner (max 3, sorted by risk)
    _warningNodes = activeWarnings.take(3).toList();
  }

  /// Classify warning level based on type and distance
  WarningLevel _classifyWarningLevel(OSMNodeType type, double distance, bool isWrongWay) {
    switch (type) {
      case OSMNodeType.oneway:
        if (isWrongWay) return WarningLevel.danger;
        if (distance < 30) return WarningLevel.warning;
        return WarningLevel.caution;

      case OSMNodeType.pedestrianRoad:
      case OSMNodeType.footwayNoBicycle:
      case OSMNodeType.noBicycle:
        if (distance < 10) return WarningLevel.danger;
        if (distance < 30) return WarningLevel.warning;
        return WarningLevel.caution;

      case OSMNodeType.stopSign:
        if (distance < 15) return WarningLevel.danger;
        if (distance < 40) return WarningLevel.warning;
        return WarningLevel.caution;

      case OSMNodeType.trafficSignal:
      case OSMNodeType.crossing:
        if (distance < 15) return WarningLevel.warning;
        return WarningLevel.caution;

      case OSMNodeType.footway:
      case OSMNodeType.dismount:
        if (distance < 8) return WarningLevel.warning;
        return WarningLevel.caution;

      case OSMNodeType.enforcementZone:
      case OSMNodeType.accidentZone:
        if (distance < 100) return WarningLevel.caution;
        return WarningLevel.info;

      case OSMNodeType.cycleway:
      case OSMNodeType.speedLimit:
        return WarningLevel.info;
    }
  }

  // --- Alert Triggers (TTS + Vibration) with 3-stage system ---
  void _triggerAlerts(OSMNode node, int stage) {
    // Voice alert with detailed 3-stage messages
    if (_voiceAlertEnabled) {
      final message = _ttsService.getDetailedMessage(
        node, stage, _localeCode,
        userSpeed: speedKmh,
      );
      if (message.isNotEmpty) {
        final level = node.warningLevel ?? WarningLevel.caution;
        _ttsService.speakByLevel(message, level);
      }
    }

    // Vibration alert scaled by stage
    if (_vibrationAlertEnabled) {
      switch (stage) {
        case 3:
          _vibrationService.urgentVibrate();
        case 2:
          _vibrationService.warningVibrate();
        case 1:
          _vibrationService.lightVibrate();
      }
    }
  }

  // --- Ride Control ---
  void startRide({bool demoMode = false}) {
    _rideStatus = RideStatus.tracking;
    _rideStartTime = DateTime.now();
    _totalDistance = 0;
    _warningsCount = 0;
    _stopSignCount = 0;
    _trafficSignalCount = 0;
    _routePoints = [];
    _warnedNodeStages.clear();
    _prevLat = null;
    _prevLon = null;
    _isDemoMode = demoMode;
    _kalmanFilter.reset();

    try {
      WakelockPlus.enable();
    } catch (e) {
      if (kDebugMode) debugPrint('WakelockPlus.enable() failed: $e');
    }

    if (demoMode) {
      _startDemoSimulation();
    }

    notifyListeners();
  }

  void pauseRide() {
    _rideStatus = RideStatus.paused;
    if (_isDemoMode) _demoTimer?.cancel();
    notifyListeners();
  }

  void resumeRide() {
    _rideStatus = RideStatus.tracking;
    if (_isDemoMode) _startDemoSimulation();
    notifyListeners();
  }

  void stopRide() {
    if (_isDemoMode) _demoTimer?.cancel();
    if (_rideStartTime != null && _totalDistance > 10) {
      _saveRideRecord();
    }
    _rideStatus = RideStatus.idle;
    _rideStartTime = null;
    _isDemoMode = false;
    _warningNodes = [];
    _warnedNodeStages.clear();

    try {
      WakelockPlus.disable();
    } catch (e) {
      if (kDebugMode) debugPrint('WakelockPlus.disable() failed: $e');
    }
    _ttsService.stop();

    notifyListeners();
  }

  // --- Enhanced Demo Mode with all node types ---
  void _startDemoSimulation() {
    _demoTimer?.cancel();
    _demoStep = 0;

    // Realistic route near Shibuya Station
    final demoRoute = [
      [35.6580, 139.7016], [35.6583, 139.7020], [35.6586, 139.7025],
      [35.6590, 139.7028], [35.6594, 139.7032], [35.6598, 139.7035],
      [35.6602, 139.7038], [35.6606, 139.7042], [35.6610, 139.7045],
      [35.6614, 139.7048], [35.6618, 139.7052], [35.6622, 139.7055],
      [35.6625, 139.7058], [35.6628, 139.7062], [35.6631, 139.7065],
      [35.6634, 139.7068], [35.6637, 139.7072], [35.6640, 139.7075],
      [35.6643, 139.7078], [35.6646, 139.7082],
    ];

    // Simulated traffic features covering all critical types
    _nearbyNodes = [
      OSMNode(id: 90001, type: OSMNodeType.stopSign,
        position: const LatLng(35.6594, 139.7033),
        tags: const {'highway': 'stop'}),
      OSMNode(id: 90002, type: OSMNodeType.trafficSignal,
        position: const LatLng(35.6610, 139.7046),
        tags: const {'highway': 'traffic_signals'}),
      OSMNode(id: 90003, type: OSMNodeType.oneway,
        position: const LatLng(35.6602, 139.7040),
        tags: const {'oneway': 'yes'},
        wayBearing: 45.0,
        wayNodes: const [LatLng(35.6598, 139.7035), LatLng(35.6606, 139.7045)]),
      OSMNode(id: 90004, type: OSMNodeType.pedestrianRoad,
        position: const LatLng(35.6618, 139.7053),
        tags: const {'highway': 'pedestrian'},
        wayNodes: const [LatLng(35.6616, 139.7050), LatLng(35.6620, 139.7056)]),
      OSMNode(id: 90005, type: OSMNodeType.crossing,
        position: const LatLng(35.6625, 139.7059),
        tags: const {'highway': 'crossing'}),
      OSMNode(id: 90006, type: OSMNodeType.cycleway,
        position: const LatLng(35.6631, 139.7066),
        tags: const {'highway': 'cycleway'},
        wayNodes: const [LatLng(35.6628, 139.7062), LatLng(35.6634, 139.7070)]),
      OSMNode(id: 90007, type: OSMNodeType.footway,
        position: const LatLng(35.6637, 139.7073),
        tags: const {'highway': 'footway'},
        wayNodes: const [LatLng(35.6635, 139.7070), LatLng(35.6639, 139.7076)]),
      OSMNode(id: 90008, type: OSMNodeType.stopSign,
        position: const LatLng(35.6646, 139.7083),
        tags: const {'highway': 'stop'}),
    ];

    _demoTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_rideStatus != RideStatus.tracking) return;
      if (_demoStep >= demoRoute.length) _demoStep = 0;

      final lat = demoRoute[_demoStep][0];
      final lon = demoRoute[_demoStep][1];
      final acc = 5.0 + (_demoStep % 3) * 2.0;
      final spd = 3.5 + (_demoStep % 5) * 0.8;
      final hdg = (_demoStep * 12.0) % 360;

      onPositionUpdate(lat, lon, acc, spd, hdg);
      _demoStep++;
    });
  }

  // --- Persistence ---
  void _saveRideRecord() {
    if (_rideBox == null) return;
    final record = RideRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: _rideStartTime!,
      endTime: DateTime.now(),
      distanceMeters: _totalDistance,
      warningsCount: _warningsCount,
      stopSignCount: _stopSignCount,
      trafficSignalCount: _trafficSignalCount,
      routePoints: _routePoints.map((p) => {'lat': p.latitude, 'lon': p.longitude}).toList(),
    );
    _rideBox!.put(record.id, json.encode(record.toJson()));
  }

  List<RideRecord> getRideHistory() {
    if (_rideBox == null) return [];
    final records = <RideRecord>[];
    for (final key in _rideBox!.keys) {
      try {
        final jsonStr = _rideBox!.get(key);
        if (jsonStr != null) {
          records.add(RideRecord.fromJson(json.decode(jsonStr)));
        }
      } catch (_) {}
    }
    records.sort((a, b) => b.startTime.compareTo(a.startTime));
    return records;
  }

  void clearHistory() {
    _rideBox?.clear();
    notifyListeners();
  }

  // --- Cleanup ---
  @override
  void dispose() {
    _demoTimer?.cancel();
    _gpsSubscription?.cancel();
    try { WakelockPlus.disable(); } catch (_) {}
    _ttsService.dispose();
    super.dispose();
  }
}
