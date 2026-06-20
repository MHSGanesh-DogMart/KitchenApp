import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '_onboarding_widgets.dart';

/// Cook · Kitchen & Food Safety (3 of 6).
class CookKitchenSafetyScreen extends StatefulWidget {
  const CookKitchenSafetyScreen({super.key});
  @override
  State<CookKitchenSafetyScreen> createState() =>
      _CookKitchenSafetyScreenState();
}

class _CookKitchenSafetyScreenState extends State<CookKitchenSafetyScreen> {
  bool _cooking = false;
  bool _storage = false;
  bool _sink = false;
  bool _gps = false;
  bool _vegOnly = false;
  bool _pledge = false;

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      step: 3,
      totalSteps: 6,
      kicker: 'Your kitchen',
      title: 'Show off your\nkitchen',
      subtitle:
          'Real photos build trust. Customers want to see where their food is cooked.',
      gradient: const [Color(0xFFE1F2EC), Color(0xFFCFE9DC), Color(0xFFF1F8F4)],
      ctaLabel: 'Continue to FSSAI',
      onCta: () => Navigator.pushNamed(context, RouteNames.cookFssai),
      body: [
        OnboardingSection(
          title: 'Kitchen photos',
          hint: 'All 3 required · shoot in daylight',
          icon: Icons.camera_alt_outlined,
        ),
        Row(
          children: [
            Expanded(
              child: UploadTile(
                style: UploadStyle.square,
                title: 'Cooking area',
                helper: '',
                icon: Icons.local_fire_department_outlined,
                uploaded: _cooking,
                required: true,
                onTap: () => setState(() => _cooking = !_cooking),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: UploadTile(
                style: UploadStyle.square,
                title: 'Storage /\nfridge',
                helper: '',
                icon: Icons.kitchen_outlined,
                uploaded: _storage,
                required: true,
                onTap: () => setState(() => _storage = !_storage),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: UploadTile(
                style: UploadStyle.square,
                title: 'Sink /\nwashing',
                helper: '',
                icon: Icons.water_drop_outlined,
                uploaded: _sink,
                required: true,
                onTap: () => setState(() => _sink = !_sink),
              ),
            ),
          ],
        ),

        SizedBox(height: 26.h),
        OnboardingSection(
          title: 'Pin your location',
          hint: 'Helps delivery partners reach you fast.',
          icon: Icons.location_on_outlined,
        ),
        _GpsCard(pinned: _gps, onTap: () => setState(() => _gps = !_gps)),

        // SizedBox(height: 10.h),
        // UploadTile(
        //   title: 'Address proof',
        //   helper: 'Electricity bill / rent agreement / gas bill',
        //   icon: Icons.description_outlined,
        //   uploaded: _addressProof,
        //   required: true,
        //   onTap: () => setState(() => _addressProof = !_addressProof),
        // ),
        SizedBox(height: 26.h),
        OnboardingSection(
          title: 'About your kitchen',
          icon: Icons.restaurant_outlined,
        ),
        _VegOnlyCard(
          value: _vegOnly,
          onChanged: (v) => setState(() => _vegOnly = v),
        ),

        // SizedBox(height: 14.h),
        // ChoicePicker(
        //   label: 'Primary cooking medium',
        //   options: _oils,
        //   value: _oil,
        //   onChanged: (v) => setState(() => _oil = v),
        // ),
        // SizedBox(height: 14.h),
        // ChoicePicker(
        //   label: 'Drinking & cooking water',
        //   options: _waters,
        //   value: _water,
        //   onChanged: (v) => setState(() => _water = v),
        // ),
        SizedBox(height: 26.h),
        OnboardingSection(
          title: 'Hygiene pledge',
          icon: Icons.health_and_safety_outlined,
        ),
        ConsentTile(
          checked: _pledge,
          accent: AppColors.tier1,
          title: 'I cook clean and stay healthy',
          body:
              'I follow hygiene practices, have no communicable disease, and use only fresh ingredients.',
          onTap: () => setState(() => _pledge = !_pledge),
        ),
      ],
    );
  }
}

class _GpsCard extends StatelessWidget {
  const _GpsCard({required this.pinned, required this.onTap});
  final bool pinned;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: pinned
                ? [
                    AppColors.secondarySoft,
                    AppColors.secondarySoft.withValues(alpha: .6),
                  ]
                : [const Color(0xFFFFF5EE), const Color(0xFFFFEAD8)],
          ),
          border: Border.all(
            color: pinned ? AppColors.secondary : AppColors.line,
            width: pinned ? 1.4 : 1,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(14.w),
            child: Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    color: pinned ? AppColors.secondary : Colors.white,
                    borderRadius: BorderRadius.circular(13.r),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (pinned ? AppColors.secondary : AppColors.primary)
                                .withValues(alpha: .18),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    pinned ? Icons.check_rounded : Icons.my_location_rounded,
                    color: pinned ? Colors.white : AppColors.primary,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 13.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pinned ? 'Location pinned' : 'Pin my exact location',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                          letterSpacing: -.1,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        pinned
                            ? '17.4451° N, 78.3502° E · tap to update'
                            : 'GPS auto-capture (one tap)',
                        style: GoogleFonts.inter(
                          fontSize: 11.5.sp,
                          color: pinned ? AppColors.secondary : AppColors.muted,
                          fontWeight: pinned
                              ? FontWeight.w600
                              : FontWeight.w500,
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
}

class _VegOnlyCard extends StatelessWidget {
  const _VegOnlyCard({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: value ? AppColors.secondarySoft : AppColors.surface,
        border: Border.all(
          color: value ? AppColors.secondary : AppColors.line,
          width: value ? 1.4 : 1,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: value ? AppColors.secondary : AppColors.cream,
              borderRadius: BorderRadius.circular(12.r),
            ),
            alignment: Alignment.center,
            child: Text('🥦', style: TextStyle(fontSize: 20.sp)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '100% vegetarian kitchen',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                    letterSpacing: -.1,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'No egg, meat or fish is ever cooked here',
                  style: GoogleFonts.inter(
                    fontSize: 11.5.sp,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.secondary,
            inactiveTrackColor: AppColors.line,
            inactiveThumbColor: Colors.white,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
