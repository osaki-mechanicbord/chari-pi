import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../providers/plan_provider.dart';

class PlanUpgradeScreen extends StatelessWidget {
  const PlanUpgradeScreen({super.key});

  static const Color _businessGold = Color(0xFFFFD700);

  @override
  Widget build(BuildContext context) {
    return Consumer<PlanProvider>(
      builder: (context, planProvider, _) {
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
                            '\u30d7\u30e9\u30f3\u9078\u629e',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
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
                          // Header
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.accentCyan.withValues(alpha: 0.15),
                                  AppColors.primaryLight.withValues(alpha: 0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.3)),
                            ),
                            child: Column(
                              children: [
                                const Text('\u{1F6B2}', style: TextStyle(fontSize: 48)),
                                const SizedBox(height: 12),
                                const Text(
                                  '\u5b89\u5168\u3092\u3082\u3063\u3068\u5b88\u308a\u307e\u3057\u3087\u3046',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold, height: 1.4),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\u5bb6\u65cf\u3082\u4f1a\u793e\u3082\u3001\u76ee\u7684\u306b\u5408\u3063\u305f\u30d7\u30e9\u30f3\u3092',
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Free plan
                          _buildPlanCard(
                            context: context,
                            title: '\u7121\u6599\u30d7\u30e9\u30f3',
                            price: '\u00a50',
                            priceSubtitle: '\u6c38\u4e45\u7121\u6599',
                            isCurrentPlan: planProvider.currentPlan == PlanType.free,
                            color: AppColors.textMuted,
                            icon: Icons.pedal_bike,
                            features: [
                              _FeatureItem('\u30ca\u30d3\u30b2\u30fc\u30b7\u30e7\u30f3\u6a5f\u80fd', true),
                              _FeatureItem('\u5b89\u5168\u8b66\u544a\uff08\u4e00\u6642\u505c\u6b62\u30fb\u4fe1\u53f7\uff09', true),
                              _FeatureItem('\u4ea4\u901a\u30eb\u30fc\u30eb\u5b66\u7fd2', true),
                              _FeatureItem('\u30af\u30a4\u30ba\u6a5f\u80fd', true),
                              _FeatureItem('\u81ea\u5206\u306e\u30e9\u30a4\u30c9\u5c65\u6b74', true),
                              _FeatureItem('1\u540dGPS\u898b\u5b88\u308a\uff08\u30d0\u30c3\u30af\u30b0\u30e9\u30a6\u30f3\u30c9\uff09', true),
                              _FeatureItem('\u30e1\u30f3\u30d0\u30fc\u30ea\u30f3\u30af\u6a5f\u80fd\uff08\u8907\u6570\u4eba\uff09', false),
                              _FeatureItem('\u5b89\u5168\u30b9\u30b3\u30a2\u30fb\u63a8\u79fb', false),
                              _FeatureItem('\u5371\u967a\u904b\u8ee2\u30ec\u30dd\u30fc\u30c8', false),
                              _FeatureItem('\u30ea\u30a2\u30eb\u30bf\u30a4\u30e0\u4f4d\u7f6e\u78ba\u8a8d', false),
                            ],
                            onSelect: planProvider.currentPlan == PlanType.free
                                ? null
                                : () async {
                                    await planProvider.downgradeToFree();
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('\u7121\u6599\u30d7\u30e9\u30f3\u306b\u5909\u66f4\u3057\u307e\u3057\u305f'), backgroundColor: AppColors.info),
                                      );
                                    }
                                  },
                          ),
                          const SizedBox(height: 16),

