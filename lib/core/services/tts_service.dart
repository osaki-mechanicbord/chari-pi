import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Text-to-Speech service for voice alerts
/// Automatically switches language based on app locale
class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  FlutterTts? _tts;
  bool _isInitialized = false;
  bool _isSpeaking = false;
  String _currentLanguage = 'ja-JP';

  // Language mapping: locale code -> TTS language code
  static const Map<String, String> _languageMap = {
    'ja': 'ja-JP',
    'en': 'en-US',
    'ko': 'ko-KR',
    'zh': 'zh-CN',
  };

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _tts = FlutterTts();

      // Configure for cycling safety — clear, loud, fast alerts
      await _tts!.setSpeechRate(0.55); // Slightly fast for urgency
      await _tts!.setVolume(1.0);       // Maximum volume
      await _tts!.setPitch(1.1);        // Slightly higher pitch for attention

      await _tts!.setLanguage(_currentLanguage);

      _tts!.setCompletionHandler(() {
        _isSpeaking = false;
      });

      _tts!.setErrorHandler((msg) {
        _isSpeaking = false;
        if (kDebugMode) debugPrint('TTS Error: $msg');
      });

      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) debugPrint('TTS init error: $e');
    }
  }

  /// Update TTS language when user changes app locale
  Future<void> setLanguage(String localeCode) async {
    final lang = _languageMap[localeCode] ?? 'ja-JP';
    if (lang == _currentLanguage) return;

    _currentLanguage = lang;
    if (_tts != null) {
      await _tts!.setLanguage(lang);
    }
  }

  /// Speak a warning message
  /// Priority alerts interrupt current speech
  Future<void> speakWarning(String message, {bool priority = false}) async {
    if (!_isInitialized || _tts == null) return;

    if (_isSpeaking && !priority) return; // Don't interrupt non-priority

    if (_isSpeaking) {
      await _tts!.stop();
    }

    _isSpeaking = true;
    await _tts!.speak(message);
  }

  /// Speak a short alert sound/phrase for immediate danger
  Future<void> speakUrgentAlert(String message) async {
    if (!_isInitialized || _tts == null) return;

    // Always interrupt for urgent alerts
    if (_isSpeaking) {
      await _tts!.stop();
    }

    // Temporarily increase rate for urgency
    await _tts!.setSpeechRate(0.65);
    await _tts!.setPitch(1.2);

    _isSpeaking = true;
    await _tts!.speak(message);

    // Reset to normal after speaking
    await Future.delayed(const Duration(seconds: 2));
    await _tts!.setSpeechRate(0.55);
    await _tts!.setPitch(1.1);
  }

  /// Stop any current speech
  Future<void> stop() async {
    if (_tts != null && _isSpeaking) {
      await _tts!.stop();
      _isSpeaking = false;
    }
  }

  void dispose() {
    _tts?.stop();
    _tts = null;
    _isInitialized = false;
  }
}
