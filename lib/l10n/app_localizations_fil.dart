// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Filipino Pilipino (`fil`).
class L10nFil extends L10n {
  L10nFil([String locale = 'fil']) : super(locale);

  @override
  String get appName => 'CHARI-PI';

  @override
  String get appTagline => 'Ang Iyong Cycling Safety Navigator';

  @override
  String get navMap => 'Mapa';

  @override
  String get navLearn => 'Matuto';

  @override
  String get navQuiz => 'Pagsusulit';

  @override
  String get navLaw => 'Batas';

  @override
  String get navLog => 'Kasaysayan';

  @override
  String get navSettings => 'Settings';

  @override
  String get splashSubtitle => 'Cycling Safety Navigator';

  @override
  String get loading => 'Naglo-load...';

  @override
  String get termsTitle => 'Mga Tuntunin ng Paggamit';

  @override
  String get agreeAndContinue => 'Sumang-ayon at Magpatuloy';

  @override
  String get startTitle => 'Simulan ang pagsakay';

  @override
  String get startButton => 'Simulan';

  @override
  String get locationPermissionRequired => 'Kailangan ang location permission';

  @override
  String get featureSafety => 'Kaligtasan';

  @override
  String get featureSafetyDesc => 'Real-time na alerto';

  @override
  String get featureMap => 'Mapa';

  @override
  String get featureMapDesc => 'OSM powered';

  @override
  String get featureLearn => 'Matuto';

  @override
  String get featureLearnDesc => 'Mga batas trapiko';

  @override
  String get gpsSearching => 'Naghahanap ng GPS...';

  @override
  String get gpsAccuracy => 'GPS Accuracy';

  @override
  String get stopSignAhead => 'Stop sign sa harap';

  @override
  String get trafficSignalAhead => 'Traffic signal sa harap';

  @override
  String get onewayWarning => 'Pag-iingat sa one-way';

  @override
  String get metersAhead => 'm sa harap';

  @override
  String get demoMode => 'Demo';

  @override
  String get demoModeButton => 'Demo Mode';

  @override
  String get gpsUnavailableTitle => 'Hindi nahanap ang GPS';

  @override
  String get gpsUnavailableMessage =>
      'Hindi makuha ang GPS location.\n\n• Suriin ang browser location permissions\n• I-on ang location services\n\nMaaari mong subukan ang Demo Mode.';

  @override
  String get closeButton => 'Isara';

  @override
  String get startWithDemo => 'Simulan ang Demo';

  @override
  String get warningCountUnit => '';

  @override
  String warningMessageFormat(int distance, String type) {
    return '$type sa ${distance}m';
  }

  @override
  String get nodeStopSign => 'Stop sign';

  @override
  String get nodeTrafficSignal => 'Traffic signal';

  @override
  String get nodeOneway => 'One-way';

  @override
  String get nodeWrongWay => 'Maling daan';

  @override
  String get nodePedestrianRoad => 'Pedestrian zone';

  @override
  String get nodeFootway => 'Sidewalk';

  @override
  String get nodeFootwayNoBicycle => 'Bawal bisikleta sa sidewalk';

  @override
  String get nodeCycleway => 'Bicycle lane';

  @override
  String get nodeCrossing => 'Crosswalk';

  @override
  String get nodeNoBicycle => 'Bawal bisikleta';

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
      'Maling daan: hanggang 3 buwang pagkakulong o 50,000 yen multa';

  @override
  String get penaltyNoBicycle =>
      'Paglabag sa no-entry: hanggang 50,000 yen multa';

  @override
  String get penaltyStopSign => 'Paglabag sa stop sign: blue ticket';

  @override
  String get penaltyEnforcement => 'Traffic enforcement area';

  @override
  String get logTitle => 'Kasaysayan ng Pagsakay';

  @override
  String get noHistory => 'Walang kasaysayan';

  @override
  String get totalDistance => 'Kabuuang Distansya';

  @override
  String get duration => 'Tagal';

  @override
  String get warningsLabel => 'Mga Babala';

  @override
  String get rideCount => 'Mga Sakay';

  @override
  String get deleteHistory => 'Burahin ang Kasaysayan';

