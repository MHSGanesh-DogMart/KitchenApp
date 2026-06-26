class ApiEndpoints {
  ApiEndpoints._();

  static const String sendOtp = '/api/kitchen/auth/otp/send';
  static const String verifyOtp = '/api/kitchen/auth/otp/verify';
  static const String submitOnboarding = '/api/kitchen/register';
  static const String upload = '/api/kitchen/upload';
  static const String getStatus = '/api/kitchen/status';
  static const String updateFcmToken = '/api/kitchen/fcm-token';
  static const String getCuisines = '/api/kitchen/cuisines';
  static const String getDetails = '/api/kitchen/details';
  static const String reapply = '/api/kitchen/reapply';

  // ── Menu management (kitchen-scoped) ──
  static const String menu = '/api/kitchen/menu';
  static String menuById(String id) => '/api/kitchen/menu/$id';
  static String menuAvailability(String id) =>
      '/api/kitchen/menu/$id/availability';
}
