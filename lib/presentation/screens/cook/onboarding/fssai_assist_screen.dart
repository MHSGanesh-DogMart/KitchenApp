import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../providers/onboarding_provider.dart';
import '_onboarding_widgets.dart';

/// Cook · FSSAI assist (3b of 6).
class CookFssaiAssistScreen extends StatelessWidget {
  const CookFssaiAssistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      step: 3,
      totalSteps: 5,
      kicker: 'FSSAI registration',
      title: "We'll get you\nFSSAI ready",
      subtitle:
          "No FSSAI yet? No problem. We'll register you for FSSAI Basic — ~₹100/yr.",
      gradient: const [
        Color(0xFFFBEFD7),
        Color(0xFFF7DFA5),
        Color(0xFFFFF7E7),
      ],
      ctaLabel: 'Register me for FSSAI Basic',
      onCta: () {
        final p = Provider.of<OnboardingProvider>(context, listen: false);
        p.updateField(hasExistingFssai: false);
        Navigator.pushNamed(context, RouteNames.cookOperations);
      },
      body: [
        OnboardingSection(
          title: 'How it works',
          hint: 'No paperwork, no government visits.',
          icon: Icons.verified_user_outlined,
        ),
        _StepRail(
          steps: const [
            _RailStep(
              done: true,
              title: 'Pulled from your profile',
              body: 'Name, address, photos — already submitted in Step 2 & 3.',
            ),
            _RailStep(
              active: true,
              title: 'We file your Basic Registration',
              body: 'Our compliance team submits to FSSAI gov portal.',
            ),
            _RailStep(
              title: "You're verified in ~24 hours",
              body: 'You can take orders the moment your status flips to live.',
            ),
          ],
        ),
        SizedBox(height: 20.h),
        InfoCallout(
          icon: Icons.lightbulb_outline_rounded,
          text:
              'The ~₹100 fee is a one-time government charge. Renewable yearly. You stay in control.',
          accent: AppColors.tier1,
          accentSoft: AppColors.tier1Soft,
        ),
        SizedBox(height: 14.h),
        _AlreadyHave(),
      ],
    );
  }
}

class _AlreadyHave extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final p = Provider.of<OnboardingProvider>(context, listen: false);
        p.updateField(
          hasExistingFssai: true,
          fssaiNumber: '23624003000124',
          fssaiExpiry: '2027-12-31',
        );
        ToastService.success('Existing FSSAI license registered.');
        Navigator.pushNamed(context, RouteNames.cookOperations);
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'I already have an FSSAI licence',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(Icons.arrow_forward_rounded,
                size: 15.sp, color: AppColors.primaryDark),
          ],
        ),
      ),
    );
  }
}

class _RailStep {
  const _RailStep({
    required this.title,
    required this.body,
    this.done = false,
    this.active = false,
  });
  final String title;
  final String body;
  final bool done;
  final bool active;
}

class _StepRail extends StatelessWidget {
  const _StepRail({required this.steps});
  final List<_RailStep> steps;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (i) {
        final s = steps[i];
        final isLast = i == steps.length - 1;
        final color = s.done
            ? AppColors.secondary
            : s.active
                ? AppColors.primary
                : AppColors.line;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      color: s.done || s.active ? color : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: color, width: 2),
                      boxShadow: (s.done || s.active)
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: .35),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: s.done
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 16)
                        : s.active
                            ? Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              )
                            : Text(
                                '${i + 1}',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.muted,
                                ),
                              ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2.w,
                        margin: EdgeInsets.symmetric(vertical: 4.h),
                        color: AppColors.line,
                      ),
                    ),
                ],
              ),
              SizedBox(width: 13.w),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.title,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: s.done || s.active
                              ? AppColors.ink
                              : AppColors.muted,
                          letterSpacing: -.1,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        s.body,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: AppColors.inkSoft,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
