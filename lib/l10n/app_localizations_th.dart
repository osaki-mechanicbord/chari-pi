// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class L10nTh extends L10n {
  L10nTh([String locale = 'th']) : super(locale);

  @override
  String get appName => 'CHARI-PI';

  @override
  String get appTagline => 'ระบบนำทางความปลอดภัยจักรยาน';

  @override
  String get navMap => 'แผนที่';

  @override
  String get navLearn => 'เรียนรู้';

  @override
  String get navQuiz => 'แบบทดสอบ';

  @override
  String get navLaw => 'กฎหมาย';

  @override
  String get navLog => 'ประวัติ';

  @override
  String get navSettings => 'ตั้งค่า';

  @override
  String get splashSubtitle => 'ระบบนำทางความปลอดภัยจักรยาน';

  @override
  String get loading => 'กำลังโหลด...';

  @override
  String get termsTitle => 'ข้อกำหนดการใช้งาน';

  @override
  String get agreeAndContinue => 'ยอมรับและดำเนินการต่อ';

  @override
  String get startTitle => 'เริ่มการขับขี่';

  @override
  String get startButton => 'เริ่มนำทาง';

  @override
  String get locationPermissionRequired => 'ต้องการสิทธิ์เข้าถึงตำแหน่ง';

  @override
  String get featureSafety => 'ปลอดภัย';

  @override
  String get featureSafetyDesc => 'แจ้งเตือนแบบเรียลไทม์';

  @override
  String get featureMap => 'แผนที่';

  @override
  String get featureMapDesc => 'ขับเคลื่อนด้วย OSM';

  @override
  String get featureLearn => 'เรียนรู้';

  @override
  String get featureLearnDesc => 'กฎจราจร';

  @override
  String get gpsSearching => 'กำลังค้นหา GPS...';

  @override
  String get gpsAccuracy => 'ความแม่นยำ GPS';

  @override
  String get stopSignAhead => 'ป้ายหยุดข้างหน้า';

  @override
  String get trafficSignalAhead => 'สัญญาณไฟจราจรข้างหน้า';

  @override
  String get onewayWarning => 'ระวังทางเดียว';

  @override
  String get metersAhead => 'ม. ข้างหน้า';

  @override
  String get demoMode => 'สาธิต';

  @override
  String get demoModeButton => 'โหมดสาธิต';

  @override
  String get gpsUnavailableTitle => 'ไม่พบ GPS';

  @override
  String get gpsUnavailableMessage =>
      'ไม่สามารถรับตำแหน่ง GPS\n\n• ตรวจสอบสิทธิ์ตำแหน่งของเบราว์เซอร์\n• เปิดบริการตำแหน่ง\n\nคุณสามารถลองโหมดสาธิต';

  @override
  String get closeButton => 'ปิด';

  @override
  String get startWithDemo => 'เริ่มสาธิต';

  @override
  String get warningCountUnit => '';

  @override
  String warningMessageFormat(int distance, String type) {
    return '$type ใน $distance ม.';
  }

  @override
  String get nodeStopSign => 'ป้ายหยุด';

  @override
  String get nodeTrafficSignal => 'สัญญาณไฟจราจร';

  @override
  String get nodeOneway => 'ทางเดียว';

  @override
  String get nodeWrongWay => 'ขับสวนทาง';

  @override
  String get nodePedestrianRoad => 'เขตคนเดินเท้า';

  @override
  String get nodeFootway => 'ทางเท้า';

  @override
  String get nodeFootwayNoBicycle => 'ทางเท้าห้ามจักรยาน';

  @override
  String get nodeCycleway => 'เลนจักรยาน';

  @override
  String get nodeCrossing => 'ทางข้าม';

  @override
  String get nodeNoBicycle => 'ห้ามจักรยาน';

  @override
  String get nodeDismount => 'เขตลงจักรยาน';

  @override
  String get nodeSpeedLimit => 'จำกัดความเร็ว';

  @override
  String get nodeAccidentZone => 'พื้นที่เกิดอุบัติเหตุบ่อย';

  @override
  String get nodeEnforcementZone => 'พื้นที่ตรวจจับ';

  @override
  String get penaltyWrongWay =>
      'ขับสวนทาง: จำคุกไม่เกิน 3 เดือนหรือปรับไม่เกิน 50,000 เยน';

  @override
  String get penaltyNoBicycle => 'ฝ่าฝืนห้ามเข้า: ปรับไม่เกิน 50,000 เยน';

  @override
  String get penaltyStopSign => 'ฝ่าป้ายหยุด: อยู่ในข่ายใบสั่งสีน้ำเงิน';

  @override
  String get penaltyEnforcement => 'พื้นที่บังคับใช้กฎจราจร';

  @override
  String get logTitle => 'ประวัติการขับขี่';

  @override
  String get noHistory => 'ไม่มีประวัติ';

  @override
  String get totalDistance => 'ระยะทางรวม';

  @override
  String get duration => 'ระยะเวลา';

  @override
  String get warningsLabel => 'การแจ้งเตือน';

  @override
  String get rideCount => 'จำนวนเที่ยว';

  @override
  String get deleteHistory => 'ลบประวัติ';

  @override
  String get deleteHistoryConfirm => 'ลบประวัติทั้งหมด?';

  @override
  String get cancelButton => 'ยกเลิก';

  @override
  String get deleteButton => 'ลบ';

  @override
  String get startNavPrompt => 'เริ่มนำทางเพื่อบันทึกการขับขี่';

  @override
  String get learnTitle => 'เรียนรู้กฎจราจร';

  @override
  String get offlineLabel => 'ออฟไลน์';

  @override
  String get refreshTooltip => 'รีเฟรชข้อมูล';

  @override
  String get allCategories => 'ทั้งหมด';

  @override
  String get sourceLabel => 'แหล่ง: สำนักงานตำรวจแห่งชาติ / e-Gov';

  @override
  String rulesCountFormat(int count) {
    return '$count กฎจราจร';
  }

  @override
  String get loadingContent => 'กำลังโหลดเนื้อหา...';

  @override
  String get retryButton => 'ลองใหม่';

  @override
  String get noMatchingRules => 'ไม่พบกฎที่ตรงกัน';

  @override
  String get catBasic => 'กฎพื้นฐาน';

  @override
  String get catIntersection => 'ทางแยก';

  @override
  String get catRoad => 'การขับบนถนน';

  @override
  String get catEquipment => 'อุปกรณ์';

  @override
  String get catProhibition => 'ข้อห้าม';

  @override
  String get catSafety => 'ความปลอดภัย';

  @override
  String get catInsurance => 'ประกันภัย';

  @override
  String get catNewLaw => 'กฎหมายใหม่';

  @override
  String get catRegistration => 'การลงทะเบียน';

  @override
  String get quizTitle => 'แบบทดสอบกฎจราจร';

  @override
  String get quizCorrect => 'ถูกต้อง!';

  @override
  String get quizIncorrect => 'ไม่ถูกต้อง...';

  @override
  String get quizScore => 'คะแนน';

  @override
  String get quizNext => 'คำถามต่อไป';

  @override
  String get quizFinish => 'ดูผลลัพธ์';

  @override
  String get quizResult => 'ผลลัพธ์';

  @override
  String get quizRetry => 'ลองใหม่';

  @override
  String get quizStart => 'เริ่มทดสอบ';

  @override
  String get quizTotal => 'รวม';

  @override
  String get quizEasy => 'ง่าย';

  @override
  String get quizMedium => 'ปานกลาง';

  @override
  String get quizHard => 'ยาก';

  @override
  String get quizAllLevels => 'ทุกระดับ';

  @override
  String get quizDifficulty => 'ระดับความยาก';

  @override
  String get quizQuestionCount => 'จำนวนคำถาม';

  @override
  String get quizQuestionUnit => 'ข้อ';

  @override
  String get quizNoQuestions => 'ไม่พบแบบทดสอบ';

  @override
  String quizQuestionProgress(int current, int total) {
    return 'ข้อ $current / $total';
  }

  @override
  String quizScoreResult(int score, int total) {
    return '$score / $total ถูกต้อง';
  }

  @override
  String get quizGreatMessage => 'ยอดเยี่ยม! คุณเข้าใจกฎจราจรดี';

  @override
  String get quizTryAgainMessage => 'พยายามอีก!\nทบทวนกฎจราจรอีกครั้ง';

  @override
  String get quizSourceNote =>
      'แหล่ง: พ.ร.บ. จราจรทางบก / สำนักงานตำรวจแห่งชาติ\nเนื้อหาอ้างอิงแหล่งข้อมูลทางการ กรุณาตรวจสอบกฎหมายล่าสุด';

  @override
  String get lawUpdatesTitle => 'อัปเดตกฎหมาย';

  @override
  String get lawUpdatesInfo => 'ข้อมูลล่าสุดเกี่ยวกับกฎหมายจักรยาน';

  @override
  String get lawNoUpdates => 'ยังไม่มีอัปเดต';

  @override
  String get lawUpcoming => 'กำลังจะมา';

  @override
  String get lawEnacted => 'มีผลบังคับใช้';

  @override
  String lawEffectiveDate(String date) {
    return 'มีผลบังคับ: $date';
  }

  @override
  String get lawCheckSource => 'ตรวจสอบแหล่ง';

  @override
  String get settingsTitle => 'ตั้งค่า';

  @override
  String get planSection => 'แผน';

  @override
  String get alertSection => 'ตั้งค่าการแจ้งเตือน';

  @override
  String get displaySection => 'การแสดงผล';

  @override
  String get appInfoSection => 'ข้อมูลแอป';

  @override
  String get legalSection => 'ข้อมูลทางกฎหมาย';

  @override
  String get languageSection => 'ภาษา';

  @override
  String get voiceAlert => 'แจ้งเตือนด้วยเสียง';

  @override
  String get voiceAlertDesc => 'เสียงแจ้งเตือนป้ายหยุดและสัญญาณไฟ';

  @override
  String get vibrationAlert => 'การสั่น';

  @override
  String get vibrationAlertDesc => 'สั่นเมื่อมีการเตือน';

  @override
  String get alertDistance => 'ระยะทางแจ้งเตือน';

  @override
  String get darkMap => 'แผนที่มืด';

  @override
  String get darkMapDesc => 'ใช้ธีมแผนที่มืด';

  @override
  String get languageSetting => 'ภาษา';

  @override
  String get languageSettingDesc => 'เปลี่ยนภาษาแสดงผลของแอป';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageEnglish => 'English';

  @override
  String get aboutApp => 'เกี่ยวกับ';

  @override
  String get aboutAppDesc => 'CHARI-PI - ระบบนำทางความปลอดภัยจักรยาน';

  @override
  String get appVersion => 'เวอร์ชัน';

  @override
  String get aboutDialogContent =>
      'CHARI-PI คือแอปนำทางที่สนับสนุนความปลอดภัยในการขับจักรยาน\n\nใช้ข้อมูล OpenStreetMap เพื่อแจ้งเตือนป้ายหยุดและสัญญาณไฟแบบเรียลไทม์\n\nขับจักรยานปลอดภัยกับ CHARI-PI!';

  @override
  String get privacyPolicy => 'นโยบายความเป็นส่วนตัว';

  @override
  String get privacyPolicyDesc => 'การจัดการข้อมูลส่วนบุคคลและตำแหน่ง';

  @override
  String get securityPolicy => 'นโยบายความปลอดภัย';

  @override
  String get securityPolicyDesc => 'การจัดการความปลอดภัยข้อมูล';

  @override
  String get termsOfService => 'ข้อกำหนดการใช้งาน';

  @override
  String get termsOfServiceDesc => 'เงื่อนไขการใช้บริการ';

  @override
  String get disclaimer => 'ข้อจำกัดความรับผิดชอบ';

  @override
  String get disclaimerDesc => 'ข้อจำกัดความรับผิดชอบของบริการ';

  @override
  String get commercialLaw => 'พ.ร.บ. การค้าพาณิชย์';

  @override
  String get commercialLawDesc => 'ข้อมูลธุรกิจและเงื่อนไขการขาย';

  @override
  String get operatingCompany => 'ผู้ดำเนินการ';

  @override
  String get companyName => 'TCI Corporation';

  @override
  String get companyAddress => 'Shintaka 1-5-4, Yodogawa-ku, Osaka, ญี่ปุ่น';

  @override
  String get planUpgrade => 'อัปเกรด';

  @override
  String get planChange => 'เปลี่ยน';

  @override
  String get planUpgradePrompt => 'อัปเกรดแผนเพื่อความปลอดภัยที่ดีขึ้น';

  @override
  String get planFreeWithWatch => 'ฟรี · เปิดใช้การติดตาม GPS';

  @override
  String get familySafety => 'ความปลอดภัยครอบครัว';

  @override
  String get familyPrompt => 'ดูแลครอบครัวและทีม';

  @override
  String get corporateSafety => 'ความปลอดภัยองค์กร';

  @override
  String get gpsWatchFree => 'ติดตาม GPS (ฟรี)';

  @override
  String get adminMode => 'โหมดผู้ดูแล';

  @override
  String get employeeMode => 'โหมดพนักงาน';

  @override
  String get watchingMode => 'กำลังติดตาม GPS';

  @override
  String get sharingGps => 'กำลังแชร์ GPS';

  @override
  String get parentMode => 'โหมดผู้ปกครอง';

  @override
  String get childMode => 'โหมดเด็ก';

  @override
  String membersCount(int count) {
    return '$count พนักงาน';
  }

  @override
  String childrenCount(int count) {
    return '$count คน';
  }

  @override
  String watchingPerson(String name) {
    return 'ติดตาม GPS · $name';
  }

  @override
  String get beingWatched => 'กำลังแชร์ GPS · กำลังถูกดูแล';

  @override
  String get gpsWaiting => 'GPS รอ';

  @override
  String get gpsHigh => 'สูง';

  @override
  String get gpsMedium => 'ปานกลาง';

  @override
  String get gpsLow => 'ต่ำ';

  @override
  String get termsContentFull =>
      'ขอบคุณที่ใช้ CHARI-PI\n\nแอปนี้เป็นเครื่องมือนำทางเพื่อสนับสนุนความปลอดภัยในการจราจรขณะขับจักรยาน\n\n[ข้อจำกัดความรับผิดชอบ]\n- แอปนี้เป็นเครื่องมือเสริม ไม่ยกเว้นหน้าที่ระวังของผู้ขับ\n- ไม่รับประกันความแม่นยำของ GPS และข้อมูลแผนที่\n- ให้ความสำคัญกับความปลอดภัยเสมอ\n- ผู้พัฒนาไม่รับผิดชอบต่ออุบัติเหตุ\n\n[เนื้อหาการเรียนรู้]\n- เนื้อหากฎจราจรอ้างอิงแหล่งข้อมูลทางการ\n- กรุณาตรวจสอบกฎหมายล่าสุด\n\n[ข้อมูลตำแหน่ง]\n- แอปใช้ GPS\n- ข้อมูลตำแหน่งประมวลผลในอุปกรณ์เท่านั้น';
}
