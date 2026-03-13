import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cycle_guard/l10n/app_localizations.dart';
import '../../core/constants/colors.dart';
import '../providers/settings_provider.dart';
import '../providers/plan_provider.dart';
import 'plan_upgrade_screen.dart';
import 'family_setup_screen.dart';
import 'legal/privacy_policy_screen.dart';
import 'legal/security_policy_screen.dart';
import 'legal/terms_of_service_screen.dart';
import 'legal/disclaimer_screen.dart';
import 'legal/commercial_law_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return Consumer2<SettingsProvider, PlanProvider>(
      builder: (context, settings, planProvider, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primaryDark, AppColors.bgMain],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.settings, color: AppColors.textMuted, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        l.settingsTitle,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Plan section
                  _buildSectionHeader(l.planSection),
                  const SizedBox(height: 12),
                  _buildPlanBanner(context, planProvider, l),
                  const SizedBox(height: 8),
                  _buildFamilyTile(context, planProvider, l),
                  const SizedBox(height: 24),

                  // Alert settings
                  _buildSectionHeader(l.alertSection),
                  const SizedBox(height: 12),
                  _buildSwitchTile(
                    icon: Icons.volume_up,
                    title: l.voiceAlert,
                    subtitle: l.voiceAlertDesc,
                    value: settings.voiceAlert,
                    onChanged: (v) => settings.setVoiceAlert(v),
                  ),
                  _buildSwitchTile(
                    icon: Icons.vibration,
                    title: l.vibrationAlert,
                    subtitle: l.vibrationAlertDesc,
                    value: settings.vibrationAlert,
                    onChanged: (v) => settings.setVibrationAlert(v),
                  ),
                  const SizedBox(height: 8),
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.social_distance, color: AppColors.accentCyan, size: 22),
                            const SizedBox(width: 12),
                            Text(l.alertDistance, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15)),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.accentCyan.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${settings.alertDistance.round()}m',
                                style: const TextStyle(color: AppColors.accentCyan, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: AppColors.accentCyan,
                            inactiveTrackColor: AppColors.divider,
                            thumbColor: AppColors.accentCyan,
                            overlayColor: AppColors.accentCyan.withValues(alpha: 0.2),
                          ),
                          child: Slider(
                            value: settings.alertDistance,
                            min: 20,
                            max: 100,
                            divisions: 8,
                            label: '${settings.alertDistance.round()}m',
                            onChanged: (v) => settings.setAlertDistance(v),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('20m', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                            Text('100m', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Display settings
                  _buildSectionHeader(l.displaySection),
                  const SizedBox(height: 12),
                  _buildSwitchTile(
                    icon: Icons.dark_mode,
                    title: l.darkMap,
                    subtitle: l.darkMapDesc,
                    value: settings.darkMap,
                    onChanged: (v) => settings.setDarkMap(v),
                  ),
                  const SizedBox(height: 24),

                  // Language settings
                  _buildSectionHeader(l.languageSection),
                  const SizedBox(height: 12),
                  _buildLanguageSelector(context, settings, l),
                  const SizedBox(height: 24),

                  // App Info
                  _buildSectionHeader(l.appInfoSection),
                  const SizedBox(height: 12),
                  _buildInfoTile(
                    icon: Icons.info_outline,
                    title: l.aboutApp,
                    subtitle: l.aboutAppDesc,
                    onTap: () => _showAbout(context, l),
                  ),
                  _buildCard(
                    child: Row(
                      children: [
                        const Icon(Icons.code, color: AppColors.textMuted, size: 22),
                        const SizedBox(width: 12),
                        Text(l.appVersion, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15)),
                        const Spacer(),
                        Text('1.0.0', style: TextStyle(color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Legal
                  _buildSectionHeader(l.legalSection),
                  const SizedBox(height: 12),
                  _buildInfoTile(
                    icon: Icons.privacy_tip_outlined,
                    title: l.privacyPolicy,
                    subtitle: l.privacyPolicyDesc,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen())),
                  ),
                  _buildInfoTile(
                    icon: Icons.security_outlined,
                    title: l.securityPolicy,
                    subtitle: l.securityPolicyDesc,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SecurityPolicyScreen())),
                  ),
                  _buildInfoTile(
                    icon: Icons.gavel_outlined,
                    title: l.termsOfService,
                    subtitle: l.termsOfServiceDesc,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsOfServiceScreen())),
                  ),
                  _buildInfoTile(
                    icon: Icons.warning_amber_outlined,
                    title: l.disclaimer,
                    subtitle: l.disclaimerDesc,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DisclaimerScreen())),
                  ),
                  _buildInfoTile(
                    icon: Icons.store_outlined,
                    title: l.commercialLaw,
                    subtitle: l.commercialLawDesc,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CommercialLawScreen())),
                  ),
                  const SizedBox(height: 16),

                  // Footer
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      children: [
                        Text(l.operatingCompany, style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                        const SizedBox(height: 4),
                        Text(l.companyName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(l.companyAddress, style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ===== Language selector =====

  Widget _buildLanguageSelector(BuildContext context, SettingsProvider settings, L10n l) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.language, color: AppColors.accentCyan, size: 22),
              const SizedBox(width: 12),
              Text(l.languageSetting, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: SettingsProvider.supportedLocales.map((locale) {
              final isSelected = settings.locale.languageCode == locale.languageCode;
              return GestureDetector(
                onTap: () => settings.setLocale(locale),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.accentCyan.withValues(alpha: 0.2) : AppColors.bgCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSelected ? AppColors.accentCyan : AppColors.divider),
                  ),
                  child: Text(
                    SettingsProvider.localeDisplayName(locale),
                    style: TextStyle(
                      color: isSelected ? AppColors.accentCyan : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ===== Plan section widgets =====

  static const Color _bizGold = Color(0xFFFFD700);
  static const Color _freeWatchGreen = Color(0xFF4CAF50);

  Widget _buildPlanBanner(BuildContext context, PlanProvider planProvider, L10n l) {
    final isFree = planProvider.currentPlan == PlanType.free;
    final isBusiness = planProvider.currentPlan == PlanType.business;
    final isFamily = planProvider.currentPlan == PlanType.family;
    final hasFreeWatch = planProvider.hasFreeWatch;

    Color accentColor;
    IconData planIcon;
    if (isBusiness) {
      accentColor = _bizGold;
      planIcon = Icons.business;
    } else if (isFamily) {
      accentColor = AppColors.accentCyan;
      planIcon = Icons.family_restroom;
    } else if (hasFreeWatch) {
      accentColor = _freeWatchGreen;
      planIcon = Icons.gps_fixed;
    } else {
      accentColor = AppColors.textMuted;
      planIcon = Icons.pedal_bike;
    }

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PlanUpgradeScreen())),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: (isFree && !hasFreeWatch)
              ? null
              : LinearGradient(colors: [accentColor.withValues(alpha: 0.2), AppColors.primaryLight.withValues(alpha: 0.1)]),
          color: (isFree && !hasFreeWatch) ? AppColors.bgCard.withValues(alpha: 0.8) : null,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: (isFree && !hasFreeWatch) ? AppColors.divider : accentColor.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(planIcon, color: accentColor, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(planProvider.getPlanName(), style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(
                    isFree && !hasFreeWatch
                        ? l.planUpgradePrompt
                        : hasFreeWatch
                            ? l.planFreeWithWatch
                            : planProvider.getPlanPrice(),
                    style: TextStyle(color: (isFree && !hasFreeWatch) ? AppColors.accentCyan : accentColor, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: ((isFree && !hasFreeWatch) ? AppColors.accentCyan : AppColors.textMuted).withValues(alpha: (isFree && !hasFreeWatch) ? 1.0 : 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isFree && !hasFreeWatch ? l.planUpgrade : l.planChange,
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyTile(BuildContext context, PlanProvider planProvider, L10n l) {
    final isBusiness = planProvider.isBusinessPlan;
    final isAdmin = planProvider.isAdmin;
    final isMember = planProvider.isMember;
    final isFreeWatcher = planProvider.isFreeWatcher;
    final isFreeWatched = planProvider.isFreeWatched;

    String subtitle;
    IconData tileIcon;
    Color tileColor;

    if (isAdmin) {
      subtitle = '${l.adminMode} · ${l.membersCount(planProvider.members.length)}';
      tileIcon = Icons.business;
      tileColor = _bizGold;
    } else if (isMember) {
      subtitle = '${l.employeeMode} · ${l.watchingMode}';
      tileIcon = Icons.business;
      tileColor = _bizGold;
    } else if (isFreeWatcher) {
      final name = planProvider.watchedName.isNotEmpty ? planProvider.watchedName : '---';
      subtitle = l.watchingPerson(name);
      tileIcon = Icons.gps_fixed;
      tileColor = _freeWatchGreen;
    } else if (isFreeWatched) {
      subtitle = l.beingWatched;
      tileIcon = Icons.gps_fixed;
      tileColor = _freeWatchGreen;
    } else if (planProvider.isParent) {
      subtitle = '${l.parentMode} · ${l.childrenCount(planProvider.children.length)}';
      tileIcon = Icons.family_restroom;
      tileColor = AppColors.accentCyan;
    } else if (planProvider.isChild) {
      subtitle = '${l.childMode} · ${l.watchingMode}';
      tileIcon = Icons.family_restroom;
      tileColor = AppColors.accentCyan;
    } else {
      subtitle = l.familyPrompt;
      tileIcon = Icons.shield;
      tileColor = AppColors.textMuted;
    }

    String tileTitle;
    if (isBusiness || isAdmin || isMember) {
      tileTitle = l.corporateSafety;
    } else if (isFreeWatcher || isFreeWatched) {
      tileTitle = l.gpsWatchFree;
    } else {
      tileTitle = l.familySafety;
    }

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FamilySetupScreen())),
      child: _buildCard(
        child: Row(
          children: [
            Icon(tileIcon, color: tileColor, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tileTitle, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                ],
              ),
            ),
            if (planProvider.familyRole != FamilyRole.none)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isAdmin || isMember ? _bizGold : isFreeWatcher || isFreeWatched ? _freeWatchGreen : AppColors.safe,
                  shape: BoxShape.circle,
                ),
              ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  // ===== Existing widgets =====

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(color: AppColors.accentCyan, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: child,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return _buildCard(
      child: Row(
        children: [
          Icon(icon, color: value ? AppColors.accentCyan : AppColors.textMuted, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.accentCyan,
            activeTrackColor: AppColors.accentCyan.withValues(alpha: 0.5),
            inactiveTrackColor: AppColors.divider,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: _buildCard(
        child: Row(
          children: [
            Icon(icon, color: AppColors.textMuted, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  void _showAbout(BuildContext context, L10n l) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.primaryLight, AppColors.accentCyan]),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shield, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Text(l.appName, style: const TextStyle(color: AppColors.textPrimary)),
          ],
        ),
        content: Text(
          l.aboutDialogContent,
          style: const TextStyle(color: AppColors.textSecondary, height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.closeButton, style: const TextStyle(color: AppColors.accentCyan)),
          ),
        ],
      ),
    );
  }
}
