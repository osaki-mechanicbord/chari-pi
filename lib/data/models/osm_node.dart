import 'package:latlong2/latlong.dart';

enum OSMNodeType { stopSign, trafficSignal, oneway }

class OSMNode {
  final int id;
  final OSMNodeType type;
  final LatLng position;
  final Map<String, String> tags;
  final double? distanceFromUser;

  OSMNode({
    required this.id,
    required this.type,
    required this.position,
    this.tags = const {},
    this.distanceFromUser,
  });

  OSMNode copyWith({double? distanceFromUser}) {
    return OSMNode(
      id: id,
      type: type,
      position: position,
      tags: tags,
      distanceFromUser: distanceFromUser ?? this.distanceFromUser,
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
    }
  }

  String get warningMessage {
    final dist = distanceFromUser?.round() ?? 0;
    return '${dist}m先に${typeLabel}あり';
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
    return OSMNode(
      id: json['id'] as int,
      type: type,
      position: LatLng(lat, lon),
      tags: tags,
    );
  }
}
