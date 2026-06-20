import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';

/// Standard full-width CTA used across Phase 2 auth screens.
class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AuthBtnVariant.primary,
    this.icon,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AuthBtnVariant variant;
  final IconData? icon;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null || loading;

    final (bg, fg, border) = switch (variant) {
      AuthBtnVariant.primary => (AppColors.primary, Colors.white, null),
      AuthBtnVariant.ink => (AppColors.ink, Colors.white, null),
      AuthBtnVariant.ghost => (
          AppColors.surface,
          AppColors.ink,
          AppColors.line,
        ),
      AuthBtnVariant.onDark => (Colors.white, AppColors.ink, null),
      AuthBtnVariant.onDarkSoft => (
          Colors.white.withValues(alpha: .14),
          Colors.white,
          null,
        ),
    };

    final radius = BorderRadius.circular(16.r);
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: disabled && !loading ? .55 : 1,
      child: Material(
        color: bg,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: disabled ? null : onPressed,
          child: Container(
            height: 52.h,
            alignment: Alignment.center,
            decoration: border == null
                ? null
                : BoxDecoration(
                    borderRadius: radius,
                    border: Border.all(color: border, width: 1.5),
                  ),
            child: loading
                ? SizedBox(
                    width: 20.r,
                    height: 20.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation(fg),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: fg, size: 18.sp),
                        SizedBox(width: 8.w),
                      ],
                      Text(
                        label,
                        style: GoogleFonts.spaceGrotesk(
                          color: fg,
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w600,
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

enum AuthBtnVariant { primary, ink, ghost, onDark, onDarkSoft }

/// Small "kicker" label used above big titles.
class AuthKicker extends StatelessWidget {
  const AuthKicker(this.text, {super.key, this.color});
  final String text;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.spaceGrotesk(
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
        color: color ?? AppColors.primaryDark,
      ),
    );
  }
}

/// Display title in Space Grotesk for auth screens.
class AuthTitle extends StatelessWidget {
  const AuthTitle(this.text, {super.key, this.color, this.fontSize});
  final String text;
  final Color? color;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.spaceGrotesk(
        fontSize: fontSize ?? 27.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: -1,
        height: 1.06,
        color: color ?? AppColors.ink,
      ),
    );
  }
}

/// Standard back button used in auth.
class AuthBackButton extends StatelessWidget {
  const AuthBackButton({super.key, this.onTap, this.color});
  final VoidCallback? onTap;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(
          color: color == null ? AppColors.line : Colors.transparent,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap ?? () => Navigator.maybePop(context),
        child: SizedBox(
          width: 38.w,
          height: 38.w,
          child: Icon(
            Icons.arrow_back_rounded,
            size: 18.sp,
            color: color == null ? AppColors.ink : Colors.white,
          ),
        ),
      ),
    );
  }
}
