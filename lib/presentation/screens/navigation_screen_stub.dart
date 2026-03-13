import 'dart:async';
import 'package:geolocator/geolocator.dart';

/// Native mobile (Android/iOS) GPS implementation using geolocator package
StreamSubscription? startGpsStream({
  required void Function(double lat, double lon, double accuracy, double speed, double heading) onPosition,
  required void Function(String error) onError,
}) {
  _initAndListen(onPosition, onError);
  return null; // subscription managed internally
}

Future<void> _initAndListen(
  void Function(double, double, double, double, double) onPosition,
  void Function(String) onError,
) async {
  // Check if location service is enabled
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    onError('GPS_SERVICE_DISABLED');
    // Keep trying — user may enable it later
    await Future.delayed(const Duration(seconds: 3));
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      onError('GPS_SERVICE_DISABLED');
      return;
    }
  }

  // Check & request permission
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      onError('GPS_PERMISSION_DENIED');
      return;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    onError('GPS_PERMISSION_DENIED_FOREVER');
    return;
  }

  // Get initial position
  try {
    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
    onPosition(
      pos.latitude,
      pos.longitude,
      pos.accuracy,
      pos.speed < 0 ? 0 : pos.speed,
      pos.heading.isNaN ? 0 : pos.heading,
    );
  } catch (e) {
    // Non-fatal — stream will provide positions
  }

  // Start continuous position stream
  // Android: uses FusedLocationProvider for battery-efficient high-accuracy tracking
  final locationSettings = AndroidSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 3, // meters — update every 3m for cycling
    intervalDuration: const Duration(seconds: 1),
    foregroundNotificationConfig: const ForegroundNotificationConfig(
      notificationTitle: 'CHARI-PI',
      notificationText: 'GPS\u3067\u5b89\u5168\u30ca\u30d3\u30b2\u30fc\u30b7\u30e7\u30f3\u4e2d...',
      notificationIcon: AndroidResource(name: 'ic_launcher', defType: 'mipmap'),
      enableWakeLock: true,
      enableWifiLock: true,
      setOngoing: true,
    ),
  );

  Geolocator.getPositionStream(locationSettings: locationSettings).listen(
    (Position pos) {
      onPosition(
        pos.latitude,
        pos.longitude,
        pos.accuracy,
        pos.speed < 0 ? 0 : pos.speed,
        pos.heading.isNaN ? 0 : pos.heading,
      );
    },
    onError: (e) {
      onError(e.toString());
    },
  );
}
