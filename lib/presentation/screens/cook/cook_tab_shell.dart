import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import 'cook_dashboard_screen.dart';
import 'cook_settings_screen.dart';
import 'earnings_screen.dart';
import 'menu_manage_screen.dart';

/// Cook-side 4-tab shell with the floating dark pill nav.
///
/// Tabs (matches the customer app's floating nav DNA):
///   · Home     → Dashboard (mockup 55)
///   · Menu     → Menu manage (mockup 59)
///   · Earnings → Earnings (mockup 62)
///   · More     → Settings (mockup 64)
class CookTabShell extends StatefulWidget {
  const CookTabShell({super.key, this.initialIndex = 0});
  final int initialIndex;
  @override
  State<CookTabShell> createState() => _CookTabShellState();
}

class _CookTabShellState extends State<CookTabShell> {
  late int _index = widget.initialIndex;

  static const _tabs = <Widget>[
    CookDashboardScreen(),
    MenuManageScreen(),
    EarningsScreen(),
    CookSettingsScreen(),
  ];

  static const _items = <(IconData, IconData, String)>[
    (Icons.dashboard_outlined, Icons.dashboard_rounded, 'Home'),
    (Icons.restaurant_menu_outlined, Icons.restaurant_menu_rounded, 'Menu'),
    (Icons.payments_outlined, Icons.payments_rounded, 'Earnings'),
    (Icons.person_outline_rounded, Icons.person_rounded, 'More'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(index: _index, children: _tabs),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _CookFloatingNav(
              currentIndex: _index,
              items: _items,
              onSelect: (i) => setState(() => _index = i),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dark ink pill with 4 tabs — active tab gets a small tangerine
/// dot under the label, matching the customer app's vocabulary.
class _CookFloatingNav extends StatelessWidget {
  const _CookFloatingNav({
    required this.currentIndex,
    required this.onSelect,
    required this.items,
  });
  final int currentIndex;
  final ValueChanged<int> onSelect;
  final List<(IconData, IconData, String)> items;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
        child: Container(
          height: 64.h,
          decoration: BoxDecoration(
            color: AppColors.ink,
            borderRadius: BorderRadius.circular(22.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.ink.withValues(alpha: .3),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Row(
            children: List.generate(items.length, (i) {
              final (iconOff, iconOn, label) = items[i];
              final selected = i == currentIndex;
              return Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16.r),
                    onTap: () => onSelect(i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          selected ? iconOn : iconOff,
                          color: selected
                              ? AppColors.primary
                              : Colors.white.withValues(alpha: .55),
                          size: 21.sp,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          label,
                          style: GoogleFonts.spaceGrotesk(
                            color: selected
                                ? Colors.white
                                : Colors.white.withValues(alpha: .55),
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: .2,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: selected ? 14.w : 0,
                          height: 2.h,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(99.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
