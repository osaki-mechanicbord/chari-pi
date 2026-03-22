import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:provider/provider.dart';
import 'package:cycle_guard/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/distance_calculator.dart' as utils;
import '../../data/models/osm_node.dart';
import '../providers/location_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/warning_banner.dart';
import '../widgets/gps_accuracy_indicator.dart';

// Conditional import for Web GPS
import 'navigation_screen_web.dart' if (dart.library.io) 'navigation_screen_stub.dart' as platform;

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> with WidgetsBindingObserver {
  GoogleMapController? _mapController;
  bool _followUser = true;
  bool _gpsInitialized = false;
  StreamSubscription? _gpsSubscription;
  Timer? _durationTimer;
  String? _gpsError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPermissionExplanationIfNeeded();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _gpsInitialized) {
      _initializeGps();
    }
  }

  Future<void> _showPermissionExplanationIfNeeded() async {
    // On web, just initialize directly (browser handles permission dialog)
    if (kIsWeb) {
      _initializeGps();
      return;
    }
    // On mobile, show explanation first then initialize (geolocator handles actual request)
    _initializeGps();
  }

  Future<void> _initializeGps() async {
    if (_gpsInitialized) return;
    _gpsInitialized = true;

    final provider = context.read<LocationProvider>();
    final settings = context.read<SettingsProvider>();
    provider.setAlertDistance(settings.alertDistance);
    provider.setVoiceAlert(settings.voiceAlert);
    provider.setVibrationAlert(settings.vibrationAlert);
    provider.setLocaleCode(settings.locale.languageCode);

    _gpsSubscription = platform.startGpsStream(
      onPosition: (lat, lon, accuracy, speed, heading) {
        if (_gpsError != null) {
          setState(() => _gpsError = null);
        }
        provider.onPositionUpdate(lat, lon, accuracy, speed, heading);
      },
      onError: (error) {
        if (kDebugMode) debugPrint('GPS Error: $error');
        setState(() {
          if (error.contains('DENIED_FOREVER')) {
            _gpsError = 'denied_forever';
          } else if (error.contains('DENIED')) {
            _gpsError = 'denied';
          } else if (error.contains('DISABLED')) {
            _gpsError = 'disabled';
          }
        });
      },
    );

    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (provider.rideStatus == RideStatus.tracking) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _gpsSubscription?.cancel();
    _durationTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  /// Convert latlong2.LatLng to google_maps_flutter.LatLng
  LatLng _toGoogleLatLng(ll.LatLng pos) {
    return LatLng(pos.latitude, pos.longitude);
  }

  /// Move camera to position
  void _animateToPosition(LatLng pos) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(pos),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return Consumer2<LocationProvider, SettingsProvider>(
      builder: (context, locationProvider, settings, child) {
        locationProvider.setAlertDistance(settings.alertDistance);
        locationProvider.setVoiceAlert(settings.voiceAlert);
        locationProvider.setVibrationAlert(settings.vibrationAlert);
        locationProvider.setLocaleCode(settings.locale.languageCode);

        final currentPos = LatLng(
          locationProvider.latitude,
          locationProvider.longitude,
        );

        if (_followUser && locationProvider.rideStatus == RideStatus.tracking) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _animateToPosition(currentPos);
          });
        }

        // Build markers
        final markers = _buildOSMMarkers(locationProvider.nearbyNodes);
        // Add user position marker
        markers.add(
          Marker(
            markerId: const MarkerId('user_position'),
            position: currentPos,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
            anchor: const Offset(0.5, 0.5),
            zIndexInt: 100,
            rotation: locationProvider.heading,
          ),
        );

        // Build polylines
        final polylines = <Polyline>{};

        // Route trail
        if (locationProvider.routePoints.length >= 2) {
          polylines.add(
            Polyline(
              polylineId: const PolylineId('route_trail'),
              points: locationProvider.routePoints
                  .map((p) => _toGoogleLatLng(p))
                  .toList(),
              color: AppColors.accentCyan,
              width: 4,
            ),
          );
        }

        // Cycleway overlays
        polylines.addAll(_buildCyclewayPolylines(locationProvider.nearbyNodes));

        // Build circles
        final circles = <Circle>{};
        if (locationProvider.rideStatus == RideStatus.tracking) {
          circles.add(
            Circle(
              circleId: const CircleId('accuracy'),
              center: currentPos,
              radius: locationProvider.accuracy.clamp(3, 100),
              fillColor: AppColors.accentCyan.withValues(alpha: 0.12),
              strokeColor: AppColors.accentCyan.withValues(alpha: 0.4),
              strokeWidth: 1,
            ),
          );
        }

        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentPos,
                zoom: 17.0,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
              },
              onCameraMoveStarted: () {
                // User gesture detected: disable auto-follow
                if (_followUser) {
                  setState(() => _followUser = false);
                }
              },
              onCameraMove: (position) {
                // Will detect manual gestures in onCameraIdle
              },
              onCameraIdle: () {
                // No-op: gesture detection handled via _followUser flag
              },
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: true,
              minMaxZoomPreference: const MinMaxZoomPreference(13.0, 19.0),
              markers: markers,
              polylines: polylines,
              circles: circles,

            ),



            if (locationProvider.warningNodes.isNotEmpty)
              Positioned(
                top: 0, left: 0, right: 0,
                child: WarningBanner(warnings: locationProvider.warningNodes),
              ),

            // GPS Permission Error Banner
            if (_gpsError != null)
              Positioned(
                top: 0, left: 0, right: 0,
                child: _buildGpsErrorBanner(l),
              ),

            Positioned(
              top: 12, right: 12,
              child: GpsAccuracyIndicator(
                accuracy: locationProvider.accuracy,
                isTracking: locationProvider.rideStatus == RideStatus.tracking,
              ),
            ),

            if (locationProvider.isDemoMode && locationProvider.rideStatus == RideStatus.tracking)
              Positioned(
                top: 12, left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.science, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(l.demoMode, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),

            if (locationProvider.rideStatus == RideStatus.tracking)
              Positioned(
                bottom: 100, left: 12,
                child: _buildInfoCard(locationProvider, l),
              ),

            if (!_followUser)
              Positioned(
                bottom: 100, right: 12,
                child: FloatingActionButton.small(
                  heroTag: 'recenter',
                  onPressed: () {
                    setState(() => _followUser = true);
                    _animateToPosition(currentPos);
                  },
                  backgroundColor: AppColors.bgCard.withValues(alpha: 0.9),
                  child: const Icon(Icons.my_location, color: AppColors.accentCyan),
                ),
              ),

            if (locationProvider.rideStatus == RideStatus.tracking)
              Positioned(
                bottom: 100, right: _followUser ? 12 : 60,
                child: FloatingActionButton.small(
                  heroTag: 'osmrefresh',
                  onPressed: () => locationProvider.refreshOsmData(),
                  backgroundColor: AppColors.bgCard.withValues(alpha: 0.9),
                  child: const Icon(Icons.refresh, color: AppColors.accentGreen, size: 20),
                ),
              ),

            Positioned(
              bottom: 20, left: 0, right: 0,
              child: Center(child: _buildRideButton(locationProvider, l)),
            ),
          ],
        );
      },
    );
  }

  /// Build cycleway polylines for bicycle lanes
  Set<Polyline> _buildCyclewayPolylines(List<OSMNode> nodes) {
    final cycleways = nodes.where((n) =>
      n.type == OSMNodeType.cycleway &&
      n.wayNodes != null &&
      n.wayNodes!.length >= 2
    ).toList();

    return cycleways.asMap().entries.map((entry) {
      return Polyline(
        polylineId: PolylineId('cycleway_${entry.key}'),
        points: entry.value.wayNodes!.map((p) => _toGoogleLatLng(p)).toList(),
        color: AppColors.accentGreen.withValues(alpha: 0.6),
        width: 5,
        patterns: [PatternItem.dot, PatternItem.gap(10)],
      );
    }).toSet();
  }

  /// Build map markers for all OSM node types
  Set<Marker> _buildOSMMarkers(List<OSMNode> nodes) {
    return nodes
        .where((n) => (n.distanceFromUser ?? double.infinity) <= 300)
        .map((node) {
      final config = _getMarkerConfig(node);

      return Marker(
        markerId: MarkerId('osm_${node.id}'),
        position: _toGoogleLatLng(node.position),
        icon: BitmapDescriptor.defaultMarkerWithHue(config.hue),
        zIndexInt: node.penaltyRisk,
        infoWindow: InfoWindow(
          title: node.typeLabel,
          snippet: node.distanceFromUser != null
              ? '${node.distanceFromUser!.round()}m'
              : '',
        ),
      );
    }).toSet();
  }

  _MarkerConfig _getMarkerConfig(OSMNode node) {
    switch (node.type) {
      case OSMNodeType.stopSign:
        return _MarkerConfig(Icons.front_hand, AppColors.danger, BitmapDescriptor.hueRed);
      case OSMNodeType.trafficSignal:
        return _MarkerConfig(Icons.traffic, AppColors.warning, BitmapDescriptor.hueOrange);
      case OSMNodeType.oneway:
        return node.isWrongWay
          ? _MarkerConfig(Icons.warning_amber, AppColors.danger, BitmapDescriptor.hueRed)
          : _MarkerConfig(Icons.arrow_forward, AppColors.info, BitmapDescriptor.hueAzure);
      case OSMNodeType.pedestrianRoad:
        return _MarkerConfig(Icons.directions_walk, const Color(0xFFE91E63), BitmapDescriptor.hueRose);
      case OSMNodeType.footway:
        return _MarkerConfig(Icons.directions_walk, const Color(0xFFFF9800), BitmapDescriptor.hueOrange);
      case OSMNodeType.footwayNoBicycle:
        return _MarkerConfig(Icons.no_transfer, AppColors.danger, BitmapDescriptor.hueRed);
      case OSMNodeType.cycleway:
        return _MarkerConfig(Icons.pedal_bike, AppColors.accentGreen, BitmapDescriptor.hueGreen);
      case OSMNodeType.crossing:
        return _MarkerConfig(Icons.transfer_within_a_station, const Color(0xFF2196F3), BitmapDescriptor.hueBlue);
      case OSMNodeType.noBicycle:
        return _MarkerConfig(Icons.block, AppColors.danger, BitmapDescriptor.hueRed);
      case OSMNodeType.dismount:
        return _MarkerConfig(Icons.directions_walk, const Color(0xFF9C27B0), BitmapDescriptor.hueViolet);
      case OSMNodeType.speedLimit:
        return _MarkerConfig(Icons.speed, const Color(0xFF607D8B), BitmapDescriptor.hueCyan);
      case OSMNodeType.accidentZone:
        return _MarkerConfig(Icons.car_crash, const Color(0xFFB71C1C), BitmapDescriptor.hueRed);
      case OSMNodeType.enforcementZone:
        return _MarkerConfig(Icons.local_police, const Color(0xFF1A237E), BitmapDescriptor.hueBlue);
    }
  }

  Widget _buildGpsErrorBanner(L10n l) {
    String message;
    String actionText;
    VoidCallback? action;

    switch (_gpsError) {
      case 'denied_forever':
        message = '\u4f4d\u7f6e\u60c5\u5831\u304c\u6c38\u4e45\u7684\u306b\u62d2\u5426\u3055\u308c\u3066\u3044\u307e\u3059\u3002\u8a2d\u5b9a\u30a2\u30d7\u30ea\u304b\u3089\u4f4d\u7f6e\u60c5\u5831\u3092\u8a31\u53ef\u3057\u3066\u304f\u3060\u3055\u3044\u3002';
        actionText = '\u8a2d\u5b9a\u3092\u958b\u304f';
        action = () {
          // Open app settings on Android
          if (!kIsWeb) {
            launchUrl(Uri.parse('app-settings:'));
          }
        };
      case 'denied':
        message = '\u30ca\u30d3\u30b2\u30fc\u30b7\u30e7\u30f3\u306b\u306f\u4f4d\u7f6e\u60c5\u5831\u306e\u8a31\u53ef\u304c\u5fc5\u8981\u3067\u3059\u3002\u5b89\u5168\u8b66\u544a\u3092\u53d7\u3051\u53d6\u308b\u305f\u3081\u3001\u4f4d\u7f6e\u60c5\u5831\u3092\u8a31\u53ef\u3057\u3066\u304f\u3060\u3055\u3044\u3002';
        actionText = '\u518d\u8a66\u884c';
        action = () {
          setState(() {
            _gpsInitialized = false;
            _gpsError = null;
          });
          _initializeGps();
        };
      case 'disabled':
        message = 'GPS\u304c\u7121\u52b9\u3067\u3059\u3002\u7aef\u672b\u306e\u4f4d\u7f6e\u60c5\u5831\u30b5\u30fc\u30d3\u30b9\u3092ON\u306b\u3057\u3066\u304f\u3060\u3055\u3044\u3002';
        actionText = '\u518d\u8a66\u884c';
        action = () {
          setState(() {
            _gpsInitialized = false;
            _gpsError = null;
          });
          _initializeGps();
        };
      default:
        message = 'GPS\u306e\u53d6\u5f97\u306b\u5931\u6557\u3057\u307e\u3057\u305f\u3002';
        actionText = '\u518d\u8a66\u884c';
        action = () {
          setState(() {
            _gpsInitialized = false;
            _gpsError = null;
          });
          _initializeGps();
        };
    }

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10)],
      ),
      child: Row(
        children: [
          const Icon(Icons.location_off, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '\u4f4d\u7f6e\u60c5\u5831\u304c\u5fc5\u8981\u3067\u3059',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: action,
            style: TextButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(actionText, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(LocationProvider provider, L10n l) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _infoRow(Icons.speed, AppColors.accentGreen, '${provider.speedKmh.toStringAsFixed(1)} km/h'),
          const SizedBox(height: 6),
          _infoRow(Icons.straighten, AppColors.accentCyan, utils.DistanceCalculator.formatDistance(provider.totalDistance)),
          const SizedBox(height: 6),
          _infoRow(Icons.timer_outlined, AppColors.warning, utils.DistanceCalculator.formatDuration(provider.rideDuration)),
          const SizedBox(height: 6),
          _infoRow(Icons.warning_amber_rounded, AppColors.danger, '${provider.warningsCount}${l.warningCountUnit}'),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildRideButton(LocationProvider provider, L10n l) {
    final isTracking = provider.rideStatus == RideStatus.tracking;
    final isPaused = provider.rideStatus == RideStatus.paused;

    if (isTracking || isPaused) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            heroTag: 'pause',
            onPressed: () => isTracking ? provider.pauseRide() : provider.resumeRide(),
            backgroundColor: AppColors.warning,
            child: Icon(isTracking ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 20),
          FloatingActionButton.large(
            heroTag: 'stop',
            onPressed: () => provider.stopRide(),
            backgroundColor: AppColors.danger,
            child: const Icon(Icons.stop, color: Colors.white, size: 36),
          ),
        ],
      );
    }

    return SizedBox(
      width: 200, height: 56,
      child: ElevatedButton(
        onPressed: () {
          final hasGps = provider.gpsStatus != GpsStatus.unavailable;
          if (hasGps) {
            provider.startRide(demoMode: false);
          } else {
            _showGpsUnavailableDialog(provider, l);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentGreen,
          foregroundColor: AppColors.primaryDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          elevation: 8,
          shadowColor: AppColors.accentGreen.withValues(alpha: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_arrow_rounded, size: 28),
            const SizedBox(width: 8),
            Text(l.startButton, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _showGpsUnavailableDialog(LocationProvider provider, L10n l) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.location_off, color: AppColors.warning),
            const SizedBox(width: 8),
            Text(l.gpsUnavailableTitle, style: const TextStyle(color: AppColors.textPrimary, fontSize: 18)),
          ],
        ),
        content: Text(
          l.gpsUnavailableMessage,
          style: const TextStyle(color: AppColors.textSecondary, height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.closeButton),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              provider.startRide(demoMode: true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
            child: Text(l.startWithDemo),
          ),
        ],
      ),
    );
  }
}

/// Simple config holder for marker icon, color, and hue
class _MarkerConfig {
  final IconData icon;
  final Color color;
  final double hue;
  _MarkerConfig(this.icon, this.color, this.hue);
}
