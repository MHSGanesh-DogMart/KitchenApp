import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import 'onboarding/_onboarding_widgets.dart';

/// Pass as `arguments` to [DishEditScreen] to prefill (edit mode).
/// Pass `null` (or no arguments) to start in add mode.
class DishDraft {
  const DishDraft({
    required this.name,
    required this.price,
    required this.perDay,
    required this.portion,
    required this.diet,
    required this.eggless,
    required this.spice,
    required this.ingredients,
    required this.shelfLife,
    required this.allergens,
    required this.cookingMedium,
    required this.description,
    required this.photoUploaded,
    required this.live,
  });
  final String name;
  final int price;
  final int perDay;
  final String portion;
  final String diet;
  final bool eggless;
  final String spice;
  final String ingredients;
  final String shelfLife;
  final Set<String> allergens;
  final String cookingMedium;
  final String description;
  final bool photoUploaded;
  final bool live;
}

/// Add / Edit dish — single shared screen.
///
///   • Receives an optional `DishDraft` via `Navigator` arguments.
///     `null` → add mode (empty form).
///     non-null → edit mode (prefilled + delete button surfaced).
///
///   • Required fields are starred and the Save CTA is disabled until
///     each one has a value.
class DishEditScreen extends StatefulWidget {
  const DishEditScreen({super.key, this.initial});
  final DishDraft? initial;
  @override
  State<DishEditScreen> createState() => _DishEditScreenState();
}

class _DishEditScreenState extends State<DishEditScreen> {
  late final bool _editing = widget.initial != null;

  // ── Photo ──
  late bool _photo = widget.initial?.photoUploaded ?? false;

  // ── Text fields ──
  late final _name = TextEditingController(text: widget.initial?.name ?? '');
  late final _price =
      TextEditingController(text: widget.initial?.price.toString() ?? '');
  late final _qty =
      TextEditingController(text: widget.initial?.perDay.toString() ?? '');
  late final _portion =
      TextEditingController(text: widget.initial?.portion ?? '');
  late final _ingredients =
      TextEditingController(text: widget.initial?.ingredients ?? '');
  late final _shelf =
      TextEditingController(text: widget.initial?.shelfLife ?? '');
  late final _description =
      TextEditingController(text: widget.initial?.description ?? '');

