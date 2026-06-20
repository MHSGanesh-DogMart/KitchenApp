import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '_onboarding_widgets.dart';

/// Cook · Go live review (6 of 6).
class CookGoLiveScreen extends StatelessWidget {
  const CookGoLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      step: 6,
      totalSteps: 6,
      kicker: 'All set',
      title: 'You are ready\nto go live ✨',
      subtitle:
          'Our team will verify your docs in ~24h. You can preview your storefront now.',
      gradient: const [
        Color(0xFFE1F2EC),
        Color(0xFFCFE9DC),
        Color(0xFFF1F8F4),
      ],
      ctaLabel: 'Submit & go live',
      onCta: () => Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.cookDashboard,
        (_) => false,
      ),
      body: [
        // ── Big celebration card ──
        _CelebrationCard(),

        SizedBox(height: 24.h),
        OnboardingSection(
          title: "Here's what you submitted",
          icon: Icons.fact_check_outlined,
        ),
        _ChecklistGroup(items: const [
          _Item(icon: Icons.person_outline_rounded, title: 'Identity & KYC', value: 'Verified docs uploaded'),
          _Item(icon: Icons.home_work_outlined, title: 'Kitchen & food safety', value: '3 photos · GPS · pledge'),
          _Item(icon: Icons.verified_user_outlined, title: 'FSSAI Basic', value: 'Registration filed'),
          _Item(icon: Icons.account_balance_outlined, title: 'Bank for payout', value: 'HDFC •• 8842'),
          _Item(icon: Icons.restaurant_menu_outlined, title: 'Menu', value: '2 dishes ready'),
          _Item(icon: Icons.assignment_turned_in_outlined, title: 'Operations & consent', value: 'All agreed'),
        ]),

        SizedBox(height: 18.h),
        Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF7E7), Color(0xFFFBEFD7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.tier1Soft),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🏠', style: TextStyle(fontSize: 22.sp)),
              SizedBox(width: 12.w),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: AppColors.tier1,
                      height: 1.55,
                      fontWeight: FontWeight.w600,
                    ),
                    children: const [
                      TextSpan(text: "You'll go live as "),
                      TextSpan(
                        text: 'Tier 1 Home Chef',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      TextSpan(
                          text:
                              '. Your storefront will show "Home Kitchen — FSSAI Basic" once verified.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CelebrationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F7B5A), Color(0xFF0D6B4E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: .35),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: .4),
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Text('🎉', style: TextStyle(fontSize: 28.sp)),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Application complete',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -.3,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Reviewed in ~24 hours. You can start cooking the moment you go live.',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: Colors.white.withValues(alpha: .85),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Item {
  const _Item({
    required this.icon,
    required this.title,
    required this.value,
  });
  final IconData icon;
  final String title;
  final String value;
}

class _ChecklistGroup extends StatelessWidget {
  const _ChecklistGroup({required this.items});
  final List<_Item> items;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: List.generate(items.length * 2 - 1, (i) {
          if (i.isOdd) {
            return Divider(
              height: 1,
              indent: 58.w,
              endIndent: 16.w,
              color: AppColors.line,
            );
          }
          final item = items[i ~/ 2];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
            child: Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: AppColors.secondarySoft,
                    borderRadius: BorderRadius.circular(9.r),
                  ),
                  alignment: Alignment.center,
                  child: Icon(item.icon,
                      size: 16.sp, color: AppColors.secondary),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        item.value,
                        style: GoogleFonts.inter(
                          fontSize: 11.5.sp,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.check_circle_rounded,
                    size: 18.sp, color: AppColors.secondary),
              ],
            ),
          );
        }),
      ),
    );
  }
}
