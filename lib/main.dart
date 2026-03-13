import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (kDebugMode) {
      debugPrint('Firebase initialized successfully');
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('Firebase initialization error: $e');
    }
  }

  await Hive.initFlutter();

  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  final locationProvider = LocationProvider();
  await locationProvider.initialize();

  final contentProvider = ContentProvider();
  contentProvider.initialize();

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
