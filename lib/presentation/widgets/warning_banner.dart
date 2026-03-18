import 'package:flutter/material.dart';
import 'package:cycle_guard/l10n/app_localizations.dart';
import '../../core/constants/colors.dart';
import '../../data/models/osm_node.dart';

class WarningBanner extends StatelessWidget {
  final List<OSMNode> warnings;

  const WarningBanner({super.key, required this.warnings});

  /// Map node type to localized display name
  String _getLocalizedType(L10n l, OSMNode node) {
    switch (node.type) {
      case OSMNodeType.stopSign:
        return l.nodeStopSign;
      case OSMNodeType.trafficSignal:
        return l.nodeTrafficSignal;
      case OSMNodeType.oneway:
        if (node.isWrongWay) return l.nodeWrongWay;
        return l.nodeOneway;
      case OSMNodeType.pedestrianRoad:
        return l.nodePedestrianRoad;
      case OSMNodeType.footway:
        return l.nodeFootway;
      case OSMNodeType.footwayNoBicycle:
        return l.nodeFootwayNoBicycle;
      case OSMNodeType.cycleway:
        return l.nodeCycleway;
      case OSMNodeType.crossing:
        return l.nodeCrossing;
      case OSMNodeType.noBicycle:
        return l.nodeNoBicycle;
      case OSMNodeType.dismount:
        return l.nodeDismount;
      case OSMNodeType.speedLimit:
        if (node.speedLimit != null) {
          return '${l.nodeSpeedLimit} ${node.speedLimit}km/h';
        }
        return l.nodeSpeedLimit;
      case OSMNodeType.accidentZone:
        return l.nodeAccidentZone;
      case OSMNodeType.enforcementZone:
        return l.nodeEnforcementZone;
    }
  }

  /// Get background color based on warning level
  Color _getBgColor(OSMNode node) {
    final level = node.warningLevel ?? WarningLevel.caution;
    switch (level) {
      case WarningLevel.danger:
        return AppColors.danger;
      case WarningLevel.warning:
        return AppColors.warning;
      case WarningLevel.caution:
        return const Color(0xFFFF8C00); // dark orange
      case WarningLevel.info:
        return AppColors.info;
    }
  }

  /// Get icon for each node type
  IconData _getIcon(OSMNode node) {
    switch (node.type) {
      case OSMNodeType.stopSign:
        return Icons.front_hand;
      case OSMNodeType.trafficSignal:
        return Icons.traffic;
      case OSMNodeType.oneway:
        return node.isWrongWay ? Icons.warning_amber : Icons.arrow_forward;
      case OSMNodeType.pedestrianRoad:
        return Icons.directions_walk;
      case OSMNodeType.footway:
        return Icons.directions_walk;
      case OSMNodeType.footwayNoBicycle:
        return Icons.no_transfer;
      case OSMNodeType.cycleway:
        return Icons.pedal_bike;
      case OSMNodeType.crossing:
        return Icons.transfer_within_a_station;
      case OSMNodeType.noBicycle:
        return Icons.block;
      case OSMNodeType.dismount:
        return Icons.directions_walk;
      case OSMNodeType.speedLimit:
        return Icons.speed;
      case OSMNodeType.accidentZone:
        return Icons.car_crash;
      case OSMNodeType.enforcementZone:
        return Icons.local_police;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return SafeArea(
      child: Column(
        children: warnings.take(3).map((warning) {
          final bgColor = _getBgColor(warning);
          final icon = _getIcon(warning);
          final dist = warning.distanceFromUser?.round() ?? 0;
          final typeName = _getLocalizedType(l, warning);

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.warningMessageFormat(dist, typeName),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Show penalty info for high-risk types
                      if (warning.penaltyRisk >= 4)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            _getPenaltyHint(warning, l),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 11,
                            ),
                          ),
                        ),
                    ],
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

  /// Penalty hint for high-risk violations
  String _getPenaltyHint(OSMNode node, L10n l) {
    switch (node.type) {
      case OSMNodeType.oneway:
        if (node.isWrongWay) return l.penaltyWrongWay;
        return '';
      case OSMNodeType.pedestrianRoad:
      case OSMNodeType.footwayNoBicycle:
      case OSMNodeType.noBicycle:
        return l.penaltyNoBicycle;
      case OSMNodeType.stopSign:
        return l.penaltyStopSign;
      case OSMNodeType.enforcementZone:
        return l.penaltyEnforcement;
      default:
        return '';
    }
  }
}
