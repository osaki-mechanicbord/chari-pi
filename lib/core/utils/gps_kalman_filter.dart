import 'dart:math';

/// GPS位置のカルマンフィルタによる平滑化
/// ブレ・ジッター・ノイズを低減し、安定した位置情報を提供
class GpsKalmanFilter {
  // State: [latitude, longitude, speed_lat, speed_lon]
  double _lat = 0;
  double _lon = 0;
  double _speedLat = 0; // latitude velocity (degrees/sec)
  double _speedLon = 0; // longitude velocity (degrees/sec)

  // Heading smoothing
  double _heading = 0;
  double _headingSin = 0;
  double _headingCos = 1;

  // Uncertainty (variance)
  double _variance = 1000; // initial large uncertainty
  DateTime? _lastTimestamp;
  bool _initialized = false;

  // Tuning parameters
  static const double _processNoise = 3.0; // m²/s⁴ (how much movement we expect)
  static const double _headingSmoothing = 0.3; // lower = smoother heading

  bool get isInitialized => _initialized;
  double get latitude => _lat;
  double get longitude => _lon;
  double get heading => _heading;

  /// Process a new GPS measurement
  /// Returns smoothed (lat, lon, heading, speed)
  ({double lat, double lon, double heading, double speed}) process({
    required double rawLat,
    required double rawLon,
    required double accuracy,
    required double rawSpeed,
    required double rawHeading,
  }) {
    final now = DateTime.now();

    if (!_initialized) {
      _lat = rawLat;
      _lon = rawLon;
      _heading = rawHeading;
      _headingSin = sin(rawHeading * pi / 180);
      _headingCos = cos(rawHeading * pi / 180);
      _variance = accuracy * accuracy;
      _lastTimestamp = now;
      _initialized = true;
      return (lat: _lat, lon: _lon, heading: _heading, speed: rawSpeed);
    }

    final dt = _lastTimestamp != null
        ? now.difference(_lastTimestamp!).inMilliseconds / 1000.0
        : 1.0;
    _lastTimestamp = now;

    if (dt <= 0 || dt > 30) {
      // Too long gap, reset
      _lat = rawLat;
      _lon = rawLon;
      _variance = accuracy * accuracy;
      return (lat: _lat, lon: _lon, heading: _smoothHeading(rawHeading), speed: rawSpeed);
    }

    // === Predict phase ===
    // Predict new position based on velocity
    _lat += _speedLat * dt;
    _lon += _speedLon * dt;

    // Increase uncertainty due to process noise
    _variance += _processNoise * dt * dt;

    // === Update phase ===
    final measurementNoise = accuracy * accuracy;

    // Kalman gain
    final kalmanGain = _variance / (_variance + measurementNoise);

    // Innovation (measurement residual)
    final innovLat = rawLat - _lat;
    final innovLon = rawLon - _lon;

    // Update state
    _lat += kalmanGain * innovLat;
    _lon += kalmanGain * innovLon;

    // Update velocity estimate (degrees/sec)
    if (dt > 0.1) {
      _speedLat = innovLat / dt * kalmanGain;
      _speedLon = innovLon / dt * kalmanGain;
    }

    // Update uncertainty
    _variance = (1 - kalmanGain) * _variance;

    // Smooth heading using circular averaging
    final smoothedHeading = _smoothHeading(rawHeading);

    // Calculate smoothed speed from position changes
    final smoothedSpeed = rawSpeed; // keep raw speed as Kalman on lat/lon already stabilizes

    return (lat: _lat, lon: _lon, heading: smoothedHeading, speed: smoothedSpeed);
  }

  /// Smooth heading using exponential moving average on unit circle
  double _smoothHeading(double rawHeading) {
    if (rawHeading.isNaN || rawHeading < 0) return _heading;

    final rawRad = rawHeading * pi / 180;
    _headingSin = _headingSin * (1 - _headingSmoothing) + sin(rawRad) * _headingSmoothing;
    _headingCos = _headingCos * (1 - _headingSmoothing) + cos(rawRad) * _headingSmoothing;

    _heading = (atan2(_headingSin, _headingCos) * 180 / pi + 360) % 360;
    return _heading;
  }

  /// Reset the filter (e.g., when ride stops)
  void reset() {
    _initialized = false;
    _variance = 1000;
    _speedLat = 0;
    _speedLon = 0;
    _lastTimestamp = null;
  }
}
