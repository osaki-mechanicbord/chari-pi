// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class L10nKo extends L10n {
  L10nKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => 'CHARI-PI';

  @override
  String get appTagline => '자전거 안전 내비게이션';

  @override
  String get navMap => '내비';

  @override
  String get navLearn => '학습';

  @override
  String get navQuiz => '퀴즈';

  @override
  String get navLaw => '법개정';

  @override
  String get navLog => '기록';

  @override
  String get navSettings => '설정';

  @override
  String get splashSubtitle => '자전거 안전 내비게이션';

  @override
  String get loading => '로딩 중...';

  @override
  String get termsTitle => '이용약관';

  @override
  String get agreeAndContinue => '동의하고 시작';

  @override
  String get startTitle => '라이딩을 시작하세요!';

  @override
  String get startButton => '내비 시작';

  @override
  String get locationPermissionRequired => '위치 권한이 필요합니다';

  @override
  String get featureSafety => '안전';

  @override
  String get featureSafetyDesc => '실시간 경고';

  @override
  String get featureMap => '지도';

  @override
  String get featureMapDesc => 'OSM 연동';

  @override
  String get featureLearn => '학습';

  @override
  String get featureLearnDesc => '교통 규칙';

  @override
  String get gpsSearching => 'GPS 검색 중...';

  @override
  String get gpsAccuracy => 'GPS 정확도';

  @override
  String get stopSignAhead => '정지 표지판 전방';

  @override
  String get trafficSignalAhead => '신호등 전방';

  @override
  String get onewayWarning => '일방통행 주의';

  @override
  String get metersAhead => 'm 전방';

  @override
  String get demoMode => '데모';

  @override
  String get demoModeButton => '데모 모드';

  @override
  String get gpsUnavailableTitle => 'GPS를 찾을 수 없음';

  @override
  String get gpsUnavailableMessage =>
      'GPS 위치정보를 가져올 수 없습니다.\n\n・브라우저 위치 권한을 확인해주세요\n・위치 서비스를 켜주세요\n\n데모 모드로 체험할 수 있습니다.';

  @override
  String get closeButton => '닫기';

  @override
  String get startWithDemo => '데모로 시작';

  @override
  String get warningCountUnit => '건';

  @override
  String warningMessageFormat(int distance, String type) {
    return '${distance}m 전방에 $type';
  }

  @override
  String get nodeStopSign => '정지 표지판';

  @override
  String get nodeTrafficSignal => '신호등';

  @override
  String get nodeOneway => '일방통행';

  @override
  String get nodeWrongWay => '역주행 경고';

  @override
  String get nodePedestrianRoad => '보행자 전용도로';

  @override
  String get nodeFootway => '보도';

  @override
  String get nodeFootwayNoBicycle => '자전거 금지 보도';

  @override
  String get nodeCycleway => '자전거 전용도로';

  @override
  String get nodeCrossing => '횡단보도';

  @override
  String get nodeNoBicycle => '자전거 통행 금지';

  @override
  String get nodeDismount => '하차 구간';

  @override
  String get nodeSpeedLimit => '속도 제한';

  @override
  String get nodeAccidentZone => '사고 다발 지점';

  @override
  String get nodeEnforcementZone => '단속 구역';

  @override
  String get penaltyWrongWay => '역주행: 3개월 이하 징역 또는 5만엔 이하 벌금';

  @override
  String get penaltyNoBicycle => '통행 금지 위반: 5만엔 이하 벌금';

  @override
  String get penaltyStopSign => '일시정지 무시: 청색 딱지 대상';

  @override
  String get penaltyEnforcement => '교통 단속 중점 구역';

  @override
  String get logTitle => '라이딩 기록';

  @override
  String get noHistory => '라이딩 기록이 없습니다';

  @override
  String get totalDistance => '총 거리';

  @override
  String get duration => '라이딩 시간';

  @override
  String get warningsLabel => '경고 횟수';

  @override
  String get rideCount => '라이딩 횟수';

  @override
  String get deleteHistory => '기록 삭제';

  @override
  String get deleteHistoryConfirm => '모든 라이딩 기록을 삭제하시겠습니까?';

  @override
  String get cancelButton => '취소';

  @override
  String get deleteButton => '삭제';

  @override
  String get startNavPrompt => '내비 시작으로 라이딩을 기록하세요';

  @override
  String get learnTitle => '교통 규칙 학습';

  @override
  String get offlineLabel => '오프라인';

  @override
  String get refreshTooltip => '데이터 새로고침';

  @override
  String get allCategories => '전체';

  @override
  String get sourceLabel => '출처: 일본 경찰청·e-Gov 법령검색';

  @override
  String rulesCountFormat(int count) {
    return '$count개의 교통 규칙';
  }

  @override
  String get loadingContent => '콘텐츠 로딩 중...';

  @override
  String get retryButton => '재시도';

  @override
  String get noMatchingRules => '해당 규칙이 없습니다';

  @override
  String get catBasic => '기본 규칙';

  @override
  String get catIntersection => '교차로·신호';

  @override
  String get catRoad => '도로 주행';

  @override
  String get catEquipment => '장비·차체';

  @override
  String get catProhibition => '금지 사항';

  @override
  String get catSafety => '안전 대책';

  @override
  String get catInsurance => '보험';

  @override
  String get catNewLaw => '신제도';

  @override
  String get catRegistration => '등록';

  @override
  String get quizTitle => '교통 규칙 퀴즈';

  @override
  String get quizCorrect => '정답!';

  @override
  String get quizIncorrect => '오답...';

  @override
  String get quizScore => '점수';

  @override
  String get quizNext => '다음 문제';

  @override
  String get quizFinish => '결과 보기';

  @override
  String get quizResult => '퀴즈 결과';

  @override
  String get quizRetry => '다시 도전';

  @override
  String get quizStart => '퀴즈 시작';

  @override
  String get quizTotal => '합계';

  @override
  String get quizEasy => '초급';

  @override
  String get quizMedium => '중급';

  @override
  String get quizHard => '상급';

  @override
  String get quizAllLevels => '전 레벨';

  @override
  String get quizDifficulty => '난이도';

  @override
  String get quizQuestionCount => '출제 수';

  @override
  String get quizQuestionUnit => '문';

  @override
  String get quizNoQuestions => '퀴즈를 찾을 수 없습니다';

  @override
  String quizQuestionProgress(int current, int total) {
    return '문$current / $total';
  }

  @override
  String quizScoreResult(int score, int total) {
    return '$score / $total 문제 정답';
  }

  @override
  String get quizGreatMessage => '훌륭합니다! 교통 규칙을 잘 이해하고 있습니다.';

  @override
  String get quizTryAgainMessage => '조금 더 노력해 봅시다!\n교통 규칙을 다시 한번 복습해 보세요.';

  @override
  String get quizSourceNote =>
      '출처: 도로교통법·경찰청 자전거 포털사이트\n콘텐츠는 공적 자료에 기반하고 있으며, 최신 법령은 직접 확인해 주세요.';

  @override
  String get lawUpdatesTitle => '법개정 뉴스';

  @override
  String get lawUpdatesInfo => '자전거 관련 법개정·신제도 최신 정보';

  @override
  String get lawNoUpdates => '법개정 정보가 아직 없습니다';

  @override
  String get lawUpcoming => '시행 예정';

  @override
  String get lawEnacted => '시행됨';

  @override
  String lawEffectiveDate(String date) {
    return '시행일: $date';
  }

  @override
  String get lawCheckSource => '출처 확인';

  @override
  String get settingsTitle => '설정';

  @override
  String get planSection => '플랜';

  @override
  String get alertSection => '경고 설정';

  @override
  String get displaySection => '표시 설정';

  @override
  String get appInfoSection => '앱 정보';

  @override
  String get legalSection => '법적 정보';

  @override
  String get languageSection => '언어 설정';

  @override
  String get voiceAlert => '음성 경고';

  @override
  String get voiceAlertDesc => '정지·신호등 음성 안내';

  @override
  String get vibrationAlert => '진동';

  @override
  String get vibrationAlertDesc => '경고 시 진동';

  @override
  String get alertDistance => '경고 거리';

  @override
  String get darkMap => '다크 맵';

  @override
  String get darkMapDesc => '어두운 지도 테마 사용';

  @override
  String get languageSetting => '언어';

  @override
  String get languageSettingDesc => '앱 표시 언어 변경';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageEnglish => 'English';

  @override
  String get aboutApp => '앱 정보';

  @override
  String get aboutAppDesc => 'CHARI-PI - 자전거 안전 내비';

  @override
  String get appVersion => '버전';

  @override
  String get aboutDialogContent =>
      'CHARI-PI는 자전거 주행 시 안전을 지원하는 내비게이션 앱입니다.\n\nOpenStreetMap 데이터를 활용하여 정지 표지판과 신호등 위치를 실시간으로 알려줍니다.\n\n안전한 자전거 라이프를 위해 활용해주세요.';

  @override
  String get privacyPolicy => '개인정보처리방침';

  @override
  String get privacyPolicyDesc => '개인정보·위치정보 처리에 관하여';

  @override
  String get securityPolicy => '보안 정책';

  @override
  String get securityPolicyDesc => '정보보안 관리 체계';

  @override
  String get termsOfService => '이용약관';

  @override
  String get termsOfServiceDesc => '서비스 이용 조건';

  @override
  String get disclaimer => '면책 조항';

  @override
  String get disclaimerDesc => '서비스 관련 면책 조항';

  @override
  String get commercialLaw => '특정상거래법 표시';

  @override
  String get commercialLawDesc => '사업자 정보·판매 조건';

  @override
  String get operatingCompany => '운영회사';

  @override
  String get companyName => 'TCI 주식회사';

  @override
  String get companyAddress => '일본 오사카시 요도가와구 신타카 1-5-4';

  @override
  String get planUpgrade => '업그레이드';

  @override
  String get planChange => '변경';

  @override
  String get planUpgradePrompt => '플랜을 업그레이드하여 안전을 지키세요';

  @override
  String get planFreeWithWatch => '무료 · GPS 보호 기능 활성화';

  @override
  String get familySafety => '가족 안전';

  @override
  String get familyPrompt => '가족과 조직의 안전을 지키기';

  @override
  String get corporateSafety => '기업 안전 관리';

  @override
  String get gpsWatchFree => 'GPS 보호 (무료)';

  @override
  String get adminMode => '관리자 모드';

  @override
  String get employeeMode => '직원 모드';

  @override
  String get watchingMode => 'GPS 보호 활성화';

  @override
  String get sharingGps => 'GPS 공유 중';

  @override
  String get parentMode => '보호자 모드';

  @override
  String get childMode => '어린이 모드';

  @override
  String membersCount(int count) {
    return '$count명의 직원';
  }

  @override
  String childrenCount(int count) {
    return '$count명의 자녀';
  }

  @override
  String watchingPerson(String name) {
    return 'GPS 보호 중 · $name님';
  }

  @override
  String get beingWatched => 'GPS 공유 중 · 보호받고 있습니다';

  @override
  String get gpsWaiting => 'GPS 대기 중';

  @override
  String get gpsHigh => '고정밀';

  @override
  String get gpsMedium => '중정밀';

  @override
  String get gpsLow => '저정밀';

  @override
  String get termsContentFull =>
      'CHARI-PI를 이용해 주셔서 감사합니다.\n\n본 앱은 자전거 주행 시 교통 안전을 지원하는 내비게이션 도구입니다.\n\n【면책 조항】\n- 본 앱은 교통 안전 보조 도구이며, 운전자의 주의 의무를 면제하지 않습니다.\n- GPS 정확도와 지도 데이터의 정확성은 보장하지 않습니다.\n- 주행 중에는 주변 안전 확인을 최우선으로 해주세요.\n- 본 앱 사용으로 발생한 사고에 대해 개발자는 책임을 지지 않습니다.';
}
