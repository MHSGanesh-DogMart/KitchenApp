import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../auth/_auth_widgets.dart';
import '../discover/_discover_widgets.dart';
import '_cook_widgets.dart';

/// Mockup 58 — Cook · Today's menu.
class TodaysMenuScreen extends StatefulWidget {
  const TodaysMenuScreen({super.key});
  @override
  State<TodaysMenuScreen> createState() => _TodaysMenuScreenState();
}

class _TodaysMenuScreenState extends State<TodaysMenuScreen> {
  final Map<String, bool> _on = {
    'Veg Thali': true,
    'Rajma Chawal': true,
    'Aloo Paratha': false,
  };

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
                const PlainAppBar(title: "Today's menu"),
                Expanded(
                  child: ListView(
                    padding:
                        EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 110.h),
                    children: [
                      Text(
                        "Set what's available today & how many.",
                        style: GoogleFonts.inter(
                          fontSize: 12.5.sp,
                          color: AppColors.inkSoft,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      _TodaysRow(
                        emoji: '🍛',
                        gradient: const [
                          Color(0xFFFFD9C8),
                          Color(0xFFFFC4AC),
                        ],
                        name: 'Veg Thali',
                        sub: '₹120 · 20 left',
                        value: _on['Veg Thali']!,
                        onChanged: (v) =>
                            setState(() => _on['Veg Thali'] = v),
                      ),
                      SizedBox(height: 8.h),
                      _TodaysRow(
                        emoji: '🥘',
                        gradient: const [
                          Color(0xFFFBEAC6),
                          Color(0xFFF2DCA6),
                        ],
                        name: 'Rajma Chawal',
                        sub: '₹90 · 15 left',
                        value: _on['Rajma Chawal']!,
                        onChanged: (v) =>
                            setState(() => _on['Rajma Chawal'] = v),
                      ),
                      SizedBox(height: 8.h),
                      _TodaysRow(
                        emoji: '🥟',
                        gradient: const [
                          Color(0xFFD6EEDF),
                          Color(0xFFBFE3CC),
                        ],
                        name: 'Aloo Paratha',
                        sub: '₹70 · 0 left',
                        value: _on['Aloo Paratha']!,
                        onChanged: (v) =>
                            setState(() => _on['Aloo Paratha'] = v),
                      ),
                      SizedBox(height: 12.h),
                      AuthButton(
                        label: "+ Add today's special",
                        variant: AuthBtnVariant.ghost,
                        onPressed: () {},
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
              child: AuthButton(
                label: 'Save menu',
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TodaysRow extends StatelessWidget {
  const _TodaysRow({
    required this.emoji,
    required this.gradient,
    required this.name,
    required this.sub,
    required this.value,
    required this.onChanged,
  });
  final String emoji;
  final List<Color> gradient;
  final String name;
  final String sub;
  final bool value;
  final ValueChanged<bool> onChanged;
  @override
  Widget build(BuildContext context) {
    return CookToggleCard(
      title: name,
      subtitle: sub,
      value: value,
      onChanged: onChanged,
      leading: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(11.r),
        ),
        alignment: Alignment.center,
        child: Text(emoji, style: TextStyle(fontSize: 18.sp)),
      ),
    );
  }
}
