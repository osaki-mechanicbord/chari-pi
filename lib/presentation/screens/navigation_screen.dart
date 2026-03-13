import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:cycle_guard/l10n/app_localizations.dart';
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
  final MapController _mapController = MapController();
  bool _followUser = true;
  bool _gpsInitialized = false;
  StreamSubscription? _gpsSubscription;
  Timer? _durationTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeGps();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _gpsInitialized) {
      _initializeGps();
    }
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
        provider.onPositionUpdate(lat, lon, accuracy, speed, heading);
      },
      onError: (error) {
        if (kDebugMode) debugPrint('GPS Error: $error');
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
    super.dispose();
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
            try {
              _mapController.move(currentPos, 17.0);
            } catch (_) {}
          });
        }

        return Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: currentPos,
                initialZoom: 17.0,
                minZoom: 13.0,
                maxZoom: 19.0,
                onPositionChanged: (pos, hasGesture) {
                  if (hasGesture) setState(() => _followUser = false);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.cycleguard.safety',
                ),
                if (locationProvider.routePoints.length >= 2)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: locationProvider.routePoints,
                        color: AppColors.accentCyan,
                        strokeWidth: 4.0,
                      ),
                    ],
                  ),
                if (locationProvider.rideStatus == RideStatus.tracking)
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: currentPos,
                        radius: locationProvider.accuracy.clamp(3, 100),
                        color: AppColors.accentCyan.withValues(alpha: 0.12),
                        borderColor: AppColors.accentCyan.withValues(alpha: 0.4),
                        borderStrokeWidth: 1.5,
                        useRadiusInMeter: true,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: _buildOSMMarkers(locationProvider.nearbyNodes),
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: currentPos,
                      width: 50,
                      height: 50,
                      child: _buildUserMarker(locationProvider.heading),
                    ),
                  ],
                ),
              ],
            ),

            if (locationProvider.warningNodes.isNotEmpty)
              Positioned(
                top: 0, left: 0, right: 0,
                child: WarningBanner(warnings: locationProvider.warningNodes),
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
                    _mapController.move(currentPos, 17.0);
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

  Widget _buildUserMarker(double heading) {
    return Transform.rotate(
      angle: heading * 3.14159265 / 180,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [AppColors.primaryLight, AppColors.accentCyan],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentCyan.withValues(alpha: 0.5),
              blurRadius: 12, spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(Icons.directions_bike, color: Colors.white, size: 30),
      ),
    );
  }

  List<Marker> _buildOSMMarkers(List<OSMNode> nodes) {
    return nodes.where((n) => (n.distanceFromUser ?? double.infinity) <= 300).map((node) {
      IconData iconData;
      Color color;
      switch (node.type) {
        case OSMNodeType.stopSign:
          iconData = Icons.front_hand;
          color = AppColors.danger;
        case OSMNodeType.trafficSignal:
          iconData = Icons.traffic;
          color = AppColors.warning;
        case OSMNodeType.oneway:
          iconData = Icons.arrow_forward;
          color = AppColors.info;
      }
      return Marker(
        point: node.position,
        width: 36, height: 36,
        child: Container(
          decoration: BoxDecoration(
            color: color, shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 8)],
          ),
          child: Icon(iconData, color: Colors.white, size: 20),
        ),
      );
    }).toList();
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
