// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'CHARI-PI';

  @override
  String get appTagline => 'Your Cycling Safety Navigator';

  @override
  String get navMap => 'Navi';

  @override
  String get navLearn => 'Learn';

  @override
  String get navQuiz => 'Quiz';

  @override
  String get navLaw => 'Laws';

  @override
  String get navLog => 'Log';

  @override
  String get navSettings => 'Settings';

  @override
  String get splashSubtitle => 'Cycling Safety Navigator';

  @override
  String get loading => 'Loading...';

  @override
  String get termsTitle => 'Terms of Use';

  @override
  String get agreeAndContinue => 'Agree & Continue';

  @override
  String get startTitle => 'Let\'s start riding';

  @override
  String get startButton => 'Start Navi';

  @override
  String get locationPermissionRequired => 'Location permission required';

  @override
  String get featureSafety => 'Safety';

  @override
  String get featureSafetyDesc => 'Real-time alerts';

  @override
  String get featureMap => 'Map';

  @override
  String get featureMapDesc => 'OSM powered';

  @override
  String get featureLearn => 'Learn';

  @override
  String get featureLearnDesc => 'Traffic rules';

  @override
  String get gpsSearching => 'Searching GPS...';

  @override
  String get gpsAccuracy => 'GPS Accuracy';

  @override
  String get stopSignAhead => 'Stop sign ahead';

  @override
  String get trafficSignalAhead => 'Traffic signal ahead';

  @override
  String get onewayWarning => 'One-way caution';

  @override
  String get metersAhead => 'm ahead';

  @override
  String get demoMode => 'Demo';

  @override
  String get demoModeButton => 'Demo Mode';

  @override
  String get gpsUnavailableTitle => 'GPS Not Found';

  @override
  String get gpsUnavailableMessage =>
      'Cannot acquire GPS location.\n\n• Check browser location permissions\n• Turn on location services\n\nYou can try Demo Mode.';

  @override
  String get closeButton => 'Close';

  @override
  String get startWithDemo => 'Start Demo';

  @override
  String get warningCountUnit => '';

  @override
  String warningMessageFormat(int distance, String type) {
    return '$type in ${distance}m';
  }

  @override
  String get nodeStopSign => 'Stop sign';

  @override
  String get nodeTrafficSignal => 'Traffic signal';

  @override
  String get nodeOneway => 'One-way';

  @override
  String get nodeWrongWay => 'Wrong way';

  @override
  String get nodePedestrianRoad => 'Pedestrian zone';

  @override
  String get nodeFootway => 'Sidewalk';

  @override
  String get nodeFootwayNoBicycle => 'No-cycling sidewalk';

  @override
  String get nodeCycleway => 'Cycle lane';

  @override
  String get nodeCrossing => 'Crosswalk';

  @override
  String get nodeNoBicycle => 'No cycling';

  @override
  String get nodeDismount => 'Dismount zone';

  @override
  String get nodeSpeedLimit => 'Speed limit';

  @override
  String get nodeAccidentZone => 'Accident zone';

  @override
  String get nodeEnforcementZone => 'Enforcement zone';

  @override
  String get penaltyWrongWay =>
      'Wrong-way: up to 3 months imprisonment or 50,000 yen fine';

  @override
  String get penaltyNoBicycle => 'No-entry violation: up to 50,000 yen fine';

  @override
  String get penaltyStopSign => 'Running stop sign: subject to blue ticket';

  @override
  String get penaltyEnforcement => 'Traffic enforcement area';

  @override
  String get logTitle => 'Ride History';

  @override
  String get noHistory => 'No ride history';

  @override
  String get totalDistance => 'Total Distance';

  @override
  String get duration => 'Duration';

  @override
  String get warningsLabel => 'Warnings';

  @override
  String get rideCount => 'Rides';

  @override
  String get deleteHistory => 'Delete History';

  @override
  String get deleteHistoryConfirm => 'Delete all ride history?';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get deleteButton => 'Delete';

  @override
  String get startNavPrompt => 'Start navigation to record your ride';

  @override
  String get learnTitle => 'Traffic Rules';

  @override
  String get offlineLabel => 'Offline';

  @override
  String get refreshTooltip => 'Refresh data';

  @override
  String get allCategories => 'All';

  @override
  String get sourceLabel => 'Source: National Police Agency / e-Gov';

  @override
  String rulesCountFormat(int count) {
    return '$count traffic rules';
  }

  @override
  String get loadingContent => 'Loading content...';

  @override
  String get retryButton => 'Retry';

  @override
  String get noMatchingRules => 'No matching rules';

  @override
  String get catBasic => 'Basic Rules';

  @override
  String get catIntersection => 'Intersections';

  @override
  String get catRoad => 'Road Riding';

  @override
  String get catEquipment => 'Equipment';

  @override
  String get catProhibition => 'Prohibited';

  @override
  String get catSafety => 'Safety';

  @override
  String get catInsurance => 'Insurance';

  @override
  String get catNewLaw => 'New Laws';

  @override
  String get catRegistration => 'Registration';

  @override
  String get quizTitle => 'Traffic Rules Quiz';

  @override
  String get quizCorrect => 'Correct!';

  @override
  String get quizIncorrect => 'Incorrect...';

  @override
  String get quizScore => 'Score';

  @override
  String get quizNext => 'Next Question';

  @override
  String get quizFinish => 'See Results';

  @override
  String get quizResult => 'Quiz Result';

  @override
  String get quizRetry => 'Try Again';

  @override
  String get quizStart => 'Start Quiz';

  @override
  String get quizTotal => 'Total';

  @override
  String get quizEasy => 'Easy';

  @override
  String get quizMedium => 'Medium';

  @override
  String get quizHard => 'Hard';

  @override
  String get quizAllLevels => 'All Levels';

  @override
  String get quizDifficulty => 'Difficulty';

  @override
  String get quizQuestionCount => 'Questions';

  @override
  String get quizQuestionUnit => 'Q';

  @override
  String get quizNoQuestions => 'No quizzes found';

  @override
  String quizQuestionProgress(int current, int total) {
    return 'Q$current / $total';
  }

  @override
  String quizScoreResult(int score, int total) {
    return '$score / $total correct';
  }

  @override
  String get quizGreatMessage =>
      'Excellent! You understand traffic rules well.';

  @override
  String get quizTryAgainMessage =>
      'Keep trying!\nReview the traffic rules once more.';

  @override
  String get quizSourceNote =>
      'Source: Road Traffic Act / National Police Agency Bicycle Portal\nContent is based on official sources. Please verify with the latest laws.';

  @override
  String get lawUpdatesTitle => 'Law Updates';

  @override
  String get lawUpdatesInfo => 'Latest bicycle law changes and new regulations';

  @override
  String get lawNoUpdates => 'No law updates yet';

  @override
  String get lawUpcoming => 'Upcoming';

  @override
  String get lawEnacted => 'Enacted';

  @override
  String lawEffectiveDate(String date) {
    return 'Effective: $date';
  }

  @override
  String get lawCheckSource => 'Check source';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get planSection => 'Plan';

  @override
  String get alertSection => 'Alert Settings';

  @override
  String get displaySection => 'Display';

  @override
  String get appInfoSection => 'App Info';

  @override
  String get legalSection => 'Legal';

  @override
  String get languageSection => 'Language';

  @override
  String get voiceAlert => 'Voice Alert';

  @override
  String get voiceAlertDesc => 'Audio alerts for stop signs & signals';

  @override
  String get vibrationAlert => 'Vibration';

  @override
  String get vibrationAlertDesc => 'Vibrate on warnings';

  @override
  String get alertDistance => 'Alert Distance';

  @override
  String get darkMap => 'Dark Map';

  @override
  String get darkMapDesc => 'Use dark map theme';

  @override
  String get languageSetting => 'Language';

  @override
  String get languageSettingDesc => 'Change app display language';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageEnglish => 'English';

  @override
  String get aboutApp => 'About';

  @override
  String get aboutAppDesc => 'CHARI-PI - Cycling Safety Navigator';

  @override
  String get appVersion => 'Version';

  @override
  String get aboutDialogContent =>
      'CHARI-PI is a navigation app that supports cycling safety.\n\nUsing OpenStreetMap data, it provides real-time notifications for stop signs and traffic signals.\n\nRide safely with CHARI-PI!';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyDesc => 'How we handle personal & location data';

  @override
  String get securityPolicy => 'Security Policy';

  @override
  String get securityPolicyDesc => 'Information security management';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get termsOfServiceDesc => 'Service usage conditions';

  @override
  String get disclaimer => 'Disclaimer';

  @override
  String get disclaimerDesc => 'Service disclaimers';

  @override
  String get commercialLaw => 'Commercial Transaction Act';

  @override
  String get commercialLawDesc => 'Business info & sales conditions';

  @override
  String get operatingCompany => 'Operator';

  @override
  String get companyName => 'TCI Corporation';

  @override
  String get companyAddress => 'Shintaka 1-5-4, Yodogawa-ku, Osaka, Japan';

  @override
  String get planUpgrade => 'Upgrade';

  @override
  String get planChange => 'Change';

  @override
  String get planUpgradePrompt => 'Upgrade your plan for better safety';

  @override
  String get planFreeWithWatch => 'Free · GPS Tracking enabled';

  @override
  String get familySafety => 'Family Safety';

  @override
  String get familyPrompt => 'Keep family & team safe';

  @override
  String get corporateSafety => 'Corporate Safety';

  @override
  String get gpsWatchFree => 'GPS Tracking (Free)';

  @override
  String get adminMode => 'Admin Mode';

  @override
  String get employeeMode => 'Employee Mode';

  @override
  String get watchingMode => 'GPS Tracking active';

  @override
  String get sharingGps => 'Sharing GPS';

  @override
  String get parentMode => 'Parent Mode';

  @override
  String get childMode => 'Child Mode';

  @override
  String membersCount(int count) {
    return '$count employees';
  }

  @override
  String childrenCount(int count) {
    return '$count children';
  }

  @override
  String watchingPerson(String name) {
    return 'GPS tracking · $name';
  }

  @override
  String get beingWatched => 'Sharing GPS · Being watched';

  @override
  String get gpsWaiting => 'GPS Standby';

  @override
  String get gpsHigh => 'High';

  @override
  String get gpsMedium => 'Medium';

  @override
  String get gpsLow => 'Low';

  @override
  String get termsContentFull =>
      'Thank you for using CHARI-PI.\n\nThis app is a navigation tool to support traffic safety while cycling.\n\n[Disclaimer]\n- This app is a supplementary tool for traffic safety and does not exempt the rider from duty of care.\n- GPS accuracy and map data accuracy are not guaranteed.\n- Always prioritize safety awareness while riding.\n- The developer assumes no liability for accidents caused by using this app.\n\n[Learning Content]\n- Traffic rule content is based on official resources from the National Police Agency and e-Gov law database.\n- Content is based on public resources, but please verify with the latest laws.\n- Not intended as legal advice.\n- Updates may be delayed after law revisions.\n\n[Sources]\n- National Police Agency Bicycle Portal: https://www.npa.go.jp/bureau/traffic/bicycle/portal/\n- e-Gov Law Search: https://laws.e-gov.go.jp/\n- Government Public Relations: https://www.gov-online.go.jp/\n\n[Location Data]\n- This app uses GPS location data.\n- Location data is processed on-device only and not sent to external servers.\n\n[Data Handling]\n- Ride history is stored locally on device only.\n- Learning content is fetched from servers and cached locally.\n- OpenStreetMap data is used for traffic sign locations.';
}
