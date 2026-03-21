import '../../data/models/osm_node.dart';

/// ベトナム語 TTS メッセージ
String getTtsMessageVi(OSMNode node, int stage, int dist, {double? userSpeed}) {
  switch (node.type) {
    case OSMNodeType.stopSign:
      switch (stage) {
        case 1: return 'Phía trước có biển dừng';
        case 2: return 'Đang tiến gần biển dừng. Hãy giảm tốc';
        case 3: return 'Biển dừng. Hãy dừng hoàn toàn';
        default: return '';
      }
    case OSMNodeType.trafficSignal:
      switch (stage) {
        case 1: return 'Có đèn tín hiệu cách $dist mét phía trước';
        case 2: return 'Đang tiến gần đèn tín hiệu. Hãy kiểm tra';
        case 3: return 'Đèn tín hiệu. Hãy tuân theo tín hiệu';
        default: return '';
      }
    case OSMNodeType.oneway:
      if (node.isWrongWay) {
        switch (stage) {
          case 1: return 'Cảnh báo. Đường phía trước là đường một chiều. Hãy kiểm tra hướng đi';
          case 2: return 'Nguy hiểm. Bạn đang đi ngược chiều. Hãy dừng ở nơi an toàn';
          case 3: return 'Đi ngược chiều. Hãy dừng ngay lập tức';
          default: return '';
        }
      }
      switch (stage) {
        case 1: return 'Có đường một chiều cách $dist mét phía trước';
        case 2: return 'Đang tiến gần đường một chiều. Hãy kiểm tra hướng';
        case 3: return 'Đường một chiều. Chú ý hướng đi';
        default: return '';
      }
    case OSMNodeType.pedestrianRoad:
      switch (stage) {
        case 1: return 'Phía trước là đường dành cho người đi bộ. Xe đạp không được đi';
        case 2: return 'Đang tiến gần đường người đi bộ. Hãy đi đường khác';
        case 3: return 'Đường dành cho người đi bộ. Cấm xe đạp';
        default: return '';
      }
    case OSMNodeType.footway:
      switch (stage) {
        case 2: return 'Đây là vỉa hè. Hãy kiểm tra biển báo cho phép xe đạp';
        case 3: return 'Bạn có thể đang đi trên vỉa hè. Hãy kiểm tra biển báo, nếu không được phép hãy xuống xe';
        default: return '';
      }
    case OSMNodeType.footwayNoBicycle:
      switch (stage) {
        case 1: return 'Vỉa hè phía trước cấm xe đạp';
        case 2: return 'Đang tiến gần vỉa hè cấm xe đạp';
        case 3: return 'Vỉa hè này cấm xe đạp. Hãy xuống xe và đi bộ';
        default: return '';
      }
    case OSMNodeType.cycleway:
      switch (stage) {
        case 1: return 'Gần đây có đường dành riêng cho xe đạp';
        case 2: return 'Đường xe đạp. Hãy đi đường này';
        default: return '';
      }
    case OSMNodeType.crossing:
      switch (stage) {
        case 1: return 'Có vạch qua đường cách $dist mét phía trước';
        case 2: return 'Đang tiến gần vạch qua đường. Chú ý người đi bộ';
        case 3: return 'Vạch qua đường. Có người đi bộ hãy dừng lại';
        default: return '';
      }
    case OSMNodeType.noBicycle:
      switch (stage) {
        case 1: return 'Phía trước cấm xe đạp. Hãy đi đường khác';
        case 2: return 'Đang tiến gần khu vực cấm xe đạp';
        case 3: return 'Khu vực này cấm xe đạp. Hãy đi đường khác ngay';
        default: return '';
      }
    case OSMNodeType.dismount:
      switch (stage) {
        case 1: return 'Phía trước là khu vực phải dắt xe';
        case 2: return 'Đang tiến gần khu vực dắt xe. Hãy xuống xe';
        case 3: return 'Khu vực dắt xe. Hãy xuống xe và đi bộ';
        default: return '';
      }
    case OSMNodeType.speedLimit:
      if (userSpeed != null && node.speedLimit != null && userSpeed > node.speedLimit!) {
        return 'Giới hạn tốc độ khu vực này là ${node.speedLimit} km/h. Tốc độ hiện tại ${userSpeed.round()} km/h. Hãy giảm tốc';
      }
      if (stage >= 2 && node.speedLimit != null) {
        return 'Giới hạn tốc độ khu vực này là ${node.speedLimit} km/h';
      }
      return '';
    case OSMNodeType.accidentZone:
      switch (stage) {
        case 1: return 'Phía trước là khu vực nhiều tai nạn xe đạp. Hãy cẩn thận';
        case 2: return 'Khu vực nhiều tai nạn. Hãy đặc biệt chú ý';
        default: return '';
      }
    case OSMNodeType.enforcementZone:
      switch (stage) {
        case 1: return 'Phía trước là khu vực kiểm tra giao thông. Hãy tuân thủ luật';
        case 2: return 'Khu vực kiểm tra. Chú ý vi phạm';
        default: return '';
      }
  }
}
