import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routing/route_names.dart';
import '../auth/_auth_widgets.dart';
import '../discover/_discover_widgets.dart';

/// Mockup 56 — Cook · Incoming order detail.
class IncomingOrderScreen extends StatelessWidget {
  const IncomingOrderScreen({super.key});

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
                      // Customer card
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
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.sp,
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
                                    'Priya M.',
                                    style: GoogleFonts.inter(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                  Text(
                                    'Koramangala 5th · 0.4 km',
                                    style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      color: AppColors.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const FlatChip(
                              label: 'New',
                              bg: AppColors.primarySoft,
                              fg: AppColors.primaryDark,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      // Items card
                      Container(
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: AppColors.line),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Veg Thali × 1',
                                  style: GoogleFonts.inter(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink,
                                  ),
                                ),
                                Text(
                                  '₹120',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: AppColors.cream,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text(
                                'Note: less oil, no chilli',
                                style: GoogleFonts.inter(
                                  fontSize: 11.5.sp,
                                  color: AppColors.inkSoft,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      // Accept hint
                      Container(
                        padding: EdgeInsets.all(13.w),
                        decoration: BoxDecoration(
                          color: AppColors.tier1Soft,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.schedule_rounded,
                                color: AppColors.tier1, size: 17.sp),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                "Accept within 5 min so the buyer isn't kept waiting.",
                                style: GoogleFonts.inter(
                                  fontSize: 11.5.sp,
                                  color: AppColors.tier1,
                                  height: 1.5,
                                  fontWeight: FontWeight.w600,
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
              child: Row(
                children: [
                  Expanded(
                    child: AuthButton(
                      label: 'Reject',
                      variant: AuthBtnVariant.ghost,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: AuthButton(
                      label: 'Accept order',
                      onPressed: () => Navigator.pushReplacementNamed(
                          context, RouteNames.cookFoodReady),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
