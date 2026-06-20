import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../discover/_discover_widgets.dart';
import '../profile/_profile_widgets.dart';

/// Mockup 65 — Cook · Help.
class CookHelpScreen extends StatelessWidget {
  const CookHelpScreen({super.key});

  static const _topQs = [
    'When do I get paid?',
    'How does FSSAI Basic work?',
    'Change my menu cutoff',
    'A buyer reported an issue',
    'Update my bank details',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const PlainAppBar(title: 'Cook support'),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 24.h),
                children: [
                  // Search bar
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(13.r),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded,
                            size: 18.sp, color: AppColors.muted),
                        SizedBox(width: 8.w),
                        Text(
                          'Search help',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const ProfileKicker('For cooks'),
                  CardGroup(
                    children: _topQs
                        .map((q) => MenuRow(title: q, onTap: () {}))
                        .toList(),
                  ),

                  SizedBox(height: 16.h),

                  // Priority cook support
                  Material(
                    color: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      side: const BorderSide(color: AppColors.line),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14.r),
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.all(13.w),
                        child: Row(
                          children: [
                            Container(
                              width: 38.w,
                              height: 38.w,
                              decoration: BoxDecoration(
                                color: AppColors.secondarySoft,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.chat_bubble_outline_rounded,
                                color: AppColors.secondary,
                                size: 18.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Chat with cook support',
                                    style: GoogleFonts.inter(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    'Priority for live cooks',
                                    style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      color: AppColors.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded,
                                color: AppColors.muted, size: 18.sp),
                          ],
                        ),
                      ),
                    ),
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
