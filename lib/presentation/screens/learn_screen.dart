import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cycle_guard/l10n/app_localizations.dart';
import '../../core/constants/colors.dart';
import '../providers/content_provider.dart';
import 'rule_detail_screen.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return Consumer<ContentProvider>(
      builder: (context, content, child) {
        final rules = _selectedCategory != null
            ? content.getRulesByCategory(_selectedCategory!)
            : content.rules;

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
                      const Icon(Icons.school, color: AppColors.accentGreen, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l.learnTitle,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (content.isOffline)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.cloud_off, color: AppColors.warning, size: 14),
                              const SizedBox(width: 4),
                              Text(l.offlineLabel, style: const TextStyle(color: AppColors.warning, fontSize: 11)),
                            ],
                          ),
                        ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: content.isLoading ? null : () => content.refresh(),
                        icon: content.isLoading
                            ? const SizedBox(
                                width: 20, height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accentCyan),
                              )
                            : const Icon(Icons.refresh, color: AppColors.accentCyan),
                        tooltip: l.refreshTooltip,
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildCategoryChip(null, l.allCategories, rules.length),
                      ..._getCategoryEntries(content, l).map((entry) =>
                        _buildCategoryChip(
                          entry['key'] as String,
                          entry['name'] as String,
                          content.getRulesByCategory(entry['key'] as String).length,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accentGreen.withValues(alpha: 0.1),
                          AppColors.accentCyan.withValues(alpha: 0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.accentGreen.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.verified, color: AppColors.accentGreen, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${l.sourceLabel}\n${l.rulesCountFormat(rules.length)}',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Expanded(child: _buildContent(content, rules, l)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(ContentProvider content, List<Map<String, dynamic>> rules, L10n l) {
    if (content.isLoading && rules.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.accentCyan),
            const SizedBox(height: 16),
            Text(l.loadingContent, style: const TextStyle(color: AppColors.textMuted)),
          ],
        ),
      );
    }

    if (content.error != null && rules.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 48, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(content.error!, style: const TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => content.refresh(),
              icon: const Icon(Icons.refresh),
              label: Text(l.retryButton),
            ),
          ],
        ),
      );
    }

    if (rules.isEmpty) {
      return Center(
        child: Text(l.noMatchingRules, style: const TextStyle(color: AppColors.textMuted)),
      );
    }

    return RefreshIndicator(
      onRefresh: () => content.refresh(),
      color: AppColors.accentCyan,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: rules.length,
        itemBuilder: (context, index) {
          return _buildRuleCard(context, rules[index], index);
        },
      ),
    );
  }

  List<Map<String, dynamic>> _getCategoryEntries(ContentProvider content, L10n l) {
    final catMap = {
      'basic': l.catBasic,
      'intersection': l.catIntersection,
      'road': l.catRoad,
      'equipment': l.catEquipment,
      'prohibition': l.catProhibition,
      'safety': l.catSafety,
      'insurance': l.catInsurance,
      'new_law': l.catNewLaw,
      'registration': l.catRegistration,
    };
    return catMap.entries
        .where((e) => content.getRulesByCategory(e.key).isNotEmpty)
        .map((e) => {'key': e.key, 'name': e.value})
        .toList();
  }

  Widget _buildCategoryChip(String? key, String name, int count) {
    final isSelected = _selectedCategory == key;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => _selectedCategory = key),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accentCyan.withValues(alpha: 0.2) : AppColors.bgCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isSelected ? AppColors.accentCyan : AppColors.divider),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: isSelected ? AppColors.accentCyan : AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '$count',
                style: TextStyle(
                  color: isSelected ? AppColors.accentCyan : AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRuleCard(BuildContext context, Map<String, dynamic> rule, int index) {
    final colors = [
      AppColors.danger, AppColors.warning, AppColors.info,
      AppColors.accentGreen, AppColors.accentCyan, AppColors.primaryLight,
    ];
    final color = colors[index % colors.length];
    final iconMap = _getIconData(rule['icon'] as String? ?? 'article');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RuleDetailScreen(rule: rule, accentColor: color),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgCard.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Icon(iconMap, color: color, size: 24)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rule['title'] as String? ?? '',
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    rule['summary'] as String? ?? '',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (rule['penalty'] != null && (rule['penalty'] as String).isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(Icons.gavel, color: AppColors.warning.withValues(alpha: 0.7), size: 12),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              rule['penalty'] as String,
                              style: TextStyle(color: AppColors.warning.withValues(alpha: 0.7), fontSize: 10),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
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
