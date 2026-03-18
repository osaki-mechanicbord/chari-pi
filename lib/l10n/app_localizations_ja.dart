// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class L10nJa extends L10n {
  L10nJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'CHARI-PI';

  @override
  String get appTagline => 'チャリッピー - 安全な自転車ライフのために';

  @override
  String get navMap => 'ナビ';

  @override
  String get navLearn => '学習';

  @override
  String get navQuiz => 'クイズ';

  @override
  String get navLaw => '法改正';

  @override
  String get navLog => '履歴';

  @override
  String get navSettings => '設定';

  @override
  String get splashSubtitle => 'チャリッピー 自転車安全ナビ';

  @override
  String get loading => '読み込み中...';

  @override
  String get termsTitle => '利用規約';

  @override
  String get agreeAndContinue => '同意して始める';

  @override
  String get startTitle => '走行を始めましょう';

  @override
  String get startButton => 'ナビ開始';

  @override
  String get locationPermissionRequired => '位置情報の許可が必要です';

  @override
  String get featureSafety => '安全';

  @override
  String get featureSafetyDesc => 'リアルタイム警告';

  @override
  String get featureMap => '地図';

  @override
  String get featureMapDesc => 'OSM連携';

  @override
  String get featureLearn => '学習';

  @override
  String get featureLearnDesc => '交通ルール';

  @override
  String get gpsSearching => 'GPS検索中...';

  @override
  String get gpsAccuracy => 'GPS精度';

  @override
  String get stopSignAhead => '一時停止あり';

  @override
  String get trafficSignalAhead => '信号機あり';

  @override
  String get onewayWarning => '一方通行注意';

  @override
  String get metersAhead => 'm先に';

  @override
  String get demoMode => 'デモ';

  @override
  String get demoModeButton => 'デモモード';

  @override
  String get gpsUnavailableTitle => 'GPS未検出';

  @override
  String get gpsUnavailableMessage =>
      'GPSの位置情報が取得できません。\n\n・ブラウザの位置情報許可を確認\n・位置情報サービスをONに\n\nデモモードで体験することもできます。';

  @override
  String get closeButton => '閉じる';

  @override
  String get startWithDemo => 'デモで開始';

  @override
  String get warningCountUnit => '件';

  @override
  String warningMessageFormat(int distance, String type) {
    return '${distance}m先に$typeあり';
  }

  @override
  String get nodeStopSign => '一時停止';

  @override
  String get nodeTrafficSignal => '信号機';

  @override
  String get nodeOneway => '一方通行';

  @override
  String get nodeWrongWay => '逆走警告';

  @override
  String get nodePedestrianRoad => '歩行者専用道路';

  @override
  String get nodeFootway => '歩道';

  @override
  String get nodeFootwayNoBicycle => '自転車禁止歩道';

  @override
  String get nodeCycleway => '自転車専用道路';

  @override
  String get nodeCrossing => '横断歩道';

  @override
  String get nodeNoBicycle => '自転車通行禁止';

  @override
  String get nodeDismount => '押し歩き区間';

  @override
  String get nodeSpeedLimit => '速度制限';

  @override
  String get nodeAccidentZone => '事故多発地点';

  @override
  String get nodeEnforcementZone => '取り締まりエリア';

  @override
  String get penaltyWrongWay => '逆走は3ヶ月以下の懲役又は5万円以下の罰金';

  @override
  String get penaltyNoBicycle => '通行禁止違反: 5万円以下の罰金';

  @override
  String get penaltyStopSign => '一時停止無視: 青切符の対象';

  @override
  String get penaltyEnforcement => '取り締まり重点エリアです';

  @override
  String get logTitle => '走行履歴';

  @override
  String get noHistory => '走行履歴がありません';

  @override
  String get totalDistance => '総距離';

  @override
  String get duration => '走行時間';

  @override
  String get warningsLabel => '警告回数';

  @override
  String get rideCount => '走行回数';

  @override
  String get deleteHistory => '履歴を削除';

  @override
  String get deleteHistoryConfirm => '全ての走行履歴を削除しますか？';

  @override
  String get cancelButton => 'キャンセル';

  @override
  String get deleteButton => '削除';

  @override
  String get startNavPrompt => '「ナビ開始」で走行を記録しましょう';

  @override
  String get learnTitle => '交通ルール学習';

  @override
  String get offlineLabel => 'オフライン';

  @override
  String get refreshTooltip => 'データを更新';

  @override
  String get allCategories => '全て';

  @override
  String get sourceLabel => '出典: 警察庁・e-Gov法令検索';

  @override
  String rulesCountFormat(int count) {
    return '$count件の交通ルール';
  }

  @override
  String get loadingContent => 'コンテンツを読み込み中...';

  @override
  String get retryButton => '再試行';

  @override
  String get noMatchingRules => '該当するルールがありません';

  @override
  String get catBasic => '基本ルール';

  @override
  String get catIntersection => '交差点・信号';

  @override
  String get catRoad => '道路走行';

  @override
  String get catEquipment => '装備・車体';

  @override
  String get catProhibition => '禁止事項';

  @override
  String get catSafety => '安全対策';

  @override
  String get catInsurance => '保険';

  @override
  String get catNewLaw => '新制度';

  @override
  String get catRegistration => '登録';

  @override
  String get quizTitle => '交通ルールクイズ';

  @override
  String get quizCorrect => '正解！';

  @override
  String get quizIncorrect => '不正解...';

  @override
  String get quizScore => 'スコア';

  @override
  String get quizNext => '次の問題';

  @override
  String get quizFinish => '結果を見る';

  @override
  String get quizResult => 'クイズ結果';

  @override
  String get quizRetry => 'もう一度';

  @override
  String get quizStart => 'クイズ開始';

  @override
  String get quizTotal => '合計';

  @override
  String get quizEasy => '初級';

  @override
  String get quizMedium => '中級';

  @override
  String get quizHard => '上級';

  @override
  String get quizAllLevels => '全レベル';

  @override
  String get quizDifficulty => '難易度';

  @override
  String get quizQuestionCount => '出題数';

  @override
  String get quizQuestionUnit => '問';

  @override
  String get quizNoQuestions => 'クイズが見つかりません';

  @override
  String quizQuestionProgress(int current, int total) {
    return '問$current / $total';
  }

  @override
  String quizScoreResult(int score, int total) {
    return '$score / $total 問正解';
  }

  @override
  String get quizGreatMessage => '素晴らしい！交通ルールをよく理解しています。';

  @override
  String get quizTryAgainMessage => 'もう少し頑張りましょう！\n交通ルールをもう一度復習してみましょう。';

  @override
  String get quizSourceNote =>
      '出典: 道路交通法・警察庁自転車ポータルサイト\n本コンテンツは公的資料に基づいていますが、最新の法令は各自でご確認ください。';

  @override
  String get lawUpdatesTitle => '法改正ニュース';

  @override
  String get lawUpdatesInfo => '自転車に関する法改正・新制度の最新情報';

  @override
  String get lawNoUpdates => '法改正情報はまだありません';

  @override
  String get lawUpcoming => '施行予定';

  @override
  String get lawEnacted => '施行済み';

  @override
  String lawEffectiveDate(String date) {
    return '施行日: $date';
  }

  @override
  String get lawCheckSource => '出典を確認';

  @override
  String get settingsTitle => '設定';

  @override
  String get planSection => 'プラン';

  @override
  String get alertSection => '警告設定';

  @override
  String get displaySection => '表示設定';

  @override
  String get appInfoSection => 'アプリ情報';

  @override
  String get legalSection => '法的情報';

  @override
  String get languageSection => '言語設定';

  @override
  String get voiceAlert => '音声警告';

  @override
  String get voiceAlertDesc => '一時停止・信号機の音声案内';

  @override
  String get vibrationAlert => 'バイブレーション';

  @override
  String get vibrationAlertDesc => '警告時のバイブレーション';

  @override
  String get alertDistance => '警告距離';

  @override
  String get darkMap => 'ダークマップ';

  @override
  String get darkMapDesc => '暗い地図テーマを使用';

  @override
  String get languageSetting => '言語';

  @override
  String get languageSettingDesc => 'アプリの表示言語を変更';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageEnglish => 'English';

  @override
  String get aboutApp => 'アプリについて';

  @override
  String get aboutAppDesc => 'CHARI-PI（チャリッピー） - 自転車安全ナビ';

  @override
  String get appVersion => 'バージョン';

  @override
  String get aboutDialogContent =>
      'CHARI-PI（チャリッピー）は自転車走行時の安全を支援するナビゲーションアプリです。\n\nOpenStreetMapのデータを活用し、一時停止標識や信号機の位置をリアルタイムで通知します。\n\n安全な自転車ライフのために、ぜひご活用ください。';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get privacyPolicyDesc => '個人情報・位置情報の取り扱いについて';

  @override
  String get securityPolicy => 'セキュリティポリシー';

  @override
  String get securityPolicyDesc => '情報セキュリティの管理体制について';

  @override
  String get termsOfService => '利用規約';

  @override
  String get termsOfServiceDesc => 'サービスのご利用条件';

  @override
  String get disclaimer => '免責事項';

  @override
  String get disclaimerDesc => 'サービスに関する免責事項';

  @override
  String get commercialLaw => '特定商取引法に基づく表記';

  @override
  String get commercialLawDesc => '事業者情報・販売条件';

  @override
  String get operatingCompany => '運営会社';

  @override
  String get companyName => '株式会社TCI';

  @override
  String get companyAddress => '大阪府大阪市淀川区新高1-5-4';

  @override
  String get planUpgrade => 'アップグレード';

  @override
  String get planChange => '変更';

  @override
  String get planUpgradePrompt => 'プランをアップグレードして安全を守ろう';

  @override
  String get planFreeWithWatch => '無料 · GPS見守り機能有効';

  @override
  String get familySafety => 'ファミリーセーフティ';

  @override
  String get familyPrompt => '家族や組織で安全を見守る';

  @override
  String get corporateSafety => '法人安全管理';

  @override
  String get gpsWatchFree => 'GPS見守り（無料）';

  @override
  String get adminMode => '管理者モード';

  @override
  String get employeeMode => '従業員モード';

  @override
  String get watchingMode => 'GPS見守り中';

  @override
  String get sharingGps => 'GPS共有中';

  @override
  String get parentMode => '保護者モード';

  @override
  String get childMode => '子供モード';

  @override
  String membersCount(int count) {
    return '$count人の従業員';
  }

  @override
  String childrenCount(int count) {
    return '$count人のお子さま';
  }

  @override
  String watchingPerson(String name) {
    return 'GPS見守り中 · $nameさん';
  }

  @override
  String get beingWatched => 'GPS共有中 · 見守られています';

  @override
  String get gpsWaiting => 'GPS待機中';

  @override
  String get gpsHigh => '高精度';

  @override
  String get gpsMedium => '中精度';

  @override
  String get gpsLow => '低精度';

  @override
  String get termsContentFull =>
      'CHARI-PI（チャリッピー）をご利用いただきありがとうございます。\n\n本アプリは、自転車走行時の交通安全を支援するナビゲーションツールです。\n\n【免責事項】\n- 本アプリは交通安全の補助ツールであり、運転者の注意義務を免除するものではありません。\n- GPS精度や地図データの正確性は保証いたしかねます。\n- 走行中は周囲の安全確認を最優先してください。\n- 本アプリの使用により発生した事故等について、開発者は一切の責任を負いません。\n\n【学習コンテンツについて】\n- 本アプリの交通ルール学習コンテンツは、警察庁自転車ポータルサイト及びe-Gov法令検索の公的資料に基づいています。\n- コンテンツは公的資料に基づいていますが、最新の法令は各自でご確認ください。\n- 法的助言を目的としたものではありません。\n- 法改正があった場合、コンテンツの更新に時間がかかる場合があります。\n\n【出典】\n- 警察庁 自転車ポータルサイト: https://www.npa.go.jp/bureau/traffic/bicycle/portal/\n- e-Gov 法令検索: https://laws.e-gov.go.jp/\n- 政府広報オンライン: https://www.gov-online.go.jp/\n\n【位置情報について】\n- 本アプリはGPS位置情報を使用します。\n- 位置情報はデバイス内のみで処理され、外部サーバーには送信されません。\n\n【データの取り扱い】\n- 走行履歴はデバイス内にのみ保存されます。\n- 学習コンテンツはサーバーから取得し、ローカルにキャッシュされます。\n- OpenStreetMapのデータを利用して交通標識の位置を取得します。';
}
