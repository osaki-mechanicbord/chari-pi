import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../providers/plan_provider.dart';
import 'family_dashboard_screen.dart';
import 'business_dashboard_screen.dart';
import 'free_watch_dashboard_screen.dart';

class FamilySetupScreen extends StatefulWidget {
  const FamilySetupScreen({super.key});

  @override
  State<FamilySetupScreen> createState() => _FamilySetupScreenState();
}

class _FamilySetupScreenState extends State<FamilySetupScreen> {
  final TextEditingController _familyIdController = TextEditingController();
  final TextEditingController _orgNameController = TextEditingController();
  bool _isJoining = false;
  bool _isJoiningBusiness = false;
  bool _isSettingUpFreeWatch = false;
  bool _isJoiningFreeWatch = false;
  final TextEditingController _watchNameController = TextEditingController();
  final TextEditingController _watchIdController = TextEditingController();

  static const Color _bizGold = Color(0xFFFFD700);
  static const Color _freeWatchGreen = Color(0xFF4CAF50);

  @override
  void dispose() {
    _familyIdController.dispose();
    _orgNameController.dispose();
    _watchNameController.dispose();
    _watchIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlanProvider>(
      builder: (context, planProvider, _) {
        // Already linked - show dashboard or status
        if (planProvider.familyRole != FamilyRole.none) {
          if (planProvider.isAdmin) {
            return const BusinessDashboardScreen();
          } else if (planProvider.isParent) {
            return const FamilyDashboardScreen();
          } else if (planProvider.isFreeWatcher) {
            return const FreeWatchDashboardScreen();
          } else if (planProvider.isFreeWatched) {
            return _buildFreeWatchedStatusScreen(context, planProvider);
          } else if (planProvider.isMember) {
            return _buildMemberStatusScreen(context, planProvider);
          } else {
            return _buildChildStatusScreen(context, planProvider);
          }
        }

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
                            '\u5b89\u5168\u7ba1\u7406\u30bb\u30c3\u30c8\u30a2\u30c3\u30d7',
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
                          const SizedBox(height: 12),
                          // Icon
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.accentCyan.withValues(alpha: 0.3),
                                  AppColors.primaryLight.withValues(alpha: 0.2),
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text('\u{1F6E1}\u{FE0F}', style: TextStyle(fontSize: 42)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            '\u3042\u306a\u305f\u306e\u5f79\u5272\u3092\u9078\u3093\u3067\u304f\u3060\u3055\u3044',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\u5bb6\u65cf\u3084\u7d44\u7e54\u3067\u30a2\u30d7\u30ea\u3092\u9023\u643a\u3057\u3066\u5b89\u5168\u3092\u898b\u5b88\u308a\u307e\u3057\u3087\u3046',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                          ),
                          const SizedBox(height: 32),

                          // ===== Family section =====
                          _buildCategoryHeader('\u30d5\u30a1\u30df\u30ea\u30fc\u30d7\u30e9\u30f3', Icons.family_restroom, AppColors.accentCyan),
                          const SizedBox(height: 12),

                          // Parent card
                          _buildRoleCard(
                            emoji: '\u{1F468}\u{200D}\u{1F469}\u{200D}\u{1F467}',
                            title: '\u4fdd\u8b77\u8005\u3068\u3057\u3066\u767b\u9332',
                            subtitle: '\u304a\u5b50\u3055\u307e\u306e\u30e9\u30a4\u30c9\u3092\u898b\u5b88\u308a\u307e\u3059',
                            features: [
                              '\u30d5\u30a1\u30df\u30ea\u30fcID\u3092\u767a\u884c',
                              '\u6700\u59275\u4eba\u307e\u3067\u306e\u304a\u5b50\u3055\u307e\u3092\u7ba1\u7406',
                              '\u30ea\u30a2\u30eb\u30bf\u30a4\u30e0\u4f4d\u7f6e\u78ba\u8a8d',
                              '\u5371\u967a\u904b\u8ee2\u30ec\u30dd\u30fc\u30c8\u53d7\u4fe1',
                            ],
                            color: AppColors.accentCyan,
                            onTap: () => _setupAsParent(context, planProvider),
                          ),
                          const SizedBox(height: 12),

                          // Child card
                          _buildRoleCard(
                            emoji: '\u{1F9D1}\u{200D}\u{1F393}',
                            title: '\u5b50\u4f9b\u3068\u3057\u3066\u53c2\u52a0',
                            subtitle: '\u4fdd\u8b77\u8005\u306e\u30d5\u30a1\u30df\u30ea\u30fcID\u3092\u5165\u529b\u3057\u307e\u3059',
                            features: [
                              '\u4fdd\u8b77\u8005\u304b\u3089\u306eID\u3092\u5165\u529b',
                              '\u901a\u5e38\u306e\u30ca\u30d3\u6a5f\u80fd\u306f\u305d\u306e\u307e\u307e',
                              '\u5b89\u5168\u30b9\u30b3\u30a2\u304c\u4fdd\u8b77\u8005\u306b\u5171\u6709',
                              '\u30d0\u30c3\u30af\u30b0\u30e9\u30a6\u30f3\u30c9\u3067\u898b\u5b88\u308a',
                            ],
                            color: AppColors.warning,
                            onTap: () => setState(() {
                              _isJoining = true;
                              _isJoiningBusiness = false;
                            }),
                          ),

                          // Family ID input
                          if (_isJoining && !_isJoiningBusiness) ...[
                            const SizedBox(height: 16),
                            _buildJoinSection(context, planProvider),
                          ],

                          const SizedBox(height: 28),

                          // ===== Free GPS Watch section =====
                          _buildCategoryHeader('無料GPS見守り', Icons.gps_fixed, _freeWatchGreen),
                          const SizedBox(height: 12),

                          // Watcher card
                          _buildRoleCard(
                            emoji: '\u{1F4CD}',
                            title: '見守る人として登録',
                            subtitle: '1名のGPS位置を無料で確認',
                            features: [
                              '見守りIDを発行',
                              '1名のバックグラウンドGPS',
                              '位置履歴の確認（5分間隔）',
                              '完全無料・課金なし',
                            ],
                            color: _freeWatchGreen,
                            onTap: () => setState(() {
                              _isSettingUpFreeWatch = true;
                              _isJoiningFreeWatch = false;
                              _isJoining = false;
                              _isJoiningBusiness = false;
                            }),
                          ),

                          if (_isSettingUpFreeWatch) ...[
                            const SizedBox(height: 16),
                            _buildFreeWatchSetupSection(context, planProvider),
                          ],

                          const SizedBox(height: 12),

                          // Watched person card
                          _buildRoleCard(
                            emoji: '\u{1F6B2}',
                            title: '見守られる人として参加',
                            subtitle: '見守る人の見守りIDを入力',
                            features: [
                              '見守る人からのIDを入力',
                              '通常のナビ機能はそのまま',
                              'GPS位置をバックグラウンド共有',
                              '完全無料・課金なし',
                            ],
                            color: _freeWatchGreen.withValues(alpha: 0.8),
                            onTap: () => setState(() {
                              _isJoiningFreeWatch = true;
                              _isSettingUpFreeWatch = false;
                              _isJoining = false;
                              _isJoiningBusiness = false;
                            }),
                          ),

                          if (_isJoiningFreeWatch) ...[
                            const SizedBox(height: 16),
                            _buildFreeWatchJoinSection(context, planProvider),
                          ],

                          const SizedBox(height: 28),

                          // ===== Business section =====
                          _buildCategoryHeader('\u6cd5\u4eba\u30d7\u30e9\u30f3', Icons.business, _bizGold),
                          const SizedBox(height: 12),

                          // Admin card
                          _buildRoleCard(
                            emoji: '\u{1F3E2}',
                            title: '\u7ba1\u7406\u8005\u3068\u3057\u3066\u767b\u9332',
                            subtitle: '\u7d44\u7e54\u306e\u81ea\u8ee2\u8eca\u5b89\u5168\u3092\u4e00\u5143\u7ba1\u7406',
                            features: [
                              '\u7d44\u7e54ID\u3092\u767a\u884c\u30fb\u5f93\u696d\u54e1\u62db\u5f85',
                              '\u767b\u9332\u4eba\u6570\u7121\u5236\u9650',
                              '\u90e8\u7f72\u5225\u5b89\u5168\u30b9\u30b3\u30a2\u7d71\u8a08',
                              '\u6708\u6b21PDF\u30ec\u30dd\u30fc\u30c8\u51fa\u529b',
                            ],
                            color: _bizGold,
                            onTap: () => _setupAsAdmin(context, planProvider),
                          ),
                          const SizedBox(height: 12),

                          // Member card
                          _buildRoleCard(
                            emoji: '\u{1F464}',
                            title: '\u5f93\u696d\u54e1\u3068\u3057\u3066\u53c2\u52a0',
                            subtitle: '\u7ba1\u7406\u8005\u306e\u7d44\u7e54ID\u3092\u5165\u529b\u3057\u307e\u3059',
                            features: [
                              '\u7ba1\u7406\u8005\u304b\u3089\u306e\u7d44\u7e54ID\u3092\u5165\u529b',
                              '\u901a\u5e38\u306e\u30ca\u30d3\u30fb\u5b66\u7fd2\u6a5f\u80fd\u306f\u305d\u306e\u307e\u307e',
                              '\u5b89\u5168\u30b9\u30b3\u30a2\u304c\u7d44\u7e54\u306b\u5171\u6709',
                              '\u30d0\u30c3\u30af\u30b0\u30e9\u30a6\u30f3\u30c9\u3067\u898b\u5b88\u308a',
                            ],
                            color: _bizGold.withValues(alpha: 0.8),
                            onTap: () => setState(() {
                              _isJoiningBusiness = true;
                              _isJoining = false;
                            }),
                          ),

                          // Business ID input
                          if (_isJoiningBusiness && !_isJoining) ...[
                            const SizedBox(height: 16),
                            _buildBusinessJoinSection(context, planProvider),
                          ],

                          const SizedBox(height: 32),

                          // Privacy notice
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.info.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.shield, color: AppColors.info, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '\u30d7\u30e9\u30a4\u30d0\u30b7\u30fc\u4fdd\u8b77',
                                        style: TextStyle(
                                          color: AppColors.info,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\u4f4d\u7f6e\u60c5\u5831\u306f\u89aa\u5b50\u9593\u30fb\u7d44\u7e54\u5185\u306e\u307f\u3067\u5171\u6709\u3055\u308c\u307e\u3059\u3002\u7b2c\u4e09\u8005\u306b\u306f\u4e00\u5207\u63d0\u4f9b\u3055\u308c\u305a\u3001\u30c7\u30fc\u30bf\u306f90\u65e5\u3067\u81ea\u52d5\u524a\u9664\u3055\u308c\u307e\u3059\u3002',
                                        style: TextStyle(color: AppColors.textSecondary, fontSize: 11, height: 1.5),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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

  Widget _buildCategoryHeader(String title, IconData icon, Color color) {
    String priceLabel;
    if (title == '\u30d5\u30a1\u30df\u30ea\u30fc\u30d7\u30e9\u30f3') {
      priceLabel = '\u00a5480/\u6708';
    } else if (title == '\u6cd5\u4eba\u30d7\u30e9\u30f3') {
      priceLabel = '\u00a53,980/\u6708';
    } else {
      priceLabel = '\u00a50';
    }
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            priceLabel,
            style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleCard({
    required String emoji,
    required String title,
    required String subtitle,
    required List<String> features,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 36)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: color, size: 18),
              ],
            ),
            const SizedBox(height: 14),
            Container(height: 1, color: AppColors.divider),
            const SizedBox(height: 14),
            ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: color, size: 16),
                      const SizedBox(width: 8),
                      Text(f, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildJoinSection(BuildContext context, PlanProvider planProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '\u30d5\u30a1\u30df\u30ea\u30fcID\u3092\u5165\u529b',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\u4fdd\u8b77\u8005\u306e\u30a2\u30d7\u30ea\u306b\u8868\u793a\u3055\u308c\u3066\u3044\u308bID\u3092\u5165\u529b\u3057\u3066\u304f\u3060\u3055\u3044',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _familyIdController,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: 'CHARI-XXXX',
              hintStyle: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.5)),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.warning, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => setState(() {
                    _isJoining = false;
                    _familyIdController.clear();
                  }),
                  child: Text('\u30ad\u30e3\u30f3\u30bb\u30eb', style: TextStyle(color: AppColors.textMuted)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () async {
                    final id = _familyIdController.text.trim();
                    if (id.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('ID\u3092\u5165\u529b\u3057\u3066\u304f\u3060\u3055\u3044'),
                          backgroundColor: AppColors.danger,
                        ),
                      );
                      return;
                    }
                    await planProvider.joinFamily(id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('\u30d5\u30a1\u30df\u30ea\u30fc\u306b\u53c2\u52a0\u3057\u307e\u3057\u305f\uff01'),
                          backgroundColor: AppColors.safe,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warning,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    '\u53c2\u52a0\u3059\u308b',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.warning, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '\u53c2\u52a0\u3059\u308b\u3068\u4f4d\u7f6e\u60c5\u5831\u304c\u4fdd\u8b77\u8005\u306b\u5171\u6709\u3055\u308c\u307e\u3059',
                    style: TextStyle(color: AppColors.warning, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessJoinSection(BuildContext context, PlanProvider planProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _bizGold.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '\u7d44\u7e54ID\u3092\u5165\u529b',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '\u7ba1\u7406\u8005\u304b\u3089\u5171\u6709\u3055\u308c\u305f\u7d44\u7e54ID\u3092\u5165\u529b\u3057\u3066\u304f\u3060\u3055\u3044',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _familyIdController,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: 'BIZ-XXXXXX',
              hintStyle: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.5)),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.divider)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.divider)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _bizGold, width: 2)),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => setState(() {
                    _isJoiningBusiness = false;
                    _familyIdController.clear();
                  }),
                  child: Text('\u30ad\u30e3\u30f3\u30bb\u30eb', style: TextStyle(color: AppColors.textMuted)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () async {
                    final id = _familyIdController.text.trim();
                    if (id.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('\u7d44\u7e54ID\u3092\u5165\u529b\u3057\u3066\u304f\u3060\u3055\u3044'), backgroundColor: AppColors.danger),
                      );
                      return;
                    }
                    await planProvider.joinBusiness(id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('\u7d44\u7e54\u306b\u53c2\u52a0\u3057\u307e\u3057\u305f\uff01'), backgroundColor: AppColors.safe),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _bizGold,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('\u53c2\u52a0\u3059\u308b', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _bizGold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: _bizGold, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '\u53c2\u52a0\u3059\u308b\u3068\u30e9\u30a4\u30c9\u60c5\u5831\u304c\u7ba1\u7406\u8005\u306b\u5171\u6709\u3055\u308c\u307e\u3059',
                    style: TextStyle(color: _bizGold, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildStatusScreen(BuildContext context, PlanProvider planProvider) {
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
                        '\u30d5\u30a1\u30df\u30ea\u30fc\u30b9\u30c6\u30fc\u30bf\u30b9',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.safe.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text('\u{1F6E1}\u{FE0F}', style: TextStyle(fontSize: 56)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '\u898b\u5b88\u308a\u6a5f\u80fd ON',
                        style: TextStyle(
                          color: AppColors.safe,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\u4fdd\u8b77\u8005\u304c\u3042\u306a\u305f\u306e\u5b89\u5168\u3092\u898b\u5b88\u3063\u3066\u3044\u307e\u3059',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Column(
                          children: [
                            _statusRow('\u30d5\u30a1\u30df\u30ea\u30fcID', planProvider.familyId),
                            const SizedBox(height: 12),
                            Container(height: 1, color: AppColors.divider),
                            const SizedBox(height: 12),
                            _statusRow('\u5f79\u5272', '\u5b50\u4f9b'),
                            const SizedBox(height: 12),
                            Container(height: 1, color: AppColors.divider),
                            const SizedBox(height: 12),
                            _statusRow('GPS\u5171\u6709', '\u6709\u52b9'),
                            const SizedBox(height: 12),
                            Container(height: 1, color: AppColors.divider),
                            const SizedBox(height: 12),
                            _statusRow('\u30b9\u30c6\u30fc\u30bf\u30b9', '\u30a2\u30af\u30c6\u30a3\u30d6'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: AppColors.bgCard,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                title: const Text('\u30d5\u30a1\u30df\u30ea\u30fc\u3092\u9000\u51fa', style: TextStyle(color: AppColors.textPrimary)),
                                content: Text(
                                  '\u30d5\u30a1\u30df\u30ea\u30fc\u304b\u3089\u9000\u51fa\u3059\u308b\u3068\u3001\u4fdd\u8b77\u8005\u306b\u4f4d\u7f6e\u60c5\u5831\u304c\u5171\u6709\u3055\u308c\u306a\u304f\u306a\u308a\u307e\u3059\u3002',
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
                                    child: const Text('\u9000\u51fa\u3059\u308b', style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            );
                            if (confirmed == true && context.mounted) {
                              await planProvider.downgradeToFree();
                              if (context.mounted) Navigator.pop(context);
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.danger,
                            side: const BorderSide(color: AppColors.danger),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('\u30d5\u30a1\u30df\u30ea\u30fc\u3092\u9000\u51fa'),
                        ),
                      ),
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

  Widget _buildMemberStatusScreen(BuildContext context, PlanProvider planProvider) {
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
                        '\u7d44\u7e54\u30b9\u30c6\u30fc\u30bf\u30b9',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: _bizGold.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text('\u{1F3E2}', style: TextStyle(fontSize: 56)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '\u7d44\u7e54\u306b\u53c2\u52a0\u4e2d',
                        style: TextStyle(color: _bizGold, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\u7ba1\u7406\u8005\u304c\u3042\u306a\u305f\u306e\u5b89\u5168\u8d70\u884c\u3092\u898b\u5b88\u3063\u3066\u3044\u307e\u3059',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Column(
                          children: [
                            _statusRow('\u7d44\u7e54ID', planProvider.familyId),
                            const SizedBox(height: 12),
                            Container(height: 1, color: AppColors.divider),
                            const SizedBox(height: 12),
                            _statusRow('\u5f79\u5272', '\u5f93\u696d\u54e1'),
                            const SizedBox(height: 12),
                            Container(height: 1, color: AppColors.divider),
                            const SizedBox(height: 12),
                            _statusRow('GPS\u5171\u6709', '\u6709\u52b9'),
                            const SizedBox(height: 12),
                            Container(height: 1, color: AppColors.divider),
                            const SizedBox(height: 12),
                            _statusRow('\u30b9\u30c6\u30fc\u30bf\u30b9', '\u30a2\u30af\u30c6\u30a3\u30d6'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: AppColors.bgCard,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                title: const Text('\u7d44\u7e54\u3092\u9000\u51fa', style: TextStyle(color: AppColors.textPrimary)),
                                content: Text(
                                  '\u7d44\u7e54\u304b\u3089\u9000\u51fa\u3059\u308b\u3068\u3001\u7ba1\u7406\u8005\u306b\u30e9\u30a4\u30c9\u60c5\u5831\u304c\u5171\u6709\u3055\u308c\u306a\u304f\u306a\u308a\u307e\u3059\u3002',
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
                                    child: const Text('\u9000\u51fa\u3059\u308b', style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            );
                            if (confirmed == true && context.mounted) {
                              await planProvider.downgradeToFree();
                              if (context.mounted) Navigator.pop(context);
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.danger,
                            side: const BorderSide(color: AppColors.danger),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('\u7d44\u7e54\u3092\u9000\u51fa'),
                        ),
                      ),
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

  Widget _statusRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }

  void _setupAsParent(BuildContext context, PlanProvider planProvider) async {
    if (!planProvider.isFamilyPlan) {
      final upgrade = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.bgCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('\u30d5\u30a1\u30df\u30ea\u30fc\u30d7\u30e9\u30f3\u304c\u5fc5\u8981\u3067\u3059',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 17)),
          content: Text(
            '\u4fdd\u8b77\u8005\u3068\u3057\u3066\u767b\u9332\u3059\u308b\u306b\u306f\u30d5\u30a1\u30df\u30ea\u30fc\u30d7\u30e9\u30f3\uff08\u00a5480/\u6708\uff09\u3078\u306e\u30a2\u30c3\u30d7\u30b0\u30ec\u30fc\u30c9\u304c\u5fc5\u8981\u3067\u3059\u3002\n\n\u203b \u73fe\u5728\u306f\u30c7\u30e2\u30e2\u30fc\u30c9\u3067\u3059\u3002\u5b9f\u969b\u306e\u8ab2\u91d1\u306f\u767a\u751f\u3057\u307e\u305b\u3093\u3002',
            style: TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('\u30ad\u30e3\u30f3\u30bb\u30eb', style: TextStyle(color: AppColors.textMuted)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan),
              child: const Text('\u30a2\u30c3\u30d7\u30b0\u30ec\u30fc\u30c9', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
      if (upgrade != true) return;
      await planProvider.upgradeToPlan(PlanType.family);
    }
    await planProvider.setFamilyRole(FamilyRole.parent);
  }

  void _setupAsAdmin(BuildContext context, PlanProvider planProvider) async {
    if (!planProvider.isBusinessPlan) {
      final upgrade = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.bgCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('\u6cd5\u4eba\u30d7\u30e9\u30f3\u304c\u5fc5\u8981\u3067\u3059',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 17)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\u7ba1\u7406\u8005\u3068\u3057\u3066\u767b\u9332\u3059\u308b\u306b\u306f\u6cd5\u4eba\u30d7\u30e9\u30f3\uff08\u00a53,980/\u6708\uff09\u3078\u306e\u30a2\u30c3\u30d7\u30b0\u30ec\u30fc\u30c9\u304c\u5fc5\u8981\u3067\u3059\u3002',
                style: TextStyle(color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _bizGold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [Icon(Icons.check, color: _bizGold, size: 16), const SizedBox(width: 6), Expanded(child: Text('\u767b\u9332\u4eba\u6570\u7121\u5236\u9650', style: TextStyle(color: AppColors.textPrimary, fontSize: 12)))]),
                    const SizedBox(height: 4),
                    Row(children: [Icon(Icons.check, color: _bizGold, size: 16), const SizedBox(width: 6), Expanded(child: Text('\u90e8\u7f72\u5225\u5b89\u5168\u7d71\u8a08', style: TextStyle(color: AppColors.textPrimary, fontSize: 12)))]),
                    const SizedBox(height: 4),
                    Row(children: [Icon(Icons.check, color: _bizGold, size: 16), const SizedBox(width: 6), Expanded(child: Text('\u6708\u6b21PDF\u30ec\u30dd\u30fc\u30c8', style: TextStyle(color: AppColors.textPrimary, fontSize: 12)))]),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '\u203b \u73fe\u5728\u306f\u30c7\u30e2\u30e2\u30fc\u30c9\u3067\u3059\u3002\u5b9f\u969b\u306e\u8ab2\u91d1\u306f\u767a\u751f\u3057\u307e\u305b\u3093\u3002',
                style: TextStyle(color: AppColors.warning, fontSize: 11),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('\u30ad\u30e3\u30f3\u30bb\u30eb', style: TextStyle(color: AppColors.textMuted)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(backgroundColor: _bizGold),
              child: const Text('\u30a2\u30c3\u30d7\u30b0\u30ec\u30fc\u30c9', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );
      if (upgrade != true) return;
      await planProvider.upgradeToPlan(PlanType.business);
    }
    await planProvider.setFamilyRole(FamilyRole.admin);
  }

  // ===== Free Watch Setup Section =====
  Widget _buildFreeWatchSetupSection(BuildContext context, PlanProvider planProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _freeWatchGreen.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '\u898b\u5b88\u308a\u5bfe\u8c61\u306e\u540d\u524d\u3092\u5165\u529b',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\u898b\u5b88\u308a\u305f\u3044\u4eba\u306e\u540d\u524d\u3092\u5165\u529b\u3057\u3066\u304f\u3060\u3055\u3044\uff081\u540d\u306e\u307f\uff09',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _watchNameController,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: '\u4f8b: \u3086\u3044',
              hintStyle: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.5)),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _freeWatchGreen, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => setState(() {
                    _isSettingUpFreeWatch = false;
                    _watchNameController.clear();
                  }),
                  child: Text('\u30ad\u30e3\u30f3\u30bb\u30eb', style: TextStyle(color: AppColors.textMuted)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () async {
                    final name = _watchNameController.text.trim();
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('\u540d\u524d\u3092\u5165\u529b\u3057\u3066\u304f\u3060\u3055\u3044'),
                          backgroundColor: AppColors.danger,
                        ),
                      );
                      return;
                    }
                    await planProvider.setupFreeWatch(name);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$name\u3055\u3093\u306eGPS\u898b\u5b88\u308a\u3092\u958b\u59cb\u3057\u307e\u3057\u305f\uff01'),
                          backgroundColor: AppColors.safe,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _freeWatchGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    '\u898b\u5b88\u308a\u3092\u958b\u59cb',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _freeWatchGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: _freeWatchGreen, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '\u898b\u5b88\u308aID\u3092\u5bfe\u8c61\u8005\u306b\u5171\u6709\u3057\u3066\u3001\u30a2\u30d7\u30ea\u304b\u3089\u53c2\u52a0\u3057\u3066\u3082\u3089\u3063\u3066\u304f\u3060\u3055\u3044',
                    style: TextStyle(color: _freeWatchGreen, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFreeWatchJoinSection(BuildContext context, PlanProvider planProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _freeWatchGreen.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '\u898b\u5b88\u308aID\u3092\u5165\u529b',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\u898b\u5b88\u308b\u4eba\u304b\u3089\u5171\u6709\u3055\u308c\u305fID\u3092\u5165\u529b\u3057\u3066\u304f\u3060\u3055\u3044',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _watchIdController,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: 'WATCH-XXXX',
              hintStyle: TextStyle(color: AppColors.textMuted.withValues(alpha: 0.5)),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _freeWatchGreen, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => setState(() {
                    _isJoiningFreeWatch = false;
                    _watchIdController.clear();
                  }),
                  child: Text('\u30ad\u30e3\u30f3\u30bb\u30eb', style: TextStyle(color: AppColors.textMuted)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () async {
                    final id = _watchIdController.text.trim();
                    if (id.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('\u898b\u5b88\u308aID\u3092\u5165\u529b\u3057\u3066\u304f\u3060\u3055\u3044'),
                          backgroundColor: AppColors.danger,
                        ),
                      );
                      return;
                    }
                    await planProvider.joinFreeWatch(id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('GPS\u898b\u5b88\u308a\u306b\u53c2\u52a0\u3057\u307e\u3057\u305f\uff01'),
                          backgroundColor: AppColors.safe,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _freeWatchGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    '\u53c2\u52a0\u3059\u308b',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _freeWatchGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: _freeWatchGreen, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '\u53c2\u52a0\u3059\u308b\u3068GPS\u4f4d\u7f6e\u304c\u898b\u5b88\u308b\u4eba\u306b\u5171\u6709\u3055\u308c\u307e\u3059',
                    style: TextStyle(color: _freeWatchGreen, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Free watched person status screen
  Widget _buildFreeWatchedStatusScreen(BuildContext context, PlanProvider planProvider) {
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
                        'GPS\u898b\u5b88\u308a\u30b9\u30c6\u30fc\u30bf\u30b9',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: _freeWatchGreen.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text('\u{1F4CD}', style: TextStyle(fontSize: 56)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'GPS\u898b\u5b88\u308a ON',
                        style: TextStyle(
                          color: _freeWatchGreen,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\u3042\u306a\u305f\u306eGPS\u4f4d\u7f6e\u304c\u898b\u5b88\u308b\u4eba\u306b\u5171\u6709\u3055\u308c\u3066\u3044\u307e\u3059',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Column(
                          children: [
                            _statusRow('\u898b\u5b88\u308aID', planProvider.familyId),
                            const SizedBox(height: 12),
                            Container(height: 1, color: AppColors.divider),
                            const SizedBox(height: 12),
                            _statusRow('\u5f79\u5272', '\u898b\u5b88\u3089\u308c\u308b\u4eba'),
                            const SizedBox(height: 12),
                            Container(height: 1, color: AppColors.divider),
                            const SizedBox(height: 12),
                            _statusRow('GPS\u5171\u6709', '\u6709\u52b9'),
                            const SizedBox(height: 12),
                            Container(height: 1, color: AppColors.divider),
                            const SizedBox(height: 12),
                            _statusRow('\u30d7\u30e9\u30f3', '\u7121\u6599'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: AppColors.bgCard,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                title: const Text('\u898b\u5b88\u308a\u3092\u89e3\u9664', style: TextStyle(color: AppColors.textPrimary)),
                                content: Text(
                                  'GPS\u898b\u5b88\u308a\u304b\u3089\u9000\u51fa\u3059\u308b\u3068\u3001\u898b\u5b88\u308b\u4eba\u306b\u4f4d\u7f6e\u304c\u5171\u6709\u3055\u308c\u306a\u304f\u306a\u308a\u307e\u3059\u3002',
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
                              await planProvider.cancelFreeWatch();
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
}
