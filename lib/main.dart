import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show kDebugMode, defaultTargetPlatform, TargetPlatform;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'presentation/providers/location_provider.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/providers/content_provider.dart';
import 'presentation/providers/plan_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (skip on iOS if GoogleService-Info.plist is not configured)
  try {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // iOS: Only initialize if GoogleService-Info.plist is properly configured
      // For now, skip Firebase on iOS to prevent crash with placeholder config
      if (kDebugMode) {
        debugPrint('Firebase: Skipping initialization on iOS (no GoogleService-Info.plist)');
      }
    } else {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      if (kDebugMode) {
        debugPrint('Firebase initialized successfully');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('Firebase initialization error (non-fatal): $e');
    }
  }

  await Hive.initFlutter();

  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  final locationProvider = LocationProvider();
  await locationProvider.initialize();

  final contentProvider = ContentProvider();
  contentProvider.initialize(localeCode: settingsProvider.locale.languageCode);

  final planProvider = PlanProvider();
  await planProvider.loadPlan();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider.value(value: locationProvider),
        ChangeNotifierProvider.value(value: contentProvider),
        ChangeNotifierProvider.value(value: planProvider),
      ],
      child: const ChariPiApp(),
    ),
  );
}
