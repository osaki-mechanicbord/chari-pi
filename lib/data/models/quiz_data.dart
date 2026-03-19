import 'quiz_data_ja.dart';
import 'quiz_data_en.dart';
import 'quiz_data_ko.dart';
import 'quiz_data_zh.dart';
import 'quiz_data_vi.dart';
import 'quiz_data_th.dart';
import 'quiz_data_fil.dart';

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String difficulty;
  final String category;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.difficulty = 'medium',
    this.category = 'basic',
  });

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'correct_index': correctIndex,
      'explanation': explanation,
      'difficulty': difficulty,
      'category': category,
    };
  }
}

class QuizData {
  /// 後方互換: 既存コードが QuizData.questions を参照している場合
  static const List<QuizQuestion> questions = QuizDataJa.questions;

  /// ロケールに応じたクイズデータを返す
  static List<QuizQuestion> getQuestions(String localeCode) {
    switch (localeCode) {
      case 'ja':
        return QuizDataJa.questions;
      case 'en':
        return QuizDataEn.questions;
      case 'ko':
        return QuizDataKo.questions;
      case 'zh':
        return QuizDataZh.questions;
      case 'vi':
        return QuizDataVi.questions;
      case 'th':
        return QuizDataTh.questions;
      case 'fil':
        return QuizDataFil.questions;
      default:
        return QuizDataJa.questions;
    }
  }
}
