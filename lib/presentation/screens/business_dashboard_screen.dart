import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../providers/plan_provider.dart';

class BusinessDashboardScreen extends StatefulWidget {
  const BusinessDashboardScreen({super.key});

  @override
  State<BusinessDashboardScreen> createState() => _BusinessDashboardScreenState();
}

class _BusinessDashboardScreenState extends State<BusinessDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const Color bizGold = Color(0xFFFFD700);

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
      builder: (context, plan, _) {
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
                        Expanded(
                          child: Text(
                            plan.orgName.isEmpty ? '\u6cd5\u4eba\u30c0\u30c3\u30b7\u30e5\u30dc\u30fc\u30c9' : plan.orgName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings, color: AppColors.textMuted),
                          onPressed: () => _showOrgSettings(context, plan),
                        ),
                      ],
                    ),
                  ),

                  // Org ID banner
                  _buildOrgIdBanner(plan),

                  // Summary stats
                  const SizedBox(height: 12),
                  _buildSummaryRow(plan),

                  // Tabs
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(12)),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(color: bizGold, borderRadius: BorderRadius.circular(12)),
                      labelColor: Colors.black,
                      unselectedLabelColor: AppColors.textMuted,
                      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      unselectedLabelStyle: const TextStyle(fontSize: 12),
                      dividerHeight: 0,
                      tabs: const [
                        Tab(text: '\u5f93\u696d\u54e1'),
                        Tab(text: '\u90e8\u7f72\u7d71\u8a08'),
                        Tab(text: '\u30e9\u30a4\u30c9\u5c65\u6b74'),
                      ],
                    ),
                  ),

                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildMembersTab(plan),
                        _buildDepartmentTab(plan),
                        _buildRideHistoryTab(plan),
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

  Widget _buildOrgIdBanner(PlanProvider plan) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [bizGold.withValues(alpha: 0.15), AppColors.primaryLight.withValues(alpha: 0.1)]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bizGold.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.vpn_key, color: bizGold, size: 18),
          const SizedBox(width: 8),
          Text('\u7d44\u7e54ID:', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(width: 8),
          Text(plan.familyId, style: const TextStyle(color: bizGold, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: plan.familyId));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ID\u3092\u30b3\u30d4\u30fc\u3057\u307e\u3057\u305f'), backgroundColor: AppColors.info, duration: Duration(seconds: 1)),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: bizGold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.copy, color: bizGold, size: 14),
                  SizedBox(width: 4),
                  Text('\u30b3\u30d4\u30fc', style: TextStyle(color: bizGold, fontSize: 11)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(PlanProvider plan) {
    final orgScore = plan.getOrgAverageSafetyScore();
    final totalRides = plan.rideReports.length;
    final totalMembers = plan.members.length;
    int totalAlerts = 0;
    for (final r in plan.rideReports) {
      totalAlerts += r.reverseRunCount + r.speedWarningCount + r.stopSignIgnoreCount;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildStatCard('\u5f93\u696d\u54e1', '$totalMembers\u4eba', Icons.people, bizGold),
          const SizedBox(width: 8),
          _buildStatCard('\u5b89\u5168\u30b9\u30b3\u30a2', '$orgScore\u70b9', Icons.shield,
              orgScore >= 80 ? AppColors.safe : orgScore >= 60 ? AppColors.warning : AppColors.danger),
          const SizedBox(width: 8),
          _buildStatCard('\u4eca\u65e5\u306e\u30e9\u30a4\u30c9', '$totalRides\u4ef6', Icons.directions_bike, AppColors.accentCyan),
          const SizedBox(width: 8),
          _buildStatCard('\u8b66\u544a', '$totalAlerts\u4ef6', Icons.warning_amber,
              totalAlerts > 0 ? AppColors.danger : AppColors.safe),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(color: AppColors.textMuted, fontSize: 9)),
          ],
        ),
      ),
    );
  }

  // ===== Members Tab =====
  Widget _buildMembersTab(PlanProvider plan) {
    if (plan.members.isEmpty) {
      return const Center(child: Text('\u5f93\u696d\u54e1\u304c\u767b\u9332\u3055\u308c\u3066\u3044\u307e\u305b\u3093', style: TextStyle(color: AppColors.textSecondary)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: plan.members.length,
      itemBuilder: (context, index) {
        final member = plan.members[index];
        final avgScore = plan.getAverageSafetyScore(member.id);
        final reports = plan.getReportsForMember(member.id);
        int alerts = 0;
        for (final r in reports) {
          alerts += r.reverseRunCount + r.speedWarningCount + r.stopSignIgnoreCount;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Text(member.avatarEmoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(member.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: bizGold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                          child: Text(member.department, style: TextStyle(color: bizGold, fontSize: 10, fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 8),
                        Text('${reports.length}\u30e9\u30a4\u30c9', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                        if (alerts > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.danger.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                            child: Text('\u8b66\u544a$alerts\u4ef6', style: TextStyle(color: AppColors.danger, fontSize: 10)),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (avgScore >= 80 ? AppColors.safe : avgScore >= 60 ? AppColors.warning : AppColors.danger).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$avgScore\u70b9',
                      style: TextStyle(
                        color: avgScore >= 80 ? AppColors.safe : avgScore >= 60 ? AppColors.warning : AppColors.danger,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6, height: 6,
                        decoration: BoxDecoration(color: member.isActive ? AppColors.safe : AppColors.textMuted, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 4),
                      Text(member.isActive ? '\u30a2\u30af\u30c6\u30a3\u30d6' : '\u30aa\u30d5\u30e9\u30a4\u30f3', style: TextStyle(color: AppColors.textMuted, fontSize: 9)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ===== Department Tab =====
  Widget _buildDepartmentTab(PlanProvider plan) {
    final deptStats = plan.getDepartmentStats();
    final orgScore = plan.getOrgAverageSafetyScore();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Org score
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
                Text('\u7d44\u7e54\u5168\u4f53\u306e\u5b89\u5168\u30b9\u30b3\u30a2', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 12),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 100, height: 100,
                      child: CircularProgressIndicator(
                        value: orgScore / 100,
                        strokeWidth: 10,
                        backgroundColor: AppColors.divider,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          orgScore >= 80 ? AppColors.safe : orgScore >= 60 ? AppColors.warning : AppColors.danger,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text('$orgScore', style: TextStyle(
                          color: orgScore >= 80 ? AppColors.safe : orgScore >= 60 ? AppColors.warning : AppColors.danger,
                          fontSize: 32, fontWeight: FontWeight.bold)),
                        Text('\u70b9', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  orgScore >= 80 ? '\u7d20\u6674\u3089\u3057\u3044\u5b89\u5168\u610f\u8b58\u3067\u3059 \u{1F389}' : orgScore >= 60 ? '\u6539\u5584\u306e\u4f59\u5730\u304c\u3042\u308a\u307e\u3059 \u{1F4AA}' : '\u5b89\u5168\u6559\u80b2\u306e\u5f37\u5316\u304c\u5fc5\u8981\u3067\u3059 \u26a0\ufe0f',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Department breakdown
          Text('\u90e8\u7f72\u5225\u5b89\u5168\u30b9\u30b3\u30a2', style: TextStyle(color: bizGold, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 12),
          ...deptStats.entries.map((entry) {
            final dept = entry.key;
            final score = entry.value;
            final deptMembers = plan.members.where((m) => m.department == dept).length;
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
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
                      Icon(Icons.apartment, color: bizGold, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(dept, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      Text('$deptMembers\u4eba', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: (score >= 80 ? AppColors.safe : score >= 60 ? AppColors.warning : AppColors.danger).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('$score\u70b9', style: TextStyle(
                          color: score >= 80 ? AppColors.safe : score >= 60 ? AppColors.warning : AppColors.danger,
                          fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: score / 100,
                      backgroundColor: AppColors.divider,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        score >= 80 ? AppColors.safe : score >= 60 ? AppColors.warning : AppColors.danger,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 16),
          // Safety education card
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
                    const Icon(Icons.school, color: AppColors.info, size: 18),
                    const SizedBox(width: 8),
                    const Text('\u5b89\u5168\u6559\u80b2\u30b3\u30f3\u30c6\u30f3\u30c4', style: TextStyle(color: AppColors.info, fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '\u30fb\u5f93\u696d\u54e1\u5411\u3051\u4ea4\u901a\u5b89\u5168\u30af\u30a4\u30ba\u3092\u914d\u4fe1\u3067\u304d\u307e\u3059\n\u30fb\u90e8\u7f72\u5225\u306e\u5b89\u5168\u30b9\u30b3\u30a2\u3092\u57fa\u306b\u7814\u4fee\u8a08\u753b\u3092\u7acb\u3066\u307e\u3057\u3087\u3046\n\u30fb\u6708\u6b21PDF\u30ec\u30dd\u30fc\u30c8\u3067\u7d4c\u55b6\u5c64\u3078\u306e\u5831\u544a\u306b\u3082\u6d3b\u7528\u3067\u304d\u307e\u3059',
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

  // ===== Ride History Tab =====
  Widget _buildRideHistoryTab(PlanProvider plan) {
    if (plan.rideReports.isEmpty) {
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
      itemCount: plan.rideReports.length,
      itemBuilder: (context, index) {
        final report = plan.rideReports[index];
        final alertCount = report.reverseRunCount + report.speedWarningCount + report.stopSignIgnoreCount;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
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
                  Text('\u{1F6B4}', style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(report.childName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
                        Text(report.route, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        Text(
                          '${report.date.month}/${report.date.day} ${report.date.hour}:${report.date.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (report.safetyScore >= 80 ? AppColors.safe : report.safetyScore >= 60 ? AppColors.warning : AppColors.danger).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('${report.safetyScore}\u70b9', style: TextStyle(
                      color: report.safetyScore >= 80 ? AppColors.safe : report.safetyScore >= 60 ? AppColors.warning : AppColors.danger,
                      fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _chip(Icons.timer, '${report.duration.inMinutes}\u5206'),
                  const SizedBox(width: 10),
                  _chip(Icons.straighten, '${report.distanceKm.toStringAsFixed(1)}km'),
                  const SizedBox(width: 10),
                  _chip(Icons.warning_amber, '$alertCount\u4ef6', color: alertCount > 0 ? AppColors.danger : AppColors.safe),
                ],
              ),
              if (alertCount > 0) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    if (report.reverseRunCount > 0) _alertTag('\u9006\u8d70 ${report.reverseRunCount}', AppColors.danger),
                    if (report.speedWarningCount > 0) _alertTag('\u901f\u5ea6 ${report.speedWarningCount}', AppColors.warning),
                    if (report.stopSignIgnoreCount > 0) _alertTag('\u4e00\u6642\u505c\u6b62 ${report.stopSignIgnoreCount}', AppColors.warning),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _chip(IconData icon, String label, {Color? color}) {
    final c = color ?? AppColors.textMuted;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(icon, color: c, size: 14), const SizedBox(width: 4), Text(label, style: TextStyle(color: c, fontSize: 12))],
    );
  }

  Widget _alertTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
    );
  }

  void _showOrgSettings(BuildContext context, PlanProvider plan) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            const Text('\u7d44\u7e54\u8a2d\u5b9a', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.business, color: bizGold),
              title: const Text('\u7d44\u7e54\u540d\u5909\u66f4', style: TextStyle(color: AppColors.textPrimary)),
              subtitle: Text(plan.orgName, style: TextStyle(color: bizGold)),
              onTap: () {
                Navigator.pop(ctx);
                _showEditOrgName(context, plan);
              },
            ),
            ListTile(
              leading: const Icon(Icons.vpn_key, color: bizGold),
              title: const Text('ID\u3092\u5171\u6709', style: TextStyle(color: AppColors.textPrimary)),
              subtitle: Text(plan.familyId, style: TextStyle(color: bizGold)),
              onTap: () {
                Clipboard.setData(ClipboardData(text: plan.familyId));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ID\u3092\u30b3\u30d4\u30fc\u3057\u307e\u3057\u305f'), backgroundColor: AppColors.info),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: AppColors.accentCyan),
              title: const Text('\u6708\u6b21\u30ec\u30dd\u30fc\u30c8\u51fa\u529b', style: TextStyle(color: AppColors.textPrimary)),
              subtitle: Text('Firebase\u7d71\u5408\u5f8c\u306b\u6709\u52b9', style: TextStyle(color: AppColors.textMuted)),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.danger),
              title: const Text('\u7d44\u7e54\u3092\u89e3\u6563', style: TextStyle(color: AppColors.danger)),
              onTap: () async {
                Navigator.pop(ctx);
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    backgroundColor: AppColors.bgCard,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: const Text('\u7d44\u7e54\u89e3\u6563', style: TextStyle(color: AppColors.danger)),
                    content: Text('\u7d44\u7e54\u3092\u89e3\u6563\u3059\u308b\u3068\u3001\u5168\u3066\u306e\u5f93\u696d\u54e1\u30ea\u30f3\u30af\u304c\u89e3\u9664\u3055\u308c\u307e\u3059\u3002', style: TextStyle(color: AppColors.textSecondary)),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(c, false), child: Text('\u30ad\u30e3\u30f3\u30bb\u30eb', style: TextStyle(color: AppColors.textMuted))),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(c, true),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                        child: const Text('\u89e3\u6563\u3059\u308b', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
                if (confirmed == true && context.mounted) {
                  await plan.downgradeToFree();
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

  void _showEditOrgName(BuildContext context, PlanProvider plan) {
    final controller = TextEditingController(text: plan.orgName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('\u7d44\u7e54\u540d\u5909\u66f4', style: TextStyle(color: AppColors.textPrimary)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: '\u7d44\u7e54\u540d\u3092\u5165\u529b',
            hintStyle: TextStyle(color: AppColors.textMuted),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.divider)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('\u30ad\u30e3\u30f3\u30bb\u30eb', style: TextStyle(color: AppColors.textMuted))),
          ElevatedButton(
            onPressed: () async {
              await plan.setOrgName(controller.text.trim());
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: bizGold),
            child: const Text('\u4fdd\u5b58', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
