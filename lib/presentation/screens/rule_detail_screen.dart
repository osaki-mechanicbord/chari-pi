import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/colors.dart';

class RuleDetailScreen extends StatelessWidget {
  final Map<String, dynamic> rule;
  final Color accentColor;

  const RuleDetailScreen({
    super.key,
    required this.rule,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final keyPoints = rule['key_points'] as List<dynamic>? ?? [];
    final lawRef = rule['law_reference'] as String? ?? '';
    final sourceUrl = rule['source_url'] as String? ?? '';
    final penalty = rule['penalty'] as String? ?? '';
    final version = rule['version'] ?? 1;
    final updatedAt = rule['updated_at'] as String? ?? '';

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
              // App bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
                    ),
                    Expanded(
                      child: Text(
                        rule['title'] as String? ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon header
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: accentColor.withValues(alpha: 0.5), width: 2),
                          ),
                          child: Center(
                            child: Icon(_getIconData(rule['icon'] as String? ?? 'article'), color: accentColor, size: 40),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Law reference badge
                      if (lawRef.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.gavel, color: AppColors.primaryLight, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  lawRef,
                                  style: const TextStyle(color: AppColors.primaryLight, fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (lawRef.isNotEmpty) const SizedBox(height: 16),

                      // Penalty warning
                      if (penalty.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.danger.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber, color: AppColors.danger, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('罰則', style: TextStyle(color: AppColors.danger, fontSize: 11, fontWeight: FontWeight.bold)),
                                    Text(penalty, style: const TextStyle(color: AppColors.danger, fontSize: 13)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (penalty.isNotEmpty) const SizedBox(height: 16),

                      // Content
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.bgCard.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Text(
                          rule['content'] as String? ?? '',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                            height: 1.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Key points
                      if (keyPoints.isNotEmpty) ...[
                        const Text(
                          'ポイント',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...keyPoints.map((point) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: accentColor.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.check, color: accentColor, size: 16),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    point.toString(),
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 24),
                      ],

                      // Source & metadata section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '出典・データ情報',
                              style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            if (sourceUrl.isNotEmpty)
                              GestureDetector(
                                onTap: () => _launchUrl(sourceUrl),
                                child: Row(
                                  children: [
                                    const Icon(Icons.link, color: AppColors.accentCyan, size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        sourceUrl,
                                        style: const TextStyle(
                                          color: AppColors.accentCyan,
                                          fontSize: 12,
                                          decoration: TextDecoration.underline,
                                          decorationColor: AppColors.accentCyan,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.update, color: AppColors.textMuted, size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  'バージョン: v$version',
                                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                                ),
                                const SizedBox(width: 16),
                                if (updatedAt.isNotEmpty)
                                  Text(
                                    '更新日: ${_formatDate(updatedAt)}',
                                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Disclaimer
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.warning.withValues(alpha: 0.2)),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline, color: AppColors.warning, size: 16),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '本コンテンツは公的資料に基づいていますが、最新の法令は各自でご確認ください。法的助言を目的としたものではありません。',
                                style: TextStyle(color: AppColors.warning, fontSize: 11, height: 1.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return isoDate;
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  IconData _getIconData(String iconName) {
    final iconMap = {
      'arrow_back': Icons.arrow_back,
      'pan_tool': Icons.pan_tool,
      'traffic': Icons.traffic,
      'turn_right': Icons.turn_right,
      'arrow_forward': Icons.arrow_forward,
      'directions_walk': Icons.directions_walk,
      'nightlight': Icons.nightlight,
      'sports_motorsports': Icons.sports_motorsports,
      'local_bar': Icons.local_bar,
      'phone_android': Icons.phone_android,
      'headphones': Icons.headphones,
      'umbrella': Icons.umbrella,
      'people': Icons.people,
      'compare_arrows': Icons.compare_arrows,
      'notifications': Icons.notifications,
      'build': Icons.build,
      'security': Icons.security,
      'receipt_long': Icons.receipt_long,
      'emergency': Icons.emergency,
      'lock': Icons.lock,
      'train': Icons.train,
      'back_hand': Icons.back_hand,
      'child_care': Icons.child_care,
      'electric_bike': Icons.electric_bike,
      'article': Icons.article,
    };
    return iconMap[iconName] ?? Icons.article;
  }
}
