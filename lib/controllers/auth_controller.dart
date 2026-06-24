import '../core/config/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../core/services/toast_service.dart';
import '../core/utils/logger.dart';

class AuthController {
  AuthController._();

  static final AuthController instance = AuthController._();

  /// Request OTP for a given phone number
  Future<bool> sendOtp(String phone) async {
    try {
      AppLogger.i('Sending OTP request to $phone');
      final response = await ApiClient.instance.post(
        ApiEndpoints.sendOtp,
        body: {'phone': phone},
      );

      if (response.statusCode == 200 && response.data != null) {
        final success = response.data['success'] as bool? ?? false;
        final message = response.data['message'] as String? ?? '';
        
        if (message.isNotEmpty) {
          if (success) {
            ToastService.success(message);
          } else {
            ToastService.error(message);
          }
        }
        return success;
      }
      return false;
    } on ApiException catch (e) {
      AppLogger.w('ApiException sending OTP: ${e.message}');
      ToastService.error(e.message);
      return false;
    } catch (e) {
      AppLogger.e('Error sending OTP for phone $phone: $e');
      ToastService.error(e.toString());
      return false;
    }
  }

  /// Verify OTP and return registration status along with token and profile data
  Future<Map<String, dynamic>?> verifyOtp(String phone, String code, {String? fcmToken}) async {
    try {
      AppLogger.i('Verifying OTP code for $phone');
      final response = await ApiClient.instance.post(
        ApiEndpoints.verifyOtp,
        body: {
          'phone': phone,
          'code': code,
          'fcmToken': fcmToken,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final success = response.data['success'] as bool? ?? false;
        final message = response.data['message'] as String? ?? '';

        if (success && response.data['data'] != null) {
          final data = response.data['data'] as Map<String, dynamic>;
          if (message.isNotEmpty) {
            ToastService.success(message);
          }
          return {
            'token': data['token'] as String?,
            'isRegistered': data['isRegistered'] as bool? ?? false,
            'status': data['status'] as String? ?? 'NEW',
            'cook': data['cook'] as Map<String, dynamic>?,
          };
        } else {
          if (message.isNotEmpty) {
            ToastService.error(message);
          }
        }
      }
      return null;
    } on ApiException catch (e) {
      AppLogger.w('ApiException verifying OTP: ${e.message}');
      ToastService.error(e.message);
      return null;
    } catch (e) {
      AppLogger.e('Error verifying OTP for phone $phone: $e');
      ToastService.error(e.toString());
      return null;
    }
  }
}
