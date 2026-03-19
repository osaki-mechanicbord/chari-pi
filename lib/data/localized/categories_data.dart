/// ロケールに応じたカテゴリ情報を返す
Map<String, dynamic> buildLocalizedCategories(String localeCode) {
  switch (localeCode) {
    case 'en':
      return _en;
    case 'ko':
      return _ko;
    case 'zh':
      return _zh;
    case 'vi':
      return _vi;
    case 'th':
      return _th;
    case 'fil':
      return _fil;
    case 'ja':
    default:
      return _ja;
  }
}

const _ja = {
  'basic': {'name': '基本ルール', 'icon': 'electric_bike', 'description': '自転車の基本的な交通ルール'},
  'intersection': {'name': '交差点', 'icon': 'traffic', 'description': '交差点での走行ルール'},
  'road': {'name': '道路', 'icon': 'compare_arrows', 'description': '道路の走行に関するルール'},
  'equipment': {'name': '装備', 'icon': 'build', 'description': '自転車の装備に関するルール'},
  'prohibition': {'name': '禁止事項', 'icon': 'pan_tool', 'description': '禁止されている行為'},
  'safety': {'name': '安全運転', 'icon': 'security', 'description': '安全に運転するためのコツ'},
  'insurance': {'name': '保険', 'icon': 'security', 'description': '自転車保険について'},
  'new_law': {'name': '新法令', 'icon': 'receipt_long', 'description': '最新の法改正情報'},
  'registration': {'name': '防犯登録', 'icon': 'lock', 'description': '防犯登録について'},
};

const _en = {
  'basic': {'name': 'Basic Rules', 'icon': 'electric_bike', 'description': 'Fundamental cycling traffic rules'},
  'intersection': {'name': 'Intersections', 'icon': 'traffic', 'description': 'Rules at intersections'},
  'road': {'name': 'Road', 'icon': 'compare_arrows', 'description': 'Road riding rules'},
  'equipment': {'name': 'Equipment', 'icon': 'build', 'description': 'Bicycle equipment rules'},
  'prohibition': {'name': 'Prohibitions', 'icon': 'pan_tool', 'description': 'Prohibited actions'},
  'safety': {'name': 'Safe Riding', 'icon': 'security', 'description': 'Tips for safe riding'},
  'insurance': {'name': 'Insurance', 'icon': 'security', 'description': 'Bicycle insurance'},
  'new_law': {'name': 'New Laws', 'icon': 'receipt_long', 'description': 'Latest law updates'},
  'registration': {'name': 'Registration', 'icon': 'lock', 'description': 'Crime prevention registration'},
};

const _ko = {
  'basic': {'name': '기본 규칙', 'icon': 'electric_bike', 'description': '자전거 기본 교통 규칙'},
  'intersection': {'name': '교차로', 'icon': 'traffic', 'description': '교차로 주행 규칙'},
  'road': {'name': '도로', 'icon': 'compare_arrows', 'description': '도로 주행 규칙'},
  'equipment': {'name': '장비', 'icon': 'build', 'description': '자전거 장비 규칙'},
  'prohibition': {'name': '금지사항', 'icon': 'pan_tool', 'description': '금지된 행위'},
  'safety': {'name': '안전운전', 'icon': 'security', 'description': '안전 운전 요령'},
  'insurance': {'name': '보험', 'icon': 'security', 'description': '자전거 보험'},
  'new_law': {'name': '신법령', 'icon': 'receipt_long', 'description': '최신 법 개정 정보'},
  'registration': {'name': '방범등록', 'icon': 'lock', 'description': '방범등록에 대해'},
};

const _zh = {
  'basic': {'name': '基本规则', 'icon': 'electric_bike', 'description': '自行车基本交通规则'},
  'intersection': {'name': '交叉路口', 'icon': 'traffic', 'description': '交叉路口行驶规则'},
  'road': {'name': '道路', 'icon': 'compare_arrows', 'description': '道路行驶规则'},
  'equipment': {'name': '装备', 'icon': 'build', 'description': '自行车装备规则'},
  'prohibition': {'name': '禁止事项', 'icon': 'pan_tool', 'description': '禁止行为'},
  'safety': {'name': '安全驾驶', 'icon': 'security', 'description': '安全驾驶技巧'},
  'insurance': {'name': '保险', 'icon': 'security', 'description': '自行车保险'},
  'new_law': {'name': '新法规', 'icon': 'receipt_long', 'description': '最新法规更新'},
  'registration': {'name': '防盗登记', 'icon': 'lock', 'description': '防盗登记相关'},
};

