import '../../data/models/osm_node.dart';

/// タイ語 TTS メッセージ
String getTtsMessageTh(OSMNode node, int stage, int dist, {double? userSpeed}) {
  switch (node.type) {
    case OSMNodeType.stopSign:
      switch (stage) {
        case 1: return 'ข้างหน้ามีป้ายหยุด';
        case 2: return 'กำลังเข้าใกล้ป้ายหยุด กรุณาชะลอ';
        case 3: return 'ป้ายหยุด กรุณาหยุดสนิท';
        default: return '';
      }
    case OSMNodeType.trafficSignal:
      switch (stage) {
        case 1: return 'มีสัญญาณไฟจราจรข้างหน้า $dist เมตร';
        case 2: return 'กำลังเข้าใกล้สัญญาณไฟ กรุณาตรวจสอบ';
        case 3: return 'สัญญาณไฟจราจร กรุณาปฏิบัติตาม';
        default: return '';
      }
    case OSMNodeType.oneway:
      if (node.isWrongWay) {
        switch (stage) {
          case 1: return 'คำเตือน ถนนข้างหน้าเป็นทางเดียว กรุณาตรวจสอบทิศทาง';
          case 2: return 'อันตราย กำลังขับสวนทางเดียว กรุณาหยุดในที่ปลอดภัย';
          case 3: return 'ขับสวนทาง กรุณาหยุดทันที';
          default: return '';
        }
      }
      switch (stage) {
        case 1: return 'มีถนนทางเดียวข้างหน้า $dist เมตร';
        case 2: return 'กำลังเข้าใกล้ถนนทางเดียว กรุณาตรวจสอบทิศทาง';
        case 3: return 'ถนนทางเดียว ระวังทิศทางการจราจร';
        default: return '';
      }
    case OSMNodeType.pedestrianRoad:
      switch (stage) {
        case 1: return 'ข้างหน้าเป็นถนนคนเดินเท่านั้น ห้ามจักรยาน';
        case 2: return 'กำลังเข้าใกล้ถนนคนเดิน กรุณาอ้อม';
        case 3: return 'ถนนคนเดินเท่านั้น ห้ามขี่จักรยาน';
        default: return '';
      }
    case OSMNodeType.footway:
      switch (stage) {
        case 2: return 'กำลังเข้าใกล้ทางเท้า กรุณาขับชิดซ้ายบนถนน';
        case 3: return 'อาจกำลังขี่บนทางเท้า กรุณากลับไปบนถนน';
        default: return '';
      }
    case OSMNodeType.footwayNoBicycle:
      switch (stage) {
        case 1: return 'ทางเท้าข้างหน้าห้ามขี่จักรยาน';
        case 2: return 'กำลังเข้าใกล้ทางเท้าที่ห้ามจักรยาน';
        case 3: return 'ทางเท้านี้ห้ามจักรยาน กรุณาลงจากจักรยานและเดิน';
        default: return '';
      }
    case OSMNodeType.cycleway:
      switch (stage) {
        case 1: return 'มีทางจักรยานใกล้เคียง';
        case 2: return 'ทางจักรยาน กรุณาใช้เส้นทางนี้';
        default: return '';
      }
    case OSMNodeType.crossing:
      switch (stage) {
        case 1: return 'มีทางข้ามข้างหน้า $dist เมตร';
        case 2: return 'กำลังเข้าใกล้ทางข้าม ระวังคนเดินเท้า';
        case 3: return 'ทางข้าม มีคนเดินเท้ากรุณาหยุด';
        default: return '';
      }
    case OSMNodeType.noBicycle:
      switch (stage) {
        case 1: return 'ข้างหน้าห้ามจักรยาน กรุณาอ้อม';
        case 2: return 'กำลังเข้าใกล้เขตห้ามจักรยาน';
        case 3: return 'ที่นี่ห้ามจักรยาน กรุณาอ้อมทันที';
        default: return '';
      }
    case OSMNodeType.dismount:
      switch (stage) {
        case 1: return 'ข้างหน้าเป็นเขตจูงจักรยาน';
        case 2: return 'กำลังเข้าใกล้เขตจูงจักรยาน กรุณาลงจากจักรยาน';
        case 3: return 'เขตจูงจักรยาน กรุณาลงจากจักรยานและเดิน';
        default: return '';
      }
    case OSMNodeType.speedLimit:
      if (userSpeed != null && node.speedLimit != null && userSpeed > node.speedLimit!) {
        return 'จำกัดความเร็วบริเวณนี้ ${node.speedLimit} กม./ชม. ความเร็วปัจจุบัน ${userSpeed.round()} กม./ชม. กรุณาชะลอ';
      }
      if (stage >= 2 && node.speedLimit != null) {
        return 'จำกัดความเร็วบริเวณนี้ ${node.speedLimit} กม./ชม.';
      }
      return '';
    case OSMNodeType.accidentZone:
      switch (stage) {
        case 1: return 'ข้างหน้าเป็นจุดเกิดอุบัติเหตุบ่อย กรุณาระวัง';
        case 2: return 'จุดเกิดอุบัติเหตุบ่อย กรุณาระวังเป็นพิเศษ';
        default: return '';
      }
    case OSMNodeType.enforcementZone:
      switch (stage) {
        case 1: return 'ข้างหน้าเป็นเขตตรวจจับจราจร กรุณาปฏิบัติตามกฎ';
        case 2: return 'เขตตรวจจับจราจร ระวังการฝ่าฝืน';
        default: return '';
      }
  }
}
