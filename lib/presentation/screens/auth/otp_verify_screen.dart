import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routing/route_names.dart';
import '_auth_widgets.dart';

/// Mockups 04 + 05 — OTP verify (with error state).
class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key, required this.phone});
  final String phone;
  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  static const _length = 4;
  late final List<TextEditingController> _ctrls =
      List.generate(_length, (_) => TextEditingController());
  late final List<FocusNode> _focs =
      List.generate(_length, (_) => FocusNode());

  bool _error = false;
  int _triesLeft = 3;
  int _secondsLeft = 24;
  Timer? _t;
  bool _verifying = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focs.first.requestFocus();
    });
  }

  void _startCountdown() {
    _t?.cancel();
    setState(() => _secondsLeft = 24);
    _t = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) t.cancel();
    });
  }

  String get _code => _ctrls.map((c) => c.text).join();

  Future<void> _verify() async {
    if (_code.length < _length) return;
    setState(() => _verifying = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    // Treat 1234 as the only "correct" code for the demo.
    if (_code == '1234') {
      // First-time cook → tier picker. (Returning cooks could go
      // straight to RouteNames.cookDashboard once we wire auth state.)
      Navigator.pushReplacementNamed(context, RouteNames.cookTier);
    } else {
      setState(() {
        _error = true;
        _verifying = false;
        _triesLeft--;
      });
    }
  }

  void _onDigit(int i, String v) {
    if (_error) setState(() => _error = false);
    if (v.isNotEmpty && i < _length - 1) {
      _focs[i + 1].requestFocus();
    } else if (v.isEmpty && i > 0) {
      _focs[i - 1].requestFocus();
    }
    if (_code.length == _length) _verify();
  }

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    for (final f in _focs) {
      f.dispose();
    }
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canResend = _secondsLeft <= 0;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 8.h, 0, 0),
                child: Row(
                  children: [
                    const AuthBackButton(),
                    SizedBox(width: 12.w),
                    Text(
                      'Verify',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              const AuthTitle('Enter the code', fontSize: 22),
              SizedBox(height: 8.h),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: AppColors.inkSoft,
                  ),
                  children: [
                    TextSpan(text: 'Sent to ${widget.phone}  ·  '),
                    TextSpan(
                      text: 'Change',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: null,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 22.h),

              // 4 OTP boxes
              Row(
                children: List.generate(_length, (i) {
                  final hasError = _error;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i < _length - 1 ? 8.w : 0),
                      child: _OtpBox(
                        controller: _ctrls[i],
                        focus: _focs[i],
                        error: hasError,
                        onChanged: (v) => _onDigit(i, v),
                      ),
                    ),
                  );
                }),
              ),

              if (_error) ...[
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Icon(Icons.error_outline_rounded,
                        color: AppColors.error, size: 16.sp),
                    SizedBox(width: 6.w),
                    Text(
                      'Incorrect code. $_triesLeft tries left.',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ],

              SizedBox(height: 14.h),
              Row(
                children: [
                  Text(
                    canResend
                        ? ''
                        : 'Resend in 0:${_secondsLeft.toString().padLeft(2, "0")}',
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: AppColors.inkSoft,
                    ),
                  ),
                  if (!canResend)
                    Text(
                      '  ·  ',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        color: AppColors.inkSoft,
                      ),
                    ),
                  GestureDetector(
                    onTap: canResend ? _startCountdown : null,
                    child: Text(
                      canResend ? 'Resend code' : 'Resend',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: canResend
                            ? AppColors.primaryDark
                            : AppColors.muted,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),
              AuthButton(
                label: _error ? 'Try again' : 'Verify',
                loading: _verifying,
                onPressed: _code.length == _length && !_verifying
                    ? _verify
                    : null,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.controller,
    required this.focus,
    required this.error,
    required this.onChanged,
  });
  final TextEditingController controller;
  final FocusNode focus;
  final bool error;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final borderColor = error
        ? AppColors.error
        : focus.hasFocus
            ? AppColors.primary
            : AppColors.line;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(13.r),
      ),
      child: TextField(
        controller: controller,
        focusNode: focus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: onChanged,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 26.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
        cursorColor: AppColors.primary,
      ),
    );
  }
}
