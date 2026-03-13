import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cycle_guard/l10n/app_localizations.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/distance_calculator.dart' as utils;
import '../../data/models/ride_record.dart';
import '../providers/location_provider.dart';
import 'package:intl/intl.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return Consumer<LocationProvider>(
      builder: (context, provider, child) {
        final records = provider.getRideHistory();

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primaryDark, AppColors.bgMain],
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Icon(Icons.history, color: AppColors.accentCyan, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        l.logTitle,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      if (records.isNotEmpty)
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: AppColors.bgCard,
                                title: Text(l.deleteHistory, style: const TextStyle(color: AppColors.textPrimary)),
                                content: Text(l.deleteHistoryConfirm, style: const TextStyle(color: AppColors.textSecondary)),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: Text(l.cancelButton),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      provider.clearHistory();
                                      Navigator.pop(ctx);
                                    },
                                    child: Text(l.deleteButton, style: const TextStyle(color: AppColors.danger)),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_outline, color: AppColors.textMuted),
                        ),
                    ],
                  ),
                ),
                if (records.isNotEmpty) _buildSummary(records, l),
                const SizedBox(height: 12),
                Expanded(
                  child: records.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.directions_bike_outlined, size: 64, color: AppColors.textMuted.withValues(alpha: 0.5)),
                              const SizedBox(height: 16),
                              Text(l.noHistory, style: TextStyle(color: AppColors.textMuted, fontSize: 16)),
                              const SizedBox(height: 8),
                              Text(
                                l.startNavPrompt,
                                style: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.7), fontSize: 13),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: records.length,
                          itemBuilder: (context, index) {
                            return _buildRecordCard(records[index], l);
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummary(List<RideRecord> records, L10n l) {
    final totalDist = records.fold<double>(0, (sum, r) => sum + r.distanceMeters);
    final totalWarnings = records.fold<int>(0, (sum, r) => sum + r.warningsCount);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryLight.withValues(alpha: 0.3),
              AppColors.accentCyan.withValues(alpha: 0.15),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStat('${records.length}', l.rideCount, Icons.route),
            _buildStat(utils.DistanceCalculator.formatDistance(totalDist), l.totalDistance, Icons.straighten),
            _buildStat('$totalWarnings', l.warningsLabel, Icons.warning_amber_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.accentCyan, size: 22),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
      ],
    );
  }

  Widget _buildRecordCard(RideRecord record, L10n l) {
    final dateFormat = DateFormat('M/d (E) HH:mm', l.localeName);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.directions_bike, color: AppColors.accentGreen, size: 20),
              const SizedBox(width: 8),
              Text(
                dateFormat.format(record.startTime),
                style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildRecordInfo(Icons.straighten, utils.DistanceCalculator.formatDistance(record.distanceMeters)),
              const SizedBox(width: 20),
              _buildRecordInfo(Icons.timer_outlined, utils.DistanceCalculator.formatDuration(record.duration)),
              const SizedBox(width: 20),
              _buildRecordInfo(Icons.warning_amber_rounded, '${record.warningsCount}${l.warningCountUnit}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecordInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.textMuted, size: 16),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      ],
    );
  }
}
