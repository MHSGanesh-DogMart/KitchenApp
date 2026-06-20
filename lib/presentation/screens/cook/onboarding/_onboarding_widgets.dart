import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../auth/_auth_widgets.dart';
import '../../discover/_discover_widgets.dart';

/// ────────────────────────────────────────────────────────────────
///  Premium shared design system for Chef onboarding screens.
///
///  Use OnboardingScaffold as the page wrapper. It renders a
///  gradient hero header (back + step pill + title + subtitle +
///  segmented progress) above a scrollable body, with a sticky
///  bottom CTA bar.
/// ────────────────────────────────────────────────────────────────

class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    super.key,
    required this.step,
    required this.totalSteps,
    required this.kicker,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.ctaLabel,
    required this.onCta,
    this.gradient,
    this.ctaEnabled = true,
  });

  final int step;
  final int totalSteps;
  final String kicker;
  final String title;
  final String subtitle;
  final List<Widget> body;
  final String ctaLabel;
  final VoidCallback? onCta;
  final List<Color>? gradient;
  final bool ctaEnabled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
            children: [
              OnboardingHeader(
                step: step,
                totalSteps: totalSteps,
                kicker: kicker,
                title: title,
                subtitle: subtitle,
                gradient: gradient,
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 120.h),
                  children: body,
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: PremiumStickyBar(
              child: PremiumCta(
                label: ctaLabel,
                onTap: onCta,
                enabled: ctaEnabled,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Gradient hero header with back button, step pill, title, subtitle,
/// and segmented progress bar.
class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({
    super.key,
    required this.step,
    required this.totalSteps,
    required this.kicker,
    required this.title,
    required this.subtitle,
    this.gradient,
  });

  final int step;
  final int totalSteps;
  final String kicker;
  final String title;
  final String subtitle;
  final List<Color>? gradient;

  @override
  Widget build(BuildContext context) {
    final colors =
        gradient ??
        const [Color(0xFFFFF1E9), Color(0xFFFFE3D2), Color(0xFFFFF7F1)];
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colors,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _GlassBackButton(),
                    const Spacer(),
                    _StepPill(step: step, totalSteps: totalSteps),
                  ],
                ),
                SizedBox(height: 22.h),
                Text(
                  kicker.toUpperCase(),
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.6,
                    color: AppColors.primaryDark,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  title,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -.8,
                    height: 1.05,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12.5.sp,
                    color: AppColors.inkSoft,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 18.h),
                SegmentedProgress(step: step, totalSteps: totalSteps),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Tiny pill — "STEP 2 / 6"
class _StepPill extends StatelessWidget {
  const _StepPill({required this.step, required this.totalSteps});
  final int step;
  final int totalSteps;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .65),
        borderRadius: BorderRadius.circular(99.r),
        border: Border.all(color: AppColors.line),
      ),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.spaceGrotesk(
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
            letterSpacing: .4,
          ),
          children: [
            const TextSpan(text: 'STEP '),
            TextSpan(
              text: '$step',
              style: TextStyle(color: AppColors.primary),
            ),
            TextSpan(text: ' / $totalSteps'),
          ],
        ),
      ),
    );
  }
}

class _GlassBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: .7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
        side: BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: () => Navigator.maybePop(context),
        child: SizedBox(
          width: 42.w,
          height: 42.w,
          child: Icon(
            Icons.arrow_back_rounded,
            size: 19.sp,
            color: AppColors.ink,
          ),
        ),
      ),
    );
  }
}

/// 6-segment progress bar — filled segments = completed steps.
class SegmentedProgress extends StatelessWidget {
  const SegmentedProgress({
    super.key,
    required this.step,
    required this.totalSteps,
  });
  final int step;
  final int totalSteps;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (i) {
        final active = i < step;
        final current = i == step - 1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < totalSteps - 1 ? 5.w : 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              height: 5.h,
              decoration: BoxDecoration(
                color: active
                    ? AppColors.primary
                    : Colors.white.withValues(alpha: .55),
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(
                  color: current ? AppColors.primary : Colors.transparent,
                  width: current ? 1.4 : 0,
                ),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: .35),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ────────────────────────────────────────────────────────────────
//  Premium sticky bottom bar with pill-shaped CTA
// ────────────────────────────────────────────────────────────────

class PremiumStickyBar extends StatelessWidget {
  const PremiumStickyBar({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: .06),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 16.h),
          child: child,
        ),
      ),
    );
  }
}

