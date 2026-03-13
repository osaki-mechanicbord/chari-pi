import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:cycle_guard/l10n/app_localizations.dart';
import 'core/constants/colors.dart';
import 'presentation/providers/settings_provider.dart';
import 'routes/app_router.dart';

class ChariPiApp extends StatelessWidget {
  const ChariPiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          title: 'CHARI-PI',
          debugShowCheckedModeBanner: false,
          locale: settings.locale,
          supportedLocales: L10n.supportedLocales,
          localizationsDelegates: const [
            L10n.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: AppColors.bgMain,
            primaryColor: AppColors.primaryLight,
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryLight,
              secondary: AppColors.accentCyan,
              surface: AppColors.surface,
              error: AppColors.danger,
            ),
            cardTheme: CardThemeData(
              color: AppColors.bgCard,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLight,
                foregroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            textTheme: const TextTheme(
              headlineLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
              headlineMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
              bodyLarge: TextStyle(color: AppColors.textPrimary),
              bodyMedium: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          initialRoute: '/',
          onGenerateRoute: AppRouter.generateRoute,
        );
      },
    );
  }
}
