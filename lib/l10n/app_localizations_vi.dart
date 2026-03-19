// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class L10nVi extends L10n {
  L10nVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'CHARI-PI';

  @override
  String get appTagline => 'Hoa tiêu an toàn cho xe đạp';

  @override
  String get navMap => 'Bản đồ';

  @override
  String get navLearn => 'Học';

  @override
  String get navQuiz => 'Trắc nghiệm';

  @override
  String get navLaw => 'Luật';

  @override
  String get navLog => 'Lịch sử';

  @override
  String get navSettings => 'Cài đặt';

  @override
  String get splashSubtitle => 'Hoa tiêu an toàn xe đạp';

  @override
  String get loading => 'Đang tải...';

  @override
  String get termsTitle => 'Điều khoản sử dụng';

  @override
  String get agreeAndContinue => 'Đồng ý & Tiếp tục';

  @override
  String get startTitle => 'Bắt đầu chuyến đi';

  @override
  String get startButton => 'Bắt đầu';

  @override
  String get locationPermissionRequired => 'Cần quyền truy cập vị trí';

  @override
  String get featureSafety => 'An toàn';

  @override
  String get featureSafetyDesc => 'Cảnh báo thời gian thực';

  @override
  String get featureMap => 'Bản đồ';

  @override
  String get featureMapDesc => 'Hỗ trợ OSM';

  @override
  String get featureLearn => 'Học';

  @override
  String get featureLearnDesc => 'Luật giao thông';

  @override
  String get gpsSearching => 'Đang tìm GPS...';

  @override
  String get gpsAccuracy => 'Độ chính xác GPS';

  @override
  String get stopSignAhead => 'Biển dừng phía trước';

  @override
  String get trafficSignalAhead => 'Đèn tín hiệu phía trước';

  @override
  String get onewayWarning => 'Chú ý đường một chiều';

  @override
  String get metersAhead => 'm phía trước';

  @override
  String get demoMode => 'Demo';

  @override
  String get demoModeButton => 'Chế độ Demo';

  @override
  String get gpsUnavailableTitle => 'Không tìm thấy GPS';

  @override
  String get gpsUnavailableMessage =>
      'Không thể lấy vị trí GPS.\n\n• Kiểm tra quyền vị trí trình duyệt\n• Bật dịch vụ định vị\n\nBạn có thể thử chế độ Demo.';

  @override
  String get closeButton => 'Đóng';

  @override
  String get startWithDemo => 'Bắt đầu Demo';

  @override
  String get warningCountUnit => '';

  @override
  String warningMessageFormat(int distance, String type) {
    return '$type trong ${distance}m';
  }

  @override
  String get nodeStopSign => 'Biển dừng';

  @override
  String get nodeTrafficSignal => 'Đèn tín hiệu';

  @override
  String get nodeOneway => 'Đường một chiều';

  @override
  String get nodeWrongWay => 'Đi ngược chiều';

  @override
  String get nodePedestrianRoad => 'Khu vực người đi bộ';

  @override
  String get nodeFootway => 'Vỉa hè';

  @override
  String get nodeFootwayNoBicycle => 'Vỉa hè cấm xe đạp';

  @override
  String get nodeCycleway => 'Làn xe đạp';

  @override
  String get nodeCrossing => 'Vạch qua đường';

  @override
  String get nodeNoBicycle => 'Cấm xe đạp';

  @override
  String get nodeDismount => 'Khu vực xuống xe';

  @override
  String get nodeSpeedLimit => 'Giới hạn tốc độ';

  @override
  String get nodeAccidentZone => 'Khu vực hay tai nạn';

  @override
  String get nodeEnforcementZone => 'Khu vực kiểm tra';

  @override
  String get penaltyWrongWay =>
      'Đi ngược chiều: phạt tù đến 3 tháng hoặc phạt tiền đến 50.000 yên';

  @override
  String get penaltyNoBicycle => 'Vi phạm cấm vào: phạt tiền đến 50.000 yên';

  @override
  String get penaltyStopSign => 'Vượt biển dừng: bị phạt vé xanh';

  @override
  String get penaltyEnforcement => 'Khu vực kiểm tra giao thông';

  @override
  String get logTitle => 'Lịch sử chuyến đi';

  @override
  String get noHistory => 'Chưa có lịch sử';

  @override
  String get totalDistance => 'Tổng quãng đường';

  @override
  String get duration => 'Thời gian';

  @override
  String get warningsLabel => 'Cảnh báo';

  @override
  String get rideCount => 'Số chuyến';

  @override
  String get deleteHistory => 'Xóa lịch sử';

  @override
  String get deleteHistoryConfirm => 'Xóa toàn bộ lịch sử?';

  @override
  String get cancelButton => 'Hủy';

  @override
  String get deleteButton => 'Xóa';

  @override
  String get startNavPrompt => 'Bắt đầu điều hướng để ghi lại chuyến đi';

  @override
  String get learnTitle => 'Học luật giao thông';

  @override
  String get offlineLabel => 'Ngoại tuyến';

  @override
  String get refreshTooltip => 'Làm mới dữ liệu';

  @override
  String get allCategories => 'Tất cả';

  @override
  String get sourceLabel => 'Nguồn: Cơ quan Cảnh sát Quốc gia / e-Gov';

  @override
  String rulesCountFormat(int count) {
    return '$count luật giao thông';
  }

  @override
  String get loadingContent => 'Đang tải nội dung...';

  @override
  String get retryButton => 'Thử lại';

  @override
  String get noMatchingRules => 'Không tìm thấy luật phù hợp';

  @override
  String get catBasic => 'Luật cơ bản';

  @override
  String get catIntersection => 'Ngã tư';

  @override
  String get catRoad => 'Đi đường';

  @override
  String get catEquipment => 'Trang bị';

  @override
  String get catProhibition => 'Cấm';

  @override
  String get catSafety => 'An toàn';

  @override
  String get catInsurance => 'Bảo hiểm';

  @override
  String get catNewLaw => 'Luật mới';

  @override
  String get catRegistration => 'Đăng ký';

  @override
  String get quizTitle => 'Trắc nghiệm luật giao thông';

  @override
  String get quizCorrect => 'Đúng!';

  @override
  String get quizIncorrect => 'Sai...';

  @override
  String get quizScore => 'Điểm';

  @override
  String get quizNext => 'Câu tiếp';

  @override
  String get quizFinish => 'Xem kết quả';

  @override
  String get quizResult => 'Kết quả';

  @override
  String get quizRetry => 'Thử lại';

  @override
  String get quizStart => 'Bắt đầu';

  @override
  String get quizTotal => 'Tổng';

  @override
  String get quizEasy => 'Dễ';

  @override
  String get quizMedium => 'Trung bình';

  @override
  String get quizHard => 'Khó';

  @override
  String get quizAllLevels => 'Tất cả';

  @override
  String get quizDifficulty => 'Độ khó';

  @override
  String get quizQuestionCount => 'Số câu hỏi';

  @override
  String get quizQuestionUnit => 'câu';

  @override
  String get quizNoQuestions => 'Không tìm thấy câu hỏi';

  @override
  String quizQuestionProgress(int current, int total) {
    return 'Câu $current / $total';
  }

  @override
  String quizScoreResult(int score, int total) {
    return '$score / $total đúng';
  }

  @override
  String get quizGreatMessage => 'Xuất sắc! Bạn hiểu rõ luật giao thông.';

  @override
  String get quizTryAgainMessage =>
      'Hãy cố gắng thêm!\nÔn lại luật giao thông nhé.';

  @override
  String get quizSourceNote =>
      'Nguồn: Luật Giao thông Đường bộ / Cổng thông tin xe đạp của Cơ quan Cảnh sát Quốc gia\nNội dung dựa trên nguồn chính thức. Vui lòng kiểm tra luật mới nhất.';

  @override
  String get lawUpdatesTitle => 'Cập nhật luật';

  @override
  String get lawUpdatesInfo => 'Thông tin mới nhất về thay đổi luật xe đạp';

  @override
  String get lawNoUpdates => 'Chưa có cập nhật';

  @override
  String get lawUpcoming => 'Sắp tới';

  @override
  String get lawEnacted => 'Đã có hiệu lực';

  @override
  String lawEffectiveDate(String date) {
    return 'Có hiệu lực: $date';
  }

  @override
  String get lawCheckSource => 'Kiểm tra nguồn';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get planSection => 'Gói dịch vụ';

  @override
  String get alertSection => 'Cài đặt cảnh báo';

  @override
  String get displaySection => 'Hiển thị';

  @override
  String get appInfoSection => 'Thông tin ứng dụng';

  @override
  String get legalSection => 'Pháp lý';

  @override
  String get languageSection => 'Ngôn ngữ';

  @override
  String get voiceAlert => 'Cảnh báo giọng nói';

  @override
  String get voiceAlertDesc => 'Cảnh báo âm thanh biển dừng & đèn';

  @override
  String get vibrationAlert => 'Rung';

  @override
  String get vibrationAlertDesc => 'Rung khi có cảnh báo';

  @override
  String get alertDistance => 'Khoảng cách cảnh báo';

  @override
  String get darkMap => 'Bản đồ tối';

  @override
  String get darkMapDesc => 'Sử dụng giao diện bản đồ tối';

  @override
  String get languageSetting => 'Ngôn ngữ';

  @override
  String get languageSettingDesc => 'Thay đổi ngôn ngữ hiển thị';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageEnglish => 'English';

  @override
  String get aboutApp => 'Giới thiệu';

  @override
  String get aboutAppDesc => 'CHARI-PI - Hoa tiêu an toàn xe đạp';

  @override
  String get appVersion => 'Phiên bản';

  @override
  String get aboutDialogContent =>
      'CHARI-PI là ứng dụng điều hướng hỗ trợ an toàn xe đạp.\n\nSử dụng dữ liệu OpenStreetMap để thông báo biển dừng và đèn tín hiệu theo thời gian thực.\n\nHãy đi xe đạp an toàn cùng CHARI-PI!';

  @override
  String get privacyPolicy => 'Chính sách bảo mật';

  @override
  String get privacyPolicyDesc => 'Cách xử lý dữ liệu cá nhân & vị trí';

  @override
  String get securityPolicy => 'Chính sách bảo mật thông tin';

  @override
  String get securityPolicyDesc => 'Quản lý bảo mật thông tin';

  @override
  String get termsOfService => 'Điều khoản dịch vụ';

  @override
  String get termsOfServiceDesc => 'Điều kiện sử dụng dịch vụ';

  @override
  String get disclaimer => 'Miễn trừ trách nhiệm';

  @override
  String get disclaimerDesc => 'Miễn trừ trách nhiệm dịch vụ';

  @override
  String get commercialLaw => 'Thông tin giao dịch thương mại';

  @override
  String get commercialLawDesc => 'Thông tin doanh nghiệp & điều kiện bán hàng';

  @override
  String get operatingCompany => 'Công ty vận hành';

  @override
  String get companyName => 'TCI Corporation';

  @override
  String get companyAddress => 'Shintaka 1-5-4, Yodogawa-ku, Osaka, Nhật Bản';

  @override
  String get planUpgrade => 'Nâng cấp';

  @override
  String get planChange => 'Thay đổi';

  @override
  String get planUpgradePrompt => 'Nâng cấp gói để an toàn hơn';

  @override
  String get planFreeWithWatch => 'Miễn phí · Theo dõi GPS';

  @override
  String get familySafety => 'An toàn gia đình';

  @override
  String get familyPrompt => 'Bảo vệ gia đình & nhóm';

  @override
  String get corporateSafety => 'An toàn doanh nghiệp';

  @override
  String get gpsWatchFree => 'Theo dõi GPS (Miễn phí)';

  @override
  String get adminMode => 'Chế độ quản trị';

  @override
  String get employeeMode => 'Chế độ nhân viên';

  @override
  String get watchingMode => 'Đang theo dõi GPS';

  @override
  String get sharingGps => 'Đang chia sẻ GPS';

  @override
  String get parentMode => 'Chế độ phụ huynh';

  @override
  String get childMode => 'Chế độ con';

  @override
  String membersCount(int count) {
    return '$count nhân viên';
  }

  @override
  String childrenCount(int count) {
    return '$count con';
  }

  @override
  String watchingPerson(String name) {
    return 'Theo dõi GPS · $name';
  }

  @override
  String get beingWatched => 'Đang chia sẻ GPS · Đang được theo dõi';

  @override
  String get gpsWaiting => 'GPS chờ';

  @override
  String get gpsHigh => 'Cao';

  @override
  String get gpsMedium => 'Trung bình';

  @override
  String get gpsLow => 'Thấp';

  @override
  String get termsContentFull =>
      'Cảm ơn bạn đã sử dụng CHARI-PI.\n\nỨng dụng này là công cụ điều hướng hỗ trợ an toàn giao thông khi đi xe đạp.\n\n[Miễn trừ trách nhiệm]\n- Ứng dụng này là công cụ hỗ trợ, không miễn trừ nghĩa vụ chú ý của người lái.\n- Độ chính xác GPS và dữ liệu bản đồ không được đảm bảo.\n- Luôn ưu tiên nhận thức an toàn khi đi xe.\n- Nhà phát triển không chịu trách nhiệm về tai nạn do sử dụng ứng dụng.\n\n[Nội dung học tập]\n- Nội dung luật giao thông dựa trên tài liệu chính thức.\n- Vui lòng xác nhận với luật mới nhất.\n\n[Dữ liệu vị trí]\n- Ứng dụng sử dụng GPS.\n- Dữ liệu vị trí chỉ được xử lý trên thiết bị.';
}
