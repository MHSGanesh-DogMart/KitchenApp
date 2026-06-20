import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../discover/_discover_widgets.dart';

/// Mockup 63 — Cook · Notifications.
class CookNotificationsScreen extends StatelessWidget {
  const CookNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const PlainAppBar(title: 'Notifications'),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 24.h),
                children: [
                  _NotifCard(
                    icon: Icons.notifications_active_rounded,
                    bg: AppColors.primarySoft,
                    fg: AppColors.primary,
                    title: 'New order #PD4821',
                    sub: 'Priya M. · 1× Veg Thali',
                  ),
                  SizedBox(height: 8.h),
                  _NotifCard(
                    icon: Icons.currency_rupee_rounded,
                    bg: AppColors.secondarySoft,
                    fg: AppColors.secondary,
                    title: 'Payout sent',
                    sub: '₹960 to HDFC •• 8842',
                  ),
                  SizedBox(height: 8.h),
                  _NotifCard(
                    icon: Icons.star_rounded,
                    bg: AppColors.tier1Soft,
                    fg: AppColors.tier1,
                    title: 'New 5-star review',
                    sub: 'From Anita P.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  const _NotifCard({
    required this.icon,
    required this.bg,
    required this.fg,
    required this.title,
    required this.sub,
  });
  final IconData icon;
  final Color bg;
  final Color fg;
  final String title;
  final String sub;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
        side: const BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(11.r),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: fg, size: 17.sp),
              ),
              SizedBox(width: 11.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      sub,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
