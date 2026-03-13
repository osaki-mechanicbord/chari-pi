import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../../data/models/osm_node.dart';
import '../constants/api_endpoints.dart';
import '../utils/distance_calculator.dart' as utils;

class OSMService {
  static final OSMService _instance = OSMService._internal();
  factory OSMService() => _instance;
  OSMService._internal();

  final Map<String, List<OSMNode>> _cache = {};
  DateTime? _lastFetchTime;
  static const Duration _cacheDuration = Duration(minutes: 5);

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
        final nodes = <OSMNode>[];

        // Collect bare node coordinates from 'out skel qt' for way lookups
        final nodeCoords = <int, List<double>>{};
        for (final element in elements) {
          if (element['type'] == 'node' && element['lat'] != null) {
            nodeCoords[element['id'] as int] = [
              (element['lat'] as num).toDouble(),
              (element['lon'] as num).toDouble(),
            ];
          }
        }

        for (final element in elements) {
          if (element['type'] == 'node' && element['lat'] != null) {
            final tags = element['tags'] as Map<String, dynamic>?;
            if (tags != null) {
              if (tags['highway'] == 'stop') {
                nodes.add(OSMNode.fromJson(element, OSMNodeType.stopSign));
              } else if (tags['highway'] == 'traffic_signals') {
                nodes.add(OSMNode.fromJson(element, OSMNodeType.trafficSignal));
              }
            }
          }

          // Parse oneway ways: use midpoint of the way as the warning position
          if (element['type'] == 'way') {
            final tags = element['tags'] as Map<String, dynamic>?;
            if (tags != null && tags['oneway'] == 'yes') {
              final nodeIds = element['nodes'] as List<dynamic>? ?? [];
              if (nodeIds.isNotEmpty) {
                // Find the closest node of this way to the user
                double? closestLat;
                double? closestLon;
                double closestDist = double.infinity;
                for (final nid in nodeIds) {
                  final coord = nodeCoords[nid as int];
                  if (coord != null) {
                    final d = utils.DistanceCalculator.calculateDistance(
                      lat, lon, coord[0], coord[1],
                    );
                    if (d < closestDist) {
                      closestDist = d;
                      closestLat = coord[0];
                      closestLon = coord[1];
                    }
                  }
                }
                if (closestLat != null && closestLon != null) {
                  nodes.add(OSMNode(
                    id: element['id'] as int,
                    type: OSMNodeType.oneway,
                    position: LatLng(closestLat, closestLon),
                    tags: tags.map((k, v) => MapEntry(k, v.toString())),
                  ));
                }
              }
            }
          }
        }

        _cache[cacheKey] = nodes;
        _lastFetchTime = DateTime.now();
        return _updateDistances(nodes, lat, lon);
      }
    } catch (e) {
      // Return cached data if available on error
      if (_cache.containsKey(cacheKey)) {
        return _updateDistances(_cache[cacheKey]!, lat, lon);
      }
    }
    return [];
  }

  List<OSMNode> _updateDistances(List<OSMNode> nodes, double lat, double lon) {
    return nodes.map((node) {
      final distance = utils.DistanceCalculator.calculateDistance(
        lat, lon,
        node.position.latitude, node.position.longitude,
      );
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
