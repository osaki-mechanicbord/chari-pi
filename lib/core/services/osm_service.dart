import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:flutter/foundation.dart';
import '../../data/models/osm_node.dart';
import '../constants/api_endpoints.dart';
import '../utils/distance_calculator.dart' as utils;

class OSMService {
  static final OSMService _instance = OSMService._internal();
  factory OSMService() => _instance;
  OSMService._internal();

  final Map<String, List<OSMNode>> _cache = {};
  DateTime? _lastFetchTime;
  static const Duration _cacheDuration = Duration(minutes: 3);

  Future<List<OSMNode>> fetchNearbyNodes(double lat, double lon) async {
    final cacheKey = '${lat.toStringAsFixed(3)}_${lon.toStringAsFixed(3)}';

    if (_cache.containsKey(cacheKey) &&
        _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
      return _updateDistances(_cache[cacheKey]!, lat, lon);
    }

    try {
      final query = ApiEndpoints.allTrafficDataQuery(lat, lon);
      final response = await http.post(
        Uri.parse(ApiEndpoints.overpassApi),
        body: {'data': query},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final elements = data['elements'] as List<dynamic>? ?? [];
        final nodes = _parseElements(elements, lat, lon);

        _cache[cacheKey] = nodes;
        _lastFetchTime = DateTime.now();
        return _updateDistances(nodes, lat, lon);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('OSM fetch error: $e');
      }
      if (_cache.containsKey(cacheKey)) {
        return _updateDistances(_cache[cacheKey]!, lat, lon);
      }
    }
    return [];
  }

  /// 全要素をパースして OSMNode リストに変換
  List<OSMNode> _parseElements(List<dynamic> elements, double userLat, double userLon) {
    final nodes = <OSMNode>[];

    // bare node の座標マップ（way の node 参照用）
    final nodeCoords = <int, LatLng>{};
    for (final element in elements) {
      if (element['type'] == 'node' && element['lat'] != null) {
        nodeCoords[element['id'] as int] = LatLng(
          (element['lat'] as num).toDouble(),
          (element['lon'] as num).toDouble(),
        );
      }
    }

    // 重複排除用（同一ID）
    final processedIds = <int>{};

    for (final element in elements) {
      final elementId = element['id'] as int;
      if (processedIds.contains(elementId)) continue;

      // === Node 要素 ===
      if (element['type'] == 'node' && element['lat'] != null) {
        final tags = element['tags'] as Map<String, dynamic>?;
        if (tags == null) continue;

        final highway = tags['highway'] as String?;
        if (highway == 'stop') {
          processedIds.add(elementId);
          nodes.add(OSMNode.fromJson(element, OSMNodeType.stopSign));
        } else if (highway == 'traffic_signals') {
          processedIds.add(elementId);
          nodes.add(OSMNode.fromJson(element, OSMNodeType.trafficSignal));
        } else if (highway == 'crossing') {
          processedIds.add(elementId);
          nodes.add(OSMNode.fromJson(element, OSMNodeType.crossing));
        }
      }

      // === Way 要素 ===
      if (element['type'] == 'way') {
        final tags = element['tags'] as Map<String, dynamic>?;
        if (tags == null) continue;

        final nodeIds = element['nodes'] as List<dynamic>? ?? [];
        final wayLatLngs = <LatLng>[];
        for (final nid in nodeIds) {
          final coord = nodeCoords[nid as int];
          if (coord != null) wayLatLngs.add(coord);
        }
        if (wayLatLngs.isEmpty) continue;

        // way のユーザー最近接点を求める
        final closestPoint = _findClosestPointOnWay(wayLatLngs, userLat, userLon);
        if (closestPoint == null) continue;

        final tagMap = tags.map((k, v) => MapEntry(k, v.toString()));
        final highway = tags['highway'] as String?;
        final bicycle = tags['bicycle'] as String?;
        final oneway = tags['oneway'] as String?;
        final foot = tags['foot'] as String?;
        final cycleway = tags['cycleway'] as String?;
        final cyclewayLeft = tags['cycleway:left'] as String?;
        final cyclewayRight = tags['cycleway:right'] as String?;

        processedIds.add(elementId);

        // 一方通行（逆走検知のための方向情報付き）
        if (oneway == 'yes') {
          final bearing = OSMNode.calculateWayBearing(wayLatLngs);
          nodes.add(OSMNode(
            id: elementId,
            type: OSMNodeType.oneway,
            position: closestPoint,
            tags: tagMap,
            wayBearing: bearing,
            wayNodes: wayLatLngs,
          ));
        }

        // 歩行者専用道路
        if (highway == 'pedestrian') {
          nodes.add(OSMNode(
            id: elementId + 100000,
            type: OSMNodeType.pedestrianRoad,
            position: closestPoint,
            tags: tagMap,
            wayNodes: wayLatLngs,
          ));
        }

        // 歩道
        if (highway == 'footway') {
          final isCrossing = tags['footway'] == 'crossing';
          if (!isCrossing) {
            if (bicycle == 'no') {
              nodes.add(OSMNode(
                id: elementId + 200000,
                type: OSMNodeType.footwayNoBicycle,
                position: closestPoint,
                tags: tagMap,
                wayNodes: wayLatLngs,
              ));
            } else {
              nodes.add(OSMNode(
                id: elementId + 300000,
                type: OSMNodeType.footway,
                position: closestPoint,
                tags: tagMap,
                wayNodes: wayLatLngs,
              ));
            }
          }
        }

        // 自転車専用道路
        if (highway == 'cycleway') {
          nodes.add(OSMNode(
            id: elementId + 400000,
            type: OSMNodeType.cycleway,
            position: closestPoint,
            tags: tagMap,
            wayNodes: wayLatLngs,
          ));
        }

        // 自転車通行禁止
        if (bicycle == 'no' && highway != 'footway') {
          nodes.add(OSMNode(
            id: elementId + 500000,
            type: OSMNodeType.noBicycle,
            position: closestPoint,
            tags: tagMap,
            wayNodes: wayLatLngs,
          ));
        }

        // 押し歩き区間
        if (bicycle == 'dismount') {
          nodes.add(OSMNode(
            id: elementId + 600000,
            type: OSMNodeType.dismount,
            position: closestPoint,
            tags: tagMap,
            wayNodes: wayLatLngs,
          ));
        }

        // 自転車レーン（車道上）
        if (cycleway == 'lane' || cyclewayLeft == 'lane' || cyclewayRight == 'lane') {
          nodes.add(OSMNode(
            id: elementId + 700000,
            type: OSMNodeType.cycleway,
            position: closestPoint,
            tags: tagMap,
            wayNodes: wayLatLngs,
          ));
        }

        // 歩行者専用指定（foot=designated + 自転車不可）
        if (foot == 'designated' && bicycle != 'yes' && bicycle != 'designated' && highway != 'footway' && highway != 'pedestrian') {
          nodes.add(OSMNode(
            id: elementId + 800000,
            type: OSMNodeType.pedestrianRoad,
            position: closestPoint,
            tags: tagMap,
            wayNodes: wayLatLngs,
          ));
        }

        // 制限速度
        if (tags.containsKey('maxspeed')) {
          final maxSpeed = int.tryParse(
            (tags['maxspeed'] as String).replaceAll(RegExp(r'[^0-9]'), ''),
          );
          if (maxSpeed != null) {
            nodes.add(OSMNode(
              id: elementId + 900000,
              type: OSMNodeType.speedLimit,
              position: closestPoint,
              tags: tagMap,
              wayNodes: wayLatLngs,
              speedLimit: maxSpeed,
            ));
          }
        }
      }
    }

    return nodes;
  }

