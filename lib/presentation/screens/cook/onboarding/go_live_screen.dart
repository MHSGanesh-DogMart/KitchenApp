import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/onboarding_provider.dart';
import '_onboarding_widgets.dart';
import 'status_screens.dart';

/// Cook · Go live review (6 of 6).
class CookGoLiveScreen extends StatelessWidget {
  const CookGoLiveScreen({super.key});

  Future<void> _onSubmit(BuildContext context) async {
    final onboarding = Provider.of<OnboardingProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    final status = await onboarding.submit(auth);
    if (status != null && context.mounted) {
      handleStatusNavigation(context, status);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnboardingProvider>(context);

    return OnboardingScaffold(
      step: 4,
      totalSteps: 4,
      kicker: 'All set',
      title: 'You are ready\nto go live ✨',
      subtitle:
          'Our team will verify your docs in ~24h. You can preview your storefront now.',
      gradient: const [
        Color(0xFFE1F2EC),
        Color(0xFFCFE9DC),
        Color(0xFFF1F8F4),
      ],
      ctaLabel: provider.submitting ? 'Submitting...' : 'Submit & go live',
      ctaEnabled: !provider.submitting,
      onCta: provider.submitting ? null : () => _onSubmit(context),
      body: [
        // ── Big celebration card ──
        _CelebrationCard(),

        SizedBox(height: 24.h),
        OnboardingSection(
          title: "Here's what you submitted",
          icon: Icons.fact_check_outlined,
        ),
        _ChecklistGroup(items: [
          _Item(
            icon: Icons.storefront_outlined,
            title: 'Storefront & Branding',
            value: '${provider.kitchenName} · Banner & ${provider.cuisines.length} cuisines selected',
          ),
          _Item(
            icon: Icons.person_outline_rounded,
            title: 'Identity & KYC',
            value: '${provider.name} · Selfie, Aadhaar & PAN uploaded',
          ),
          _Item(
            icon: Icons.home_work_outlined,
            title: 'Location & Address',
            value: '${provider.isVegOnly ? "100% Vegetarian" : "Standard Kitchen"} · ${provider.city}, ${provider.state} · GPS pinned',
          ),
          _Item(
            icon: Icons.verified_user_outlined,
            title: 'FSSAI Status',
            value: provider.hasExistingFssai
                ? 'Existing FSSAI: ${provider.fssaiNumber} (Expiry: ${provider.fssaiExpiry})'
                : 'FSSAI Basic filing registration (~₹100/yr)',
          ),
          _Item(
            icon: Icons.assignment_turned_in_outlined,
            title: 'Operations & consent',
            value: 'Capacity: ${provider.capacity} orders/day · Consents signed',
          ),
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
                    children: [
                      const TextSpan(text: "You'll go live as "),
                      TextSpan(
                        text: provider.tier == 1 ? 'Tier 1 Home Chef' : 'Tier 2 Verified Kitchen',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      TextSpan(
                        text: provider.tier == 1
                            ? '. Your storefront will show "Home Kitchen — FSSAI Basic" once verified.'
                            : '. Your storefront will show "Verified Kitchen — Licensed" once verified.',
                      ),
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
