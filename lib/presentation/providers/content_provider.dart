import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import '../../data/models/learn_data.dart';
import '../../data/models/quiz_data.dart';
import '../../core/services/content_api_service.dart';

/// コンテンツプロバイダー
/// ローカルデータをベースに、APIからの追加データもマージ
class ContentProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _rules = [];
  List<Map<String, dynamic>> _quizzes = [];
  List<Map<String, dynamic>> _lawUpdates = [];
  Map<String, dynamic> _categories = {};
  bool _isLoading = false;
  String? _error;
  bool _isOffline = false;
  String _localeCode = 'ja';

  List<Map<String, dynamic>> get rules => _rules;
  List<Map<String, dynamic>> get quizzes => _quizzes;
  List<Map<String, dynamic>> get lawUpdates => _lawUpdates;
  Map<String, dynamic> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isOffline => _isOffline;

  static const String _cacheBoxName = 'content_cache';
  static const Duration _cacheExpiry = Duration(hours: 6);

  /// 初期化：ローカルデータを即座にロード → API同期を試行
  Future<void> initialize({String localeCode = 'ja'}) async {
    _localeCode = localeCode;
    _isLoading = true;
    notifyListeners();

    // 1. ローカルデータを即座にロード（これで学習・クイズは必ず表示される）
    _loadLocalData();

    // 2. キャッシュからの追加データロード
    await _loadFromCache();

    // 3. APIからの同期を試行（失敗してもローカルデータがあるので問題なし）
    await _syncFromApi();

    _isLoading = false;
    notifyListeners();
  }

  /// ローカルの静的データをロード（オフラインでも必ず動作）
  void _loadLocalData() {
    // learn_data.dart のデータを Map 形式に変換してロード
    final localRules = LearnData.getContents(_localeCode)
        .map((content) => content.toMap())
        .toList();

    // quiz_data.dart のデータを Map 形式に変換してロード
    final localQuizzes = QuizData.getQuestions(_localeCode)
        .map((question) => question.toMap())
        .toList();

    // ローカルデータをセット（APIデータがなくてもこれで表示可能）
    _rules = localRules;
    _quizzes = localQuizzes;

    // カテゴリ情報を構築
    _categories = _buildCategoriesFromLocalData();

    // 法改正情報（ローカル）
    _lawUpdates = _buildLocalLawUpdates();
  }

  /// ローカルデータからカテゴリ情報を構築
  Map<String, dynamic> _buildCategoriesFromLocalData() {
    return {
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
  }

  /// ローカルの法改正情報
  List<Map<String, dynamic>> _buildLocalLawUpdates() {
    return [
      {
        'title': '自転車の「青切符」制度が開始',
        'summary': '2024年11月1日から自転車にも交通反則通告制度（青切符）が導入。16歳以上が対象で、信号無視6,000円、一時不停止5,000円等の反則金。',
        'date': '2024-11-01',
        'category': 'new_law',
      },
      {
        'title': 'ながらスマホの罰則強化',
        'summary': '自転車のながらスマホに6ヶ月以下の懲役又は10万円以下の罰金。交通危険を生じさせた場合は1年以下の懲役又は30万円以下の罰金。',
        'date': '2024-11-01',
        'category': 'new_law',
      },
      {
        'title': '酒気帯び運転の罰則新設',
        'summary': '自転車の酒気帯び運転に3年以下の懲役又は50万円以下の罰金の罰則が新設。従来の酒酔い運転に加え、酒気帯びも処罰対象に。',
        'date': '2024-11-01',
        'category': 'new_law',
      },
      {
        'title': '全年齢ヘルメット着用努力義務化',
        'summary': '2023年4月1日から全ての自転車利用者にヘルメット着用が努力義務化。罰則はないが、頭部致命傷リスクの大幅な軽減効果あり。',
        'date': '2023-04-01',
        'category': 'equipment',
      },
    ];
  }

  /// キャッシュからデータ読み込み（APIから取得した追加データ）
  Future<void> _loadFromCache() async {
    try {
      final box = await Hive.openBox(_cacheBoxName);
      final rulesJson = box.get('rules');
      final quizzesJson = box.get('quizzes');
      final updatesJson = box.get('law_updates');

      // APIから取得してキャッシュされたデータがあれば、ローカルデータとマージ
      if (rulesJson != null) {
        final cachedRules = List<Map<String, dynamic>>.from(
          (json.decode(rulesJson) as List).map((e) => Map<String, dynamic>.from(e)),
        );
        _mergeRules(cachedRules);
      }
      if (quizzesJson != null) {
        final cachedQuizzes = List<Map<String, dynamic>>.from(
          (json.decode(quizzesJson) as List).map((e) => Map<String, dynamic>.from(e)),
        );
        _mergeQuizzes(cachedQuizzes);
      }
      if (updatesJson != null) {
        final cachedUpdates = List<Map<String, dynamic>>.from(
          (json.decode(updatesJson) as List).map((e) => Map<String, dynamic>.from(e)),
        );
        if (cachedUpdates.isNotEmpty) {
          _lawUpdates = cachedUpdates;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Cache load error: $e');
      }
    }
  }

  /// APIのルールデータをローカルデータとマージ
  void _mergeRules(List<Map<String, dynamic>> apiRules) {
    if (apiRules.isEmpty) return;

    // APIデータのタイトルセットを作成
    final apiTitles = apiRules.map((r) => r['title'] as String?).toSet();

    // ローカルデータでAPIに存在しないものを残す
    final localOnly = _rules.where((r) => !apiTitles.contains(r['title'])).toList();

    // APIデータ + ローカルのみのデータ
    _rules = [...apiRules, ...localOnly];
  }

  /// APIのクイズデータをローカルデータとマージ
  void _mergeQuizzes(List<Map<String, dynamic>> apiQuizzes) {
    if (apiQuizzes.isEmpty) return;

    final apiQuestions = apiQuizzes.map((q) => q['question'] as String?).toSet();
    final localOnly = _quizzes.where((q) => !apiQuestions.contains(q['question'])).toList();

    _quizzes = [...apiQuizzes, ...localOnly];
  }

  /// APIからデータ同期
  Future<void> _syncFromApi() async {
    try {
      // キャッシュの有効期限をチェック
      final box = await Hive.openBox(_cacheBoxName);
      final lastSync = box.get('last_sync');
      if (lastSync != null) {
        final lastSyncTime = DateTime.parse(lastSync);
        if (DateTime.now().difference(lastSyncTime) < _cacheExpiry) {
          _isOffline = false;
          return; // キャッシュが新鮮なのでスキップ
        }
      }

      // APIから取得
      final futures = await Future.wait([
        ContentApiService.fetchRules(),
        ContentApiService.fetchQuizzes(),
        ContentApiService.fetchLawUpdates(),
        ContentApiService.fetchCategories(),
      ]);

      final apiRules = futures[0] as List<Map<String, dynamic>>;
      final apiQuizzes = futures[1] as List<Map<String, dynamic>>;
      final apiUpdates = futures[2] as List<Map<String, dynamic>>;
      final apiCategories = futures[3] as Map<String, dynamic>;

      // APIデータをローカルデータとマージ
      _mergeRules(apiRules);
      _mergeQuizzes(apiQuizzes);
      if (apiUpdates.isNotEmpty) _lawUpdates = apiUpdates;
      if (apiCategories.isNotEmpty) _categories = apiCategories;

      // キャッシュに保存
      await box.put('rules', json.encode(apiRules));
      await box.put('quizzes', json.encode(apiQuizzes));
      await box.put('law_updates', json.encode(apiUpdates));
      await box.put('categories', json.encode(apiCategories));
      await box.put('last_sync', DateTime.now().toIso8601String());

      _isOffline = false;
      _error = null;
    } catch (e) {
      // API接続失敗 → オフラインモード（ローカルデータはすでにロード済み）
      _isOffline = true;
      // ローカルデータがあるのでエラーメッセージは設定しない
      _error = null;
      if (kDebugMode) {
        debugPrint('API sync error (using local data): $e');
      }
    }
  }

  Future<void> updateLocale(String localeCode) async {
    if (_localeCode == localeCode) return;
    _localeCode = localeCode;
    _loadLocalData();
    notifyListeners();
  }

  /// 強制リフレッシュ
  Future<void> refresh() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // ローカルデータを再読み込み
    _loadLocalData();

    // キャッシュの有効期限をリセット
    final box = await Hive.openBox(_cacheBoxName);
    await box.delete('last_sync');

    await _syncFromApi();

    _isLoading = false;
    notifyListeners();
  }

  /// カテゴリ別ルールを取得
  List<Map<String, dynamic>> getRulesByCategory(String category) {
    return _rules.where((r) => r['category'] == category).toList();
  }

  /// カテゴリ別クイズを取得
  List<Map<String, dynamic>> getQuizzesByCategory(String category) {
    return _quizzes.where((q) => q['category'] == category).toList();
  }

  /// ランダムクイズを取得
  List<Map<String, dynamic>> getRandomQuizzes(int count) {
    final shuffled = List<Map<String, dynamic>>.from(_quizzes)..shuffle();
    return shuffled.take(count).toList();
  }
}
