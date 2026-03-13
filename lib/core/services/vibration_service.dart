import 'package:flutter/services.dart';

/// Vibration alert service for cycling safety warnings
class VibrationService {
  static final VibrationService _instance = VibrationService._internal();
  factory VibrationService() => _instance;
  VibrationService._internal();

  /// Standard warning vibration (e.g., approaching stop sign at 50m)
  Future<void> warningVibrate() async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 200));
    await HapticFeedback.heavyImpact();
  }

  /// Urgent alert vibration (e.g., very close to danger at <20m)
  Future<void> urgentVibrate() async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 150));
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 150));
    await HapticFeedback.heavyImpact();
  }

  /// Light notification vibration
  Future<void> lightVibrate() async {
    await HapticFeedback.mediumImpact();
  }
}
