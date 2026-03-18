class ApiEndpoints {
  static const String overpassApi = 'https://overpass-api.de/api/interpreter';
  static const String osmTileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  /// 包括的な交通規制データクエリ（13種類の標識・規制情報）
  /// 自転車の罰金リスクを最大限カバー
  static String allTrafficDataQuery(double lat, double lon, {int radius = 500}) {
    return '''
    [out:json][timeout:30];
    (
      // === 既存（改善） ===
      // ① 一時停止標識
      node["highway"="stop"](around:$radius,$lat,$lon);
      // ② 信号機
      node["highway"="traffic_signals"](around:$radius,$lat,$lon);
      // ③ 一方通行（way方向で逆走検知）
      way["oneway"="yes"](around:$radius,$lat,$lon);

      // === 新規追加: 罰金リスク直結 ===
      // ④ 歩行者専用道路（自転車走行禁止）
      way["highway"="pedestrian"](around:$radius,$lat,$lon);
      // ⑤ 歩道（条件付き走行可）
      way["highway"="footway"](around:$radius,$lat,$lon);
      // ⑥ 歩行者専用指定の道路
      way["foot"="designated"]["bicycle"!="yes"]["bicycle"!="designated"](around:$radius,$lat,$lon);
      // ⑦ 自転車専用道路（推奨ルート）
      way["highway"="cycleway"](around:$radius,$lat,$lon);
      // ⑧ 自転車通行禁止道路
      way["bicycle"="no"](around:$radius,$lat,$lon);
      // ⑨ 押し歩き区間
      way["bicycle"="dismount"](around:$radius,$lat,$lon);
      // ⑩ 横断歩道
      node["highway"="crossing"](around:$radius,$lat,$lon);
      // ⑪ 自転車レーン（車道上）
      way["cycleway"="lane"](around:$radius,$lat,$lon);
      way["cycleway:left"="lane"](around:$radius,$lat,$lon);
      way["cycleway:right"="lane"](around:$radius,$lat,$lon);
      // ⑫ 制限速度のある道路
      way["maxspeed"](around:$radius,$lat,$lon);
    );
    out body;
    >;
    out skel qt;
    ''';
  }

  // ===== 個別クエリ（デバッグ・テスト用） =====

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

  /// 歩行者専用・歩道・自転車禁止エリアのクエリ
  static String pedestrianZonesQuery(double lat, double lon, {int radius = 300}) {
    return '''
    [out:json][timeout:25];
    (
      way["highway"="pedestrian"](around:$radius,$lat,$lon);
      way["highway"="footway"](around:$radius,$lat,$lon);
      way["bicycle"="no"](around:$radius,$lat,$lon);
      way["bicycle"="dismount"](around:$radius,$lat,$lon);
    );
    out body;
    >;
    out skel qt;
    ''';
  }

  /// 自転車インフラ（自転車道・レーン）のクエリ
  static String cycleInfraQuery(double lat, double lon, {int radius = 500}) {
    return '''
    [out:json][timeout:25];
    (
      way["highway"="cycleway"](around:$radius,$lat,$lon);
      way["cycleway"="lane"](around:$radius,$lat,$lon);
    );
    out body;
    >;
    out skel qt;
    ''';
  }
}
