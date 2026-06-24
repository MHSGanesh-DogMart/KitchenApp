import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routing/route_names.dart';
import '_auth_widgets.dart';

/// Mockup 02 — Intro carousel (3 pages).
class IntroCarouselScreen extends StatefulWidget {
  const IntroCarouselScreen({super.key});
  @override
  State<IntroCarouselScreen> createState() => _IntroCarouselScreenState();
}

class _IntroCarouselScreenState extends State<IntroCarouselScreen> {
  final _ctrl = PageController();
  int _page = 0;

  static const _slides = <_Slide>[
    _Slide(
      emoji: '👩‍🍳',
      gradient: [Color(0xFFFFD9C8), Color(0xFFFFC4AC)],
      title: 'Turn your kitchen\ninto a business',
      body: 'Cook the food you love from home and earn every week.',
    ),
    _Slide(
      emoji: '🍳',
      gradient: [Color(0xFFD6EEDF), Color(0xFFBFE3CC)],
      title: 'Cook on\nyour terms',
      body: 'You set the menu, the hours, and how many orders you take.',
    ),
    _Slide(
      emoji: '💸',
      gradient: [Color(0xFFFBEAC6), Color(0xFFF2DCA6)],
      title: 'Get paid\nweekly',
      body: 'Transparent earnings and on-time payouts, straight to your bank.',
    ),
  ];

  void _next() {
    if (_page == _slides.length - 1) {
      Navigator.pushReplacementNamed(context, RouteNames.login);
    } else {
      _ctrl.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          Row(
            children: [
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, RouteNames.login),
                child: Text(
                  'Skip',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
            ],
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
          child: Column(
            children: [
              // Pages
              Expanded(
                child: PageView.builder(
                  controller: _ctrl,
                  itemCount: _slides.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (_, i) => _SlideView(slide: _slides[i]),
                ),
              ),

              // Dots
              Padding(
                padding: EdgeInsets.symmetric(vertical: 18.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_slides.length, (i) {
                    final active = i == _page;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      margin: EdgeInsets.symmetric(horizontal: 3.w),
                      height: 6.h,
                      width: active ? 22.w : 6.w,
                      decoration: BoxDecoration(
                        color: active ? AppColors.primary : AppColors.line,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    );
                  }),
                ),
              ),

              AuthButton(
                label: _page == _slides.length - 1 ? 'Get started' : 'Next',
                onPressed: _next,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Slide {
  const _Slide({
    required this.emoji,
    required this.gradient,
    required this.title,
    required this.body,
  });
  final String emoji;
  final List<Color> gradient;
  final String title;
  final String body;
}

class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide});
  final _Slide slide;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 220.w,
          height: 220.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: slide.gradient,
            ),
            borderRadius: BorderRadius.circular(32.r),
            boxShadow: [
              BoxShadow(
                color: slide.gradient.last.withValues(alpha: .35),
                blurRadius: 32,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(slide.emoji, style: TextStyle(fontSize: 90.sp)),
        ),
        SizedBox(height: 32.h),
        Text(
          slide.title,
          textAlign: TextAlign.center,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 26.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: -.8,
            height: 1.1,
            color: AppColors.ink,
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: 260.w,
          child: Text(
            slide.body,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13.5.sp,
              color: AppColors.inkSoft,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }
}
