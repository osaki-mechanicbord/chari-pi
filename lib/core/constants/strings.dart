class AppStrings {
  // App
  static const String appName = 'CHARI-PI';
  static const String appTagline = 'チャリッピー - 安全な自転車ライフのために';

  // Navigation
  static const String navMap = 'ナビ';
  static const String navLog = '履歴';
  static const String navLearn = '学習';
  static const String navQuiz = 'クイズ';
  static const String navSettings = '設定';

  // Splash
  static const String splashSubtitle = 'チャリッピー 自転車安全ナビ';
  static const String loading = '読み込み中...';

  // Terms
  static const String termsTitle = '利用規約';
  static const String termsContent = '''
CHARI-PI（チャリッピー）をご利用いただきありがとうございます。

本アプリは、自転車走行時の交通安全を支援するナビゲーションツールです。

【免責事項】
- 本アプリは交通安全の補助ツールであり、運転者の注意義務を免除するものではありません。
- GPS精度や地図データの正確性は保証いたしかねます。
- 走行中は周囲の安全確認を最優先してください。
- 本アプリの使用により発生した事故等について、開発者は一切の責任を負いません。

【学習コンテンツについて】
- 本アプリの交通ルール学習コンテンツは、警察庁自転車ポータルサイト及びe-Gov法令検索の公的資料に基づいています。
- コンテンツは公的資料に基づいていますが、最新の法令は各自でご確認ください。
- 法的助言を目的としたものではありません。
- 法改正があった場合、コンテンツの更新に時間がかかる場合があります。

【出典】
- 警察庁 自転車ポータルサイト: https://www.npa.go.jp/bureau/traffic/bicycle/portal/
- e-Gov 法令検索: https://laws.e-gov.go.jp/
- 政府広報オンライン: https://www.gov-online.go.jp/

【位置情報について】
- 本アプリはGPS位置情報を使用します。
- 位置情報はデバイス内のみで処理され、外部サーバーには送信されません。

【データの取り扱い】
- 走行履歴はデバイス内にのみ保存されます。
- 学習コンテンツはサーバーから取得し、ローカルにキャッシュされます。
- OpenStreetMapのデータを利用して交通標識の位置を取得します。
''';
  static const String agreeAndContinue = '同意して始める';

  // Start Screen
  static const String startTitle = '走行を始めましょう';
  static const String startButton = 'ナビ開始';
  static const String locationPermissionRequired = '位置情報の許可が必要です';

  // Navigation
  static const String gpsSearching = 'GPS検索中...';
  static const String gpsAccuracy = 'GPS精度';
  static const String stopSignAhead = '一時停止あり';
  static const String trafficSignalAhead = '信号機あり';
  static const String onewayWarning = '一方通行注意';
  static const String metersAhead = 'm先に';

  // Log
  static const String logTitle = '走行履歴';
  static const String noHistory = '走行履歴がありません';
  static const String totalDistance = '総距離';
  static const String duration = '走行時間';
  static const String warnings = '警告回数';

  // Learn
  static const String learnTitle = '交通ルール学習';
  static const String learnStopSign = '一時停止の正しい止まり方';
  static const String learnTrafficSignal = '自転車の信号ルール';
  static const String learnOneway = '一方通行のルール';
  static const String learnLeftSide = '左側通行のルール';
  static const String learnCrosswalk = '横断歩道のルール';
  static const String learnNightRide = '夜間走行のルール';

  // Quiz
  static const String quizTitle = '交通ルールクイズ';
  static const String quizCorrect = '正解！';
  static const String quizIncorrect = '不正解...';
  static const String quizScore = 'スコア';
  static const String quizNext = '次の問題';
  static const String quizFinish = '結果を見る';
  static const String quizResult = 'クイズ結果';
  static const String quizRetry = 'もう一度';

  // Settings
  static const String settingsTitle = '設定';
  static const String voiceAlert = '音声警告';
  static const String vibrationAlert = 'バイブレーション';
  static const String alertDistance = '警告距離';
  static const String mapStyle = '地図スタイル';
  static const String clearCache = 'キャッシュを削除';
  static const String appVersion = 'バージョン';
  static const String privacyPolicy = 'プライバシーポリシー';
  static const String termsOfService = '利用規約';
  static const String aboutApp = 'アプリについて';
}
