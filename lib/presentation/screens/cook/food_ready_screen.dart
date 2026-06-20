import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../auth/_auth_widgets.dart';
import '../discover/_discover_widgets.dart';

/// Mockup 57 — Cook · Food ready / send rider.
class FoodReadyScreen extends StatelessWidget {
  const FoodReadyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const PlainAppBar(title: '#PD4821'),
                Expanded(
                  child: ListView(
                    padding:
                        EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 110.h),
                    children: [
                      // Customer summary
                      Container(
                        padding: EdgeInsets.all(13.w),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: AppColors.line),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 17.r,
                              backgroundColor: AppColors.tier1,
                              child: Text(
                                'PM',
                                style: GoogleFonts.spaceGrotesk(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(width: 11.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Priya M. · #PD4821',
                                    style: GoogleFonts.inter(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                  Text(
                                    '1× Veg Thali',
                                    style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      color: AppColors.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const FlatChip(
                              label: 'Accepted',
                              bg: AppColors.primarySoft,
                              fg: AppColors.primaryDark,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      // Cooking status card
                      Container(
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: AppColors.line),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cooking status',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                FlatChip(
                                  label: '✓ Accepted',
                                  bg: AppColors.secondarySoft,
                                  fg: AppColors.secondary,
                                ),
                                SizedBox(width: 8.w),
                                FlatChip(
                                  label: '● Cooking',
                                  bg: AppColors.primary,
                                  fg: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      // Hint card
                      Container(
                        padding: EdgeInsets.all(13.w),
                        decoration: BoxDecoration(
                          color: AppColors.secondarySoft,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.directions_bike_rounded,
                                color: AppColors.secondary, size: 18.sp),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5.sp,
                                    color: AppColors.secondary,
                                    height: 1.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  children: const [
                                    TextSpan(text: 'Tap '),
                                    TextSpan(
                                      text: 'Food ready',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                    TextSpan(
                                        text:
                                            ' and we auto-send a rider to your door.'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: StickyBar(
              child: AuthButton(
                label: 'Mark food ready → send rider',
                icon: Icons.send_rounded,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Rider dispatched 🚴')),
                  );
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
