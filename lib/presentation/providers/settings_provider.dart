import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _voiceAlert = true;
  bool _vibrationAlert = true;
  double _alertDistance = 50.0;
  bool _termsAccepted = false;
  bool _darkMap = true;
  Locale _locale = const Locale('ja');

  bool get voiceAlert => _voiceAlert;
  bool get vibrationAlert => _vibrationAlert;
  double get alertDistance => _alertDistance;
  bool get termsAccepted => _termsAccepted;
  bool get darkMap => _darkMap;
  Locale get locale => _locale;

  static const List<Locale> supportedLocales = [
    Locale('ja'),
    Locale('en'),
    Locale('ko'),
    Locale('zh'),
    Locale('vi'),
    Locale('th'),
    Locale('fil'),
  ];

  static String localeDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'ja':
        return '日本語';
      case 'en':
        return 'English';
      case 'ko':
        return '한국어';
      case 'zh':
        return '中文';
      case 'vi':
        return 'Tiếng Việt';
      case 'th':
        return 'ภาษาไทย';
      case 'fil':
        return 'Filipino';
      default:
        return locale.languageCode;
    }
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _voiceAlert = prefs.getBool('voiceAlert') ?? true;
    _vibrationAlert = prefs.getBool('vibrationAlert') ?? true;
    _alertDistance = prefs.getDouble('alertDistance') ?? 50.0;
    _termsAccepted = prefs.getBool('termsAccepted') ?? false;
    _darkMap = prefs.getBool('darkMap') ?? true;
    final langCode = prefs.getString('languageCode') ?? 'ja';
    _locale = Locale(langCode);
    notifyListeners();
  }

  Future<void> setVoiceAlert(bool value) async {
    _voiceAlert = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('voiceAlert', value);
    notifyListeners();
  }

  Future<void> setVibrationAlert(bool value) async {
    _vibrationAlert = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibrationAlert', value);
    notifyListeners();
  }

  Future<void> setAlertDistance(double value) async {
    _alertDistance = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('alertDistance', value);
    notifyListeners();
  }

  Future<void> setTermsAccepted(bool value) async {
    _termsAccepted = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('termsAccepted', value);
    notifyListeners();
  }

  Future<void> setDarkMap(bool value) async {
    _darkMap = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMap', value);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    notifyListeners();
  }
}
