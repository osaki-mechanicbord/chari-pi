import 'dart:async';
import '../../core/services/web_gps_service.dart';

/// Web platform: uses browser Geolocation API
StreamSubscription? startGpsStream({
  required void Function(double lat, double lon, double accuracy, double speed, double heading) onPosition,
  required void Function(String error) onError,
}) {
  final gps = WebGpsService();

  if (!gps.isSupported) {
    onError('Geolocation API not supported');
    return null;
  }

  // Try to get initial position
  gps.getCurrentPosition().then((result) {
    if (result != null) {
      onPosition(result.latitude, result.longitude, result.accuracy, result.speed, result.heading);
    }
  });

  // Start continuous watching
  gps.startWatching();

  final sub = gps.positionStream.listen(
    (result) {
      onPosition(result.latitude, result.longitude, result.accuracy, result.speed, result.heading);
    },
    onError: (e) {
      onError(e.toString());
    },
  );

  return sub;
}
