import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../providers/plan_provider.dart';

class FamilyDashboardScreen extends StatefulWidget {
  const FamilyDashboardScreen({super.key});

  @override
  State<FamilyDashboardScreen> createState() => _FamilyDashboardScreenState();
}

class _FamilyDashboardScreenState extends State<FamilyDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedChildId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlanProvider>(
      builder: (context, planProvider, _) {
        if (_selectedChildId == null && planProvider.children.isNotEmpty) {
          _selectedChildId = planProvider.children.first.id;
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
                            '\u30d5\u30a1\u30df\u30ea\u30fc\u30c0\u30c3\u30b7\u30e5\u30dc\u30fc\u30c9',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings, color: AppColors.textMuted),
                          onPressed: () => _showFamilySettings(context, planProvider),
                        ),
                      ],
                    ),
                  ),

                  // Family ID banner
                  _buildFamilyIdBanner(planProvider),

                  // Child selector
                  if (planProvider.children.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildChildSelector(planProvider),
                  ],

                  // Tabs
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: AppColors.accentCyan,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: AppColors.textMuted,
                      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      unselectedLabelStyle: const TextStyle(fontSize: 12),
                      dividerHeight: 0,
                      tabs: const [
                        Tab(text: '\u6982\u8981'),
                        Tab(text: '\u30e9\u30a4\u30c9\u5c65\u6b74'),
                        Tab(text: '\u5b89\u5168\u30b9\u30b3\u30a2'),
                      ],
                    ),
                  ),

                  // Tab content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildOverviewTab(planProvider),
                        _buildRideHistoryTab(planProvider),
                        _buildSafetyScoreTab(planProvider),
                      ],
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

  Widget _buildFamilyIdBanner(PlanProvider planProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accentCyan.withValues(alpha: 0.15),
            AppColors.primaryLight.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.vpn_key, color: AppColors.accentCyan, size: 18),
          const SizedBox(width: 8),
          Text(
            '\u30d5\u30a1\u30df\u30ea\u30fcID:',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(width: 8),
          Text(
            planProvider.familyId,
            style: const TextStyle(
              color: AppColors.accentCyan,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: planProvider.familyId));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('ID\u3092\u30b3\u30d4\u30fc\u3057\u307e\u3057\u305f'),
                  backgroundColor: AppColors.info,
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.copy, color: AppColors.accentCyan, size: 14),
                  SizedBox(width: 4),
                  Text('\u30b3\u30d4\u30fc', style: TextStyle(color: AppColors.accentCyan, fontSize: 11)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildSelector(PlanProvider planProvider) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: planProvider.children.length + 1,
        itemBuilder: (context, index) {
          if (index == planProvider.children.length) {
            // Add child button
            return GestureDetector(
              onTap: () => _showAddChildDialog(context),
              child: Container(
                width: 64,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider, style: BorderStyle.solid),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline, color: AppColors.textMuted, size: 24),
                    const SizedBox(height: 4),
                    Text('\u8ffd\u52a0', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                  ],
                ),
              ),
            );
          }

          final child = planProvider.children[index];
          final isSelected = child.id == _selectedChildId;

          return GestureDetector(
            onTap: () => setState(() => _selectedChildId = child.id),
            child: Container(
              width: 80,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accentCyan.withValues(alpha: 0.15) : AppColors.bgCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? AppColors.accentCyan : AppColors.divider,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(child.avatarEmoji, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 2),
                  Text(
                    child.name,
                    style: TextStyle(
                      color: isSelected ? AppColors.accentCyan : AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${child.age}\u6b73',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 10),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewTab(PlanProvider planProvider) {
    final selectedChild = planProvider.children.where((c) => c.id == _selectedChildId).firstOrNull;
    if (selectedChild == null) {
      return const Center(
        child: Text('\u304a\u5b50\u3055\u307e\u3092\u8ffd\u52a0\u3057\u3066\u304f\u3060\u3055\u3044', style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    final reports = planProvider.getReportsForChild(selectedChild.id);
    final avgScore = planProvider.getAverageSafetyScore(selectedChild.id);
    final latestReport = reports.isNotEmpty ? reports.first : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location card (mock)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.safe,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '\u73fe\u5728\u306e\u72b6\u614b',
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.safe.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '\u5b89\u5168',
                        style: TextStyle(color: AppColors.safe, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColors.accentCyan, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '\u6771\u4eac\u90fd\u6e0b\u8c37\u533a\u795e\u5bae\u524d5-XX-XX',
                            style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
                          ),
                          Text(
                            '3\u5206\u524d\u306b\u66f4\u65b0',
                            style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, color: AppColors.textMuted, size: 40),
                        SizedBox(height: 8),
                        Text(
                          '\u30ea\u30a2\u30eb\u30bf\u30a4\u30e0\u30de\u30c3\u30d7',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                        ),
                        Text(
                          '\uff08Firebase\u7d71\u5408\u5f8c\u306b\u6709\u52b9\uff09',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Safety score overview
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
                const Text(
                  '\u5b89\u5168\u30b9\u30b3\u30a2',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 12),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        value: avgScore / 100,
                        strokeWidth: 10,
                        backgroundColor: AppColors.divider,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          avgScore >= 80 ? AppColors.safe : avgScore >= 60 ? AppColors.warning : AppColors.danger,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          '$avgScore',
                          style: TextStyle(
                            color: avgScore >= 80 ? AppColors.safe : avgScore >= 60 ? AppColors.warning : AppColors.danger,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('\u70b9', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _getSafetyMessage(avgScore),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Latest ride
          if (latestReport != null) ...[
            Text(
              '\u6700\u65b0\u306e\u30e9\u30a4\u30c9',
              style: TextStyle(color: AppColors.accentCyan, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
            const SizedBox(height: 8),
            _buildRideCard(latestReport),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRideHistoryTab(PlanProvider planProvider) {
    final reports = _selectedChildId != null
        ? planProvider.getReportsForChild(_selectedChildId!)
        : <RideReport>[];

    if (reports.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('\u{1F6B4}', style: TextStyle(fontSize: 48)),
            SizedBox(height: 12),
            Text('\u30e9\u30a4\u30c9\u5c65\u6b74\u304c\u3042\u308a\u307e\u305b\u3093', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildRideCard(reports[index]),
        );
      },
    );
  }

  Widget _buildSafetyScoreTab(PlanProvider planProvider) {
    final selectedChild = planProvider.children.where((c) => c.id == _selectedChildId).firstOrNull;
    if (selectedChild == null) {
      return const Center(child: Text('\u304a\u5b50\u3055\u307e\u3092\u9078\u629e\u3057\u3066\u304f\u3060\u3055\u3044', style: TextStyle(color: AppColors.textSecondary)));
    }

    final reports = planProvider.getReportsForChild(selectedChild.id);
    final avgScore = planProvider.getAverageSafetyScore(selectedChild.id);
    int totalReverse = 0;
    int totalSpeed = 0;
    int totalStop = 0;
    for (final r in reports) {
      totalReverse += r.reverseRunCount;
      totalSpeed += r.speedWarningCount;
      totalStop += r.stopSignIgnoreCount;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Score trend (mock chart)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '\u5b89\u5168\u30b9\u30b3\u30a2\u63a8\u79fb',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 120,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: reports.reversed.map((r) {
                      final height = (r.safetyScore / 100) * 100;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${r.safetyScore}',
                                style: TextStyle(
                                  color: r.safetyScore >= 80
                                      ? AppColors.safe
                                      : r.safetyScore >= 60
                                          ? AppColors.warning
                                          : AppColors.danger,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                height: height,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      (r.safetyScore >= 80
                                              ? AppColors.safe
                                              : r.safetyScore >= 60
                                                  ? AppColors.warning
                                                  : AppColors.danger)
                                          .withValues(alpha: 0.6),
                                      (r.safetyScore >= 80
                                              ? AppColors.safe
                                              : r.safetyScore >= 60
                                                  ? AppColors.warning
                                                  : AppColors.danger)
                                          .withValues(alpha: 0.2),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '\u5e73\u5747: $avgScore\u70b9',
                      style: TextStyle(
                        color: avgScore >= 80
                            ? AppColors.safe
                            : avgScore >= 60
                                ? AppColors.warning
                                : AppColors.danger,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Warning breakdown
          Text(
            '\u8b66\u544a\u306e\u5185\u8a33',
            style: TextStyle(color: AppColors.accentCyan, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
          const SizedBox(height: 12),
          _buildWarningCard(
            icon: Icons.wrong_location,
            title: '\u9006\u8d70',
            count: totalReverse,
            color: AppColors.danger,
            description: '\u9053\u8def\u306e\u53f3\u5074\u3092\u8d70\u884c\u3057\u305f\u56de\u6570',
          ),
          _buildWarningCard(
            icon: Icons.speed,
            title: '\u901f\u5ea6\u8d85\u904e',
            count: totalSpeed,
            color: AppColors.warning,
            description: '\u5236\u9650\u901f\u5ea6\u3092\u8d85\u3048\u305f\u56de\u6570',
          ),
          _buildWarningCard(
            icon: Icons.front_hand,
            title: '\u4e00\u6642\u505c\u6b62\u7121\u8996',
            count: totalStop,
            color: AppColors.warning,
            description: '\u4e00\u6642\u505c\u6b62\u5730\u70b9\u3067\u6b62\u307e\u3089\u306a\u304b\u3063\u305f\u56de\u6570',
          ),
          const SizedBox(height: 16),

          // Age-based advice
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.lightbulb, color: AppColors.info, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      selectedChild.age <= 12 ? '\u5c0f\u5b66\u751f\u5411\u3051\u30a2\u30c9\u30d0\u30a4\u30b9' : '\u4e2d\u9ad8\u751f\u5411\u3051\u30a2\u30c9\u30d0\u30a4\u30b9',
                      style: const TextStyle(color: AppColors.info, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  selectedChild.age <= 12
                      ? '\u30fb\u4ea4\u5dee\u70b9\u3067\u306f\u5fc5\u305a\u6b62\u307e\u3063\u3066\u5de6\u53f3\u78ba\u8a8d\u3059\u308b\u7df4\u7fd2\u3092\u3057\u307e\u3057\u3087\u3046\n\u30fb\u4fdd\u8b77\u8005\u3068\u4e00\u7dd2\u306b\u901a\u5b66\u8def\u3092\u8d70\u3063\u3066\u5371\u967a\u306a\u5834\u6240\u3092\u78ba\u8a8d\u3057\u307e\u3057\u3087\u3046\n\u30fb\u30d8\u30eb\u30e1\u30c3\u30c8\u306e\u7740\u7528\u3092\u5fd8\u308c\u305a\u306b'
                      : '\u30fb\u4e00\u65b9\u901a\u884c\u306e\u6a19\u8b58\u3092\u610f\u8b58\u3057\u3066\u8d70\u884c\u3057\u307e\u3057\u3087\u3046\n\u30fb\u30b9\u30de\u30db\u3092\u898b\u306a\u304c\u3089\u306e\u904b\u8ee2\u306f\u7d76\u5bfe\u306b\u3084\u3081\u307e\u3057\u3087\u3046\n\u30fb\u591c\u9593\u8d70\u884c\u6642\u306f\u5fc5\u305a\u30e9\u30a4\u30c8\u3092\u70b9\u706f\u3057\u307e\u3057\u3087\u3046',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.6),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRideCard(RideReport report) {
    final alertCount = report.reverseRunCount + report.speedWarningCount + report.stopSignIgnoreCount;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '\u{1F6B4}',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.route,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${report.date.month}/${report.date.day} ${report.date.hour}:${report.date.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (report.safetyScore >= 80 ? AppColors.safe : report.safetyScore >= 60 ? AppColors.warning : AppColors.danger)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${report.safetyScore}\u70b9',
                  style: TextStyle(
                    color: report.safetyScore >= 80 ? AppColors.safe : report.safetyScore >= 60 ? AppColors.warning : AppColors.danger,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatChip(Icons.timer, '${report.duration.inMinutes}\u5206'),
              const SizedBox(width: 12),
              _buildStatChip(Icons.straighten, '${report.distanceKm.toStringAsFixed(1)}km'),
              const SizedBox(width: 12),
              _buildStatChip(
                Icons.warning_amber,
                '$alertCount\u4ef6',
                color: alertCount > 0 ? AppColors.danger : AppColors.safe,
              ),
            ],
          ),
          if (alertCount > 0) ...[
            const SizedBox(height: 10),
            Container(height: 1, color: AppColors.divider),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                if (report.reverseRunCount > 0)
                  _buildAlertTag('\u9006\u8d70 ${report.reverseRunCount}\u56de', AppColors.danger),
                if (report.speedWarningCount > 0)
                  _buildAlertTag('\u901f\u5ea6\u8d85\u904e ${report.speedWarningCount}\u56de', AppColors.warning),
                if (report.stopSignIgnoreCount > 0)
                  _buildAlertTag('\u4e00\u6642\u505c\u6b62 ${report.stopSignIgnoreCount}\u56de', AppColors.warning),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label, {Color? color}) {
    final c = color ?? AppColors.textMuted;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: c, size: 14),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: c, fontSize: 12)),
      ],
    );
  }

  Widget _buildAlertTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildWarningCard({
    required IconData icon,
    required String title,
    required int count,
    required Color color,
    required String description,
  }) {
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                Text(description, style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
          ),
          Text(
            '$count\u56de',
            style: TextStyle(
              color: count > 0 ? color : AppColors.safe,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getSafetyMessage(int score) {
    if (score >= 80) return '\u7d20\u6674\u3089\u3057\u3044\uff01\u5b89\u5168\u904b\u8ee2\u304c\u3067\u304d\u3066\u3044\u307e\u3059 \u{1F389}';
    if (score >= 60) return '\u307e\u305a\u307e\u305a\u3067\u3059\u304c\u3001\u3082\u3046\u5c11\u3057\u6ce8\u610f\u304c\u5fc5\u8981\u3067\u3059 \u{1F4AA}';
    return '\u5371\u967a\u904b\u8ee2\u304c\u591a\u3044\u3067\u3059\u3002\u4e00\u7dd2\u306b\u7df4\u7fd2\u3057\u307e\u3057\u3087\u3046 \u26a0\ufe0f';
  }

  void _showAddChildDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('\u304a\u5b50\u3055\u307e\u306e\u8ffd\u52a0', style: TextStyle(color: AppColors.textPrimary, fontSize: 17)),
        content: Text(
          '\u304a\u5b50\u3055\u307e\u306e\u30a2\u30d7\u30ea\u3067\u30d5\u30a1\u30df\u30ea\u30fcID\u3092\u5165\u529b\u3057\u3066\u53c2\u52a0\u3059\u308b\u3068\u3001\u81ea\u52d5\u7684\u306b\u3053\u3053\u306b\u8868\u793a\u3055\u308c\u307e\u3059\u3002\n\n\u73fe\u5728\u306e\u30c7\u30e2\u30e2\u30fc\u30c9\u3067\u306f\u30b5\u30f3\u30d7\u30eb\u30c7\u30fc\u30bf\u304c\u8868\u793a\u3055\u308c\u3066\u3044\u307e\u3059\u3002',
          style: TextStyle(color: AppColors.textSecondary, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('\u9589\u3058\u308b', style: TextStyle(color: AppColors.accentCyan)),
          ),
        ],
      ),
    );
  }

  void _showFamilySettings(BuildContext context, PlanProvider planProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '\u30d5\u30a1\u30df\u30ea\u30fc\u8a2d\u5b9a',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.vpn_key, color: AppColors.accentCyan),
              title: const Text('ID\u3092\u5171\u6709', style: TextStyle(color: AppColors.textPrimary)),
              subtitle: Text(planProvider.familyId, style: TextStyle(color: AppColors.accentCyan)),
              onTap: () {
                Clipboard.setData(ClipboardData(text: planProvider.familyId));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ID\u3092\u30b3\u30d4\u30fc\u3057\u307e\u3057\u305f'), backgroundColor: AppColors.info),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications, color: AppColors.warning),
              title: const Text('\u901a\u77e5\u8a2d\u5b9a', style: TextStyle(color: AppColors.textPrimary)),
              subtitle: Text('Firebase\u7d71\u5408\u5f8c\u306b\u6709\u52b9', style: TextStyle(color: AppColors.textMuted)),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.danger),
              title: const Text('\u30d5\u30a1\u30df\u30ea\u30fc\u3092\u89e3\u6563', style: TextStyle(color: AppColors.danger)),
              onTap: () async {
                Navigator.pop(ctx);
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    backgroundColor: AppColors.bgCard,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: const Text('\u30d5\u30a1\u30df\u30ea\u30fc\u89e3\u6563', style: TextStyle(color: AppColors.danger)),
                    content: Text(
                      '\u30d5\u30a1\u30df\u30ea\u30fc\u3092\u89e3\u6563\u3059\u308b\u3068\u3001\u3059\u3079\u3066\u306e\u89aa\u5b50\u30ea\u30f3\u30af\u304c\u89e3\u9664\u3055\u308c\u307e\u3059\u3002',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(c, false),
                        child: Text('\u30ad\u30e3\u30f3\u30bb\u30eb', style: TextStyle(color: AppColors.textMuted)),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(c, true),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                        child: const Text('\u89e3\u6563\u3059\u308b', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
                if (confirmed == true && context.mounted) {
                  await planProvider.downgradeToFree();
                  if (context.mounted) Navigator.pop(context);
                }
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
