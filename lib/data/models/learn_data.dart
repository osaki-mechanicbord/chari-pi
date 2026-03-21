import 'learn_data_ja.dart';
import 'learn_data_en.dart';
import 'learn_data_ko.dart';
import 'learn_data_zh.dart';
import 'learn_data_vi.dart';
import 'learn_data_th.dart';
import 'learn_data_fil.dart';

class LearnContent {
  final String title;
  final String icon;
  final String summary;
  final String content;
  final List<String> keyPoints;
  final String category;
  final String? penalty;
  final String? lawReference;
  final String? source;

  const LearnContent({
    required this.title,
    required this.icon,
    required this.summary,
    required this.content,
    required this.keyPoints,
    required this.category,
    this.penalty,
    this.lawReference,
    this.source,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'icon': icon,
      'summary': summary,
      'content': content,
      'key_points': keyPoints,
      'category': category,
      'penalty': penalty ?? '',
      'law_reference': lawReference ?? '',
      'source': source ?? '',
      'version': 1,
      'updated_at': '2025-01-01T00:00:00Z',
    };
  }
}

class LearnData {
  /// 後方互換: 既存コードが LearnData.contents を参照している場合
  static const List<LearnContent> contents = LearnDataJa.contents;

  /// ロケールに応じた学習コンテンツを返す
  static List<LearnContent> getContents(String localeCode) {
    switch (localeCode) {
      case 'ja':
        return LearnDataJa.contents;
      case 'en':
        return LearnDataEn.contents;
      case 'ko':
        return LearnDataKo.contents;
      case 'zh':
        return LearnDataZh.contents;
      case 'vi':
        return LearnDataVi.contents;
      case 'th':
        return LearnDataTh.contents;
      case 'fil':
        return LearnDataFil.contents;
      default:
        return LearnDataJa.contents;
    }
  }
}
