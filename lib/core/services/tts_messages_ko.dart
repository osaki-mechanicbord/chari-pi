import '../../data/models/osm_node.dart';

/// 韓国語 TTS メッセージ
String getTtsMessageKo(OSMNode node, int stage, int dist, {double? userSpeed}) {
  switch (node.type) {
    case OSMNodeType.stopSign:
      switch (stage) {
        case 1: return '전방에 일시정지가 있습니다';
        case 2: return '일시정지에 접근 중입니다. 감속하세요';
        case 3: return '일시정지입니다. 완전히 정지하세요';
        default: return '';
      }
    case OSMNodeType.trafficSignal:
      switch (stage) {
        case 1: return '$dist미터 앞에 신호등이 있습니다';
        case 2: return '신호등에 접근 중입니다. 신호를 확인하세요';
        case 3: return '신호등입니다. 신호에 따르세요';
        default: return '';
      }
    case OSMNodeType.oneway:
      if (node.isWrongWay) {
        switch (stage) {
          case 1: return '경고. 전방 도로는 일방통행입니다. 진행 방향을 확인하세요';
          case 2: return '위험. 일방통행을 역주행하고 있습니다. 안전한 곳에서 정지하세요';
          case 3: return '역주행입니다. 즉시 정지하세요';
          default: return '';
        }
      }
      switch (stage) {
        case 1: return '$dist미터 앞에 일방통행이 있습니다';
        case 2: return '일방통행에 접근 중입니다. 방향을 확인하세요';
        case 3: return '일방통행입니다. 통행 방향에 주의하세요';
        default: return '';
      }
    case OSMNodeType.pedestrianRoad:
      switch (stage) {
        case 1: return '전방에 보행자 전용도로가 있습니다. 자전거 통행 불가';
        case 2: return '보행자 전용도로에 접근 중입니다. 우회하세요';
        case 3: return '보행자 전용도로입니다. 자전거 통행 금지';
        default: return '';
      }
    case OSMNodeType.footway:
      switch (stage) {
        case 2: return '보도입니다. 자전거 주행 가능 표지판을 확인하세요';
        case 3: return '보도를 주행 중일 수 있습니다. 표지판을 확인하고, 주행 불가 시 내려서 걸으세요';
        default: return '';
      }
    case OSMNodeType.footwayNoBicycle:
      switch (stage) {
        case 1: return '전방 보도는 자전거 주행 금지입니다';
        case 2: return '자전거 주행 금지 보도에 접근 중입니다';
        case 3: return '이 보도는 자전거 주행 금지입니다. 내려서 걸으세요';
        default: return '';
      }
    case OSMNodeType.cycleway:
      switch (stage) {
        case 1: return '근처에 자전거 전용도로가 있습니다';
        case 2: return '자전거 전용도로입니다. 이곳을 주행하세요';
        default: return '';
      }
    case OSMNodeType.crossing:
      switch (stage) {
        case 1: return '$dist미터 앞에 횡단보도가 있습니다';
        case 2: return '횡단보도에 접근 중입니다. 보행자에 주의하세요';
        case 3: return '횡단보도입니다. 보행자가 있으면 정지하세요';
        default: return '';
      }
    case OSMNodeType.noBicycle:
      switch (stage) {
        case 1: return '전방은 자전거 통행 금지입니다. 우회하세요';
        case 2: return '자전거 통행 금지 구역에 접근 중입니다';
        case 3: return '여기는 자전거 통행 금지입니다. 즉시 우회하세요';
        default: return '';
      }
    case OSMNodeType.dismount:
      switch (stage) {
        case 1: return '전방은 내려서 걷기 구간입니다';
        case 2: return '내려서 걷기 구간에 접근 중입니다. 자전거에서 내리세요';
        case 3: return '내려서 걷기 구간입니다. 자전거에서 내려 걸으세요';
        default: return '';
      }
    case OSMNodeType.speedLimit:
      if (userSpeed != null && node.speedLimit != null && userSpeed > node.speedLimit!) {
        return '이 구간 제한속도는 시속 ${node.speedLimit}km입니다. 현재 시속 ${userSpeed.round()}km. 감속하세요';
      }
      if (stage >= 2 && node.speedLimit != null) {
        return '이 구간 제한속도는 시속 ${node.speedLimit}km입니다';
      }
      return '';
    case OSMNodeType.accidentZone:
      switch (stage) {
        case 1: return '전방은 자전거 사고 다발 지점입니다. 주의하며 주행하세요';
        case 2: return '사고 다발 지점입니다. 충분히 주의하세요';
        default: return '';
      }
    case OSMNodeType.enforcementZone:
      switch (stage) {
        case 1: return '전방은 교통 단속 중점 구역입니다. 교통 규칙을 지키세요';
        case 2: return '단속 중점 구역입니다. 위반에 주의하세요';
        default: return '';
      }
  }
}
