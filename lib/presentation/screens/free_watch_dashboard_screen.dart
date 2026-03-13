import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../providers/plan_provider.dart';

class FreeWatchDashboardScreen extends StatelessWidget {
  const FreeWatchDashboardScreen({super.key});

  static const Color _watchGreen = Color(0xFF4CAF50);

  @override
  Widget build(BuildContext context) {
    return Consumer<PlanProvider>(
      builder: (context, plan, _) {
        final snapshots = plan.gpsSnapshots;
        final latest = snapshots.isNotEmpty ? snapshots.first : null;
        final name = plan.watchedName.isNotEmpty ? plan.watchedName : '---';

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primaryDark, AppColors.bgMain],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // AppBar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            'GPS\u898b\u5b88\u308a',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Watch ID banner
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: _watchGreen.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: _watchGreen.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.link, color: _watchGreen, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  '\u898b\u5b88\u308aID: ${plan.familyId}',
                                  style: TextStyle(
                                    color: _watchGreen,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('ID\u3092\u30b3\u30d4\u30fc\u3057\u307e\u3057\u305f'),
                                        backgroundColor: AppColors.safe,
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  child: Icon(Icons.copy, color: _watchGreen, size: 16),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Target person card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.bgCard,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: _watchGreen.withValues(alpha: 0.3)),
                            ),
                            child: Column(
                              children: [
                                // Avatar & Name
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: _watchGreen.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Text('\u{1F4CD}', style: TextStyle(fontSize: 36)),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  name,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: latest != null && latest.isMoving
                                            ? AppColors.warning
                                            : _watchGreen,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      latest != null && latest.isMoving ? '\u79fb\u52d5\u4e2d' : '\u505c\u6b62\u4e2d',
                                      style: TextStyle(
                                        color: latest != null && latest.isMoving
                                            ? AppColors.warning
                                            : _watchGreen,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(height: 1, color: AppColors.divider),
                                const SizedBox(height: 16),

                                // Latest location info
                                if (latest != null) ...[
                                  _buildLocationRow(
                                    Icons.place,
                                    '\u73fe\u5728\u5730',
                                    latest.address,
                                    _watchGreen,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildLocationRow(
                                    Icons.access_time,
                                    '\u6700\u7d42\u66f4\u65b0',
                                    _formatTime(latest.timestamp),
                                    AppColors.textMuted,
                                  ),
                                ] else
                                  Text(
                                    '\u4f4d\u7f6e\u60c5\u5831\u304c\u307e\u3060\u3042\u308a\u307e\u305b\u3093',
                                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Location history header
                          Row(
                            children: [
                              const Icon(Icons.history, color: AppColors.accentCyan, size: 18),
                              const SizedBox(width: 8),
                              const Text(
                                '\u4f4d\u7f6e\u5c65\u6b74',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.textMuted.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '\u76f4\u8fd130\u5206',
                                  style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // GPS history list
                          if (snapshots.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                color: AppColors.bgCard,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.divider),
                              ),
                              child: Column(
                                children: [
                                  const Text('\u{1F4E1}', style: TextStyle(fontSize: 40)),
                                  const SizedBox(height: 12),
                                  Text(
                                    'GPS\u30c7\u30fc\u30bf\u304c\u307e\u3060\u3042\u308a\u307e\u305b\u3093',
                                    style: TextStyle(color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            )
                          else
                            ...snapshots.map((s) => _buildSnapshotCard(s)),

                          const SizedBox(height: 24),

                          // Free plan limitation notice
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.accentCyan.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.25)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.info_outline, color: AppColors.accentCyan, size: 18),
                                    const SizedBox(width: 8),
                                    const Text(
                                      '\u7121\u6599\u30d7\u30e9\u30f3\u306e\u5236\u9650',
                                      style: TextStyle(
                                        color: AppColors.accentCyan,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\u2022 \u898b\u5b88\u308a\u5bfe\u8c61: 1\u540d\u306e\u307f\n\u2022 GPS\u4f4d\u7f6e\u306e\u78ba\u8a8d\u306e\u307f\uff08\u5b89\u5168\u30b9\u30b3\u30a2\u30fb\u30ec\u30dd\u30fc\u30c8\u306a\u3057\uff09\n\u2022 \u66f4\u65b0\u983b\u5ea6: 5\u5206\u3054\u3068',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                    height: 1.6,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.upgrade, size: 18),
                                    label: const Text('\u30d5\u30a1\u30df\u30ea\u30fc\u30d7\u30e9\u30f3\u3067\u3082\u3063\u3068\u898b\u5b88\u308b'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.accentCyan,
                                      side: BorderSide(color: AppColors.accentCyan.withValues(alpha: 0.5)),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Cancel watch
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    backgroundColor: AppColors.bgCard,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    title: const Text(
                                      '\u898b\u5b88\u308a\u3092\u89e3\u9664',
                                      style: TextStyle(color: AppColors.textPrimary),
                                    ),
                                    content: Text(
                                      '$name\u3055\u3093\u306eGPS\u898b\u5b88\u308a\u3092\u89e3\u9664\u3057\u307e\u3059\u304b\uff1f',
                                      style: TextStyle(color: AppColors.textSecondary),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx, false),
                                        child: Text('\u30ad\u30e3\u30f3\u30bb\u30eb', style: TextStyle(color: AppColors.textMuted)),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(ctx, true),
                                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                                        child: const Text('\u89e3\u9664\u3059\u308b', style: TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirmed == true && context.mounted) {
                                  await plan.cancelFreeWatch();
                                  if (context.mounted) Navigator.pop(context);
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.danger,
                                side: const BorderSide(color: AppColors.danger),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: const Text('\u898b\u5b88\u308a\u3092\u89e3\u9664'),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLocationRow(IconData icon, String label, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSnapshotCard(GpsSnapshot snapshot) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: snapshot.isMoving
                  ? AppColors.warning.withValues(alpha: 0.15)
                  : _watchGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              snapshot.isMoving ? Icons.directions_bike : Icons.location_on,
              color: snapshot.isMoving ? AppColors.warning : _watchGreen,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.address,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _formatTime(snapshot.timestamp),
                      style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: snapshot.isMoving
                            ? AppColors.warning.withValues(alpha: 0.15)
                            : _watchGreen.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        snapshot.isMoving ? '\u79fb\u52d5\u4e2d' : '\u505c\u6b62',
                        style: TextStyle(
                          color: snapshot.isMoving ? AppColors.warning : _watchGreen,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return '\u305f\u3063\u305f\u4eca';
    if (diff.inMinutes < 60) return '${diff.inMinutes}\u5206\u524d';
    if (diff.inHours < 24) return '${diff.inHours}\u6642\u9593\u524d';
    return '${diff.inDays}\u65e5\u524d';
  }
}
