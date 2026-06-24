import 'package:flutter/foundation.dart';
import 'package:padosi_food/core/config/api_endpoints.dart';
import 'package:padosi_food/core/network/api_client.dart';

import '../core/notifications/notification_service.dart';
import '../core/routing/route_names.dart';
import '../core/services/navigation_service.dart';
import '../core/services/toast_service.dart';
import '../core/storage/secure_storage.dart';
import '../core/utils/logger.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unknown;
  AuthStatus get status => _status;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> restoreSession() async {
    final token = await SecureStorage.instance.getToken();
    _status = (token != null && token.isNotEmpty)
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> onLoginSuccess(String token, {String? refreshToken}) async {
    await SecureStorage.instance.saveToken(token);
    if (refreshToken != null) {
      await SecureStorage.instance.saveRefreshToken(refreshToken);
    }
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  Future<void> logout({bool silent = false}) async {
    try {
      await NotificationService.instance.deleteToken();
    } catch (e) {
      AppLogger.w('FCM deleteToken on logout failed: $e');
    }
    await SecureStorage.instance.clear();
    _status = AuthStatus.unauthenticated;
    notifyListeners();
    if (!silent) {
      NavigationService.pushNamedAndRemoveUntil(RouteNames.login);
    }
  }

  Future<String?> checkKitchenStatus() async {
    try {
      final response = await ApiClient.instance.get(ApiEndpoints.getStatus);
      if (response.statusCode == 200 && response.data != null) {
        final statusVal = response.data['status'] as String?;
        return statusVal;
      }
    } catch (e) {
      AppLogger.e('Error checking kitchen status: $e');
    }
    return null;
  }

  Future<bool> syncFcmToken(String fcmToken) async {
    try {
      final response = await ApiClient.instance.post(
        ApiEndpoints.updateFcmToken,
        body: {'fcmToken': fcmToken},
      );
      if (response.statusCode == 200) {
        AppLogger.i('FCM token synchronized successfully.');
        return true;
      }
    } catch (e) {
      AppLogger.e('Error synchronizing FCM token: $e');
    }
    return false;
  }

  Future<void> handleUnauthorized() async {
    if (_status == AuthStatus.unauthenticated) return;
    ToastService.error('Session expired. Please login again.');
    await logout();
  }

  void setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }
}
