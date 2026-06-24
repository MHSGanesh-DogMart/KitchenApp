import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../core/services/toast_service.dart';

/// Helper helper to navigate based on status
void handleStatusNavigation(BuildContext context, String status) {
  if (!context.mounted) return;
  switch (status) {
    case 'Kitchen_Approved':
      Navigator.pushNamedAndRemoveUntil(context, RouteNames.cookDashboard, (_) => false);
      break;
    case 'Kitchen_Pending':
      Navigator.pushNamedAndRemoveUntil(context, RouteNames.cookPending, (_) => false);
      break;
    case 'Kitchen_Rejected':
      Navigator.pushNamedAndRemoveUntil(context, RouteNames.cookRejected, (_) => false);
      break;
    case 'Fssai_Awaiting':
      Navigator.pushNamedAndRemoveUntil(context, RouteNames.cookFssaiAwaiting, (_) => false);
      break;
    case 'Fssai_Approved':
      // FSSAI approved but general kitchen approval might still be pending
      Navigator.pushNamedAndRemoveUntil(context, RouteNames.cookPending, (_) => false);
      break;
    default:
      Navigator.pushNamedAndRemoveUntil(context, RouteNames.login, (_) => false);
      break;
  }
}

class KitchenPendingScreen extends StatefulWidget {
  const KitchenPendingScreen({super.key});

  @override
  State<KitchenPendingScreen> createState() => _KitchenPendingScreenState();
}

class _KitchenPendingScreenState extends State<KitchenPendingScreen> {
  bool _checking = false;

  Future<void> _checkStatus() async {
    setState(() => _checking = true);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final status = await auth.checkKitchenStatus();
    setState(() => _checking = false);

    if (status != null && mounted) {
      if (status == 'Kitchen_Pending') {
        ToastService.success('Your application is still under review.');
      } else {
        handleStatusNavigation(context, status);
      }
    } else if (mounted) {
      ToastService.error('Failed to update status. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF9F5), Color(0xFFFFECE0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                Center(
                  child: Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.hourglass_empty_rounded,
                      color: Colors.orange[800],
                      size: 48.sp,
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                Text(
                  'Application under review',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'We are currently verifying your Aadhaar, PAN, FSSAI, and Kitchen photos. This normally takes 24–48 hours. We will notify you as soon as your kitchen is approved!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: AppColors.inkSoft,
                    height: 1.5,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _checking ? null : _checkStatus,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99.r),
                    ),
                    elevation: 0,
                  ),
                  child: _checking
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          'Refresh Status',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
                SizedBox(height: 12.h),
                TextButton(
                  onPressed: () => auth.logout(),
                  child: Text(
                    'Log Out',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.red[700],
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class KitchenRejectedScreen extends StatelessWidget {
  const KitchenRejectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFEBEE), Color(0xFFFFCDD2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                Center(
                  child: Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.gpp_bad_outlined,
                      color: Colors.red[800],
                      size: 48.sp,
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                Text(
                  'Application Rejected',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Unfortunately, your kitchen application was not approved by the admin. This could be due to blurry document photos or incorrect details. Please contact support to rectify and resubmit.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: AppColors.inkSoft,
                    height: 1.5,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    ToastService.success('Support ticket created. We will call you shortly!');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Contact Support',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                TextButton(
                  onPressed: () => auth.logout(),
                  child: Text(
                    'Log Out',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.red[700],
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FssaiAwaitingScreen extends StatefulWidget {
  const FssaiAwaitingScreen({super.key});

  @override
  State<FssaiAwaitingScreen> createState() => _FssaiAwaitingScreenState();
}

class _FssaiAwaitingScreenState extends State<FssaiAwaitingScreen> {
  bool _checking = false;

  Future<void> _checkStatus() async {
    setState(() => _checking = true);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final status = await auth.checkKitchenStatus();
    setState(() => _checking = false);

    if (status != null && mounted) {
      if (status == 'Fssai_Awaiting') {
        ToastService.success('We are still processing your FSSAI filing.');
      } else {
        handleStatusNavigation(context, status);
      }
    } else if (mounted) {
      ToastService.error('Failed to update status. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F2F1), Color(0xFFB2DFDB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                Center(
                  child: Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.assignment_ind_outlined,
                      color: Colors.teal[800],
                      size: 48.sp,
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                Text(
                  'FSSAI Filing Awaiting',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Your documents are received. We are currently filing your basic FSSAI license application with the government. This status will update as soon as the filing is processed.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: AppColors.inkSoft,
                    height: 1.5,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _checking ? null : _checkStatus,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99.r),
                    ),
                    elevation: 0,
                  ),
                  child: _checking
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          'Refresh Status',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
                SizedBox(height: 12.h),
                TextButton(
                  onPressed: () => auth.logout(),
                  child: Text(
                    'Log Out',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.red[700],
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