                          // Family plan
                          _buildPlanCard(
                            context: context,
                            title: '\u30d5\u30a1\u30df\u30ea\u30fc\u30d7\u30e9\u30f3',
                            price: '\u00a5480',
                            priceSubtitle: '/\u6708\uff08\u7a0e\u8fbc\uff09',
                            isCurrentPlan: planProvider.currentPlan == PlanType.family,
                            color: AppColors.accentCyan,
                            icon: Icons.family_restroom,
                            isRecommended: true,
                            badgeText: '\u500b\u4eba\u304a\u3059\u3059\u3081',
                            features: [
                              _FeatureItem('\u7121\u6599\u30d7\u30e9\u30f3\u306e\u5168\u6a5f\u80fd', true),
                              _FeatureItem('\u89aa\u5b50\u30ea\u30f3\u30af\u6a5f\u80fd\uff08\u6700\u59275\u4eba\uff09', true),
                              _FeatureItem('\u30ea\u30a2\u30eb\u30bf\u30a4\u30e0\u4f4d\u7f6e\u78ba\u8a8d', true),
                              _FeatureItem('\u5371\u967a\u904b\u8ee2\u30ec\u30dd\u30fc\u30c8', true),
                              _FeatureItem('\u5b89\u5168\u30b9\u30b3\u30a2\u30fb\u63a8\u79fb\u30b0\u30e9\u30d5', true),
                              _FeatureItem('\u30d0\u30c3\u30af\u30b0\u30e9\u30a6\u30f3\u30c9GPS\u8ffd\u8de1', true),
                              _FeatureItem('\u30d7\u30c3\u30b7\u30e5\u901a\u77e5\uff08\u5371\u967a\u904b\u8ee2\u6642\uff09', true),
                              _FeatureItem('\u6708\u6b21\u5b89\u5168\u30ec\u30dd\u30fc\u30c8', true),
                              _FeatureItem('\u5e74\u9f62\u5225\u8a2d\u5b9a\uff08\u5c0f\u5b66\u751f/\u4e2d\u9ad8\u751f\uff09', true),
                              _FeatureItem('\u512a\u5148\u30b5\u30dd\u30fc\u30c8', true),
                            ],
                            onSelect: planProvider.currentPlan == PlanType.family
                                ? null
                                : () async {
                                    final confirmed = await _showUpgradeConfirm(
                                      context,
                                      '\u30d5\u30a1\u30df\u30ea\u30fc\u30d7\u30e9\u30f3',
                                      '\u00a5480/\u6708',
                                      AppColors.accentCyan,
                                      Icons.family_restroom,
                                      ['\u89aa\u5b50\u30ea\u30f3\u30af\uff08\u6700\u59275\u4eba\uff09', '\u30ea\u30a2\u30eb\u30bf\u30a4\u30e0GPS\u8ffd\u8de1', '\u5371\u967a\u904b\u8ee2\u30ec\u30dd\u30fc\u30c8', '\u5b89\u5168\u30b9\u30b3\u30a2\u7ba1\u7406'],
                                    );
                                    if (confirmed == true) {
                                      await planProvider.upgradeToPlan(PlanType.family);
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('\u30d5\u30a1\u30df\u30ea\u30fc\u30d7\u30e9\u30f3\u306b\u30a2\u30c3\u30d7\u30b0\u30ec\u30fc\u30c9\u3057\u307e\u3057\u305f\uff01'), backgroundColor: AppColors.safe),
                                        );
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                          ),
                          const SizedBox(height: 16),

                          // Business plan
                          _buildPlanCard(
                            context: context,
                            title: '\u6cd5\u4eba\u30d7\u30e9\u30f3',
                            price: '\u00a53,980',
                            priceSubtitle: '/\u6708\uff08\u7a0e\u8fbc\uff09',
                            isCurrentPlan: planProvider.currentPlan == PlanType.business,
                            color: _businessGold,
                            icon: Icons.business,
                            isRecommended: false,
                            badgeText: '\u6cd5\u4eba\u5411\u3051',
                            badgeColor: _businessGold,
                            features: [
                              _FeatureItem('\u30d5\u30a1\u30df\u30ea\u30fc\u30d7\u30e9\u30f3\u306e\u5168\u6a5f\u80fd', true),
                              _FeatureItem('\u767b\u9332\u4eba\u6570\u7121\u5236\u9650', true),
                              _FeatureItem('\u7d44\u7e54ID\u767a\u884c\u30fb\u5f93\u696d\u54e1\u7ba1\u7406', true),
                              _FeatureItem('\u90e8\u7f72\u5225\u5b89\u5168\u30b9\u30b3\u30a2\u7d71\u8a08', true),
                              _FeatureItem('\u5168\u5f93\u696d\u54e1\u306e\u30e9\u30a4\u30c9\u5c65\u6b74\u4e00\u89a7', true),
                              _FeatureItem('\u5371\u967a\u904b\u8ee2\u30a2\u30e9\u30fc\u30c8\uff08\u7ba1\u7406\u8005\u901a\u77e5\uff09', true),
                              _FeatureItem('\u5b89\u5168\u6559\u80b2\u30b3\u30f3\u30c6\u30f3\u30c4\u914d\u4fe1', true),
                              _FeatureItem('\u6708\u6b21\u5b89\u5168\u30ec\u30dd\u30fc\u30c8\uff08PDF\u51fa\u529b\uff09', true),
                              _FeatureItem('\u5c02\u7528\u30b5\u30dd\u30fc\u30c8\u7a93\u53e3', true),
                              _FeatureItem('\u30ab\u30b9\u30bf\u30e0\u30d6\u30e9\u30f3\u30c7\u30a3\u30f3\u30b0', true),
                            ],
                            onSelect: planProvider.currentPlan == PlanType.business
                                ? null
                                : () async {
                                    final confirmed = await _showUpgradeConfirm(
                                      context,
                                      '\u6cd5\u4eba\u30d7\u30e9\u30f3',
                                      '\u00a53,980/\u6708',
                                      _businessGold,
                                      Icons.business,
                                      ['\u767b\u9332\u4eba\u6570\u7121\u5236\u9650', '\u5f93\u696d\u54e1\u30fb\u90e8\u7f72\u7ba1\u7406', '\u90e8\u7f72\u5225\u5b89\u5168\u7d71\u8a08', '\u6708\u6b21PDF\u30ec\u30dd\u30fc\u30c8', '\u5c02\u7528\u30b5\u30dd\u30fc\u30c8'],
                                    );
                                    if (confirmed == true) {
                                      await planProvider.upgradeToPlan(PlanType.business);
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('\u6cd5\u4eba\u30d7\u30e9\u30f3\u306b\u30a2\u30c3\u30d7\u30b0\u30ec\u30fc\u30c9\u3057\u307e\u3057\u305f\uff01'), backgroundColor: AppColors.safe),
                                        );
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                          ),
                          const SizedBox(height: 24),

