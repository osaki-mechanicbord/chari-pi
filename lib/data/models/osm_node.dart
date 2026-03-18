import 'dart:math' as math;
import 'package:latlong2/latlong.dart';

enum OSMNodeType {
  stopSign,
  trafficSignal,
  oneway,
  // 新規追加: 罰金リスク直結の検知対象
  pedestrianRoad,   // 歩行者専用道路 (highway=pedestrian)
  footway,          // 歩道 (highway=footway)
  footwayNoBicycle, // 自転車禁止歩道 (highway=footway + bicycle=no)
  cycleway,         // 自転車専用道路 (highway=cycleway)
  crossing,         // 横断歩道 (highway=crossing)
  noBicycle,        // 自転車通行禁止 (bicycle=no on road)
  dismount,         // 押し歩き区間 (bicycle=dismount)
  speedLimit,       // 制限速度区間
  accidentZone,     // 事故多発地点（警察庁データ）
  enforcementZone,  // 取り締まり重点エリア
}

/// 警告の緊急度レベル
enum WarningLevel {
  info,     // 情報提供（自転車レーン案内など）
  caution,  // 注意喚起（横断歩道など）
  warning,  // 警告（一時停止接近など）
  danger,   // 危険（逆走・歩行者専用道路走行中など）
}

class OSMNode {
  final int id;
  final OSMNodeType type;
  final LatLng position;
  final Map<String, String> tags;
  final double? distanceFromUser;

  // 逆走検知用: way の進行許可方向（度数、北=0、時計回り）
  final double? wayBearing;

  // way のノード列（逆走検知の精密計算用）
  final List<LatLng>? wayNodes;

  // 制限速度
  final int? speedLimit;

  // 警告レベル（動的に更新）
  final WarningLevel? warningLevel;

  // 逆走フラグ
  final bool isWrongWay;

  OSMNode({
    required this.id,
    required this.type,
    required this.position,
    this.tags = const {},
    this.distanceFromUser,
    this.wayBearing,
    this.wayNodes,
    this.speedLimit,
    this.warningLevel,
    this.isWrongWay = false,
  });

  OSMNode copyWith({
    double? distanceFromUser,
    WarningLevel? warningLevel,
    bool? isWrongWay,
  }) {
    return OSMNode(
      id: id,
      type: type,
      position: position,
      tags: tags,
      distanceFromUser: distanceFromUser ?? this.distanceFromUser,
      wayBearing: wayBearing,
      wayNodes: wayNodes,
      speedLimit: speedLimit,
      warningLevel: warningLevel ?? this.warningLevel,
      isWrongWay: isWrongWay ?? this.isWrongWay,
    );
  }

  String get typeLabel {
    switch (type) {
      case OSMNodeType.stopSign:
        return '一時停止';
      case OSMNodeType.trafficSignal:
        return '信号機';
      case OSMNodeType.oneway:
        return '一方通行';
      case OSMNodeType.pedestrianRoad:
        return '歩行者専用道路';
      case OSMNodeType.footway:
        return '歩道';
      case OSMNodeType.footwayNoBicycle:
        return '自転車禁止歩道';
      case OSMNodeType.cycleway:
        return '自転車専用道路';
      case OSMNodeType.crossing:
        return '横断歩道';
      case OSMNodeType.noBicycle:
        return '自転車通行禁止';
      case OSMNodeType.dismount:
        return '押し歩き区間';
      case OSMNodeType.speedLimit:
        return '速度制限区間';
      case OSMNodeType.accidentZone:
        return '事故多発地点';
      case OSMNodeType.enforcementZone:
        return '取り締まり重点エリア';
    }
  }

  /// 罰金リスクレベル（音声ガイダンスの優先度に使用）
  int get penaltyRisk {
    switch (type) {
      case OSMNodeType.pedestrianRoad:
      case OSMNodeType.footwayNoBicycle:
      case OSMNodeType.noBicycle:
        return 5; // 最高リスク
      case OSMNodeType.oneway:
        return isWrongWay ? 5 : 2;
      case OSMNodeType.stopSign:
        return 4;
      case OSMNodeType.dismount:
        return 3;
      case OSMNodeType.footway:
      case OSMNodeType.crossing:
        return 3;
      case OSMNodeType.trafficSignal:
        return 3;
      case OSMNodeType.enforcementZone:
        return 4;
      case OSMNodeType.accidentZone:
        return 2;
      case OSMNodeType.speedLimit:
        return 2;
      case OSMNodeType.cycleway:
        return 1; // 案内情報
    }
  }

