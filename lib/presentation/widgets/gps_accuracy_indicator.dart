import 'package:flutter/material.dart';
import 'package:cycle_guard/l10n/app_localizations.dart';
import '../../core/constants/colors.dart';

class GpsAccuracyIndicator extends StatelessWidget {
  final double accuracy;
  final bool isTracking;

  const GpsAccuracyIndicator({
    super.key,
    required this.accuracy,
    required this.isTracking,
  });

  Color get _statusColor {
    if (!isTracking) return AppColors.textMuted;
    if (accuracy <= 5) return AppColors.safe;
    if (accuracy <= 15) return AppColors.warning;
    return AppColors.danger;
  }

  String _statusText(L10n l) {
    if (!isTracking) return l.gpsWaiting;
    if (accuracy <= 5) return l.gpsHigh;
    if (accuracy <= 15) return l.gpsMedium;
    return l.gpsLow;
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bgCard.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _statusColor.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: _statusColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _statusColor.withValues(alpha: 0.5),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            _statusText(l),
            style: TextStyle(
              color: _statusColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isTracking) ...[
            const SizedBox(width: 4),
            Text(
              '(${accuracy.toStringAsFixed(0)}m)',
              style: TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }
}
