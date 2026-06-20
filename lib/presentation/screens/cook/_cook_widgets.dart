import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';

/// Thin coral progress bar used across cook onboarding screens.
class CookProgress extends StatelessWidget {
  const CookProgress({super.key, required this.fraction});
  /// 0.0 → 1.0
  final double fraction;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.r),
      child: Stack(
        children: [
          Container(height: 5.h, color: AppColors.cream),
          AnimatedFractionallySizedBox(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            alignment: Alignment.centerLeft,
            widthFactor: fraction,
            child: Container(
              height: 5.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "Card" style labeled field used in cook onboarding (read-only-ish look).
class CookField extends StatelessWidget {
  const CookField({
    super.key,
    required this.label,
    required this.value,
    this.focused = false,
    this.trailing,
  });
  final String label;
  final String value;
  final bool focused;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 10.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(
          color: focused ? AppColors.primary : AppColors.line,
          width: focused ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(13.r),
        boxShadow: focused
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: .12),
                  spreadRadius: 3,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.muted,
                    letterSpacing: .8,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// Compact toggle row card (used by Today's menu / Cook settings).
class CookToggleCard extends StatelessWidget {
  const CookToggleCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.leading,
  });
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget? leading;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          ?leading,
          if (leading != null) SizedBox(width: 11.w),
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
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.success,
            inactiveTrackColor: AppColors.line,
            inactiveThumbColor: Colors.white,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
