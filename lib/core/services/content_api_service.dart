import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// CHARI-PI コンテンツAPIサービス
/// バックエンドからルール・クイズ・法改正情報を取得
class ContentApiService {
  // Web: 同一オリジン（プロキシ経由） / モバイル: 設定可能なURL
  static String get baseUrl {
    if (kIsWeb) {
      // 統合サーバーのプロキシを使用（同一オリジン）
      final uri = Uri.base;
      return '${uri.scheme}://${uri.host}:${uri.port}';
    }
    return 'http://10.0.2.2:5080'; // Android エミュレータ
  }

  static Future<Map<String, dynamic>> _get(String path, {Map<String, String>? params}) async {
    try {
      final uri = Uri.parse('$baseUrl$path').replace(queryParameters: params);
      final response = await http.get(uri).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      throw Exception('API Error: ${response.statusCode}');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ContentApiService error: $e');
      }
      rethrow;
    }
  }

  /// ルール一覧を取得
  static Future<List<Map<String, dynamic>>> fetchRules({String? category}) async {
    final params = <String, String>{};
    if (category != null) params['category'] = category;
    final result = await _get('/api/v1/rules', params: params);
    return List<Map<String, dynamic>>.from(result['data'] ?? []);
  }

  /// ルール詳細を取得
  static Future<Map<String, dynamic>> fetchRule(String ruleId) async {
    final result = await _get('/api/v1/rules/$ruleId');
    return result['data'] as Map<String, dynamic>;
  }

  /// クイズ一覧を取得
  static Future<List<Map<String, dynamic>>> fetchQuizzes({
    String? category,
    String? difficulty,
    int? count,
  }) async {
    final params = <String, String>{};
    if (category != null) params['category'] = category;
    if (difficulty != null) params['difficulty'] = difficulty;
    if (count != null) params['count'] = count.toString();
    final result = await _get('/api/v1/quizzes', params: params);
    return List<Map<String, dynamic>>.from(result['data'] ?? []);
  }

  /// 法改正情報を取得
  static Future<List<Map<String, dynamic>>> fetchLawUpdates() async {
    final result = await _get('/api/v1/law-updates');
    return List<Map<String, dynamic>>.from(result['data'] ?? []);
  }

  /// カテゴリ一覧を取得
  static Future<Map<String, dynamic>> fetchCategories() async {
    final result = await _get('/api/v1/categories');
    return result['data'] as Map<String, dynamic>;
  }

  /// 統計情報を取得
  static Future<Map<String, dynamic>> fetchStats() async {
    return await _get('/api/v1/stats');
  }
}
