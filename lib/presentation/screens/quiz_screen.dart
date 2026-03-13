import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cycle_guard/l10n/app_localizations.dart';
import '../../core/constants/colors.dart';
import '../providers/content_provider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _answered = false;
  bool _quizFinished = false;
  List<Map<String, dynamic>> _questions = [];
  int _quizCount = 10;
  String _selectedDifficulty = 'all';
  bool _quizStarted = false;

  void _startQuiz(ContentProvider content) {
    List<Map<String, dynamic>> pool = content.quizzes;
    if (_selectedDifficulty != 'all') {
      pool = pool.where((q) => q['difficulty'] == _selectedDifficulty).toList();
    }
    pool = List.from(pool)..shuffle();
    setState(() {
      _questions = pool.take(_quizCount).toList();
      _quizStarted = true;
      _currentIndex = 0;
      _score = 0;
      _selectedAnswer = null;
      _answered = false;
      _quizFinished = false;
    });
  }

  void _selectAnswer(int index) {
    if (_answered) return;
    setState(() {
      _selectedAnswer = index;
      _answered = true;
      if (index == (_questions[_currentIndex]['correct_index'] as int)) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex >= _questions.length - 1) {
      setState(() => _quizFinished = true);
    } else {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _answered = false;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _quizStarted = false;
      _quizFinished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    return Consumer<ContentProvider>(
      builder: (context, content, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primaryDark, AppColors.bgMain],
            ),
          ),
          child: SafeArea(
            child: !_quizStarted
                ? _buildQuizSetup(content, l)
                : _quizFinished
                    ? _buildResult(l)
                    : _buildQuestion(l),
          ),
        );
      },
    );
  }

  Widget _buildQuizSetup(ContentProvider content, L10n l) {
    final totalQuizzes = content.quizzes.length;
    final easyCount = content.quizzes.where((q) => q['difficulty'] == 'easy').length;
    final mediumCount = content.quizzes.where((q) => q['difficulty'] == 'medium').length;
    final hardCount = content.quizzes.where((q) => q['difficulty'] == 'hard').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.quiz, color: AppColors.accentCyan, size: 28),
              const SizedBox(width: 12),
              Text(l.quizTitle, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgCard.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(l.quizTotal, '$totalQuizzes${l.quizQuestionUnit}', AppColors.accentCyan),
                _buildStatItem(l.quizEasy, '$easyCount${l.quizQuestionUnit}', AppColors.accentGreen),
                _buildStatItem(l.quizMedium, '$mediumCount${l.quizQuestionUnit}', AppColors.warning),
                _buildStatItem(l.quizHard, '$hardCount${l.quizQuestionUnit}', AppColors.danger),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(l.quizDifficulty, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            children: [
              _buildDifficultyChip('all', l.quizAllLevels, AppColors.accentCyan),
              _buildDifficultyChip('easy', l.quizEasy, AppColors.accentGreen),
              _buildDifficultyChip('medium', l.quizMedium, AppColors.warning),
              _buildDifficultyChip('hard', l.quizHard, AppColors.danger),
            ],
          ),
          const SizedBox(height: 24),
          Text(l.quizQuestionCount, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            children: [5, 10, 15, 20].map((n) {
              final isSelected = _quizCount == n;
              return GestureDetector(
                onTap: () => setState(() => _quizCount = n),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.accentCyan.withValues(alpha: 0.2) : AppColors.bgCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSelected ? AppColors.accentCyan : AppColors.divider),
                  ),
                  child: Text(
                    '$n${l.quizQuestionUnit}',
                    style: TextStyle(
                      color: isSelected ? AppColors.accentCyan : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: totalQuizzes > 0 ? () => _startQuiz(content) : null,
              icon: const Icon(Icons.play_arrow, size: 28),
              label: Text(l.quizStart, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentCyan,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: AppColors.warning, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l.quizSourceNote,
                    style: const TextStyle(color: AppColors.warning, fontSize: 11, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
      ],
    );
  }

  Widget _buildDifficultyChip(String key, String label, Color color) {
    final isSelected = _selectedDifficulty == key;
    return GestureDetector(
      onTap: () => setState(() => _selectedDifficulty = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : AppColors.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? color : AppColors.divider),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? color : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion(L10n l) {
    if (_questions.isEmpty) {
      return Center(child: Text(l.quizNoQuestions, style: const TextStyle(color: AppColors.textMuted)));
    }
    final question = _questions[_currentIndex];
    final options = List<String>.from(question['options'] as List);
    final diffMap = {'easy': l.quizEasy, 'medium': l.quizMedium, 'hard': l.quizHard};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.quiz, color: AppColors.accentCyan, size: 28),
              const SizedBox(width: 12),
              Text(l.quizTitle, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                l.quizQuestionProgress(_currentIndex + 1, _questions.length),
                style: const TextStyle(color: AppColors.accentCyan, fontWeight: FontWeight.bold),
              ),
              if (question['difficulty'] != null) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(question['difficulty'] as String).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    diffMap[question['difficulty']] ?? '',
                    style: TextStyle(color: _getDifficultyColor(question['difficulty'] as String), fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              const Spacer(),
              Text(
                '${l.quizScore}: $_score',
                style: const TextStyle(color: AppColors.accentGreen, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
              backgroundColor: AppColors.bgCard,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentCyan),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.bgCard.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: Text(
              question['question'] as String? ?? '',
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w600, height: 1.6),
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(options.length, (index) {
            final isSelected = _selectedAnswer == index;
            final isCorrect = index == (question['correct_index'] as int);
            Color borderColor = AppColors.divider;
            Color bgColor = AppColors.bgCard.withValues(alpha: 0.6);

            if (_answered) {
              if (isCorrect) {
                borderColor = AppColors.safe;
                bgColor = AppColors.safe.withValues(alpha: 0.15);
              } else if (isSelected && !isCorrect) {
                borderColor = AppColors.danger;
                bgColor = AppColors.danger.withValues(alpha: 0.15);
              }
            } else if (isSelected) {
              borderColor = AppColors.accentCyan;
              bgColor = AppColors.accentCyan.withValues(alpha: 0.1);
            }

            return GestureDetector(
              onTap: () => _selectAnswer(index),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: _answered && (isCorrect || isSelected) ? 2 : 1),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: borderColor.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: _answered
                            ? Icon(
                                isCorrect ? Icons.check : (isSelected ? Icons.close : null),
                                color: isCorrect ? AppColors.safe : AppColors.danger,
                                size: 18,
                              )
                            : Text(
                                String.fromCharCode(65 + index),
                                style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        options[index],
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          if (_answered)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (_selectedAnswer == (question['correct_index'] as int) ? AppColors.safe : AppColors.danger).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (_selectedAnswer == (question['correct_index'] as int) ? AppColors.safe : AppColors.danger).withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedAnswer == (question['correct_index'] as int) ? l.quizCorrect : l.quizIncorrect,
                    style: TextStyle(
                      color: _selectedAnswer == (question['correct_index'] as int) ? AppColors.safe : AppColors.danger,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    question['explanation'] as String? ?? '',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
                  ),
                ],
              ),
            ),
          if (_answered)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLight,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    _currentIndex >= _questions.length - 1 ? l.quizFinish : l.quizNext,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'easy': return AppColors.accentGreen;
      case 'medium': return AppColors.warning;
      case 'hard': return AppColors.danger;
      default: return AppColors.accentCyan;
    }
  }

  Widget _buildResult(L10n l) {
    final total = _questions.length;
    final percentage = total > 0 ? (_score / total * 100).round() : 0;
    final isGreat = percentage >= 80;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isGreat ? Icons.emoji_events : Icons.school,
              size: 80,
              color: isGreat ? AppColors.accentGreen : AppColors.warning,
            ),
            const SizedBox(height: 24),
            Text(l.quizResult, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isGreat
                      ? [AppColors.accentGreen, AppColors.accentCyan]
                      : [AppColors.warning, AppColors.danger],
                ),
              ),
              child: Center(
                child: Text('$percentage%', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
            Text(l.quizScoreResult(_score, total), style: const TextStyle(color: AppColors.textSecondary, fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              isGreat ? l.quizGreatMessage : l.quizTryAgainMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _restartQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(l.quizRetry, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
