import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '_onboarding_widgets.dart';

/// Cook onboarding · Choose tier (1 of 6).
class CookTierScreen extends StatefulWidget {
  const CookTierScreen({super.key});
  @override
  State<CookTierScreen> createState() => _CookTierScreenState();
}

class _CookTierScreenState extends State<CookTierScreen> {
  int _tier = 1;

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      step: 1,
      totalSteps: 6,
      kicker: 'Welcome aboard',
      title: "Choose how\nyou'll sell",
      subtitle: 'Most home cooks pick Tier 1 — it has the simplest onboarding.',
      ctaLabel: _tier == 1
          ? 'Continue as Home Chef'
          : 'Continue as Verified Kitchen',
      onCta: () => Navigator.pushNamed(context, RouteNames.cookIdentity),
      body: [
        _TierCard(
          selected: _tier == 1,
          recommended: true,
          accent: AppColors.tier1,
          accentSoft: AppColors.tier1Soft,
          icon: '🏠',
          kicker: 'TIER 1 · HOME CHEF',
          title: 'For home cooks',
          sub:
              'Aadhaar, PAN, kitchen photos, bank account, FSSAI Basic — we help you register.',
          callout: 'No FSSAI yet? We register you for ~₹100/yr.',
          onTap: () => setState(() => _tier = 1),
        ),
        SizedBox(height: 12.h),
        _TierCard(
          selected: _tier == 2,
          recommended: false,
          accent: AppColors.tier2,
          accentSoft: AppColors.tier2Soft,
          icon: '🏢',
          kicker: 'TIER 2 · VERIFIED KITCHEN',
          title: 'For licensed kitchens',
          sub:
              'FSSAI Licence + GST + business verification. Bigger order limits.',
          onTap: () => setState(() => _tier = 2),
        ),
        SizedBox(height: 16.h),
        InfoCallout(
          icon: Icons.verified_user_outlined,
          text: 'You can upgrade your tier anytime from Settings.',
        ),
      ],
    );
  }
}

class _TierCard extends StatelessWidget {
  const _TierCard({
    required this.selected,
    required this.recommended,
    required this.accent,
    required this.accentSoft,
    required this.icon,
    required this.kicker,
    required this.title,
    required this.sub,
    required this.onTap,
    this.callout,
  });
  final bool selected;
  final bool recommended;
  final Color accent;
  final Color accentSoft;
  final String icon;
  final String kicker;
  final String title;
  final String sub;
  final String? callout;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: selected ? accent : AppColors.line,
          width: selected ? 1.8 : 1,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: accent.withValues(alpha: .18),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ]
            : [
                BoxShadow(
                  color: AppColors.ink.withValues(alpha: .03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: accentSoft,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(icon, style: TextStyle(fontSize: 22.sp)),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  kicker,
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 9.5.sp,
                                    fontWeight: FontWeight.w800,
                                    color: accent,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              if (recommended) ...[
                                SizedBox(width: 6.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 6.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    'POPULAR',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 8.5.sp,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: .8,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            title,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                              letterSpacing: -.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: 24.w,
                      height: 24.w,
                      decoration: BoxDecoration(
                        color: selected ? accent : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected ? accent : AppColors.line,
                          width: 2,
                        ),
                      ),
                      child: selected
                          ? const Icon(Icons.check_rounded,
                              color: Colors.white, size: 14)
                          : null,
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  sub,
                  style: GoogleFonts.inter(
                    fontSize: 12.5.sp,
                    color: AppColors.inkSoft,
                    height: 1.55,
                  ),
                ),
                if (callout != null) ...[
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.all(11.w),
                    decoration: BoxDecoration(
                      color: accentSoft,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('✨', style: TextStyle(fontSize: 13.sp)),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            callout!,
                            style: GoogleFonts.inter(
                              fontSize: 11.5.sp,
                              color: accent,
                              height: 1.45,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