  @override
  String get deleteHistoryConfirm => 'Burahin lahat ng kasaysayan?';

  @override
  String get cancelButton => 'Kanselahin';

  @override
  String get deleteButton => 'Burahin';

  @override
  String get startNavPrompt => 'Simulan ang navigation para i-record ang ride';

  @override
  String get learnTitle => 'Mga Batas Trapiko';

  @override
  String get offlineLabel => 'Offline';

  @override
  String get refreshTooltip => 'I-refresh ang data';

  @override
  String get allCategories => 'Lahat';

  @override
  String get sourceLabel => 'Pinagmulan: National Police Agency / e-Gov';

  @override
  String rulesCountFormat(int count) {
    return '$count na batas trapiko';
  }

  @override
  String get loadingContent => 'Naglo-load ng content...';

  @override
  String get retryButton => 'Subukan muli';

  @override
  String get noMatchingRules => 'Walang nahanap na batas';

  @override
  String get catBasic => 'Pangunahing Batas';

  @override
  String get catIntersection => 'Mga Intersection';

  @override
  String get catRoad => 'Pagmamaneho sa Daan';

  @override
  String get catEquipment => 'Kagamitan';

  @override
  String get catProhibition => 'Ipinagbabawal';

  @override
  String get catSafety => 'Kaligtasan';

  @override
  String get catInsurance => 'Insurance';

  @override
  String get catNewLaw => 'Bagong Batas';

  @override
  String get catRegistration => 'Pagpaparehistro';

  @override
  String get quizTitle => 'Quiz sa Batas Trapiko';

  @override
  String get quizCorrect => 'Tama!';

  @override
  String get quizIncorrect => 'Mali...';

  @override
  String get quizScore => 'Iskor';

  @override
  String get quizNext => 'Susunod na Tanong';

  @override
  String get quizFinish => 'Tingnan ang Resulta';

  @override
  String get quizResult => 'Resulta ng Quiz';

  @override
  String get quizRetry => 'Subukan Muli';

  @override
  String get quizStart => 'Simulan ang Quiz';

  @override
  String get quizTotal => 'Kabuuan';

  @override
  String get quizEasy => 'Madali';

  @override
  String get quizMedium => 'Katamtaman';

  @override
  String get quizHard => 'Mahirap';

  @override
  String get quizAllLevels => 'Lahat ng Level';

  @override
  String get quizDifficulty => 'Kahirapan';

  @override
  String get quizQuestionCount => 'Mga Tanong';

  @override
  String get quizQuestionUnit => 'tanong';

  @override
  String get quizNoQuestions => 'Walang nahanap na quiz';

  @override
  String quizQuestionProgress(int current, int total) {
    return 'Tanong $current / $total';
  }

  @override
  String quizScoreResult(int score, int total) {
    return '$score / $total ang tama';
  }

  @override
  String get quizGreatMessage =>
      'Magaling! Mahusay ang kaalaman mo sa batas trapiko.';

  @override
  String get quizTryAgainMessage =>
      'Subukan muli!\nRebyuhin ang mga batas trapiko.';

  @override
  String get quizSourceNote =>
      'Pinagmulan: Road Traffic Act / National Police Agency Bicycle Portal\nAng content ay batay sa opisyal na pinagmulan. Suriin ang pinakabagong batas.';

  @override
  String get lawUpdatesTitle => 'Mga Update sa Batas';

  @override
  String get lawUpdatesInfo => 'Pinakabagong pagbabago sa batas ng bisikleta';

  @override
  String get lawNoUpdates => 'Wala pang update';

  @override
  String get lawUpcoming => 'Paparating';

  @override
  String get lawEnacted => 'Ipinatupad na';

  @override
  String lawEffectiveDate(String date) {
    return 'Epektibo: $date';
  }

  @override
  String get lawCheckSource => 'Suriin ang pinagmulan';

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
  String get languageSection => 'Wika';

  @override
  String get voiceAlert => 'Voice Alert';

  @override
  String get voiceAlertDesc => 'Audio alert para sa stop sign at signal';

  @override
  String get vibrationAlert => 'Vibration';

