class RideRecord {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final double distanceMeters;
  final int warningsCount;
  final int stopSignCount;
  final int trafficSignalCount;
  final int onewayCount;
  final List<Map<String, double>> routePoints;

  RideRecord({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.distanceMeters,
    required this.warningsCount,
    this.stopSignCount = 0,
    this.trafficSignalCount = 0,
    this.onewayCount = 0,
    this.routePoints = const [],
  });

  Duration get duration => endTime.difference(startTime);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'distanceMeters': distanceMeters,
      'warningsCount': warningsCount,
      'stopSignCount': stopSignCount,
      'trafficSignalCount': trafficSignalCount,
      'onewayCount': onewayCount,
    };
  }

  factory RideRecord.fromJson(Map<String, dynamic> json) {
    return RideRecord(
      id: json['id'] ?? '',
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      distanceMeters: (json['distanceMeters'] as num).toDouble(),
      warningsCount: json['warningsCount'] as int? ?? 0,
      stopSignCount: json['stopSignCount'] as int? ?? 0,
      trafficSignalCount: json['trafficSignalCount'] as int? ?? 0,
      onewayCount: json['onewayCount'] as int? ?? 0,
    );
  }
}
