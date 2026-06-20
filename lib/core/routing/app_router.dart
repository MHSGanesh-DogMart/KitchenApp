import 'package:flutter/material.dart';

// Auth (re-used; cooks log in by phone)
import '../../presentation/screens/auth/intro_carousel_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/otp_verify_screen.dart';
import '../../presentation/screens/auth/splash_screen.dart' as auth_splash;

// Cook side — onboarding
import '../../presentation/screens/cook/onboarding/fssai_assist_screen.dart';
import '../../presentation/screens/cook/onboarding/go_live_screen.dart';
import '../../presentation/screens/cook/onboarding/identity_screen.dart';
import '../../presentation/screens/cook/onboarding/kitchen_safety_screen.dart';
import '../../presentation/screens/cook/onboarding/menu_setup_screen.dart';
import '../../presentation/screens/cook/onboarding/operations_screen.dart';
import '../../presentation/screens/cook/onboarding/tier_screen.dart';

// Cook side — tab shell + per-screen routes
import '../../presentation/screens/cook/cook_help_screen.dart';
import '../../presentation/screens/cook/cook_notifications_screen.dart';
import '../../presentation/screens/cook/cook_tab_shell.dart';
import '../../presentation/screens/cook/dish_edit_screen.dart';
import '../../presentation/screens/cook/food_ready_screen.dart';
import '../../presentation/screens/cook/incoming_order_screen.dart';
import '../../presentation/screens/cook/order_history_screen.dart';
import '../../presentation/screens/cook/reviews_screen.dart';
import '../../presentation/screens/cook/todays_menu_screen.dart';

// Re-used settings sub-screens
import '../../presentation/screens/profile/help_screen.dart';
import '../../presentation/screens/profile/language_screen.dart';
import '../../presentation/screens/profile/settings_screen.dart';

// Splash
import '../../presentation/screens/splash/splash_screen.dart';

// Empty / error states
import '../../presentation/screens/common/states.dart';

import 'route_names.dart';

/// Router for the Padosi **Partner** app.
class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ── Boot ──
      case RouteNames.boot:
      case RouteNames.splash:
        return _page(const SplashScreen(), settings);

      // ── Auth ──
      case RouteNames.onboarding:
        return _page(const auth_splash.AuthSplashScreen(), settings);
      case RouteNames.authIntro:
        return _page(const IntroCarouselScreen(), settings);
      case RouteNames.login:
        return _page(const LoginScreen(), settings);
      case RouteNames.otp:
        final phone = (settings.arguments as String?) ?? '+91 98xxx xxx21';
        return _page(OtpVerifyScreen(phone: phone), settings);

      // ── Cook onboarding (becomeChef == cookTier alias) ──
      case RouteNames.cookTier:
        return _page(const CookTierScreen(), settings);
      case RouteNames.cookIdentity:
        return _page(const CookIdentityScreen(), settings);
      case RouteNames.cookKitchenSafety:
        return _page(const CookKitchenSafetyScreen(), settings);
      case RouteNames.cookFssai:
        return _page(const CookFssaiAssistScreen(), settings);
      case RouteNames.cookMenuSetup:
        return _page(const CookMenuSetupScreen(), settings);
      case RouteNames.cookOperations:
        return _page(const CookOperationsScreen(), settings);
      case RouteNames.cookGoLive:
        return _page(const CookGoLiveScreen(), settings);

      // ── Cook tab shell (Dashboard / Orders / Menu / More) ──
      // RouteNames.home is a string alias for cookDashboard.
      case RouteNames.cookDashboard:
        return _page(const CookTabShell(), settings);

      // ── Cook detail screens ──
      case RouteNames.cookIncomingOrder:
        return _page(const IncomingOrderScreen(), settings);
      case RouteNames.cookFoodReady:
        return _page(const FoodReadyScreen(), settings);
      case RouteNames.cookTodaysMenu:
        return _page(const TodaysMenuScreen(), settings);
      case RouteNames.cookDishEdit:
        final draft = settings.arguments as DishDraft?;
        return _page(DishEditScreen(initial: draft), settings);
      case RouteNames.cookOrderHistory:
        return _page(const CookOrderHistoryScreen(), settings);
      case RouteNames.cookReviews:
        return _page(const CookReviewsScreen(), settings);
      case RouteNames.cookNotifications:
        return _page(const CookNotificationsScreen(), settings);
      case RouteNames.cookHelp:
        return _page(const CookHelpScreen(), settings);

      // ── Re-used settings sub ──
      case RouteNames.help:
        return _page(const HelpScreen(), settings);
      case RouteNames.language:
        return _page(const LanguageScreen(), settings);
      case RouteNames.settings:
        return _page(const SettingsScreen(), settings);

      // ── Empty / error states ──
      case RouteNames.stateOffline:
        return _page(const OfflineScreen(), settings);
      case RouteNames.stateNoResults:
        return _page(const NoResultsScreen(), settings);

      default:
        return _page(const _NotFound(), settings);
    }
  }

  static MaterialPageRoute _page(Widget child, RouteSettings settings) =>
      MaterialPageRoute(builder: (_) => child, settings: settings);
}

class _NotFound extends StatelessWidget {
  const _NotFound();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Route not found')));
}
