class ApiEndpoints {
  ApiEndpoints._();

  static const String sendOtp = '/api/kitchen/auth/otp/send';
  static const String verifyOtp = '/api/kitchen/auth/otp/verify';
  static const String submitOnboarding = '/api/kitchen/onboard/submit';
  static const String upload = '/api/kitchen/upload';
  static const String getStatus = '/api/kitchen/status';
  static const String updateFcmToken = '/api/kitchen/fcm-token';
}