  @override
  String get vibrationAlertDesc => 'Mag-vibrate sa mga babala';

  @override
  String get alertDistance => 'Alert Distance';

  @override
  String get darkMap => 'Dark Map';

  @override
  String get darkMapDesc => 'Gamitin ang dark map theme';

  @override
  String get languageSetting => 'Wika';

  @override
  String get languageSettingDesc => 'Palitan ang display language ng app';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageEnglish => 'English';

  @override
  String get aboutApp => 'Tungkol Sa';

  @override
  String get aboutAppDesc => 'CHARI-PI - Cycling Safety Navigator';

  @override
  String get appVersion => 'Version';

  @override
  String get aboutDialogContent =>
      'Ang CHARI-PI ay isang navigation app na sumusuporta sa cycling safety.\n\nGumagamit ng OpenStreetMap data para magbigay ng real-time na notification para sa stop sign at traffic signal.\n\nMagbisikleta nang ligtas kasama ang CHARI-PI!';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyDesc =>
      'Paano namin pinangangasiwaan ang personal at location data';

  @override
  String get securityPolicy => 'Security Policy';

  @override
  String get securityPolicyDesc => 'Information security management';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get termsOfServiceDesc => 'Mga kondisyon ng paggamit ng serbisyo';

  @override
  String get disclaimer => 'Disclaimer';

  @override
  String get disclaimerDesc => 'Mga disclaimer ng serbisyo';

  @override
  String get commercialLaw => 'Commercial Transaction Act';

  @override
  String get commercialLawDesc => 'Business info at sales conditions';

  @override
  String get operatingCompany => 'Operator';

  @override
  String get companyName => 'TCI Corporation';

  @override
  String get companyAddress => 'Shintaka 1-5-4, Yodogawa-ku, Osaka, Japan';

  @override
  String get planUpgrade => 'I-upgrade';

  @override
  String get planChange => 'Palitan';

  @override
  String get planUpgradePrompt =>
      'I-upgrade ang plan para sa mas mabuting kaligtasan';

  @override
  String get planFreeWithWatch => 'Libre · GPS Tracking enabled';

  @override
  String get familySafety => 'Family Safety';

  @override
  String get familyPrompt => 'Pangalagaan ang pamilya at team';

  @override
  String get corporateSafety => 'Corporate Safety';

  @override
  String get gpsWatchFree => 'GPS Tracking (Libre)';

  @override
  String get adminMode => 'Admin Mode';

  @override
  String get employeeMode => 'Employee Mode';

  @override
  String get watchingMode => 'GPS Tracking aktibo';

  @override
  String get sharingGps => 'Nagsheshare ng GPS';

  @override
  String get parentMode => 'Parent Mode';

  @override
  String get childMode => 'Child Mode';

  @override
  String membersCount(int count) {
    return '$count empleyado';
  }

  @override
  String childrenCount(int count) {
    return '$count anak';
  }

  @override
  String watchingPerson(String name) {
    return 'GPS tracking · $name';
  }

  @override
  String get beingWatched => 'Nagsheshare ng GPS · Binabantayan';

  @override
  String get gpsWaiting => 'GPS Standby';

  @override
  String get gpsHigh => 'Mataas';

  @override
  String get gpsMedium => 'Katamtaman';

  @override
  String get gpsLow => 'Mababa';

  @override
  String get termsContentFull =>
      'Salamat sa paggamit ng CHARI-PI.\n\nAng app na ito ay isang navigation tool para suportahan ang traffic safety habang nagbibisikleta.\n\n[Disclaimer]\n- Ang app na ito ay supplementary tool at hindi nagpapalaya sa rider sa duty of care.\n- Hindi ginagarantiya ang GPS at map data accuracy.\n- Palaging unahin ang safety awareness habang nagmamaneho.\n- Hindi mananagot ang developer sa mga aksidente.\n\n[Learning Content]\n- Ang traffic rule content ay batay sa opisyal na resources.\n- Suriin ang pinakabagong batas.\n\n[Location Data]\n- Gumagamit ang app ng GPS.\n- Ang location data ay on-device lamang.';
}
