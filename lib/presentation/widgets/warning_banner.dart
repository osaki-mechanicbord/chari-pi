import 'package:flutter/material.dart';
import 'package:cycle_guard/l10n/app_localizations.dart';
import '../../core/constants/colors.dart';
import '../../data/models/osm_node.dart';

class WarningBanner extends StatelessWidget {
  final List<OSMNode> warnings;

  const WarningBanner({super.key, required this.warnings});

  String _getLocalizedType(L10n l, OSMNodeType type) {
    switch (type) {
      case OSMNodeType.stopSign:
        return l.nodeStopSign;
      case OSMNodeType.trafficSignal:
        return l.nodeTrafficSignal;
      case OSMNodeType.oneway:
        return l.nodeOneway;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return SafeArea(
      child: Column(
        children: warnings.take(2).map((warning) {
          Color bgColor;
          IconData icon;
          switch (warning.type) {
            case OSMNodeType.stopSign:
              bgColor = AppColors.danger;
              icon = Icons.front_hand;
              break;
            case OSMNodeType.trafficSignal:
              bgColor = AppColors.warning;
              icon = Icons.traffic;
              break;
            case OSMNodeType.oneway:
              bgColor = AppColors.info;
              icon = Icons.arrow_forward;
              break;
          }
          final dist = warning.distanceFromUser?.round() ?? 0;
          final typeName = _getLocalizedType(l, warning.type);
          return Container(
            margin: const EdgeInsets.fromLTRB(12, 4, 12, 0),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: bgColor.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: bgColor.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l.warningMessageFormat(dist, typeName),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${dist}m',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
