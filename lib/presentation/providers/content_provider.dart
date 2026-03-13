import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import '../../core/services/content_api_service.dart';

/// コンテンツプロバイダー
/// APIからデータ取得 + Hiveローカルキャッシュ
class ContentProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _rules = [];
  List<Map<String, dynamic>> _quizzes = [];
  List<Map<String, dynamic>> _lawUpdates = [];
  Map<String, dynamic> _categories = {};
  bool _isLoading = false;
  String? _error;
  bool _isOffline = false;

  List<Map<String, dynamic>> get rules => _rules;
  List<Map<String, dynamic>> get quizzes => _quizzes;
  List<Map<String, dynamic>> get lawUpdates => _lawUpdates;
  Map<String, dynamic> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isOffline => _isOffline;

  static const String _cacheBoxName = 'content_cache';
  static const Duration _cacheExpiry = Duration(hours: 6);

  /// 初期化：キャッシュからロード後、API同期を試行
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    // 1. ローカルキャッシュからロード（即座に表示可能）
    await _loadFromCache();

    // 2. APIからの同期を試行
    await _syncFromApi();

    _isLoading = false;
    notifyListeners();
  }

  /// キャッシュからデータ読み込み
  Future<void> _loadFromCache() async {
    try {
      final box = await Hive.openBox(_cacheBoxName);
      final rulesJson = box.get('rules');
      final quizzesJson = box.get('quizzes');
      final updatesJson = box.get('law_updates');
      final categoriesJson = box.get('categories');

      if (rulesJson != null) {
        _rules = List<Map<String, dynamic>>.from(
          (json.decode(rulesJson) as List).map((e) => Map<String, dynamic>.from(e)),
        );
      }
      if (quizzesJson != null) {
        _quizzes = List<Map<String, dynamic>>.from(
          (json.decode(quizzesJson) as List).map((e) => Map<String, dynamic>.from(e)),
        );
      }
      if (updatesJson != null) {
        _lawUpdates = List<Map<String, dynamic>>.from(
          (json.decode(updatesJson) as List).map((e) => Map<String, dynamic>.from(e)),
        );
      }
      if (categoriesJson != null) {
        _categories = Map<String, dynamic>.from(json.decode(categoriesJson));
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Cache load error: $e');
      }
    }
  }

  /// APIからデータ同期
  Future<void> _syncFromApi() async {
    try {
      // キャッシュの有効期限をチェック
      final box = await Hive.openBox(_cacheBoxName);
      final lastSync = box.get('last_sync');
      if (lastSync != null) {
        final lastSyncTime = DateTime.parse(lastSync);
        if (DateTime.now().difference(lastSyncTime) < _cacheExpiry && _rules.isNotEmpty) {
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

      _rules = futures[0] as List<Map<String, dynamic>>;
      _quizzes = futures[1] as List<Map<String, dynamic>>;
      _lawUpdates = futures[2] as List<Map<String, dynamic>>;
      _categories = futures[3] as Map<String, dynamic>;

      // キャッシュに保存
      await box.put('rules', json.encode(_rules));
      await box.put('quizzes', json.encode(_quizzes));
      await box.put('law_updates', json.encode(_lawUpdates));
      await box.put('categories', json.encode(_categories));
      await box.put('last_sync', DateTime.now().toIso8601String());

      _isOffline = false;
      _error = null;
    } catch (e) {
      _isOffline = true;
      if (_rules.isEmpty) {
        _error = 'データの取得に失敗しました。ネットワーク接続を確認してください。';
      }
      if (kDebugMode) {
        debugPrint('API sync error: $e');
      }
    }
  }

  /// 強制リフレッシュ
  Future<void> refresh() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

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
