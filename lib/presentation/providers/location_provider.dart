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
  static const double _osmFetchMinDistance = 50.0; // meters before re-fetching
  double? _lastOsmFetchLat;
  double? _lastOsmFetchLon;

  // Warning deduplication
  final Set<int> _warnedNodeIds = {};
  static const double _warningResetDistance = 150.0; // reset warning after moving away

  // Route tracking
  List<LatLng> _routePoints = [];
  double? _prevLat;
  double? _prevLon;
  DateTime? _lastPositionTime;

  // Storage
  Box<String>? _rideBox;

  // Settings (injected from SettingsProvider)
  double _alertDistance = 50.0;
  bool _voiceAlertEnabled = true;
  bool _vibrationAlertEnabled = true;
  String _localeCode = 'ja';

  // Alert services
  final TtsService _ttsService = TtsService();
  final VibrationService _vibrationService = VibrationService();

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

  // --- GPS Position Handling (called by platform-specific code) ---
  void onPositionUpdate(double lat, double lon, double accuracy, double speed, double heading) {
    final now = DateTime.now();

    // Update GPS status
    _gpsStatus = _classifyAccuracy(accuracy);

    // Filter jitter: ignore updates with >100m accuracy
    if (accuracy > 100) return;

    // Calculate distance from previous point
    if (_prevLat != null && _prevLon != null) {
      final dist = utils.DistanceCalculator.calculateDistance(
        _prevLat!, _prevLon!, lat, lon,
      );

      // Filter GPS noise: ignore micro-movements (<1m) unless enough time passed
      final timeDiff = _lastPositionTime != null
          ? now.difference(_lastPositionTime!).inMilliseconds
          : 5000;
      if (dist < 1.0 && timeDiff < 3000) return;

      // Accumulate distance only when tracking
      if (_rideStatus == RideStatus.tracking) {
        // Filter unreasonable jumps (>500m in single update = GPS glitch)
        if (dist < 500) {
          _totalDistance += dist;
        }
      }
    }

    // Store previous position
    _prevLat = lat;
    _prevLon = lon;
    _lastPositionTime = now;

    // Update current position
    _latitude = lat;
    _longitude = lon;
    _accuracy = accuracy;
    _speed = speed.isNaN || speed < 0 ? 0 : speed;
    _heading = heading.isNaN ? _heading : heading;

    // Add route point when tracking (every 5m+)
    if (_rideStatus == RideStatus.tracking) {
      if (_routePoints.isEmpty) {
        _routePoints.add(LatLng(lat, lon));
      } else {
        final lastPt = _routePoints.last;
        final distFromLast = utils.DistanceCalculator.calculateDistance(
          lastPt.latitude, lastPt.longitude, lat, lon,
        );
        if (distFromLast >= 5.0) {
          _routePoints.add(LatLng(lat, lon));
        }
      }
    }

    // Fetch OSM data periodically
    _fetchOsmDataIfNeeded(lat, lon);

    // Update warning distances
    _updateWarnings(lat, lon);

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

    // Throttle: minimum interval between fetches
    if (_lastOsmFetch != null && now.difference(_lastOsmFetch!) < _osmFetchInterval) {
      return;
    }

    // Distance check: only fetch if moved enough
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
      // Keep existing data on fetch failure
      if (kDebugMode) {
        debugPrint('OSM fetch error: $e');
      }
    }
  }

  /// Force a fresh OSM fetch at the current position
  Future<void> refreshOsmData() async {
    _lastOsmFetch = null;
    _lastOsmFetchLat = null;
    _lastOsmFetchLon = null;
    await _fetchOsmDataIfNeeded(_latitude, _longitude);
  }

  // --- Warning System ---
  void _updateWarnings(double lat, double lon) {
    // Update distances for all nearby nodes
    final updatedNodes = _nearbyNodes.map((node) {
      final dist = utils.DistanceCalculator.calculateDistance(
        lat, lon,
        node.position.latitude, node.position.longitude,
      );
      return node.copyWith(distanceFromUser: dist);
    }).toList()
      ..sort((a, b) => (a.distanceFromUser ?? 0).compareTo(b.distanceFromUser ?? 0));

    _nearbyNodes = updatedNodes;

    // Find nodes within alert distance
    final newWarnings = updatedNodes
        .where((n) => (n.distanceFromUser ?? double.infinity) <= _alertDistance)
        .toList();

    // Deduplication: only warn once per node until user moves away
    final freshWarnings = <OSMNode>[];
    for (final node in newWarnings) {
      if (!_warnedNodeIds.contains(node.id)) {
        freshWarnings.add(node);
        _warnedNodeIds.add(node.id);
        _warningsCount++;
        if (node.type == OSMNodeType.stopSign) _stopSignCount++;
        if (node.type == OSMNodeType.trafficSignal) _trafficSignalCount++;

        // Trigger alerts for fresh warnings only
        if (_rideStatus == RideStatus.tracking) {
          _triggerAlerts(node);
        }
      }
    }

    // Reset warning for nodes the user has moved far away from
    _warnedNodeIds.removeWhere((id) {
      final node = updatedNodes.where((n) => n.id == id).firstOrNull;
      if (node == null) return true; // Node no longer in nearby list
      return (node.distanceFromUser ?? double.infinity) > _warningResetDistance;
    });

    // Show all active warnings (within alert distance, including already-warned)
    _warningNodes = newWarnings;
  }

  // --- Alert Triggers (TTS + Vibration) ---
  void _triggerAlerts(OSMNode node) {
    final dist = node.distanceFromUser?.round() ?? 0;
    final isUrgent = dist <= 20;

    // Voice alert
    if (_voiceAlertEnabled) {
      final message = _getWarningMessage(node, dist);
      if (isUrgent) {
        _ttsService.speakUrgentAlert(message);
      } else {
        _ttsService.speakWarning(message, priority: node.type == OSMNodeType.stopSign);
      }
    }

    // Vibration alert
    if (_vibrationAlertEnabled) {
      if (isUrgent) {
        _vibrationService.urgentVibrate();
      } else {
        _vibrationService.warningVibrate();
      }
    }
  }

  String _getWarningMessage(OSMNode node, int distance) {
    // Multi-language warning messages
    switch (_localeCode) {
      case 'en':
        switch (node.type) {
          case OSMNodeType.stopSign:
            return 'Stop sign ahead, $distance meters';
          case OSMNodeType.trafficSignal:
            return 'Traffic signal ahead, $distance meters';
          case OSMNodeType.oneway:
            return 'One-way street ahead, $distance meters';
        }
      case 'ko':
        switch (node.type) {
          case OSMNodeType.stopSign:
            return '${distance}\uBBF8\uD130 \uC55E \uC77C\uC2DC\uC815\uC9C0';
          case OSMNodeType.trafficSignal:
            return '${distance}\uBBF8\uD130 \uC55E \uC2E0\uD638\uB4F1';
          case OSMNodeType.oneway:
            return '${distance}\uBBF8\uD130 \uC55E \uC77C\uBC29\uD1B5\uD589';
        }
      case 'zh':
        switch (node.type) {
          case OSMNodeType.stopSign:
            return '\u524D\u65B9${distance}\u7C73\u6709\u505C\u8F66\u6807\u5FD7';
          case OSMNodeType.trafficSignal:
            return '\u524D\u65B9${distance}\u7C73\u6709\u4EA4\u901A\u4FE1\u53F7\u706F';
          case OSMNodeType.oneway:
            return '\u524D\u65B9${distance}\u7C73\u5355\u884C\u9053';
        }
      default: // ja
        switch (node.type) {
          case OSMNodeType.stopSign:
            return '${distance}\u30E1\u30FC\u30C8\u30EB\u5148\u306B\u4E00\u6642\u505C\u6B62';
          case OSMNodeType.trafficSignal:
            return '${distance}\u30E1\u30FC\u30C8\u30EB\u5148\u306B\u4FE1\u53F7\u6A5F';
          case OSMNodeType.oneway:
            return '${distance}\u30E1\u30FC\u30C8\u30EB\u5148\u306B\u4E00\u65B9\u901A\u884C';
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
    _warnedNodeIds.clear();
    _prevLat = null;
    _prevLon = null;
    _isDemoMode = demoMode;

    // Keep screen on during ride
    WakelockPlus.enable();

    if (demoMode) {
      _startDemoSimulation();
    }
    // If not demo, GPS stream should already be feeding onPositionUpdate()

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
    _warnedNodeIds.clear();

    // Release screen lock and stop TTS
    WakelockPlus.disable();
    _ttsService.stop();

    notifyListeners();
  }

  // --- Demo Mode (fallback when GPS unavailable) ---
  void _startDemoSimulation() {
    _demoTimer?.cancel();
    _demoStep = 0;

    // Realistic route near Shibuya Station with actual OSM-like data
    final demoRoute = [
      [35.6580, 139.7016], [35.6583, 139.7020], [35.6586, 139.7025],
      [35.6590, 139.7028], [35.6594, 139.7032], [35.6598, 139.7035],
      [35.6602, 139.7038], [35.6606, 139.7042], [35.6610, 139.7045],
      [35.6614, 139.7048], [35.6618, 139.7052], [35.6622, 139.7055],
      [35.6625, 139.7058], [35.6628, 139.7062], [35.6631, 139.7065],
      [35.6634, 139.7068], [35.6637, 139.7072], [35.6640, 139.7075],
      [35.6643, 139.7078], [35.6646, 139.7082],
    ];

    // Simulated real-world traffic features
    _nearbyNodes = [
      OSMNode(id: 90001, type: OSMNodeType.stopSign, position: const LatLng(35.6594, 139.7033), tags: {'highway': 'stop'}),
      OSMNode(id: 90002, type: OSMNodeType.trafficSignal, position: const LatLng(35.6610, 139.7046), tags: {'highway': 'traffic_signals'}),
      OSMNode(id: 90003, type: OSMNodeType.stopSign, position: const LatLng(35.6625, 139.7059), tags: {'highway': 'stop'}),
      OSMNode(id: 90004, type: OSMNodeType.trafficSignal, position: const LatLng(35.6637, 139.7073), tags: {'highway': 'traffic_signals'}),
      OSMNode(id: 90005, type: OSMNodeType.stopSign, position: const LatLng(35.6646, 139.7083), tags: {'highway': 'stop'}),
    ];

    _demoTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_rideStatus != RideStatus.tracking) return;
      if (_demoStep >= demoRoute.length) _demoStep = 0;

      final lat = demoRoute[_demoStep][0];
      final lon = demoRoute[_demoStep][1];
      final acc = 5.0 + (_demoStep % 3) * 2.0;
      final spd = 3.5 + (_demoStep % 5) * 0.8; // m/s (12-17 km/h)
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
    WakelockPlus.disable();
    _ttsService.dispose();
    super.dispose();
  }
}
