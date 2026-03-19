import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fil.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_th.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fil'),
    Locale('ja'),
    Locale('ko'),
    Locale('th'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// No description provided for @appName.
  ///
  /// In ja, this message translates to:
  /// **'CHARI-PI'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In ja, this message translates to:
  /// **'チャリッピー - 安全な自転車ライフのために'**
  String get appTagline;

  /// No description provided for @navMap.
  ///
  /// In ja, this message translates to:
  /// **'ナビ'**
  String get navMap;

  /// No description provided for @navLearn.
  ///
  /// In ja, this message translates to:
  /// **'学習'**
  String get navLearn;

  /// No description provided for @navQuiz.
  ///
  /// In ja, this message translates to:
  /// **'クイズ'**
  String get navQuiz;

  /// No description provided for @navLaw.
  ///
  /// In ja, this message translates to:
  /// **'法改正'**
  String get navLaw;

  /// No description provided for @navLog.
  ///
  /// In ja, this message translates to:
  /// **'履歴'**
  String get navLog;

  /// No description provided for @navSettings.
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get navSettings;

  /// No description provided for @splashSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'チャリッピー 自転車安全ナビ'**
  String get splashSubtitle;

  /// No description provided for @loading.
  ///
  /// In ja, this message translates to:
  /// **'読み込み中...'**
  String get loading;

  /// No description provided for @termsTitle.
  ///
  /// In ja, this message translates to:
  /// **'利用規約'**
  String get termsTitle;

  /// No description provided for @agreeAndContinue.
  ///
  /// In ja, this message translates to:
  /// **'同意して始める'**
  String get agreeAndContinue;

  /// No description provided for @startTitle.
  ///
  /// In ja, this message translates to:
  /// **'走行を始めましょう'**
  String get startTitle;

  /// No description provided for @startButton.
  ///
  /// In ja, this message translates to:
  /// **'ナビ開始'**
  String get startButton;

  /// No description provided for @locationPermissionRequired.
  ///
  /// In ja, this message translates to:
  /// **'位置情報の許可が必要です'**
  String get locationPermissionRequired;

  /// No description provided for @featureSafety.
  ///
  /// In ja, this message translates to:
  /// **'安全'**
  String get featureSafety;

  /// No description provided for @featureSafetyDesc.
  ///
  /// In ja, this message translates to:
  /// **'リアルタイム警告'**
  String get featureSafetyDesc;

  /// No description provided for @featureMap.
  ///
  /// In ja, this message translates to:
  /// **'地図'**
  String get featureMap;

  /// No description provided for @featureMapDesc.
  ///
  /// In ja, this message translates to:
  /// **'OSM連携'**
  String get featureMapDesc;

  /// No description provided for @featureLearn.
  ///
  /// In ja, this message translates to:
  /// **'学習'**
  String get featureLearn;

  /// No description provided for @featureLearnDesc.
  ///
  /// In ja, this message translates to:
  /// **'交通ルール'**
  String get featureLearnDesc;

  /// No description provided for @gpsSearching.
  ///
  /// In ja, this message translates to:
  /// **'GPS検索中...'**
  String get gpsSearching;

  /// No description provided for @gpsAccuracy.
  ///
  /// In ja, this message translates to:
  /// **'GPS精度'**
  String get gpsAccuracy;

  /// No description provided for @stopSignAhead.
  ///
  /// In ja, this message translates to:
  /// **'一時停止あり'**
  String get stopSignAhead;

  /// No description provided for @trafficSignalAhead.
  ///
  /// In ja, this message translates to:
  /// **'信号機あり'**
  String get trafficSignalAhead;

  /// No description provided for @onewayWarning.
  ///
  /// In ja, this message translates to:
  /// **'一方通行注意'**
  String get onewayWarning;

  /// No description provided for @metersAhead.
  ///
  /// In ja, this message translates to:
  /// **'m先に'**
  String get metersAhead;

  /// No description provided for @demoMode.
  ///
  /// In ja, this message translates to:
  /// **'デモ'**
  String get demoMode;

  /// No description provided for @demoModeButton.
  ///
  /// In ja, this message translates to:
  /// **'デモモード'**
  String get demoModeButton;

  /// No description provided for @gpsUnavailableTitle.
  ///
  /// In ja, this message translates to:
  /// **'GPS未検出'**
  String get gpsUnavailableTitle;

  /// No description provided for @gpsUnavailableMessage.
  ///
  /// In ja, this message translates to:
  /// **'GPSの位置情報が取得できません。\n\n・ブラウザの位置情報許可を確認\n・位置情報サービスをONに\n\nデモモードで体験することもできます。'**
  String get gpsUnavailableMessage;

  /// No description provided for @closeButton.
  ///
  /// In ja, this message translates to:
  /// **'閉じる'**
  String get closeButton;

  /// No description provided for @startWithDemo.
  ///
  /// In ja, this message translates to:
  /// **'デモで開始'**
  String get startWithDemo;

  /// No description provided for @warningCountUnit.
  ///
  /// In ja, this message translates to:
  /// **'件'**
  String get warningCountUnit;

  /// No description provided for @warningMessageFormat.
  ///
  /// In ja, this message translates to:
  /// **'{distance}m先に{type}あり'**
  String warningMessageFormat(int distance, String type);

  /// No description provided for @nodeStopSign.
  ///
  /// In ja, this message translates to:
  /// **'一時停止'**
  String get nodeStopSign;

  /// No description provided for @nodeTrafficSignal.
  ///
  /// In ja, this message translates to:
  /// **'信号機'**
  String get nodeTrafficSignal;

  /// No description provided for @nodeOneway.
  ///
  /// In ja, this message translates to:
  /// **'一方通行'**
  String get nodeOneway;

  /// No description provided for @nodeWrongWay.
  ///
  /// In ja, this message translates to:
  /// **'逆走警告'**
  String get nodeWrongWay;

  /// No description provided for @nodePedestrianRoad.
  ///
  /// In ja, this message translates to:
  /// **'歩行者専用道路'**
  String get nodePedestrianRoad;

  /// No description provided for @nodeFootway.
  ///
  /// In ja, this message translates to:
  /// **'歩道'**
  String get nodeFootway;

  /// No description provided for @nodeFootwayNoBicycle.
  ///
  /// In ja, this message translates to:
  /// **'自転車禁止歩道'**
  String get nodeFootwayNoBicycle;

  /// No description provided for @nodeCycleway.
  ///
  /// In ja, this message translates to:
  /// **'自転車専用道路'**
  String get nodeCycleway;

  /// No description provided for @nodeCrossing.
  ///
  /// In ja, this message translates to:
  /// **'横断歩道'**
  String get nodeCrossing;

  /// No description provided for @nodeNoBicycle.
  ///
  /// In ja, this message translates to:
  /// **'自転車通行禁止'**
  String get nodeNoBicycle;

  /// No description provided for @nodeDismount.
  ///
  /// In ja, this message translates to:
  /// **'押し歩き区間'**
  String get nodeDismount;

  /// No description provided for @nodeSpeedLimit.
  ///
  /// In ja, this message translates to:
  /// **'速度制限'**
  String get nodeSpeedLimit;

  /// No description provided for @nodeAccidentZone.
  ///
  /// In ja, this message translates to:
  /// **'事故多発地点'**
  String get nodeAccidentZone;

  /// No description provided for @nodeEnforcementZone.
  ///
  /// In ja, this message translates to:
  /// **'取り締まりエリア'**
  String get nodeEnforcementZone;

  /// No description provided for @penaltyWrongWay.
  ///
  /// In ja, this message translates to:
  /// **'逆走は3ヶ月以下の懲役又は5万円以下の罰金'**
  String get penaltyWrongWay;

  /// No description provided for @penaltyNoBicycle.
  ///
  /// In ja, this message translates to:
  /// **'通行禁止違反: 5万円以下の罰金'**
  String get penaltyNoBicycle;

  /// No description provided for @penaltyStopSign.
  ///
  /// In ja, this message translates to:
  /// **'一時停止無視: 青切符の対象'**
  String get penaltyStopSign;

  /// No description provided for @penaltyEnforcement.
  ///
  /// In ja, this message translates to:
  /// **'取り締まり重点エリアです'**
  String get penaltyEnforcement;

  /// No description provided for @logTitle.
  ///
  /// In ja, this message translates to:
  /// **'走行履歴'**
  String get logTitle;

  /// No description provided for @noHistory.
  ///
  /// In ja, this message translates to:
  /// **'走行履歴がありません'**
  String get noHistory;

  /// No description provided for @totalDistance.
  ///
  /// In ja, this message translates to:
  /// **'総距離'**
  String get totalDistance;

  /// No description provided for @duration.
  ///
  /// In ja, this message translates to:
  /// **'走行時間'**
  String get duration;

  /// No description provided for @warningsLabel.
  ///
  /// In ja, this message translates to:
  /// **'警告回数'**
  String get warningsLabel;

  /// No description provided for @rideCount.
  ///
  /// In ja, this message translates to:
  /// **'走行回数'**
  String get rideCount;

  /// No description provided for @deleteHistory.
  ///
  /// In ja, this message translates to:
  /// **'履歴を削除'**
  String get deleteHistory;

  /// No description provided for @deleteHistoryConfirm.
  ///
  /// In ja, this message translates to:
  /// **'全ての走行履歴を削除しますか？'**
  String get deleteHistoryConfirm;

  /// No description provided for @cancelButton.
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get cancelButton;

  /// No description provided for @deleteButton.
  ///
  /// In ja, this message translates to:
  /// **'削除'**
  String get deleteButton;

  /// No description provided for @startNavPrompt.
  ///
  /// In ja, this message translates to:
  /// **'「ナビ開始」で走行を記録しましょう'**
  String get startNavPrompt;

  /// No description provided for @learnTitle.
  ///
  /// In ja, this message translates to:
  /// **'交通ルール学習'**
  String get learnTitle;

  /// No description provided for @offlineLabel.
  ///
  /// In ja, this message translates to:
  /// **'オフライン'**
  String get offlineLabel;

  /// No description provided for @refreshTooltip.
  ///
  /// In ja, this message translates to:
  /// **'データを更新'**
  String get refreshTooltip;

  /// No description provided for @allCategories.
  ///
  /// In ja, this message translates to:
  /// **'全て'**
  String get allCategories;

  /// No description provided for @sourceLabel.
  ///
  /// In ja, this message translates to:
  /// **'出典: 警察庁・e-Gov法令検索'**
  String get sourceLabel;

  /// No description provided for @rulesCountFormat.
  ///
  /// In ja, this message translates to:
  /// **'{count}件の交通ルール'**
  String rulesCountFormat(int count);

  /// No description provided for @loadingContent.
  ///
  /// In ja, this message translates to:
  /// **'コンテンツを読み込み中...'**
  String get loadingContent;

  /// No description provided for @retryButton.
  ///
  /// In ja, this message translates to:
  /// **'再試行'**
  String get retryButton;

  /// No description provided for @noMatchingRules.
  ///
  /// In ja, this message translates to:
  /// **'該当するルールがありません'**
  String get noMatchingRules;

  /// No description provided for @catBasic.
  ///
  /// In ja, this message translates to:
  /// **'基本ルール'**
  String get catBasic;

  /// No description provided for @catIntersection.
  ///
  /// In ja, this message translates to:
  /// **'交差点・信号'**
  String get catIntersection;

  /// No description provided for @catRoad.
  ///
  /// In ja, this message translates to:
  /// **'道路走行'**
  String get catRoad;

  /// No description provided for @catEquipment.
  ///
  /// In ja, this message translates to:
  /// **'装備・車体'**
  String get catEquipment;

  /// No description provided for @catProhibition.
  ///
  /// In ja, this message translates to:
  /// **'禁止事項'**
  String get catProhibition;

  /// No description provided for @catSafety.
  ///
  /// In ja, this message translates to:
  /// **'安全対策'**
  String get catSafety;

  /// No description provided for @catInsurance.
  ///
  /// In ja, this message translates to:
  /// **'保険'**
  String get catInsurance;

  /// No description provided for @catNewLaw.
  ///
  /// In ja, this message translates to:
  /// **'新制度'**
  String get catNewLaw;

  /// No description provided for @catRegistration.
  ///
  /// In ja, this message translates to:
  /// **'登録'**
  String get catRegistration;

  /// No description provided for @quizTitle.
  ///
  /// In ja, this message translates to:
  /// **'交通ルールクイズ'**
  String get quizTitle;

  /// No description provided for @quizCorrect.
  ///
  /// In ja, this message translates to:
  /// **'正解！'**
  String get quizCorrect;

  /// No description provided for @quizIncorrect.
  ///
  /// In ja, this message translates to:
  /// **'不正解...'**
  String get quizIncorrect;

  /// No description provided for @quizScore.
  ///
  /// In ja, this message translates to:
  /// **'スコア'**
  String get quizScore;

  /// No description provided for @quizNext.
  ///
  /// In ja, this message translates to:
  /// **'次の問題'**
  String get quizNext;

  /// No description provided for @quizFinish.
  ///
  /// In ja, this message translates to:
  /// **'結果を見る'**
  String get quizFinish;

  /// No description provided for @quizResult.
  ///
  /// In ja, this message translates to:
  /// **'クイズ結果'**
  String get quizResult;

  /// No description provided for @quizRetry.
  ///
  /// In ja, this message translates to:
  /// **'もう一度'**
  String get quizRetry;

  /// No description provided for @quizStart.
  ///
  /// In ja, this message translates to:
  /// **'クイズ開始'**
  String get quizStart;

  /// No description provided for @quizTotal.
  ///
  /// In ja, this message translates to:
  /// **'合計'**
  String get quizTotal;

  /// No description provided for @quizEasy.
  ///
  /// In ja, this message translates to:
  /// **'初級'**
  String get quizEasy;

  /// No description provided for @quizMedium.
  ///
  /// In ja, this message translates to:
  /// **'中級'**
  String get quizMedium;

  /// No description provided for @quizHard.
  ///
  /// In ja, this message translates to:
  /// **'上級'**
  String get quizHard;

  /// No description provided for @quizAllLevels.
  ///
  /// In ja, this message translates to:
  /// **'全レベル'**
  String get quizAllLevels;

  /// No description provided for @quizDifficulty.
  ///
  /// In ja, this message translates to:
  /// **'難易度'**
  String get quizDifficulty;

  /// No description provided for @quizQuestionCount.
  ///
  /// In ja, this message translates to:
  /// **'出題数'**
  String get quizQuestionCount;

  /// No description provided for @quizQuestionUnit.
  ///
  /// In ja, this message translates to:
  /// **'問'**
  String get quizQuestionUnit;

  /// No description provided for @quizNoQuestions.
  ///
  /// In ja, this message translates to:
  /// **'クイズが見つかりません'**
  String get quizNoQuestions;

  /// No description provided for @quizQuestionProgress.
  ///
  /// In ja, this message translates to:
  /// **'問{current} / {total}'**
  String quizQuestionProgress(int current, int total);

  /// No description provided for @quizScoreResult.
  ///
  /// In ja, this message translates to:
  /// **'{score} / {total} 問正解'**
  String quizScoreResult(int score, int total);

  /// No description provided for @quizGreatMessage.
  ///
  /// In ja, this message translates to:
  /// **'素晴らしい！交通ルールをよく理解しています。'**
  String get quizGreatMessage;

  /// No description provided for @quizTryAgainMessage.
  ///
  /// In ja, this message translates to:
  /// **'もう少し頑張りましょう！\n交通ルールをもう一度復習してみましょう。'**
  String get quizTryAgainMessage;

  /// No description provided for @quizSourceNote.
  ///
  /// In ja, this message translates to:
  /// **'出典: 道路交通法・警察庁自転車ポータルサイト\n本コンテンツは公的資料に基づいていますが、最新の法令は各自でご確認ください。'**
  String get quizSourceNote;

  /// No description provided for @lawUpdatesTitle.
  ///
  /// In ja, this message translates to:
  /// **'法改正ニュース'**
  String get lawUpdatesTitle;

  /// No description provided for @lawUpdatesInfo.
  ///
  /// In ja, this message translates to:
  /// **'自転車に関する法改正・新制度の最新情報'**
  String get lawUpdatesInfo;

  /// No description provided for @lawNoUpdates.
  ///
  /// In ja, this message translates to:
  /// **'法改正情報はまだありません'**
  String get lawNoUpdates;

  /// No description provided for @lawUpcoming.
  ///
  /// In ja, this message translates to:
  /// **'施行予定'**
  String get lawUpcoming;

  /// No description provided for @lawEnacted.
  ///
  /// In ja, this message translates to:
  /// **'施行済み'**
  String get lawEnacted;

  /// No description provided for @lawEffectiveDate.
  ///
  /// In ja, this message translates to:
  /// **'施行日: {date}'**
  String lawEffectiveDate(String date);

  /// No description provided for @lawCheckSource.
  ///
  /// In ja, this message translates to:
  /// **'出典を確認'**
  String get lawCheckSource;

  /// No description provided for @settingsTitle.
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get settingsTitle;

  /// No description provided for @planSection.
  ///
  /// In ja, this message translates to:
  /// **'プラン'**
  String get planSection;

  /// No description provided for @alertSection.
  ///
  /// In ja, this message translates to:
  /// **'警告設定'**
  String get alertSection;

  /// No description provided for @displaySection.
  ///
  /// In ja, this message translates to:
  /// **'表示設定'**
  String get displaySection;

  /// No description provided for @appInfoSection.
  ///
  /// In ja, this message translates to:
  /// **'アプリ情報'**
  String get appInfoSection;

  /// No description provided for @legalSection.
  ///
  /// In ja, this message translates to:
  /// **'法的情報'**
  String get legalSection;

  /// No description provided for @languageSection.
  ///
  /// In ja, this message translates to:
  /// **'言語設定'**
  String get languageSection;

  /// No description provided for @voiceAlert.
  ///
  /// In ja, this message translates to:
  /// **'音声警告'**
  String get voiceAlert;

  /// No description provided for @voiceAlertDesc.
  ///
  /// In ja, this message translates to:
  /// **'一時停止・信号機の音声案内'**
  String get voiceAlertDesc;

  /// No description provided for @vibrationAlert.
  ///
  /// In ja, this message translates to:
  /// **'バイブレーション'**
  String get vibrationAlert;

  /// No description provided for @vibrationAlertDesc.
  ///
  /// In ja, this message translates to:
  /// **'警告時のバイブレーション'**
  String get vibrationAlertDesc;

  /// No description provided for @alertDistance.
  ///
  /// In ja, this message translates to:
  /// **'警告距離'**
  String get alertDistance;

  /// No description provided for @darkMap.
  ///
  /// In ja, this message translates to:
  /// **'ダークマップ'**
  String get darkMap;

  /// No description provided for @darkMapDesc.
  ///
  /// In ja, this message translates to:
  /// **'暗い地図テーマを使用'**
  String get darkMapDesc;

  /// No description provided for @languageSetting.
  ///
  /// In ja, this message translates to:
  /// **'言語'**
  String get languageSetting;

  /// No description provided for @languageSettingDesc.
  ///
  /// In ja, this message translates to:
  /// **'アプリの表示言語を変更'**
  String get languageSettingDesc;

  /// No description provided for @languageJapanese.
  ///
  /// In ja, this message translates to:
  /// **'日本語'**
  String get languageJapanese;

  /// No description provided for @languageEnglish.
  ///
  /// In ja, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @aboutApp.
  ///
  /// In ja, this message translates to:
  /// **'アプリについて'**
  String get aboutApp;

  /// No description provided for @aboutAppDesc.
  ///
  /// In ja, this message translates to:
  /// **'CHARI-PI（チャリッピー） - 自転車安全ナビ'**
  String get aboutAppDesc;

  /// No description provided for @appVersion.
  ///
  /// In ja, this message translates to:
  /// **'バージョン'**
  String get appVersion;

  /// No description provided for @aboutDialogContent.
  ///
  /// In ja, this message translates to:
  /// **'CHARI-PI（チャリッピー）は自転車走行時の安全を支援するナビゲーションアプリです。\n\nOpenStreetMapのデータを活用し、一時停止標識や信号機の位置をリアルタイムで通知します。\n\n安全な自転車ライフのために、ぜひご活用ください。'**
  String get aboutDialogContent;

  /// No description provided for @privacyPolicy.
  ///
  /// In ja, this message translates to:
  /// **'プライバシーポリシー'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyDesc.
  ///
  /// In ja, this message translates to:
  /// **'個人情報・位置情報の取り扱いについて'**
  String get privacyPolicyDesc;

  /// No description provided for @securityPolicy.
  ///
  /// In ja, this message translates to:
  /// **'セキュリティポリシー'**
  String get securityPolicy;

  /// No description provided for @securityPolicyDesc.
  ///
  /// In ja, this message translates to:
  /// **'情報セキュリティの管理体制について'**
  String get securityPolicyDesc;

  /// No description provided for @termsOfService.
  ///
  /// In ja, this message translates to:
  /// **'利用規約'**
  String get termsOfService;

  /// No description provided for @termsOfServiceDesc.
  ///
  /// In ja, this message translates to:
  /// **'サービスのご利用条件'**
  String get termsOfServiceDesc;

  /// No description provided for @disclaimer.
  ///
  /// In ja, this message translates to:
  /// **'免責事項'**
  String get disclaimer;

  /// No description provided for @disclaimerDesc.
  ///
  /// In ja, this message translates to:
  /// **'サービスに関する免責事項'**
  String get disclaimerDesc;

  /// No description provided for @commercialLaw.
  ///
  /// In ja, this message translates to:
  /// **'特定商取引法に基づく表記'**
  String get commercialLaw;

  /// No description provided for @commercialLawDesc.
  ///
  /// In ja, this message translates to:
  /// **'事業者情報・販売条件'**
  String get commercialLawDesc;

  /// No description provided for @operatingCompany.
  ///
  /// In ja, this message translates to:
  /// **'運営会社'**
  String get operatingCompany;

  /// No description provided for @companyName.
  ///
  /// In ja, this message translates to:
  /// **'株式会社TCI'**
  String get companyName;

  /// No description provided for @companyAddress.
  ///
  /// In ja, this message translates to:
  /// **'大阪府大阪市淀川区新高1-5-4'**
  String get companyAddress;

  /// No description provided for @planUpgrade.
  ///
  /// In ja, this message translates to:
  /// **'アップグレード'**
  String get planUpgrade;

  /// No description provided for @planChange.
  ///
  /// In ja, this message translates to:
  /// **'変更'**
  String get planChange;

  /// No description provided for @planUpgradePrompt.
  ///
  /// In ja, this message translates to:
  /// **'プランをアップグレードして安全を守ろう'**
  String get planUpgradePrompt;

  /// No description provided for @planFreeWithWatch.
  ///
  /// In ja, this message translates to:
  /// **'無料 · GPS見守り機能有効'**
  String get planFreeWithWatch;

  /// No description provided for @familySafety.
  ///
  /// In ja, this message translates to:
  /// **'ファミリーセーフティ'**
  String get familySafety;

  /// No description provided for @familyPrompt.
  ///
  /// In ja, this message translates to:
  /// **'家族や組織で安全を見守る'**
  String get familyPrompt;

  /// No description provided for @corporateSafety.
  ///
  /// In ja, this message translates to:
  /// **'法人安全管理'**
  String get corporateSafety;

  /// No description provided for @gpsWatchFree.
  ///
  /// In ja, this message translates to:
  /// **'GPS見守り（無料）'**
  String get gpsWatchFree;

  /// No description provided for @adminMode.
  ///
  /// In ja, this message translates to:
  /// **'管理者モード'**
  String get adminMode;

  /// No description provided for @employeeMode.
  ///
  /// In ja, this message translates to:
  /// **'従業員モード'**
  String get employeeMode;

  /// No description provided for @watchingMode.
  ///
  /// In ja, this message translates to:
  /// **'GPS見守り中'**
  String get watchingMode;

  /// No description provided for @sharingGps.
  ///
  /// In ja, this message translates to:
  /// **'GPS共有中'**
  String get sharingGps;

  /// No description provided for @parentMode.
  ///
  /// In ja, this message translates to:
  /// **'保護者モード'**
  String get parentMode;

  /// No description provided for @childMode.
  ///
  /// In ja, this message translates to:
  /// **'子供モード'**
  String get childMode;

  /// No description provided for @membersCount.
  ///
  /// In ja, this message translates to:
  /// **'{count}人の従業員'**
  String membersCount(int count);

  /// No description provided for @childrenCount.
  ///
  /// In ja, this message translates to:
  /// **'{count}人のお子さま'**
  String childrenCount(int count);

  /// No description provided for @watchingPerson.
  ///
  /// In ja, this message translates to:
  /// **'GPS見守り中 · {name}さん'**
  String watchingPerson(String name);

  /// No description provided for @beingWatched.
  ///
  /// In ja, this message translates to:
  /// **'GPS共有中 · 見守られています'**
  String get beingWatched;

  /// No description provided for @gpsWaiting.
  ///
  /// In ja, this message translates to:
  /// **'GPS待機中'**
  String get gpsWaiting;

  /// No description provided for @gpsHigh.
  ///
  /// In ja, this message translates to:
  /// **'高精度'**
  String get gpsHigh;

  /// No description provided for @gpsMedium.
  ///
  /// In ja, this message translates to:
  /// **'中精度'**
  String get gpsMedium;

  /// No description provided for @gpsLow.
  ///
  /// In ja, this message translates to:
  /// **'低精度'**
  String get gpsLow;

  /// No description provided for @termsContentFull.
  ///
  /// In ja, this message translates to:
  /// **'CHARI-PI（チャリッピー）をご利用いただきありがとうございます。\n\n本アプリは、自転車走行時の交通安全を支援するナビゲーションツールです。\n\n【免責事項】\n- 本アプリは交通安全の補助ツールであり、運転者の注意義務を免除するものではありません。\n- GPS精度や地図データの正確性は保証いたしかねます。\n- 走行中は周囲の安全確認を最優先してください。\n- 本アプリの使用により発生した事故等について、開発者は一切の責任を負いません。\n\n【学習コンテンツについて】\n- 本アプリの交通ルール学習コンテンツは、警察庁自転車ポータルサイト及びe-Gov法令検索の公的資料に基づいています。\n- コンテンツは公的資料に基づいていますが、最新の法令は各自でご確認ください。\n- 法的助言を目的としたものではありません。\n- 法改正があった場合、コンテンツの更新に時間がかかる場合があります。\n\n【出典】\n- 警察庁 自転車ポータルサイト: https://www.npa.go.jp/bureau/traffic/bicycle/portal/\n- e-Gov 法令検索: https://laws.e-gov.go.jp/\n- 政府広報オンライン: https://www.gov-online.go.jp/\n\n【位置情報について】\n- 本アプリはGPS位置情報を使用します。\n- 位置情報はデバイス内のみで処理され、外部サーバーには送信されません。\n\n【データの取り扱い】\n- 走行履歴はデバイス内にのみ保存されます。\n- 学習コンテンツはサーバーから取得し、ローカルにキャッシュされます。\n- OpenStreetMapのデータを利用して交通標識の位置を取得します。'**
  String get termsContentFull;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'en',
    'fil',
    'ja',
    'ko',
    'th',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return L10nEn();
    case 'fil':
      return L10nFil();
    case 'ja':
      return L10nJa();
    case 'ko':
      return L10nKo();
    case 'th':
      return L10nTh();
    case 'vi':
      return L10nVi();
    case 'zh':
      return L10nZh();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