  /// way 上のユーザー最近接点を求める
  LatLng? _findClosestPointOnWay(List<LatLng> wayNodes, double userLat, double userLon) {
    if (wayNodes.isEmpty) return null;

    double closestDist = double.infinity;
    LatLng? closestPoint;

    for (final node in wayNodes) {
      final d = utils.DistanceCalculator.calculateDistance(
        userLat, userLon, node.latitude, node.longitude,
      );
      if (d < closestDist) {
        closestDist = d;
        closestPoint = node;
      }
    }
    return closestPoint;
  }

  List<OSMNode> _updateDistances(List<OSMNode> nodes, double lat, double lon) {
    return nodes.map((node) {
      double distance;
      // way データがある場合、way への最短距離を使用（より正確）
      if (node.wayNodes != null && node.wayNodes!.length >= 2) {
        distance = OSMNode.distanceToWay(LatLng(lat, lon), node.wayNodes!);
      } else {
        distance = utils.DistanceCalculator.calculateDistance(
          lat, lon,
          node.position.latitude, node.position.longitude,
        );
      }
      return node.copyWith(distanceFromUser: distance);
    }).toList()
      ..sort((a, b) => (a.distanceFromUser ?? 0).compareTo(b.distanceFromUser ?? 0));
  }

  List<OSMNode> getWarningNodes(List<OSMNode> nodes, {double threshold = 100}) {
    return nodes.where((n) => (n.distanceFromUser ?? double.infinity) <= threshold).toList();
  }

  void clearCache() {
    _cache.clear();
    _lastFetchTime = null;
  }
}
