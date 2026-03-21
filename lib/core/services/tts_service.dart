import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../data/models/osm_node.dart';
import 'tts_messages_ko.dart';
import 'tts_messages_zh.dart';
import 'tts_messages_vi.dart';
import 'tts_messages_th.dart';
import 'tts_messages_fil.dart';

/// Text-to-Speech service for voice alerts
/// 段階的・詳細な音声ガイダンスで「見ないで安全」を実現
class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  FlutterTts? _tts;
  bool _isInitialized = false;
  bool _isSpeaking = false;
  String _currentLanguage = 'ja-JP';

  static const Map<String, String> _languageMap = {
    'ja': 'ja-JP',
    'en': 'en-US',
    'ko': 'ko-KR',
    'zh': 'zh-CN',
    'vi': 'vi-VN',
    'th': 'th-TH',
    'fil': 'fil-PH',
  };

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _tts = FlutterTts();
      await _tts!.setSpeechRate(0.52);
      await _tts!.setVolume(1.0);
      await _tts!.setPitch(1.1);
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

  Future<void> setLanguage(String localeCode) async {
    final lang = _languageMap[localeCode] ?? 'ja-JP';
    if (lang == _currentLanguage) return;
    _currentLanguage = lang;
    if (_tts != null) {
      await _tts!.setLanguage(lang);
    }
  }

  /// 3段階の距離別アラートメッセージを生成
  /// 返り値: アラート段階 (0=対象外, 1=予告, 2=注意, 3=緊急)
  int getAlertStage(double distance, OSMNodeType type) {
    switch (type) {
      // 一方通行逆走・歩行者専用道路 → way距離ベースで即時警告
      case OSMNodeType.oneway:
      case OSMNodeType.pedestrianRoad:
      case OSMNodeType.footwayNoBicycle:
      case OSMNodeType.noBicycle:
      case OSMNodeType.dismount:
        if (distance <= 10) return 3;
        if (distance <= 30) return 2;
        if (distance <= 60) return 1;
        return 0;

      // 一時停止・信号・横断歩道 → 段階的アラート
      case OSMNodeType.stopSign:
      case OSMNodeType.trafficSignal:
      case OSMNodeType.crossing:
        if (distance <= 15) return 3;
        if (distance <= 40) return 2;
        if (distance <= 80) return 1;
        return 0;

      // 歩道走行 → way距離ベース
      case OSMNodeType.footway:
        if (distance <= 8) return 3;
        if (distance <= 20) return 2;
        return 0;

      // 事故多発・取り締まりエリア → 広い範囲
      case OSMNodeType.accidentZone:
      case OSMNodeType.enforcementZone:
        if (distance <= 100) return 2;
        if (distance <= 300) return 1;
        return 0;

      // 自転車レーン・速度制限 → 案内
      case OSMNodeType.cycleway:
      case OSMNodeType.speedLimit:
        if (distance <= 30) return 2;
        if (distance <= 80) return 1;
        return 0;
    }
  }

  /// ノードタイプと距離段階に応じた詳細メッセージを生成
  String getDetailedMessage(OSMNode node, int stage, String localeCode, {double? userSpeed}) {
    final dist = node.distanceFromUser?.round() ?? 0;

    switch (localeCode) {
      case 'en':
        return _getEnglishMessage(node, stage, dist, userSpeed: userSpeed);
      case 'ko':
        return getTtsMessageKo(node, stage, dist, userSpeed: userSpeed);
      case 'zh':
        return getTtsMessageZh(node, stage, dist, userSpeed: userSpeed);
      case 'vi':
        return getTtsMessageVi(node, stage, dist, userSpeed: userSpeed);
      case 'th':
        return getTtsMessageTh(node, stage, dist, userSpeed: userSpeed);
      case 'fil':
        return getTtsMessageFil(node, stage, dist, userSpeed: userSpeed);
      case 'ja':
      default:
        return _getJapaneseMessage(node, stage, dist, userSpeed: userSpeed);
    }
  }

  String _getJapaneseMessage(OSMNode node, int stage, int dist, {double? userSpeed}) {
    switch (node.type) {
      case OSMNodeType.stopSign:
        switch (stage) {
          case 1: return 'この先、一時停止があります';
          case 2: return '一時停止に近づいています。減速してください';
          case 3: return '一時停止です。完全に停止してください';
          default: return '';
        }
      case OSMNodeType.trafficSignal:
        switch (stage) {
          case 1: return '$distメートル先に信号機があります';
          case 2: return '信号機に近づいています。信号を確認してください';
          case 3: return '信号機です。信号に従ってください';
          default: return '';
        }
      case OSMNodeType.oneway:
        if (node.isWrongWay) {
          switch (stage) {
            case 1: return '警告。前方の道路は一方通行です。進行方向を確認してください';
            case 2: return '危険。一方通行を逆走しています。安全な場所で停止してください';
            case 3: return '逆走です。直ちに停止してください。違反の場合5万円以下の罰金です';
            default: return '';
          }
        }
        switch (stage) {
          case 1: return '$distメートル先に一方通行があります';
          case 2: return '一方通行に近づいています。方向を確認してください';
          case 3: return '一方通行です。通行方向に注意してください';
          default: return '';
        }
      case OSMNodeType.pedestrianRoad:
        switch (stage) {
          case 1: return '前方に歩行者専用道路があります。自転車は通行できません';
          case 2: return '歩行者専用道路に近づいています。迂回してください';
          case 3: return '歩行者専用道路です。自転車は通行禁止です';
          default: return '';
        }
      case OSMNodeType.footway:
        switch (stage) {
          case 2: return '歩道です。自転車走行可の標識を確認してください';
          case 3: return '歩道を走行中の可能性があります。標識を確認し、走行不可の場合は降りて歩いてください';
          default: return '';
        }
      case OSMNodeType.footwayNoBicycle:
        switch (stage) {
          case 1: return '前方の歩道は自転車走行禁止です';
          case 2: return '自転車走行禁止の歩道に近づいています';
          case 3: return 'この歩道は自転車走行禁止です。降りて歩いてください';
          default: return '';
        }
      case OSMNodeType.cycleway:
        switch (stage) {
          case 1: return '近くに自転車専用道路があります';
          case 2: return '自転車専用道路です。こちらを走行しましょう';
          default: return '';
        }
      case OSMNodeType.crossing:
        switch (stage) {
          case 1: return '$distメートル先に横断歩道があります';
          case 2: return '横断歩道に近づいています。歩行者に注意してください';
          case 3: return '横断歩道です。歩行者がいれば一時停止してください';
          default: return '';
        }
      case OSMNodeType.noBicycle:
        switch (stage) {
          case 1: return '前方は自転車通行禁止です。迂回してください';
          case 2: return '自転車通行禁止区域に近づいています';
          case 3: return 'ここは自転車通行禁止です。直ちに迂回してください';
          default: return '';
        }
      case OSMNodeType.dismount:
        switch (stage) {
          case 1: return '前方は押し歩き区間です';
          case 2: return '押し歩き区間に近づいています。自転車から降りてください';
          case 3: return '押し歩き区間です。自転車から降りて歩いてください';
          default: return '';
        }
      case OSMNodeType.speedLimit:
        if (userSpeed != null && node.speedLimit != null && userSpeed > node.speedLimit!) {
          return 'この区間の制限速度は時速${node.speedLimit}キロです。現在時速${userSpeed.round()}キロです。減速してください';
        }
        if (stage >= 2 && node.speedLimit != null) {
          return 'この区間の制限速度は時速${node.speedLimit}キロです';
        }
        return '';
      case OSMNodeType.accidentZone:
        switch (stage) {
          case 1: return 'この先、自転車事故の多発地点です。注意して走行してください';
          case 2: return '事故多発地点です。十分に注意してください';
          default: return '';
        }
      case OSMNodeType.enforcementZone:
        switch (stage) {
          case 1: return 'この先、交通取り締まり重点エリアです。交通ルールを守って走行しましょう';
          case 2: return '取り締まり重点エリアです。違反に注意してください';
          default: return '';
        }
    }
  }

  String _getEnglishMessage(OSMNode node, int stage, int dist, {double? userSpeed}) {
    switch (node.type) {
      case OSMNodeType.stopSign:
        switch (stage) {
          case 1: return 'Stop sign ahead, $dist meters';
          case 2: return 'Approaching stop sign. Slow down';
          case 3: return 'Stop sign. Come to a complete stop';
          default: return '';
        }
      case OSMNodeType.trafficSignal:
        switch (stage) {
          case 1: return 'Traffic signal ahead, $dist meters';
          case 2: return 'Approaching traffic signal';
          case 3: return 'Traffic signal. Check the light';
          default: return '';
        }
      case OSMNodeType.oneway:
        if (node.isWrongWay) {
          switch (stage) {
            case 1: return 'Warning. One-way street ahead. Check direction';
            case 2: return 'Danger. Wrong way on a one-way street. Stop safely';
            case 3: return 'Wrong way. Stop immediately';
            default: return '';
          }
        }
        switch (stage) {
          case 1: return 'One-way street ahead, $dist meters';
          case 2: return 'Approaching one-way street';
          case 3: return 'One-way street. Check direction';
          default: return '';
        }
      case OSMNodeType.pedestrianRoad:
        switch (stage) {
          case 1: return 'Pedestrian zone ahead. No cycling allowed';
          case 2: return 'Approaching pedestrian zone. Find alternate route';
          case 3: return 'Pedestrian zone. Cycling prohibited';
          default: return '';
        }
      case OSMNodeType.footway:
        switch (stage) {
          case 2: return 'Sidewalk ahead. Check for signs permitting cycling';
          case 3: return 'You may be on a sidewalk. Check signs. If cycling is not allowed, please dismount';
          default: return '';
        }
      case OSMNodeType.footwayNoBicycle:
        switch (stage) {
          case 1: return 'Sidewalk ahead. No cycling allowed';
          case 2: return 'Approaching no-cycling sidewalk';
          case 3: return 'No cycling on this sidewalk. Please dismount';
          default: return '';
        }
      case OSMNodeType.cycleway:
        switch (stage) {
          case 1: return 'Cycle lane nearby';
          case 2: return 'Cycle lane available. Use it for safety';
          default: return '';
        }
      case OSMNodeType.crossing:
        switch (stage) {
          case 1: return 'Crosswalk ahead, $dist meters';
          case 2: return 'Approaching crosswalk. Watch for pedestrians';
          case 3: return 'Crosswalk. Yield to pedestrians';
          default: return '';
        }
      case OSMNodeType.noBicycle:
        switch (stage) {
          case 1: return 'No cycling zone ahead';
          case 2: return 'Approaching no-cycling zone';
          case 3: return 'No cycling allowed here. Find alternate route';
          default: return '';
        }
      case OSMNodeType.dismount:
        switch (stage) {
          case 1: return 'Dismount zone ahead';
          case 2: return 'Approaching dismount zone. Get off your bicycle';
          case 3: return 'Dismount zone. Walk your bicycle';
          default: return '';
        }
      case OSMNodeType.speedLimit:
        if (userSpeed != null && node.speedLimit != null && userSpeed > node.speedLimit!) {
          return 'Speed limit ${node.speedLimit} km/h. Current speed ${userSpeed.round()} km/h';
        }
        if (stage >= 2 && node.speedLimit != null) {
          return 'Speed limit ${node.speedLimit} kilometers per hour';
        }
        return '';
      case OSMNodeType.accidentZone:
        switch (stage) {
          case 1: return 'Bicycle accident zone ahead. Ride carefully';
          case 2: return 'Accident zone. Exercise caution';
          default: return '';
        }
      case OSMNodeType.enforcementZone:
        switch (stage) {
          case 1: return 'Traffic enforcement zone ahead';
          case 2: return 'Enforcement zone. Follow traffic rules';
          default: return '';
        }
    }
  }

  /// 警告メッセージを発話
  Future<void> speakWarning(String message, {bool priority = false}) async {
    if (!_isInitialized || _tts == null || message.isEmpty) return;
    if (_isSpeaking && !priority) return;

    if (_isSpeaking) {
      await _tts!.stop();
    }

    _isSpeaking = true;
    await _tts!.setSpeechRate(0.52);
    await _tts!.setPitch(1.1);
    await _tts!.speak(message);
  }

  /// 緊急アラートを発話（逆走・歩行者専用道路等）
  Future<void> speakUrgentAlert(String message) async {
    if (!_isInitialized || _tts == null || message.isEmpty) return;

    if (_isSpeaking) {
      await _tts!.stop();
    }

    await _tts!.setSpeechRate(0.60);
    await _tts!.setPitch(1.25);

    _isSpeaking = true;
    await _tts!.speak(message);

    await Future.delayed(const Duration(seconds: 2));
    await _tts!.setSpeechRate(0.52);
    await _tts!.setPitch(1.1);
  }

  /// 危険レベルに応じて自動的に発話モードを選択
  Future<void> speakByLevel(String message, WarningLevel level) async {
    switch (level) {
      case WarningLevel.danger:
        await speakUrgentAlert(message);
      case WarningLevel.warning:
        await speakWarning(message, priority: true);
      case WarningLevel.caution:
        await speakWarning(message, priority: false);
      case WarningLevel.info:
        await speakWarning(message, priority: false);
    }
  }

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
