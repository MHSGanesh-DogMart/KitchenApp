import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../discover/_discover_widgets.dart';

/// Mockup 61 — Cook · Reviews.
class CookReviewsScreen extends StatelessWidget {
  const CookReviewsScreen({super.key});

  static const _ratings = <(int, double)>[
    (5, 0.88),
    (4, 0.09),
    (3, 0.02),
    (2, 0.01),
    (1, 0.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const PlainAppBar(title: 'Reviews'),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 24.h),
                children: [
                  // Summary card
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              '4.9',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                                letterSpacing: -.6,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '210 reviews',
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            children: _ratings
                                .map((r) => Padding(
                                      padding: EdgeInsets.only(bottom: 4.h),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 14.w,
                                            child: Text(
                                              '${r.$1}',
                                              style: GoogleFonts.inter(
                                                fontSize: 10.sp,
                                                color: AppColors.muted,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Icon(Icons.star_rounded,
                                              size: 11.sp,
                                              color:
                                                  const Color(0xFFF5A623)),
                                          SizedBox(width: 7.w),
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(99.r),
                                              child: Container(
                                                height: 5.h,
                                                color: AppColors.cream,
                                                child: FractionallySizedBox(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  widthFactor: r.$2,
                                                  child: Container(
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),
                  _ReviewCard(
                    initials: 'AP',
                    name: 'Anita P.',
                    rating: 5.0,
                    body: 'Tastes exactly like home. On time too!',
                  ),
                  SizedBox(height: 8.h),
                  _ReviewCard(
                    initials: 'RK',
                    name: 'Rohit K.',
                    rating: 4.5,
                    body: 'Great thali, a bit spicy for me.',
                  ),
                  SizedBox(height: 8.h),
                  _ReviewCard(
                    initials: 'MM',
                    name: 'Meera M.',
                    rating: 5.0,
                    body: 'Best dal I\'ve had in years. Will reorder.',
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

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.initials,
    required this.name,
    required this.rating,
    required this.body,
  });
  final String initials;
  final String name;
  final double rating;
  final String body;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 13.r,
                backgroundColor: AppColors.tier1,
                child: Text(
                  initials,
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 9.w),
              Expanded(
                child: Text(
                  name,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
              FlatChip(
                label: '★ ${rating.toStringAsFixed(1)}',
                bg: AppColors.surface,
                fg: AppColors.inkSoft,
                border: true,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            body,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppColors.inkSoft,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
