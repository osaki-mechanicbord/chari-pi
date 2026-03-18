// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class L10nZh extends L10n {
  L10nZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'CHARI-PI';

  @override
  String get appTagline => '骑行安全导航';

  @override
  String get navMap => '导航';

  @override
  String get navLearn => '学习';

  @override
  String get navQuiz => '测验';

  @override
  String get navLaw => '法规';

  @override
  String get navLog => '记录';

  @override
  String get navSettings => '设置';

  @override
  String get splashSubtitle => '骑行安全导航';

  @override
  String get loading => '加载中...';

  @override
  String get termsTitle => '使用条款';

  @override
  String get agreeAndContinue => '同意并继续';

  @override
  String get startTitle => '开始骑行吧！';

  @override
  String get startButton => '开始导航';

  @override
  String get locationPermissionRequired => '需要位置权限';

  @override
  String get featureSafety => '安全';

  @override
  String get featureSafetyDesc => '实时警告';

  @override
  String get featureMap => '地图';

  @override
  String get featureMapDesc => 'OSM连接';

  @override
  String get featureLearn => '学习';

  @override
  String get featureLearnDesc => '交通规则';

  @override
  String get gpsSearching => '搜索GPS中...';

  @override
  String get gpsAccuracy => 'GPS精度';

  @override
  String get stopSignAhead => '前方有停车标志';

  @override
  String get trafficSignalAhead => '前方有信号灯';

  @override
  String get onewayWarning => '单行道注意';

  @override
  String get metersAhead => '米前方';

  @override
  String get demoMode => '演示';

  @override
  String get demoModeButton => '演示模式';

  @override
  String get gpsUnavailableTitle => '未找到GPS';

  @override
  String get gpsUnavailableMessage =>
      '无法获取GPS位置信息。\n\n・请检查浏览器位置权限\n・请开启位置服务\n\n可以尝试演示模式。';

  @override
  String get closeButton => '关闭';

  @override
  String get startWithDemo => '开始演示';

  @override
  String get warningCountUnit => '次';

  @override
  String warningMessageFormat(int distance, String type) {
    return '前方$distance米有$type';
  }

  @override
  String get nodeStopSign => '停车标志';

  @override
  String get nodeTrafficSignal => '信号灯';

  @override
  String get nodeOneway => '单行道';

  @override
  String get nodeWrongWay => '逆行警告';

  @override
  String get nodePedestrianRoad => '行人专用道路';

  @override
  String get nodeFootway => '人行道';

  @override
  String get nodeFootwayNoBicycle => '禁止骑行人行道';

  @override
  String get nodeCycleway => '自行车专用道';

  @override
  String get nodeCrossing => '人行横道';

  @override
  String get nodeNoBicycle => '禁止自行车通行';

  @override
  String get nodeDismount => '推行区间';

  @override
  String get nodeSpeedLimit => '限速';

  @override
  String get nodeAccidentZone => '事故多发地点';

  @override
  String get nodeEnforcementZone => '执法重点区域';

  @override
  String get penaltyWrongWay => '逆行：最高3个月以下有期徒刑或5万日元以下罚款';

  @override
  String get penaltyNoBicycle => '禁止通行违规：最高5万日元以下罚款';

  @override
  String get penaltyStopSign => '闯停车标志：蓝色罚单对象';

  @override
  String get penaltyEnforcement => '交通执法重点区域';

  @override
  String get logTitle => '骑行记录';

  @override
  String get noHistory => '暂无骑行记录';

  @override
  String get totalDistance => '总距离';

  @override
  String get duration => '骑行时间';

  @override
  String get warningsLabel => '警告次数';

  @override
  String get rideCount => '骑行次数';

  @override
  String get deleteHistory => '删除记录';

  @override
  String get deleteHistoryConfirm => '要删除所有骑行记录吗？';

  @override
  String get cancelButton => '取消';

  @override
  String get deleteButton => '删除';

  @override
  String get startNavPrompt => '开始导航来记录骑行';

  @override
  String get learnTitle => '交通规则学习';

  @override
  String get offlineLabel => '离线';

  @override
  String get refreshTooltip => '刷新数据';

  @override
  String get allCategories => '全部';

  @override
  String get sourceLabel => '来源：日本警察厅·e-Gov法令检索';

  @override
  String rulesCountFormat(int count) {
    return '$count条交通规则';
  }

  @override
  String get loadingContent => '加载内容中...';

  @override
  String get retryButton => '重试';

  @override
  String get noMatchingRules => '没有匹配的规则';

  @override
  String get catBasic => '基本规则';

  @override
  String get catIntersection => '路口·信号';

  @override
  String get catRoad => '道路行驶';

  @override
  String get catEquipment => '装备·车辆';

  @override
  String get catProhibition => '禁止事项';

  @override
  String get catSafety => '安全对策';

  @override
  String get catInsurance => '保险';

  @override
  String get catNewLaw => '新制度';

  @override
  String get catRegistration => '登记';

  @override
  String get quizTitle => '交通规则测验';

  @override
  String get quizCorrect => '正确！';

  @override
  String get quizIncorrect => '不正确...';

  @override
  String get quizScore => '得分';

  @override
  String get quizNext => '下一题';

  @override
  String get quizFinish => '查看结果';

  @override
  String get quizResult => '测验结果';

  @override
  String get quizRetry => '再来一次';

  @override
  String get quizStart => '开始测验';

  @override
  String get quizTotal => '合计';

  @override
  String get quizEasy => '初级';

  @override
  String get quizMedium => '中级';

  @override
  String get quizHard => '高级';

  @override
  String get quizAllLevels => '全部级别';

  @override
  String get quizDifficulty => '难度';

  @override
  String get quizQuestionCount => '出题数';

  @override
  String get quizQuestionUnit => '题';

  @override
  String get quizNoQuestions => '未找到测验';

  @override
  String quizQuestionProgress(int current, int total) {
    return '第$current题 / 共$total题';
  }

  @override
  String quizScoreResult(int score, int total) {
    return '$score / $total 题正确';
  }

  @override
  String get quizGreatMessage => '太棒了！你很好地理解了交通规则。';

  @override
  String get quizTryAgainMessage => '再加把劲！\n再复习一下交通规则吧。';

  @override
  String get quizSourceNote => '来源：道路交通法·警察厅自行车门户网站\n内容基于官方资料，请自行确认最新法规。';

  @override
  String get lawUpdatesTitle => '法规更新';

  @override
  String get lawUpdatesInfo => '自行车相关法规变更·新制度最新信息';

  @override
  String get lawNoUpdates => '暂无法规更新信息';

  @override
  String get lawUpcoming => '即将施行';

  @override
  String get lawEnacted => '已施行';

  @override
  String lawEffectiveDate(String date) {
    return '施行日：$date';
  }

  @override
  String get lawCheckSource => '查看来源';

  @override
  String get settingsTitle => '设置';

  @override
  String get planSection => '方案';

  @override
  String get alertSection => '警报设置';

  @override
  String get displaySection => '显示设置';

  @override
  String get appInfoSection => '应用信息';

  @override
  String get legalSection => '法律信息';

  @override
  String get languageSection => '语言设置';

  @override
  String get voiceAlert => '语音警报';

  @override
  String get voiceAlertDesc => '停车标志·信号灯语音提示';

  @override
  String get vibrationAlert => '振动';

  @override
  String get vibrationAlertDesc => '警告时的振动提示';

  @override
  String get alertDistance => '警告距离';

  @override
  String get darkMap => '暗色地图';

  @override
  String get darkMapDesc => '使用暗色地图主题';

  @override
  String get languageSetting => '语言';

  @override
  String get languageSettingDesc => '更改应用显示语言';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageEnglish => 'English';

  @override
  String get aboutApp => '关于应用';

  @override
  String get aboutAppDesc => 'CHARI-PI - 骑行安全导航';

  @override
  String get appVersion => '版本';

  @override
  String get aboutDialogContent =>
      'CHARI-PI是一款支持骑行安全的导航应用。\n\n利用OpenStreetMap数据，实时通知停车标志和信号灯的位置。\n\n为了安全的骑行生活，请善加利用。';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get privacyPolicyDesc => '个人信息·位置信息的处理';

  @override
  String get securityPolicy => '安全政策';

  @override
  String get securityPolicyDesc => '信息安全管理体制';

  @override
  String get termsOfService => '使用条款';

  @override
  String get termsOfServiceDesc => '服务使用条件';

  @override
  String get disclaimer => '免责声明';

  @override
  String get disclaimerDesc => '服务相关免责声明';

  @override
  String get commercialLaw => '特定商业交易法公示';

  @override
  String get commercialLawDesc => '经营者信息·销售条件';

  @override
  String get operatingCompany => '运营公司';

  @override
  String get companyName => 'TCI株式会社';

  @override
  String get companyAddress => '日本大阪市淀川区新高1-5-4';

  @override
  String get planUpgrade => '升级';

  @override
  String get planChange => '更改';

  @override
  String get planUpgradePrompt => '升级方案提升安全保障';

  @override
  String get planFreeWithWatch => '免费 · GPS守护功能已启用';

  @override
  String get familySafety => '家庭安全';

  @override
  String get familyPrompt => '守护家人和组织的安全';

  @override
  String get corporateSafety => '企业安全管理';

  @override
  String get gpsWatchFree => 'GPS守护（免费）';

  @override
  String get adminMode => '管理员模式';

  @override
  String get employeeMode => '员工模式';

  @override
  String get watchingMode => 'GPS守护中';

  @override
  String get sharingGps => 'GPS共享中';

  @override
  String get parentMode => '家长模式';

  @override
  String get childMode => '儿童模式';

  @override
  String membersCount(int count) {
    return '$count名员工';
  }

  @override
  String childrenCount(int count) {
    return '$count名儿童';
  }

  @override
  String watchingPerson(String name) {
    return 'GPS守护中 · $name';
  }

  @override
  String get beingWatched => 'GPS共享中 · 被守护中';

  @override
  String get gpsWaiting => 'GPS待机中';

  @override
  String get gpsHigh => '高精度';

  @override
  String get gpsMedium => '中精度';

  @override
  String get gpsLow => '低精度';

  @override
  String get termsContentFull =>
      '感谢您使用CHARI-PI。\n\n本应用是支持骑行时交通安全的导航工具。\n\n【免责声明】\n- 本应用为交通安全辅助工具，不免除骑行者的注意义务。\n- 不保证GPS精度和地图数据的准确性。\n- 骑行时请以周围安全确认为最优先。\n- 对于使用本应用导致的事故，开发者不承担任何责任。';
}
