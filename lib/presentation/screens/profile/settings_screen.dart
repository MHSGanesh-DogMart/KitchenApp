import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routing/route_names.dart';
import '../discover/_discover_widgets.dart';
import '_profile_widgets.dart';

/// Mockup 38 — Settings.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _push = true;
  bool _orderUpdates = true;
  bool _offers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const PlainAppBar(title: 'Settings'),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 24.h),
                children: [
                  const ProfileKicker('Preferences'),
                  CardGroup(children: [
                    ToggleRow(
                      title: 'Push notifications',
                      value: _push,
                      onChanged: (v) => setState(() => _push = v),
                    ),
                    ToggleRow(
                      title: 'Order updates',
                      value: _orderUpdates,
                      onChanged: (v) =>
                          setState(() => _orderUpdates = v),
                    ),
                    ToggleRow(
                      title: 'Offers & promos',
                      value: _offers,
                      onChanged: (v) => setState(() => _offers = v),
                    ),
                    MenuRow(
                      title: 'Language',
                      onTap: () => Navigator.pushNamed(
                          context, RouteNames.language),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'English',
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
                    ),
                  ]),
                  const ProfileKicker('Account'),
                  CardGroup(children: [
                    MenuRow(title: 'Privacy policy', onTap: () {}),
                    MenuRow(title: 'Terms of service', onTap: () {}),
                    MenuRow(
                      title: 'Delete account',
                      danger: true,
                      onTap: () {},
                    ),
                  ]),
                  SizedBox(height: 18.h),
                  Center(
                    child: Text(
                      'Padosi · v1.0.0',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: AppColors.muted,
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
