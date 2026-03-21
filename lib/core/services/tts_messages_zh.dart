import '../../data/models/osm_node.dart';

/// 中国語 TTS メッセージ
String getTtsMessageZh(OSMNode node, int stage, int dist, {double? userSpeed}) {
  switch (node.type) {
    case OSMNodeType.stopSign:
      switch (stage) {
        case 1: return '前方有停车标志';
        case 2: return '正在接近停车标志。请减速';
        case 3: return '停车标志。请完全停车';
        default: return '';
      }
    case OSMNodeType.trafficSignal:
      switch (stage) {
        case 1: return '前方$dist米处有信号灯';
        case 2: return '正在接近信号灯。请确认信号';
        case 3: return '信号灯。请遵守信号';
        default: return '';
      }
    case OSMNodeType.oneway:
      if (node.isWrongWay) {
        switch (stage) {
          case 1: return '警告。前方道路是单行道。请确认行驶方向';
          case 2: return '危险。正在逆行单行道。请在安全处停车';
          case 3: return '逆行。请立即停车';
          default: return '';
        }
      }
      switch (stage) {
        case 1: return '前方$dist米处有单行道';
        case 2: return '正在接近单行道。请确认方向';
        case 3: return '单行道。请注意通行方向';
        default: return '';
      }
    case OSMNodeType.pedestrianRoad:
      switch (stage) {
        case 1: return '前方有行人专用道路。自行车不可通行';
        case 2: return '正在接近行人专用道路。请绕行';
        case 3: return '行人专用道路。禁止骑自行车';
        default: return '';
      }
    case OSMNodeType.footway:
      switch (stage) {
        case 2: return '这里是人行道。请确认是否有允许骑行的标志';
        case 3: return '您可能正在人行道上骑行。请确认标志，如不可骑行请下车步行';
        default: return '';
      }
    case OSMNodeType.footwayNoBicycle:
      switch (stage) {
        case 1: return '前方人行道禁止骑自行车';
        case 2: return '正在接近禁止骑行的人行道';
        case 3: return '此人行道禁止骑自行车。请下车步行';
        default: return '';
      }
    case OSMNodeType.cycleway:
      switch (stage) {
        case 1: return '附近有自行车专用道';
        case 2: return '自行车专用道。请在此行驶';
        default: return '';
      }
    case OSMNodeType.crossing:
      switch (stage) {
        case 1: return '前方$dist米处有人行横道';
        case 2: return '正在接近人行横道。请注意行人';
        case 3: return '人行横道。有行人请停车';
        default: return '';
      }
    case OSMNodeType.noBicycle:
      switch (stage) {
        case 1: return '前方禁止自行车通行。请绕行';
        case 2: return '正在接近禁止自行车通行区域';
        case 3: return '此处禁止自行车通行。请立即绕行';
        default: return '';
      }
    case OSMNodeType.dismount:
      switch (stage) {
        case 1: return '前方是推行区间';
        case 2: return '正在接近推行区间。请下车';
        case 3: return '推行区间。请下车推行';
        default: return '';
      }
    case OSMNodeType.speedLimit:
      if (userSpeed != null && node.speedLimit != null && userSpeed > node.speedLimit!) {
        return '此区间限速每小时${node.speedLimit}公里。当前时速${userSpeed.round()}公里。请减速';
      }
      if (stage >= 2 && node.speedLimit != null) {
        return '此区间限速每小时${node.speedLimit}公里';
      }
      return '';
    case OSMNodeType.accidentZone:
      switch (stage) {
        case 1: return '前方是自行车事故多发地点。请谨慎行驶';
        case 2: return '事故多发地点。请充分注意';
        default: return '';
      }
    case OSMNodeType.enforcementZone:
      switch (stage) {
        case 1: return '前方是交通执法重点区域。请遵守交通规则';
        case 2: return '执法重点区域。请注意违规';
        default: return '';
      }
  }
}
