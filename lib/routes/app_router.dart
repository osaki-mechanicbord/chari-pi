import 'package:flutter/material.dart';
import '../presentation/screens/splash_screen.dart';
import '../presentation/screens/terms_screen.dart';
import '../presentation/screens/start_screen.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/plan_upgrade_screen.dart';
import '../presentation/screens/family_setup_screen.dart';
import '../presentation/screens/business_dashboard_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/terms':
        return MaterialPageRoute(builder: (_) => const TermsScreen());
      case '/start':
        return MaterialPageRoute(builder: (_) => const StartScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/plan':
        return MaterialPageRoute(builder: (_) => const PlanUpgradeScreen());
      case '/family':
        return MaterialPageRoute(builder: (_) => const FamilySetupScreen());
      case '/business-dashboard':
        return MaterialPageRoute(builder: (_) => const BusinessDashboardScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found: ${settings.name}')),
          ),
        );
    }
  }
}
