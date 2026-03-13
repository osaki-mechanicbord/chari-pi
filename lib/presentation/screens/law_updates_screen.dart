import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cycle_guard/l10n/app_localizations.dart';
import '../../core/constants/colors.dart';
import '../providers/content_provider.dart';

class LawUpdatesScreen extends StatelessWidget {
  const LawUpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return Consumer<ContentProvider>(
      builder: (context, content, child) {
        final updates = content.lawUpdates;

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
                      const Icon(Icons.new_releases, color: AppColors.warning, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l.lawUpdatesTitle,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                      ),
                      IconButton(
                        onPressed: content.isLoading ? null : () => content.refresh(),
                        icon: const Icon(Icons.refresh, color: AppColors.accentCyan),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.accentCyan.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.gavel, color: AppColors.accentCyan, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            l.lawUpdatesInfo,
                            style: const TextStyle(color: AppColors.accentCyan, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: updates.isEmpty
                      ? Center(child: Text(l.lawNoUpdates, style: const TextStyle(color: AppColors.textMuted)))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: updates.length,
                          itemBuilder: (context, index) {
                            final update = updates[index];
                            return _buildUpdateCard(context, update, l);
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

  Widget _buildUpdateCard(BuildContext context, Map<String, dynamic> update, L10n l) {
    final effectiveDate = update['effective_date'] as String? ?? '';
    final isUpcoming = effectiveDate.isNotEmpty && DateTime.tryParse(effectiveDate)?.isAfter(DateTime.now()) == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isUpcoming ? AppColors.warning.withValues(alpha: 0.3) : AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isUpcoming)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(l.lawUpcoming, style: const TextStyle(color: AppColors.warning, fontSize: 11, fontWeight: FontWeight.bold)),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(l.lawEnacted, style: const TextStyle(color: AppColors.accentGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              if (effectiveDate.isNotEmpty)
                Text(
                  l.lawEffectiveDate(effectiveDate),
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            update['title'] as String? ?? '',
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            update['summary'] as String? ?? '',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if ((update['law_reference'] as String?)?.isNotEmpty == true)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    update['law_reference'] as String,
                    style: const TextStyle(color: AppColors.primaryLight, fontSize: 11),
                  ),
                ),
              const Spacer(),
              if ((update['source_url'] as String?)?.isNotEmpty == true)
                GestureDetector(
                  onTap: () async {
                    final uri = Uri.tryParse(update['source_url'] as String);
                    if (uri != null) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.open_in_new, color: AppColors.accentCyan, size: 14),
                      const SizedBox(width: 4),
                      Text(l.lawCheckSource, style: const TextStyle(color: AppColors.accentCyan, fontSize: 12)),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
