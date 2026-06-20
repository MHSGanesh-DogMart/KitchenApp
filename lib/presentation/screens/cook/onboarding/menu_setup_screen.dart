import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '_onboarding_widgets.dart';

/// Cook · Menu setup (4 of 6).
class CookMenuSetupScreen extends StatefulWidget {
  const CookMenuSetupScreen({super.key});
  @override
  State<CookMenuSetupScreen> createState() => _CookMenuSetupScreenState();
}

class _CookMenuSetupScreenState extends State<CookMenuSetupScreen> {
  bool _photo = false;
  String _diet = 'Veg';
  bool _eggless = true;
  String _spice = 'Medium';
  final Set<String> _allergens = {};

  final _name = TextEditingController(text: 'Veg Thali');
  final _price = TextEditingController(text: '120');
  final _qty = TextEditingController(text: '20');
  final _portion =
      TextEditingController(text: '2 roti + dal + sabzi + rice');
  final _ingredients =
      TextEditingController(text: 'Wheat, dal, mixed veg, ghee, spices');
  final _shelf = TextEditingController(text: '2 hours');

  static const _diets = ['Veg', 'Non-veg', 'Vegan', 'Jain'];
  static const _spices = ['Mild', 'Medium', 'Spicy', 'Extra spicy'];
  static const _allergenList = [
    'Dairy',
    'Nuts',
    'Gluten',
    'Egg',
    'Soy',
    'Mustard',
    'Sesame',
  ];

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _qty.dispose();
    _portion.dispose();
    _ingredients.dispose();
    _shelf.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      step: 4,
      totalSteps: 6,
      kicker: 'Your menu',
      title: 'Add your\nfirst dish',
      subtitle:
          'A real photo and full details means fewer customer complaints and better ratings.',
      gradient: const [
        Color(0xFFFFE7DF),
        Color(0xFFFFCFBA),
        Color(0xFFFFF1EA),
      ],
      ctaLabel: 'Continue to Operations',
      onCta: () =>
          Navigator.pushNamed(context, RouteNames.cookOperations),
      body: [
        // Big dish photo hero
        OnboardingSection(
          title: 'Dish photo',
          hint: 'Mandatory · real cooked food, not stock images.',
          icon: Icons.restaurant_menu_outlined,
        ),
        UploadTile(
          style: UploadStyle.hero,
          title: 'Add a real photo',
          helper: 'Bright light, top-down angle works best',
          icon: Icons.add_a_photo_outlined,
          uploaded: _photo,
          required: true,
          onTap: () => setState(() => _photo = !_photo),
        ),

        SizedBox(height: 26.h),
        OnboardingSection(
          title: 'Basic info',
          icon: Icons.info_outline_rounded,
        ),
        PremiumField(
          controller: _name,
          label: 'Dish name',
          hint: 'e.g. Veg Thali',
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: PremiumField(
                controller: _price,
                label: 'Price (₹)',
                hint: '120',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(5),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: PremiumField(
                controller: _qty,
                label: 'Per day',
                hint: '20',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        PremiumField(
          controller: _portion,
          label: 'Portion size',
          hint: '2 roti + dal + sabzi + rice',
        ),

        SizedBox(height: 26.h),
        OnboardingSection(
          title: 'Dietary tags',
          icon: Icons.eco_outlined,
        ),
        ChoicePicker(
          label: 'Diet',
          options: _diets,
          value: _diet,
          onChanged: (v) => setState(() => _diet = v),
        ),
        SizedBox(height: 14.h),
        _EgglessToggle(
          value: _eggless,
          onChanged: (v) => setState(() => _eggless = v),
        ),
        SizedBox(height: 14.h),
        ChoicePicker(
          label: 'Spice level',
          options: _spices,
          value: _spice,
          onChanged: (v) => setState(() => _spice = v),
        ),

        SizedBox(height: 26.h),
        OnboardingSection(
          title: 'Ingredients & freshness',
          icon: Icons.eco_outlined,
        ),
        PremiumField(
          controller: _ingredients,
          label: 'Ingredients (comma separated)',
          hint: 'Wheat, dal, vegetables, spices',
          maxLines: 3,
        ),
        SizedBox(height: 10.h),
        PremiumField(
          controller: _shelf,
          label: 'Consume within',
          hint: 'e.g. 2 hours',
        ),

        SizedBox(height: 26.h),
        OnboardingSection(
          title: 'Allergens',
          hint: 'Tap all that apply — protects you legally.',
          icon: Icons.warning_amber_rounded,
        ),
        MultiChoicePicker(
          label: '',
          options: _allergenList,
          selected: _allergens,
          onToggle: (a) => setState(() {
            _allergens.contains(a)
                ? _allergens.remove(a)
                : _allergens.add(a);
          }),
        ),
        SizedBox(height: 14.h),
        InfoCallout(
          icon: Icons.shield_outlined,
          text:
              'Declaring allergens honestly is your legal protection if a customer has a reaction.',
          accent: AppColors.tier1,
          accentSoft: AppColors.tier1Soft,
        ),

        SizedBox(height: 22.h),
        OnboardingSection(
          title: 'Already added',
          hint: 'You can add more dishes after going live.',
        ),
        _DishPreview(
          emoji: '🍛',
          gradient: const [Color(0xFFFFD9C8), Color(0xFFFFC4AC)],
          title: 'Rajma Chawal',
          sub: '₹90 · 15/day · Veg · Medium',
        ),
      ],
    );
  }
}

class _EgglessToggle extends StatelessWidget {
  const _EgglessToggle({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(13.w),
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
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: value ? AppColors.secondary : AppColors.cream,
              borderRadius: BorderRadius.circular(11.r),
            ),
            alignment: Alignment.center,
            child: Text('🥚', style: TextStyle(fontSize: 18.sp)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Eggless',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'No egg used in cooking or batter',
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

class _DishPreview extends StatelessWidget {
  const _DishPreview({
    required this.emoji,
    required this.gradient,
    required this.title,
    required this.sub,
  });
  final String emoji;
  final List<Color> gradient;
  final String title;
  final String sub;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(12.r),
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
                  title,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  sub,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: AppColors.secondarySoft,
              borderRadius: BorderRadius.circular(99.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_rounded,
                    size: 11.sp, color: AppColors.secondary),
                SizedBox(width: 3.w),
                Text(
                  'Saved',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
