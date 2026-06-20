import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routing/route_names.dart';
import '../discover/_discover_widgets.dart';
import '../profile/_profile_widgets.dart';

/// Mockup 64 — Cook · Settings (Profile tab in cook shell).
class CookSettingsScreen extends StatefulWidget {
  const CookSettingsScreen({super.key});
  @override
  State<CookSettingsScreen> createState() => _CookSettingsScreenState();
}

class _CookSettingsScreenState extends State<CookSettingsScreen> {
  bool _accepting = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 12.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Settings',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -.6,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 110.h),
                children: [
                  // Cook header card
                  Container(
                    padding: EdgeInsets.all(15.w),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25.r,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            'SA',
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.white,
                              fontSize: 19.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sunita Aunty',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 7.w, vertical: 3.h),
                                decoration: BoxDecoration(
                                  color: AppColors.tier1Soft,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  '🏠 Tier 1 · FSSAI Basic',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 9.5.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.tier1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const ProfileKicker('Kitchen'),
                  CardGroup(children: [
                    ToggleRow(
                      title: 'Accepting orders',
                      value: _accepting,
                      onChanged: (v) => setState(() => _accepting = v),
                    ),
                    MenuRow(
                      title: 'Order cutoff time',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '11:00 AM',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: AppColors.muted,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(Icons.chevron_right_rounded,
                              color: AppColors.muted, size: 18.sp),
                        ],
                      ),
                      onTap: () {},
                    ),
                    MenuRow(
                      title: 'Delivery radius',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '3 km',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: AppColors.muted,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(Icons.chevron_right_rounded,
                              color: AppColors.muted, size: 18.sp),
                        ],
                      ),
                      onTap: () {},
                    ),
                  ]),

                  const ProfileKicker('Account'),
                  CardGroup(children: [
                    MenuRow(
                      title: 'Bank & payout',
                      leadingIcon: Icons.account_balance_rounded,
                      onTap: () {},
                    ),
                    MenuRow(
                      title: 'FSSAI & documents',
                      leadingIcon: Icons.verified_user_outlined,
                      onTap: () {},
                    ),
                    MenuRow(
                      title: 'Reviews',
                      leadingIcon: Icons.star_border_rounded,
                      onTap: () => Navigator.pushNamed(
                          context, RouteNames.cookReviews),
                    ),
                    MenuRow(
                      title: 'Order history',
                      leadingIcon: Icons.history_rounded,
                      onTap: () => Navigator.pushNamed(
                          context, RouteNames.cookOrderHistory),
                    ),
                    MenuRow(
                      title: 'Notifications',
                      leadingIcon: Icons.notifications_none_rounded,
                      onTap: () => Navigator.pushNamed(
                          context, RouteNames.cookNotifications),
                    ),
                    MenuRow(
                      title: 'Help & support',
                      leadingIcon: Icons.help_outline_rounded,
                      onTap: () => Navigator.pushNamed(
                          context, RouteNames.cookHelp),
                    ),
                  ]),

                  SizedBox(height: 14.h),
                  CardGroup(children: [
                    MenuRow(
                      title: 'Switch to buyer mode',
                      leadingIcon: Icons.swap_horiz_rounded,
                      onTap: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        RouteNames.home,
                        (_) => false,
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