  String get warningMessage {
    final dist = distanceFromUser?.round() ?? 0;
    return '${dist}m先に$typeLabelあり';
  }

  factory OSMNode.fromJson(Map<String, dynamic> json, OSMNodeType type) {
    final lat = (json['lat'] as num).toDouble();
    final lon = (json['lon'] as num).toDouble();
    final tags = <String, String>{};
    if (json['tags'] != null) {
      (json['tags'] as Map<String, dynamic>).forEach((key, value) {
        tags[key] = value.toString();
      });
    }

    int? maxSpeed;
    if (tags.containsKey('maxspeed')) {
      maxSpeed = int.tryParse(tags['maxspeed']!.replaceAll(RegExp(r'[^0-9]'), ''));
    }

    return OSMNode(
      id: json['id'] as int,
      type: type,
      position: LatLng(lat, lon),
      tags: tags,
      speedLimit: maxSpeed,
    );
  }

  /// way の node 列から進行許可方向（bearing）を算出
  static double? calculateWayBearing(List<LatLng> nodes) {
    if (nodes.length < 2) return null;
    final first = nodes.first;
    final last = nodes.last;
    return _calculateBearing(
      first.latitude, first.longitude,
      last.latitude, last.longitude,
    );
  }

  /// 2点間の方位角を計算（度数、北=0、時計回り）
  static double _calculateBearing(double lat1, double lon1, double lat2, double lon2) {
    final dLon = _toRadians(lon2 - lon1);
    final y = math.sin(dLon) * math.cos(_toRadians(lat2));
    final x = math.cos(_toRadians(lat1)) * math.sin(_toRadians(lat2)) -
              math.sin(_toRadians(lat1)) * math.cos(_toRadians(lat2)) * math.cos(dLon);
    final bearing = math.atan2(y, x);
    return (_toDegrees(bearing) + 360) % 360;
  }

  /// ユーザーの heading と way の方向を比較して逆走判定
  /// 戻り値: true = 逆走中
  static bool isGoingWrongWay(double userHeading, double wayBearing) {
    final diff = ((userHeading - wayBearing) + 360) % 360;
    // 120°〜240° = おおよそ逆方向
    return diff > 120 && diff < 240;
  }

  /// ユーザーの現在位置から way（線分列）への最短距離を計算
  static double distanceToWay(LatLng userPos, List<LatLng> wayNodes) {
    if (wayNodes.isEmpty) return double.infinity;
    if (wayNodes.length == 1) {
      return _haversineDistance(
        userPos.latitude, userPos.longitude,
        wayNodes.first.latitude, wayNodes.first.longitude,
      );
    }

    double minDist = double.infinity;
    for (int i = 0; i < wayNodes.length - 1; i++) {
      final dist = _pointToSegmentDistance(
        userPos, wayNodes[i], wayNodes[i + 1],
      );
      if (dist < minDist) minDist = dist;
    }
    return minDist;
  }

  /// 点から線分への最短距離（メートル）
  static double _pointToSegmentDistance(LatLng p, LatLng a, LatLng b) {
    // 簡易直交座標変換（小区間なので十分な精度）
    final cosLat = math.cos(_toRadians(p.latitude));
    final px = (p.longitude - a.longitude) * cosLat;
    final py = p.latitude - a.latitude;
    final bx = (b.longitude - a.longitude) * cosLat;
    final by = b.latitude - a.latitude;

    final dot = px * bx + py * by;
    final lenSq = bx * bx + by * by;

    double t = 0;
    if (lenSq > 0) {
      t = (dot / lenSq).clamp(0.0, 1.0);
    }

    final closestLat = a.latitude + t * by;
    final closestLon = a.longitude + t * (b.longitude - a.longitude);

    return _haversineDistance(
      p.latitude, p.longitude, closestLat, closestLon,
    );
  }

  static double _haversineDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371000.0;
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
              math.cos(_toRadians(lat1)) * math.cos(_toRadians(lat2)) *
              math.sin(dLon / 2) * math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  static double _toRadians(double degrees) => degrees * math.pi / 180;
  static double _toDegrees(double radians) => radians * 180 / math.pi;
}