class PremiumCta extends StatelessWidget {
  const PremiumCta({
    super.key,
    required this.label,
    required this.onTap,
    this.enabled = true,
  });
  final String label;
  final VoidCallback? onTap;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    final disabled = !enabled || onTap == null;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: disabled ? .5 : 1,
      child: Material(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(99.r),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(99.r),
          onTap: disabled ? null : onTap,
          child: Container(
            height: 56.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99.r),
              boxShadow: disabled
                  ? null
                  : [
                      BoxShadow(
                        color: AppColors.ink.withValues(alpha: .25),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: .2,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 18.sp,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────
//  Section header — title + optional accent line
// ────────────────────────────────────────────────────────────────

class OnboardingSection extends StatelessWidget {
  const OnboardingSection({
    super.key,
    required this.title,
    this.hint,
    this.icon,
  });
  final String title;
  final String? hint;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(8.r),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 15.sp, color: AppColors.primaryDark),
            ),
            SizedBox(width: 10.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                    letterSpacing: -.2,
                  ),
                ),
                if (hint != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    hint!,
                    style: GoogleFonts.inter(
                      fontSize: 11.5.sp,
                      color: AppColors.muted,
                      height: 1.45,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────
//  Premium text field (floating label, soft border, focus glow)
// ────────────────────────────────────────────────────────────────

class PremiumField extends StatefulWidget {
  const PremiumField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
  });
  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final IconData? suffixIcon;
  @override
  State<PremiumField> createState() => _PremiumFieldState();
}

class _PremiumFieldState extends State<PremiumField> {
  final _focus = FocusNode();
  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focus.hasFocus;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label.toUpperCase(),
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w700,
                    color: focused ? AppColors.primaryDark : AppColors.muted,
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(height: 2.h),
                TextFormField(
                  controller: widget.controller,
                  focusNode: _focus,
                  keyboardType:
                      widget.keyboardType ??
                      (widget.maxLines > 1 ? TextInputType.multiline : null),
                  inputFormatters: widget.inputFormatters,
                  textCapitalization: widget.textCapitalization,
                  maxLines: widget.maxLines,
                  readOnly: widget.readOnly,
                  onTap: widget.onTap,
                  cursorColor: AppColors.primary,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: widget.hint,
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.muted,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.suffixIcon != null)
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Icon(
                widget.suffixIcon,
                color: AppColors.muted,
                size: 18.sp,
              ),
            ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────
//  Upload tile — for selfie, docs, kitchen photos, dish photo
// ────────────────────────────────────────────────────────────────

enum UploadStyle { hero, doc, square }

class UploadTile extends StatelessWidget {
  const UploadTile({
    super.key,
    required this.title,
    required this.helper,
    required this.icon,
    required this.uploaded,
    required this.onTap,
    this.style = UploadStyle.doc,
    this.required = false,
  });
  final String title;
  final String helper;
  final IconData icon;
  final bool uploaded;
  final VoidCallback onTap;
  final UploadStyle style;
  final bool required;

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case UploadStyle.hero:
        return _hero();
      case UploadStyle.square:
        return _square();
      case UploadStyle.doc:
        return _doc();
    }
  }

  Widget _hero() {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: uploaded
                ? [
                    AppColors.secondarySoft,
                    AppColors.secondarySoft.withValues(alpha: .6),
                  ]
                : [const Color(0xFFFFF5EE), const Color(0xFFFFEFE3)],
          ),
          border: Border.all(
            color: uploaded ? AppColors.secondary : AppColors.line,
            width: uploaded ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 18.w),
            child: Row(
              children: [
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    color: uploaded ? AppColors.secondary : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (uploaded ? AppColors.secondary : AppColors.ink)
                            .withValues(alpha: .15),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    uploaded ? Icons.check_rounded : icon,
                    color: uploaded ? Colors.white : AppColors.primary,
                    size: 30.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              uploaded ? '$title added' : title,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                                letterSpacing: -.2,
                              ),
                            ),
                          ),
                          if (required && !uploaded) ...[
                            SizedBox(width: 8.w),
                            _RequiredDot(),
                          ],
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        uploaded ? 'Tap to retake' : helper,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: AppColors.inkSoft,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _doc() {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: uploaded ? AppColors.secondary : AppColors.line,
          width: uploaded ? 1.4 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(13.w),
          child: Row(
            children: [
              Container(
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  color: uploaded ? AppColors.secondarySoft : AppColors.cream,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
                child: Icon(
                  uploaded ? Icons.check_rounded : icon,
                  color: uploaded ? AppColors.secondary : AppColors.muted,
                  size: 22.sp,
                ),
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
                            title,
                            style: GoogleFonts.inter(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                        if (required && !uploaded) ...[
                          SizedBox(width: 7.w),
                          _RequiredDot(),
                        ],
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      uploaded ? 'Uploaded · tap to replace' : helper,
                      style: GoogleFonts.inter(
                        fontSize: 11.5.sp,
                        color: uploaded ? AppColors.secondary : AppColors.muted,
                        fontWeight: uploaded
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: uploaded
                      ? AppColors.secondarySoft
                      : AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(99.r),
                ),
                child: Text(
                  uploaded ? 'Replace' : 'Upload',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: uploaded
                        ? AppColors.secondary
                        : AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _square() {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: uploaded
                ? [
                    AppColors.secondarySoft,
                    AppColors.secondarySoft.withValues(alpha: .55),
                  ]
                : [const Color(0xFFFFF6EF), const Color(0xFFFFEEDF)],
          ),
          border: Border.all(
            color: uploaded ? AppColors.secondary : AppColors.line,
            width: uploaded ? 1.4 : 1,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: SizedBox(
            height: 130.h,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 44.w,
                        height: 44.w,
                        decoration: BoxDecoration(
                          color: uploaded ? AppColors.secondary : Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  (uploaded
                                          ? AppColors.secondary
                                          : AppColors.ink)
                                      .withValues(alpha: .12),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          uploaded ? Icons.check_rounded : icon,
                          color: uploaded ? Colors.white : AppColors.primary,
                          size: 22.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                            color: uploaded
                                ? AppColors.secondary
                                : AppColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (required && !uploaded)
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: _RequiredDot(small: true),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RequiredDot extends StatelessWidget {
  const _RequiredDot({this.small = false});
  final bool small;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6.w : 7.w,
        vertical: small ? 2.h : 3.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(99.r),
      ),
      child: Text(
        '*',
        style: GoogleFonts.spaceGrotesk(
          fontSize: small ? 11.sp : 12.sp,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          height: 1,
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────
//  Choice / pill picker block
// ────────────────────────────────────────────────────────────────

class ChoicePicker extends StatelessWidget {
  const ChoicePicker({
    super.key,
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final List<String> options;
  final String value;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.spaceGrotesk(
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.muted,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: options.map((o) {
            return FilterChip2(
              label: o,
              selected: o == value,
              onTap: () => onChanged(o),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class MultiChoicePicker extends StatelessWidget {
  const MultiChoicePicker({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onToggle,
  });
  final String label;
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.spaceGrotesk(
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.muted,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: options.map((o) {
            return FilterChip2(
              label: o,
              selected: selected.contains(o),
              onTap: () => onToggle(o),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────────
//  Consent checkbox tile (premium)
// ────────────────────────────────────────────────────────────────

class ConsentTile extends StatelessWidget {
  const ConsentTile({
    super.key,
    required this.checked,
    required this.title,
    required this.body,
    required this.onTap,
    this.accent,
  });
  final bool checked;
  final String title;
  final String body;
  final VoidCallback onTap;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final c = accent ?? AppColors.secondary;
    final cSoft = accent != null
        ? accent!.withValues(alpha: .15)
        : AppColors.secondarySoft;
    return Material(
      color: checked ? cSoft : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: checked ? c : AppColors.line,
          width: checked ? 1.4 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(14.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 22.w,
                height: 22.w,
                margin: EdgeInsets.only(top: 2.h),
                decoration: BoxDecoration(
                  color: checked ? c : Colors.transparent,
                  borderRadius: BorderRadius.circular(7.r),
                  border: Border.all(
                    color: checked ? c : AppColors.line,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: checked
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 14,
                      )
                    : null,
              ),
              SizedBox(width: 13.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        letterSpacing: -.1,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      body,
                      style: GoogleFonts.inter(
                        fontSize: 11.5.sp,
                        color: AppColors.inkSoft,
                        height: 1.5,
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

// ────────────────────────────────────────────────────────────────
//  Info callout (soft tinted card with icon + text)
// ────────────────────────────────────────────────────────────────

class InfoCallout extends StatelessWidget {
  const InfoCallout({
    super.key,
    required this.text,
    this.icon = Icons.info_outline_rounded,
    this.accent,
    this.accentSoft,
  });
  final String text;
  final IconData icon;
  final Color? accent;
  final Color? accentSoft;
  @override
  Widget build(BuildContext context) {
    final a = accent ?? AppColors.primary;
    final s = accentSoft ?? AppColors.primarySoft;
    return Container(
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: s,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: a, size: 17.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: a,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
