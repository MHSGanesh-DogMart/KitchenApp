import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/api_endpoints.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/network/api_client.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/utils/logger.dart';
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
  Map<String, dynamic>? _cook;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final res = await ApiClient.instance.get(ApiEndpoints.getDetails);
      final data = res.data;
      final cook = (data is Map && data['data'] is Map)
          ? (data['data']['cook'] ?? data['data'])
          : null;
      if (cook is Map && mounted) {
        setState(() => _cook = Map<String, dynamic>.from(cook));
      }
    } catch (e) {
      AppLogger.w('Settings: failed to load kitchen profile: $e');
    }
  }

  String get _displayName {
    final c = _cook;
    if (c == null) return 'Loading…';
    final kn = (c['kitchenName'] ?? '').toString().trim();
    final n = (c['name'] ?? '').toString().trim();
    return kn.isNotEmpty ? kn : (n.isNotEmpty ? n : 'My Kitchen');
  }

  String get _initials {
    final src = _displayName;
    final parts = src.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'K';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  String get _tierLabel {
    final t = _cook?['tier'];
    final tier = t is int ? t : int.tryParse('$t') ?? 1;
    final hasFssai = _cook?['hasExistingFssai'] == true;
    return '🏠 Tier $tier · FSSAI ${hasFssai ? 'Verified' : 'Basic'}';
  }

  String get _selfieUrl => (_cook?['selfieUrl'] ?? '').toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  // Cook header card → tap to open full kitchen profile
                  InkWell(
                    borderRadius: BorderRadius.circular(18.r),
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.cookProfileDetails,
                    ),
                    child: Container(
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
                            backgroundImage: _selfieUrl.isNotEmpty
                                ? NetworkImage(_selfieUrl)
                                : null,
                            child: _selfieUrl.isEmpty
                                ? Text(
                                    _initials,
                                    style: GoogleFonts.spaceGrotesk(
                                      color: Colors.white,
                                      fontSize: 19.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                                : null,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _displayName,
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 7.w,
                                    vertical: 3.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.tier1Soft,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    _tierLabel,
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
                          Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.muted,
                            size: 20.sp,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const ProfileKicker('Kitchen'),
                  CardGroup(
                    children: [
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
                            Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.muted,
                              size: 18.sp,
                            ),
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
                            Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.muted,
                              size: 18.sp,
                            ),
                          ],
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),

                  const ProfileKicker('Account'),
                  CardGroup(
                    children: [
                      MenuRow(
                        title: 'Kitchen profile',
                        leadingIcon: Icons.storefront_outlined,
                        onTap: () => Navigator.pushNamed(
                          context,
                          RouteNames.cookProfileDetails,
                        ),
                      ),
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
                          context,
                          RouteNames.cookReviews,
                        ),
                      ),
                      MenuRow(
                        title: 'Order history',
                        leadingIcon: Icons.history_rounded,
                        onTap: () => Navigator.pushNamed(
                          context,
                          RouteNames.cookOrderHistory,
                        ),
                      ),
                      MenuRow(
                        title: 'Notifications',
                        leadingIcon: Icons.notifications_none_rounded,
                        onTap: () => Navigator.pushNamed(
                          context,
                          RouteNames.cookNotifications,
                        ),
                      ),
                      MenuRow(
                        title: 'Help & support',
                        leadingIcon: Icons.help_outline_rounded,
                        onTap: () =>
                            Navigator.pushNamed(context, RouteNames.cookHelp),
                      ),
                    ],
                  ),

                  SizedBox(height: 14.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
