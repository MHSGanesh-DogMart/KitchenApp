/// Route names for the Padosi **Partner** (kitchen / cook) app.
///
/// Customer-side routes were stripped — this app only ships the
/// flows a home chef needs: splash → auth → onboarding → cook tab
/// shell (Dashboard / Orders / Menu / More) plus per-order screens.
class RouteNames {
  RouteNames._();

  // ── Boot ──
  static const String boot = '/';
  static const String splash = '/splash';

  // ── Auth flow (cooks log in by phone too) ──
  static const String onboarding = '/onboarding'; // alias for splash
  static const String authIntro = '/auth/intro';
  static const String login = '/auth/login';

  // ── Legacy alias — kept so old cook screens that point to
  // RouteNames.home land on the dashboard cleanly. ──
  static const String home = '/cook/dashboard';

  // ── Cook onboarding ──
  static const String becomeChef = '/cook/tier';
  static const String cookTier = '/cook/tier';
  static const String cookIdentity = '/cook/identity';
  static const String cookKitchenSafety = '/cook/kitchen-safety';
  static const String cookFssai = '/cook/fssai';
  static const String cookOperations = '/cook/operations';
  static const String cookGoLive = '/cook/go-live';
  static const String cookFssaiAwaiting = '/cook/status/fssai-awaiting';
  static const String cookPending = '/cook/status/pending';
  static const String cookRejected = '/cook/status/rejected';

  // ── Cook tab shell (mockups 55-65) ──
  static const String cookDashboard = '/cook/dashboard';
  static const String cookIncomingOrder = '/cook/incoming';
  static const String cookFoodReady = '/cook/food-ready';
  static const String cookTodaysMenu = '/cook/todays-menu';
  static const String cookMenuManage = '/cook/menu';
  static const String cookDishEdit = '/cook/dish-edit';
  static const String cookOrderHistory = '/cook/history';
  static const String cookReviews = '/cook/reviews';
  static const String cookEarnings = '/cook/earnings';
  static const String cookNotifications = '/cook/notifications';
  static const String cookSettings = '/cook/settings';
  static const String cookProfileDetails = '/cook/profile-details';
  static const String cookHelp = '/cook/help';

  // ── Settings sub (kept from customer side, used by cook too) ──
  static const String help = '/profile/help';
  static const String language = '/profile/language';
  static const String settings = '/profile/settings';

  // ── Empty / error states ──
  static const String stateOffline = '/state/offline';
  static const String stateNoResults = '/state/no-results';
}
