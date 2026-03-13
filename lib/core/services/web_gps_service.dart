import 'dart:async';
import 'dart:js_interop';
import 'package:web/web.dart' as web;

class WebLocationResult {
  final double latitude;
  final double longitude;
  final double accuracy;
  final double speed;
  final double heading;
  final DateTime timestamp;

  WebLocationResult({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.speed,
    required this.heading,
    required this.timestamp,
  });
}

class WebGpsService {
  int? _watchId;
  final StreamController<WebLocationResult> _positionController =
      StreamController<WebLocationResult>.broadcast();

  Stream<WebLocationResult> get positionStream => _positionController.stream;

  bool get isSupported {
    try {
      web.window.navigator.geolocation;
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<WebLocationResult?> getCurrentPosition() async {
    if (!isSupported) return null;

    final completer = Completer<WebLocationResult?>();

    web.window.navigator.geolocation.getCurrentPosition(
      ((web.GeolocationPosition position) {
        final coords = position.coords;
        final result = WebLocationResult(
          latitude: coords.latitude.toDouble(),
          longitude: coords.longitude.toDouble(),
          accuracy: coords.accuracy.toDouble(),
          speed: (coords.speed ?? 0.0).toDouble(),
          heading: (coords.heading ?? 0.0).toDouble(),
          timestamp: DateTime.fromMillisecondsSinceEpoch(position.timestamp),
        );
        if (!completer.isCompleted) completer.complete(result);
      }).toJS,
      ((web.GeolocationPositionError error) {
        if (!completer.isCompleted) completer.complete(null);
      }).toJS,
      web.PositionOptions(
        enableHighAccuracy: true,
        timeout: 15000,
        maximumAge: 0,
      ),
    );

    return completer.future.timeout(
      const Duration(seconds: 20),
      onTimeout: () => null,
    );
  }

  void startWatching() {
    if (!isSupported) return;
    stopWatching();

    _watchId = web.window.navigator.geolocation.watchPosition(
      ((web.GeolocationPosition position) {
        final coords = position.coords;
        final result = WebLocationResult(
          latitude: coords.latitude.toDouble(),
          longitude: coords.longitude.toDouble(),
          accuracy: coords.accuracy.toDouble(),
          speed: (coords.speed ?? 0.0).toDouble(),
          heading: (coords.heading ?? 0.0).toDouble(),
          timestamp: DateTime.fromMillisecondsSinceEpoch(position.timestamp),
        );
        _positionController.add(result);
      }).toJS,
      ((web.GeolocationPositionError error) {
        // Silently handle errors - caller should handle stream gaps
      }).toJS,
      web.PositionOptions(
        enableHighAccuracy: true,
        timeout: 10000,
        maximumAge: 0,
      ),
    );
  }

  void stopWatching() {
    if (_watchId != null) {
      web.window.navigator.geolocation.clearWatch(_watchId!);
      _watchId = null;
    }
  }

  void dispose() {
    stopWatching();
    _positionController.close();
  }
}