                          // FAQ
                          _buildFaqSection(),
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

  Widget _buildPlanCard({
    required BuildContext context,
    required String title,
    required String price,
    required String priceSubtitle,
    required bool isCurrentPlan,
    required Color color,
    required IconData icon,
    required List<_FeatureItem> features,
    bool isRecommended = false,
    String? badgeText,
    Color? badgeColor,
    VoidCallback? onSelect,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isCurrentPlan ? color : AppColors.divider,
              width: isCurrentPlan ? 2 : 1,
            ),
            boxShadow: isRecommended
                ? [BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 20, spreadRadius: 2)]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                        if (isCurrentPlan)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text('\u73fe\u5728\u306e\u30d7\u30e9\u30f3', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(price, style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.bold)),
                      Text(priceSubtitle, style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(height: 1, color: AppColors.divider),
              const SizedBox(height: 16),
              ...features.map((f) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Icon(
                          f.included ? Icons.check_circle : Icons.cancel,
                          color: f.included ? AppColors.safe : AppColors.textMuted.withValues(alpha: 0.4),
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            f.title,
                            style: TextStyle(
                              color: f.included ? AppColors.textPrimary : AppColors.textMuted.withValues(alpha: 0.5),
                              fontSize: 13,
                              decoration: f.included ? null : TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: onSelect,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCurrentPlan ? AppColors.bgCard : color,
                    foregroundColor: isCurrentPlan ? color : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: isCurrentPlan ? BorderSide(color: color) : BorderSide.none,
                    ),
                    elevation: isCurrentPlan ? 0 : 4,
                  ),
                  child: Text(
                    isCurrentPlan ? '\u73fe\u5728\u5229\u7528\u4e2d' : '\u3053\u306e\u30d7\u30e9\u30f3\u3092\u9078\u629e',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (badgeText != null)
          Positioned(
            top: -12,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isRecommended
                      ? [AppColors.accentCyan, AppColors.primaryLight]
                      : [badgeColor ?? color, (badgeColor ?? color).withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: (badgeColor ?? color).withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Text(badgeText, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
      ],
    );
  }

  Widget _buildFaqSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('\u3088\u304f\u3042\u308b\u8cea\u554f', style: TextStyle(color: AppColors.accentCyan, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 12),
        _buildFaqItem('\u7121\u6599\u30d7\u30e9\u30f3\u3067\u3082\u898b\u5b88\u308a\u304c\u3067\u304d\u307e\u3059\u304b\uff1f', '\u306f\u3044\u3001\u7121\u6599\u30d7\u30e9\u30f3\u30671\u540d\u306e\u307f\u30d0\u30c3\u30af\u30b0\u30e9\u30a6\u30f3\u30c9GPS\u8ffd\u8de1\u304c\u53ef\u80fd\u3067\u3059\u3002\u4f4d\u7f6e\u60c5\u5831\u306e\u78ba\u8a8d\u306e\u307f\u3067\u3001\u5b89\u5168\u30b9\u30b3\u30a2\u3084\u30ec\u30dd\u30fc\u30c8\u6a5f\u80fd\u306f\u30d5\u30a1\u30df\u30ea\u30fc\u30d7\u30e9\u30f3\u304b\u3089\u3054\u5229\u7528\u3044\u305f\u3060\u3051\u307e\u3059\u3002'),
        _buildFaqItem('\u89e3\u7d04\u306f\u3044\u3064\u3067\u3082\u3067\u304d\u307e\u3059\u304b\uff1f', '\u306f\u3044\u3001\u3044\u3064\u3067\u3082\u89e3\u7d04\u53ef\u80fd\u3067\u3059\u3002\u89e3\u7d04\u5f8c\u3082\u6708\u672b\u307e\u3067\u6a5f\u80fd\u3092\u3054\u5229\u7528\u3044\u305f\u3060\u3051\u307e\u3059\u3002'),
        _buildFaqItem('\u30d7\u30e9\u30a4\u30d0\u30b7\u30fc\u306f\u5b88\u3089\u308c\u307e\u3059\u304b\uff1f', '\u4f4d\u7f6e\u60c5\u5831\u306f\u7d44\u7e54\u5185\u30fb\u5bb6\u65cf\u9593\u306e\u307f\u3067\u5171\u6709\u3055\u308c\u3001\u7b2c\u4e09\u8005\u306b\u306f\u63d0\u4f9b\u3055\u308c\u307e\u305b\u3093\u3002\u30c7\u30fc\u30bf\u306f90\u65e5\u3067\u81ea\u52d5\u524a\u9664\u3055\u308c\u307e\u3059\u3002'),
        _buildFaqItem('\u30d5\u30a1\u30df\u30ea\u30fc\u30d7\u30e9\u30f3\u306e\u4e0a\u9650\u306f\uff1f', '\u30d5\u30a1\u30df\u30ea\u30fc\u30d7\u30e9\u30f3\u306f\u6700\u59275\u4eba\u3002\u305d\u308c\u4ee5\u4e0a\u306e\u5834\u5408\u306f\u6cd5\u4eba\u30d7\u30e9\u30f3\uff08\u7121\u5236\u9650\uff09\u3092\u3054\u691c\u8a0e\u304f\u3060\u3055\u3044\u3002'),
        _buildFaqItem('\u6cd5\u4eba\u30d7\u30e9\u30f3\u306e\u767b\u9332\u4eba\u6570\u306b\u5236\u9650\u306f\uff1f', '\u3044\u3044\u3048\u3001\u6cd5\u4eba\u30d7\u30e9\u30f3\u306f\u767b\u9332\u4eba\u6570\u7121\u5236\u9650\u3067\u3059\u3002\u4f55\u4eba\u3067\u3082\u6708\u984d\u00a53,980\u3067\u3054\u5229\u7528\u3044\u305f\u3060\u3051\u307e\u3059\u3002'),
        _buildFaqItem('\u96fb\u6c60\u6d88\u8cbb\u306f\u5927\u4e08\u592b\u3067\u3059\u304b\uff1f', '\u30cf\u30a4\u30d6\u30ea\u30c3\u30c9\u65b9\u5f0f\u3092\u63a1\u7528\u3057\u3001\u79fb\u52d5\u4e2d\u306e\u307f\u9ad8\u983b\u5ea6GPS\u3001\u505c\u6b62\u4e2d\u306f\u7701\u96fb\u529b\u30e2\u30fc\u30c9\u3067\u52d5\u4f5c\u3057\u307e\u3059\u3002\u4e00\u65e5\u7d048\u301c15%\u306e\u96fb\u6c60\u6d88\u8cbb\u3067\u3059\u3002'),
      ],
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Q.', style: TextStyle(color: AppColors.accentCyan, fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(width: 6),
              Expanded(child: Text(question, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('A.', style: TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(width: 6),
              Expanded(child: Text(answer, style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.5))),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool?> _showUpgradeConfirm(BuildContext context, String planName, String price, Color color, IconData icon, List<String> features) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Text('\u30d7\u30e9\u30f3\u30a2\u30c3\u30d7\u30b0\u30ec\u30fc\u30c9', style: TextStyle(color: AppColors.textPrimary, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$planName\uff08$price\uff09\u306b\u30a2\u30c3\u30d7\u30b0\u30ec\u30fc\u30c9\u3057\u307e\u3059\u304b\uff1f', style: TextStyle(color: AppColors.textSecondary, height: 1.5)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: features.map((f) => _confirmFeatureRow(Icons.check, f)).toList(),
              ),
            ),
            const SizedBox(height: 8),
            Text('\u203b \u73fe\u5728\u306f\u30c7\u30e2\u30e2\u30fc\u30c9\u3067\u3059\u3002\u5b9f\u969b\u306e\u8ab2\u91d1\u306f\u767a\u751f\u3057\u307e\u305b\u3093\u3002', style: TextStyle(color: AppColors.warning, fontSize: 11)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('\u30ad\u30e3\u30f3\u30bb\u30eb', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('\u30a2\u30c3\u30d7\u30b0\u30ec\u30fc\u30c9', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  static Widget _confirmFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, color: AppColors.safe, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12))),
        ],
      ),
    );
  }
}

class _FeatureItem {
  final String title;
  final bool included;
  _FeatureItem(this.title, this.included);
}