const _vi = {
  'basic': {'name': 'Quy tắc cơ bản', 'icon': 'electric_bike', 'description': 'Quy tắc giao thông cơ bản cho xe đạp'},
  'intersection': {'name': 'Ngã tư', 'icon': 'traffic', 'description': 'Quy tắc tại ngã tư'},
  'road': {'name': 'Đường', 'icon': 'compare_arrows', 'description': 'Quy tắc đi đường'},
  'equipment': {'name': 'Trang bị', 'icon': 'build', 'description': 'Quy tắc trang bị xe đạp'},
  'prohibition': {'name': 'Cấm', 'icon': 'pan_tool', 'description': 'Hành vi bị cấm'},
  'safety': {'name': 'An toàn', 'icon': 'security', 'description': 'Mẹo lái xe an toàn'},
  'insurance': {'name': 'Bảo hiểm', 'icon': 'security', 'description': 'Bảo hiểm xe đạp'},
  'new_law': {'name': 'Luật mới', 'icon': 'receipt_long', 'description': 'Cập nhật luật mới nhất'},
  'registration': {'name': 'Đăng ký', 'icon': 'lock', 'description': 'Đăng ký phòng chống tội phạm'},
};

const _th = {
  'basic': {'name': 'กฎพื้นฐาน', 'icon': 'electric_bike', 'description': 'กฎจราจรพื้นฐานสำหรับจักรยาน'},
  'intersection': {'name': 'ทางแยก', 'icon': 'traffic', 'description': 'กฎที่ทางแยก'},
  'road': {'name': 'ถนน', 'icon': 'compare_arrows', 'description': 'กฎการขับบนถนน'},
  'equipment': {'name': 'อุปกรณ์', 'icon': 'build', 'description': 'กฎอุปกรณ์จักรยาน'},
  'prohibition': {'name': 'ข้อห้าม', 'icon': 'pan_tool', 'description': 'การกระทำที่ห้าม'},
  'safety': {'name': 'ขับปลอดภัย', 'icon': 'security', 'description': 'เคล็ดลับขับปลอดภัย'},
  'insurance': {'name': 'ประกัน', 'icon': 'security', 'description': 'ประกันจักรยาน'},
  'new_law': {'name': 'กฎหมายใหม่', 'icon': 'receipt_long', 'description': 'ข้อมูลกฎหมายล่าสุด'},
  'registration': {'name': 'ลงทะเบียน', 'icon': 'lock', 'description': 'การลงทะเบียนป้องกันอาชญากรรม'},
};

const _fil = {
  'basic': {'name': 'Pangunahing Patakaran', 'icon': 'electric_bike', 'description': 'Pangunahing patakaran sa trapiko ng bisikleta'},
  'intersection': {'name': 'Intersection', 'icon': 'traffic', 'description': 'Patakaran sa intersection'},
  'road': {'name': 'Kalsada', 'icon': 'compare_arrows', 'description': 'Patakaran sa pagmamaneho sa kalsada'},
  'equipment': {'name': 'Kagamitan', 'icon': 'build', 'description': 'Patakaran sa kagamitan ng bisikleta'},
  'prohibition': {'name': 'Ipinagbabawal', 'icon': 'pan_tool', 'description': 'Mga ipinagbabawal na gawain'},
  'safety': {'name': 'Ligtas na Pagmamaneho', 'icon': 'security', 'description': 'Tips para sa ligtas na pagmamaneho'},
  'insurance': {'name': 'Insurance', 'icon': 'security', 'description': 'Insurance ng bisikleta'},
  'new_law': {'name': 'Bagong Batas', 'icon': 'receipt_long', 'description': 'Pinakabagong update sa batas'},
  'registration': {'name': 'Pagpaparehistro', 'icon': 'lock', 'description': 'Crime prevention registration'},
};
