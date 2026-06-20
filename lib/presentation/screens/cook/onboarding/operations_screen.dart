import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '_onboarding_widgets.dart';

/// Cook · Operations & Consent (5 of 6).
class CookOperationsScreen extends StatefulWidget {
  const CookOperationsScreen({super.key});
  @override
  State<CookOperationsScreen> createState() => _CookOperationsScreenState();
}

class _CookOperationsScreenState extends State<CookOperationsScreen> {
  bool _breakfast = false;
  bool _lunch = true;
  bool _dinner = true;

  final _capacity = TextEditingController(text: '20');
  String _cutOff = '2 hours';
  String _packaging = 'Eco-friendly box';
  String _delivery = 'Platform delivery';

  final Set<String> _offDays = {};

  bool _consentHygiene = false;
  bool _consentTnC = false;
  bool _consentPhotos = false;

  static const _cutOffs = ['1 hour', '2 hours', '4 hours', 'Same-day morning'];
  static const _packagings = [
    'Foil container',
    'Plastic box',
    'Eco-friendly box',
    'Banana leaf / steel',
  ];
  static const _deliveryModes = [
    'Platform delivery',
    'Self pickup only',
    'Both options',
  ];
  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  bool get _allConsents =>
      _consentHygiene && _consentTnC && _consentPhotos;

  @override
  void dispose() {
    _capacity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      step: 5,
      totalSteps: 6,
      kicker: 'Operations',
      title: 'How you\nwork',
      subtitle:
          'Set realistic hours and capacity — customers see these on your page.',
      gradient: const [
        Color(0xFFF1ECFF),
        Color(0xFFE2D7FF),
        Color(0xFFF8F4FF),
      ],
      ctaLabel: _allConsents ? 'Continue to Review' : 'Accept all to continue',
      ctaEnabled: _allConsents,
      onCta: _allConsents
          ? () => Navigator.pushNamed(context, RouteNames.cookGoLive)
          : null,
      body: [
        OnboardingSection(
          title: 'Meals you cook',
          icon: Icons.restaurant_outlined,
        ),
        _MealCard(
          emoji: '🥣',
          label: 'Breakfast',
          time: '7:00 – 10:00 AM',
          value: _breakfast,
          onChanged: (v) => setState(() => _breakfast = v),
        ),
        SizedBox(height: 8.h),
        _MealCard(
          emoji: '🍛',
          label: 'Lunch',
          time: '12:00 – 2:30 PM',
          value: _lunch,
          onChanged: (v) => setState(() => _lunch = v),
        ),
        SizedBox(height: 8.h),
        _MealCard(
          emoji: '🍲',
          label: 'Dinner',
          time: '7:30 – 10:00 PM',
          value: _dinner,
          onChanged: (v) => setState(() => _dinner = v),
        ),

        SizedBox(height: 26.h),
        OnboardingSection(
          title: 'Capacity & cut-off',
          icon: Icons.timer_outlined,
        ),
        Row(
          children: [
            Expanded(
              child: PremiumField(
                controller: _capacity,
                label: 'Orders / day',
                hint: '20',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              flex: 2,
              child: _CapacityHint(),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        ChoicePicker(
          label: 'Order cut-off (notice required)',
          options: _cutOffs,
          value: _cutOff,
          onChanged: (v) => setState(() => _cutOff = v),
        ),

        SizedBox(height: 26.h),
        OnboardingSection(
          title: 'Weekly off',
          hint: 'Tap days you rest.',
          icon: Icons.event_busy_outlined,
        ),
        Wrap(
          spacing: 7.w,
          runSpacing: 7.h,
          children: _days.map((d) {
            final off = _offDays.contains(d);
            return _DayChip(
              day: d,
              off: off,
              onTap: () => setState(() {
                off ? _offDays.remove(d) : _offDays.add(d);
              }),
            );
          }).toList(),
        ),

        SizedBox(height: 26.h),
        OnboardingSection(
          title: 'Packaging & delivery',
          icon: Icons.inventory_2_outlined,
        ),
        ChoicePicker(
          label: 'Packaging',
          options: _packagings,
          value: _packaging,
          onChanged: (v) => setState(() => _packaging = v),
        ),
        SizedBox(height: 14.h),
        ChoicePicker(
          label: 'Delivery mode',
          options: _deliveryModes,
          value: _delivery,
          onChanged: (v) => setState(() => _delivery = v),
        ),

        SizedBox(height: 26.h),
        OnboardingSection(
          title: 'Final agreement',
          hint: 'All three are required to go live.',
          icon: Icons.assignment_outlined,
        ),
        ConsentTile(
          checked: _consentHygiene,
          title: 'Hygiene & food safety pledge',
          body:
              'I follow hygiene best practices, use fresh ingredients, and never cook when sick.',
          onTap: () =>
              setState(() => _consentHygiene = !_consentHygiene),
        ),
        SizedBox(height: 8.h),
        ConsentTile(
          checked: _consentTnC,
          title: 'Terms & Privacy Policy',
          body:
              'I have read and accept the Partner Terms and Privacy Policy.',
          onTap: () => setState(() => _consentTnC = !_consentTnC),
        ),
        SizedBox(height: 8.h),
        ConsentTile(
          checked: _consentPhotos,
          title: 'Use my photos for marketing',
          body:
              'Gharanna can use my dish & kitchen photos in the app and social media.',
          onTap: () => setState(() => _consentPhotos = !_consentPhotos),
        ),
      ],
    );
  }
}

class _MealCard extends StatelessWidget {
  const _MealCard({
    required this.emoji,
    required this.label,
    required this.time,
    required this.value,
    required this.onChanged,
  });
  final String emoji;
  final String label;
  final String time;
  final bool value;
  final ValueChanged<bool> onChanged;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: value
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.secondarySoft,
                  AppColors.secondarySoft.withValues(alpha: .5),
                ],
              )
            : null,
        color: value ? null : AppColors.surface,
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.ink.withValues(alpha: .06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: TextStyle(fontSize: 20.sp)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                    letterSpacing: -.1,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  time,
                  style: GoogleFonts.inter(
                    fontSize: 11.5.sp,
                    color: value ? AppColors.secondary : AppColors.muted,
                    fontWeight:
                        value ? FontWeight.w600 : FontWeight.w500,
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

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.day,
    required this.off,
    required this.onTap,
  });
  final String day;
  final bool off;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: off ? AppColors.ink : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(99.r),
        side: BorderSide(
          color: off ? AppColors.ink : AppColors.line,
          width: off ? 1.2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(99.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Text(
            day,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: off ? Colors.white : AppColors.inkSoft,
            ),
          ),
        ),
      ),
    );
  }
}

class _CapacityHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Icon(Icons.tips_and_updates_outlined,
              color: AppColors.muted, size: 17.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'Start conservative. You can increase capacity anytime.',
              style: GoogleFonts.inter(
                fontSize: 10.5.sp,
                color: AppColors.inkSoft,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
