import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/notifications/notification_service.dart';
import '../../../core/utils/logger.dart';
import '../../../providers/auth_provider.dart';
import '../cook/onboarding/status_screens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _minDisplay = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final auth = context.read<AuthProvider>();
    await Future.wait([
      auth.restoreSession(),
      Future.delayed(_minDisplay),
    ]);
    if (!mounted) return;

    if (auth.status == AuthStatus.authenticated) {
      // Sync FCM push token in splash in case it failed before
      final fcmToken = NotificationService.instance.token;
      if (fcmToken != null && fcmToken.isNotEmpty) {
        auth.syncFcmToken(fcmToken).catchError((err) {
          AppLogger.w('Background FCM token sync failed in splash: $err');
          return false;
        });
      }

      // Query status and navigate accordingly
      final status = await auth.checkKitchenStatus();
      if (mounted) {
        if (status != null) {
          handleStatusNavigation(context, status);
        } else {
          // Status check failed or token invalid -> logout and go to onboarding intro
          await auth.logout(silent: true);
          if (mounted) {
            Navigator.of(context).pushReplacementNamed(RouteNames.onboarding);
          }
        }
      }
    } else {
      Navigator.of(context).pushReplacementNamed(RouteNames.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.ink,
      ),
      child: Scaffold(
        backgroundColor: AppColors.ink,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 88.r,
                  height: 88.r,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: .45),
                        blurRadius: 36,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text('🏠', style: TextStyle(fontSize: 44.sp)),
                ),
                SizedBox(height: AppSizes.xl),
                Text(
                  AppStrings.appName,
                  style: AppTextStyles.display.copyWith(
                    color: Colors.white,
                    fontSize: 36.sp,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  AppStrings.appTagline,
                  style: AppTextStyles.bodyMd.copyWith(
                    color: Colors.white.withValues(alpha: .7),
                  ),
                ),
                SizedBox(height: AppSizes.xxxl),
                SizedBox(
                  width: 24.r,
                  height: 24.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
