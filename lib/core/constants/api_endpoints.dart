class ApiEndpoints {
  static const String overpassApi = 'https://overpass-api.de/api/interpreter';
  static const String osmTileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  static String stopSignQuery(double lat, double lon, {int radius = 500}) {
    return '''
    [out:json][timeout:25];
    (
      node["highway"="stop"](around:$radius,$lat,$lon);
    );
    out body;
    ''';
  }

  static String trafficSignalQuery(double lat, double lon, {int radius = 500}) {
    return '''
    [out:json][timeout:25];
    (
      node["highway"="traffic_signals"](around:$radius,$lat,$lon);
    );
    out body;
    ''';
  }

  static String onewayQuery(double lat, double lon, {int radius = 300}) {
    return '''
    [out:json][timeout:25];
    (
      way["oneway"="yes"](around:$radius,$lat,$lon);
    );
    out body;
    >;
    out skel qt;
    ''';
  }

  static String allTrafficDataQuery(double lat, double lon, {int radius = 500}) {
    return '''
    [out:json][timeout:30];
    (
      node["highway"="stop"](around:$radius,$lat,$lon);
      node["highway"="traffic_signals"](around:$radius,$lat,$lon);
      way["oneway"="yes"](around:$radius,$lat,$lon);
    );
    out body;
    >;
    out skel qt;
    ''';
  }
}