  // ── Pickers ──
  late String _diet = widget.initial?.diet ?? 'Veg';
  late bool _eggless = widget.initial?.eggless ?? true;
  late String _spice = widget.initial?.spice ?? 'Medium';
  late final Set<String> _allergens = {...?widget.initial?.allergens};
  late bool _live = widget.initial?.live ?? true;

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
    _description.dispose();
    super.dispose();
  }

  bool _showMore = false;

  bool get _isValid =>
      _photo &&
      _name.text.trim().isNotEmpty &&
      _price.text.trim().isNotEmpty &&
      _qty.text.trim().isNotEmpty;

  void _refresh() => setState(() {});

  void _save() {
    Navigator.pop(context, true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.ink,
        content: Text(
          _editing
              ? 'Changes saved'
              : (_live ? 'Dish added and live' : 'Dish saved · paused'),
          style: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          'Delete this dish?',
          style: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        content: Text(
          'It will be removed from your menu. Existing orders are not affected.',
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            color: AppColors.inkSoft,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.w700,
                color: AppColors.muted,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Delete',
              style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
    if (ok == true && mounted) Navigator.pop(context, 'deleted');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Soft gradient backdrop (same warmth as onboarding).
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 220.h,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFE7DF),
                    Color(0xFFFFCFBA),
                    Color(0xFFFAF7F1),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // ── Top bar ──
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 4.h),
                  child: Row(
                    children: [
                      _CircleBtn(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      if (_editing)
                        _CircleBtn(
                          icon: Icons.delete_outline_rounded,
                          tint: AppColors.primaryDark,
                          onTap: _confirmDelete,
                        ),
                    ],
                  ),
                ),

                // ── Scrollable body ──
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 130.h),
                    children: [
                      // Title block
                      Text(
                        _editing ? 'EDIT DISH' : 'NEW DISH',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.6,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        _editing
                            ? 'Update the details below'
                            : "Let's add your\nnew dish",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -.8,
                          height: 1.05,
                          color: AppColors.ink,
                        ),
                      ),

                      // ── Photo ──
                      SizedBox(height: 22.h),
                      OnboardingSection(
                        title: 'Dish photo',
                        hint:
                            'Real cooked food, bright light, top-down works best.',
                        icon: Icons.restaurant_menu_outlined,
                      ),
                      UploadTile(
                        style: UploadStyle.hero,
                        title: 'Add a real photo',
                        helper: 'No stock images',
                        icon: Icons.add_a_photo_outlined,
                        uploaded: _photo,
                        required: true,
                        onTap: () => setState(() => _photo = !_photo),
                      ),

                      // ── Basic info ──
                      SizedBox(height: 24.h),
                      OnboardingSection(
                        title: 'Basics',
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
                              label: 'Qty / day',
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

                      // ── Diet + spice (compact) ──
                      SizedBox(height: 24.h),
                      OnboardingSection(
                        title: 'Diet & spice',
                        icon: Icons.eco_outlined,
                      ),
                      ChoicePicker(
                        label: 'Diet',
                        options: _diets,
                        value: _diet,
                        onChanged: (v) => setState(() => _diet = v),
                      ),
                      SizedBox(height: 12.h),
                      ChoicePicker(
                        label: 'Spice level',
                        options: _spices,
                        value: _spice,
                        onChanged: (v) => setState(() => _spice = v),
                      ),

                      // ── Allergens ──
                      SizedBox(height: 24.h),
                      OnboardingSection(
                        title: 'Allergens',
                        hint: 'Tap all that apply — keeps you legally safe.',
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

                      // ── More details (optional, collapsed) ──
                      SizedBox(height: 24.h),
                      _MoreToggle(
                        open: _showMore,
                        onTap: () =>
                            setState(() => _showMore = !_showMore),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOut,
                        alignment: Alignment.topCenter,
                        child: _showMore
                            ? Padding(
                                padding: EdgeInsets.only(top: 14.h),
                                child: Column(
                                  children: [
                                    PremiumField(
                                      controller: _portion,
                                      label: 'Portion size',
                                      hint: '2 roti + dal + sabzi + rice',
                                    ),
                                    SizedBox(height: 10.h),
                                    PremiumField(
                                      controller: _ingredients,
                                      label: 'Ingredients',
                                      hint:
                                          'Wheat, dal, vegetables, spices',
                                      maxLines: 3,
                                    ),
                                    SizedBox(height: 10.h),
                                    PremiumField(
                                      controller: _description,
                                      label: 'Short description',
                                      hint:
                                          'Home-ground spices, slow-cooked...',
                                      maxLines: 3,
                                    ),
                                    SizedBox(height: 14.h),
                                    _EgglessToggle(
                                      value: _eggless,
                                      onChanged: (v) =>
                                          setState(() => _eggless = v),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),

                      // ── Publish state ──
                      SizedBox(height: 24.h),
                      _PublishToggle(
                        value: _live,
                        onChanged: (v) => setState(() => _live = v),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Sticky bottom CTA ──
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _StickyCta(
              label: _editing
                  ? 'Save changes'
                  : (_live ? 'Save & publish' : 'Save · keep paused'),
              enabled: _isValid,
              onTap: _isValid ? _save : null,
              onAnyChange: _refresh,
              listenTo: [
                _name,
                _price,
                _qty,
                _portion,
                _ingredients,
                _shelf,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  Sub-widgets
// ══════════════════════════════════════════════════════════════

class _CircleBtn extends StatelessWidget {
  const _CircleBtn({required this.icon, required this.onTap, this.tint});
  final IconData icon;
  final VoidCallback onTap;
  final Color? tint;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: .85),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
        side: BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: onTap,
        child: SizedBox(
          width: 42.w,
          height: 42.w,
          child: Icon(icon,
              size: 19.sp, color: tint ?? AppColors.ink),
        ),
      ),
    );
  }
}

class _MoreToggle extends StatelessWidget {
  const _MoreToggle({required this.open, required this.onTap});
  final bool open;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(8.r),
              ),
              alignment: Alignment.center,
              child: Icon(
                open ? Icons.remove_rounded : Icons.add_rounded,
                size: 15.sp,
                color: AppColors.primaryDark,
              ),
            ),
            SizedBox(width: 11.w),
            Expanded(
              child: Text(
                open
                    ? 'Hide extra details'
                    : 'More details (optional)',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ),
            AnimatedRotation(
              duration: const Duration(milliseconds: 220),
              turns: open ? .5 : 0,
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.muted,
                size: 22.sp,
              ),
            ),
          ],
        ),
      ),
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

class _PublishToggle extends StatelessWidget {
  const _PublishToggle({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: value ? AppColors.secondarySoft : AppColors.cream,
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
              color: value ? AppColors.secondary : AppColors.muted,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: (value ? AppColors.secondary : AppColors.muted)
                      .withValues(alpha: .3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Icon(
              value ? Icons.bolt_rounded : Icons.pause_rounded,
              color: Colors.white,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value ? 'Live on the menu' : 'Save as paused',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                    letterSpacing: -.1,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value
                      ? 'Customers can order this dish immediately'
                      : "Won't appear on the customer menu",
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

/// Sticky bottom CTA. Listens to a list of controllers so the disabled
/// state updates as the user types in required fields.
class _StickyCta extends StatefulWidget {
  const _StickyCta({
    required this.label,
    required this.enabled,
    required this.onTap,
    required this.onAnyChange,
    required this.listenTo,
  });
  final String label;
  final bool enabled;
  final VoidCallback? onTap;
  final VoidCallback onAnyChange;
  final List<TextEditingController> listenTo;
  @override
  State<_StickyCta> createState() => _StickyCtaState();
}

class _StickyCtaState extends State<_StickyCta> {
  @override
  void initState() {
    super.initState();
    for (final c in widget.listenTo) {
      c.addListener(widget.onAnyChange);
    }
  }

  @override
  void dispose() {
    for (final c in widget.listenTo) {
      c.removeListener(widget.onAnyChange);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disabled = !widget.enabled;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: .06),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 16.h),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: disabled ? .5 : 1,
            child: Material(
              color: AppColors.ink,
              borderRadius: BorderRadius.circular(99.r),
              child: InkWell(
                borderRadius: BorderRadius.circular(99.r),
                onTap: disabled ? null : widget.onTap,
                child: Container(
                  height: 56.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99.r),
                    boxShadow: disabled
                        ? null
                        : [
                            BoxShadow(
                              color:
                                  AppColors.ink.withValues(alpha: .25),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.label,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: .2,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(Icons.check_rounded,
                          size: 18.sp, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
