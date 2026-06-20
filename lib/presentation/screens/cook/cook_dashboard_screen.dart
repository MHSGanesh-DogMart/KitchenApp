import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routing/route_names.dart';

/// Cook dashboard (Home tab) — premium polish to match the user-app
/// design language: gradient header backdrop, lifted hero cards, soft
/// shadows, weekly sparkline, refined order rows.
class CookDashboardScreen extends StatefulWidget {
  const CookDashboardScreen({super.key});
  @override
  State<CookDashboardScreen> createState() => _CookDashboardScreenState();
}

class _CookDashboardScreenState extends State<CookDashboardScreen> {
  bool _open = true;

  // Mock weekly earnings for the sparkline (Mon → Sun, today = Wed).
  final List<double> _weekly = const [780, 920, 960, 0, 0, 0, 0];
  final int _todayIdx = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Gradient backdrop behind the header — fades into the page.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 320.h,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFF1E9),
                    Color(0xFFFFE3D2),
                    Color(0xFFFAF7F1),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 120.h),
              children: [
                // ── Greeting header ──
                _GreetingHeader(
                  onBell: () => Navigator.pushNamed(
                    context,
                    RouteNames.cookNotifications,
                  ),
                  open: _open,
                ),
                SizedBox(height: 16.h),

                // ── Online / offline pill ──
                _OnlineCard(
                  open: _open,
                  onToggle: () => setState(() => _open = !_open),
                ),

                SizedBox(height: 18.h),

                // ── Hero earnings ──
                _EarningsHero(
                  earned: 960,
                  orders: 8,
                  avg: 120,
                  weekly: _weekly,
                  todayIdx: _todayIdx,
                  onTap: () =>
                      Navigator.pushNamed(context, RouteNames.cookEarnings),
                ),

                SizedBox(height: 24.h),

                // ── OPEN state: live work surface ──
                if (_open) ...[
                  _SectionHeader(
                    kicker: 'NEEDS YOUR ATTENTION',
                    title: 'Quick actions',
                    trailingPill: '2',
                  ),
                  SizedBox(height: 12.h),
                  _ActionCard(
                    icon: Icons.notifications_active_rounded,
                    tint: AppColors.primary,
                    title: '2 new orders waiting',
                    sub: 'Accept within 5 minutes',
                    urgent: true,
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.cookIncomingOrder,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _ActionCard(
                    icon: Icons.local_dining_rounded,
                    tint: AppColors.secondary,
                    title: '1 order ready for pickup',
                    sub: 'Rider on the way — share OTP',
                    onTap: () => Navigator.pushNamed(
                        context, RouteNames.cookFoodReady),
                  ),
                  SizedBox(height: 24.h),
                  _SectionHeader(
                      kicker: "TODAY'S PULSE", title: 'At a glance'),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _StatTile(
                          icon: Icons.schedule_rounded,
                          big: '22 min',
                          label: 'Avg prep time',
                          accent: AppColors.ink,
                          accentSoft: AppColors.cream,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: _StatTile(
                          icon: Icons.star_rounded,
                          big: '4.9',
                          label: 'Rating · 142',
                          accent: const Color(0xFFE6A100),
                          accentSoft: const Color(0xFFFFF3D6),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: _StatTile(
                          icon: Icons.restaurant_menu_rounded,
                          big: '12',
                          label: 'Dishes live',
                          accent: AppColors.secondary,
                          accentSoft: AppColors.secondarySoft,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: _StatTile(
                          icon: Icons.timer_outlined,
                          big: '11:00 AM',
                          label: 'Lunch cutoff',
                          accent: AppColors.primary,
                          accentSoft: AppColors.primarySoft,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 26.h),
                  _SectionHeader(
                    kicker: 'LIVE NOW',
                    title: 'Live orders',
                    trailingPill: '2 new',
                    trailingAction: 'See all',
                    onTrailingAction: () => Navigator.pushNamed(
                        context, RouteNames.cookOrderHistory),
                  ),
                  SizedBox(height: 12.h),
                  _OrderCard(
                    orderId: '#PD4821',
                    customer: 'Priya M.',
                    avatar: 'PM',
                    items: '1× Veg Thali · less oil',
                    price: 120,
                    elapsed: '2 min ago',
                    isNew: true,
                    onAccept: () => Navigator.pushNamed(
                      context,
                      RouteNames.cookIncomingOrder,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _OrderCard(
                    orderId: '#PD4822',
                    customer: 'Ravi K.',
                    avatar: 'RK',
                    items: '2× Rajma Chawal',
                    price: 180,
                    elapsed: 'Just now',
                    isNew: true,
                    onAccept: () => Navigator.pushNamed(
                      context,
                      RouteNames.cookIncomingOrder,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _OrderCard(
                    orderId: '#PD4820',
                    customer: 'Anita',
                    avatar: 'AN',
                    items: '1× Paneer Butter Masala',
                    price: 140,
                    elapsed: 'Cooking · 12 min left',
                    accepted: true,
                    onAccept: () => Navigator.pushNamed(
                        context, RouteNames.cookFoodReady),
                  ),
                ]

                // ── CLOSED state: calm summary + open CTA ──
                else ...[
                  _ClosedSummary(
                    onOpen: () => setState(() => _open = true),
                  ),
                ],

                SizedBox(height: 24.h),

                // ── Tip / nudge strip (shown in both states) ──
                _TipStrip(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  Greeting header
// ══════════════════════════════════════════════════════════════

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader({required this.onBell, required this.open});
  final VoidCallback onBell;
  final bool open;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.5),
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6A45), Color(0xFFE0431F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: .35),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            'SS',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: .3,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    _greeting(),
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: AppColors.muted,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .6,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  if (open)
                    Container(
                      width: 7.w,
                      height: 7.w,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                'Sunita Aunty',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -.6,
                  color: AppColors.ink,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
        _BellBtn(count: 3, onTap: onBell),
      ],
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'GOOD MORNING';
    if (h < 17) return 'GOOD AFTERNOON';
    return 'GOOD EVENING';
  }
}

class _BellBtn extends StatelessWidget {
  const _BellBtn({required this.count, required this.onTap});
  final int count;
  final VoidCallback onTap;
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
          width: 44.w,
          height: 44.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.notifications_none_rounded,
                color: AppColors.ink,
                size: 21.sp,
              ),
              if (count > 0)
                Positioned(
                  top: 9.h,
                  right: 10.w,
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  Online / offline card
// ══════════════════════════════════════════════════════════════

class _OnlineCard extends StatelessWidget {
  const _OnlineCard({required this.open, required this.onToggle});
  final bool open;
  final VoidCallback onToggle;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: onToggle,
        child: Container(
          padding: EdgeInsets.fromLTRB(14.w, 12.h, 12.w, 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: open
                  ? AppColors.success.withValues(alpha: .4)
                  : AppColors.line,
              width: open ? 1.4 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.ink.withValues(alpha: .04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              _PulseDot(active: open),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      open ? 'Kitchen is open' : 'Kitchen is closed',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        letterSpacing: -.2,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      open
                          ? 'Customers can order from your menu'
                          : "You won't receive new orders",
                      style: GoogleFonts.inter(
                        fontSize: 11.5.sp,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 48.w,
                height: 28.h,
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: open ? AppColors.success : AppColors.line,
                  borderRadius: BorderRadius.circular(99.r),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 220),
                  alignment: open
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.ink.withValues(alpha: .2),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PulseDot extends StatefulWidget {
  const _PulseDot({required this.active});
  final bool active;
  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.active ? AppColors.success : AppColors.muted;
    return SizedBox(
      width: 14.w,
      height: 14.w,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              if (widget.active)
                Container(
                  width: 14.w * (1 + _ctrl.value * .6),
                  height: 14.w * (1 + _ctrl.value * .6),
                  decoration: BoxDecoration(
                    color: c.withValues(alpha: .25 * (1 - _ctrl.value)),
                    shape: BoxShape.circle,
                  ),
                ),
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(color: c, shape: BoxShape.circle),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  Earnings hero (dark) with mini sparkline
// ══════════════════════════════════════════════════════════════

class _EarningsHero extends StatelessWidget {
  const _EarningsHero({
    required this.earned,
    required this.orders,
    required this.avg,
    required this.weekly,
    required this.todayIdx,
    required this.onTap,
  });
  final int earned;
  final int orders;
  final int avg;
  final List<double> weekly;
  final int todayIdx;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.ink,
      borderRadius: BorderRadius.circular(24.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(24.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 16.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            gradient: const LinearGradient(
              colors: [Color(0xFF1E1D17), Color(0xFF16150F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.ink.withValues(alpha: .28),
                blurRadius: 24,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Today's earnings",
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: Colors.white.withValues(alpha: .65),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 9.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: .2),
                      borderRadius: BorderRadius.circular(99.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.trending_up_rounded,
                          color: AppColors.success,
                          size: 12.sp,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          '+18% vs avg',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹$earned',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 38.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: -1.2,
                      height: 1.05,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 110.w,
                    height: 40.h,
                    child: CustomPaint(
                      painter: _SparklinePainter(
                        values: weekly,
                        todayIdx: todayIdx,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                  _HeroStat(label: 'Orders', value: '$orders'),
                  Container(
                    width: 1,
                    height: 24.h,
                    margin: EdgeInsets.symmetric(horizontal: 14.w),
                    color: Colors.white.withValues(alpha: .15),
                  ),
                  _HeroStat(label: 'Avg', value: '₹$avg'),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 7.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(99.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Details',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 13.sp,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.spaceGrotesk(
            fontSize: 9.5.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: .55),
            letterSpacing: 1.1,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({required this.values, required this.todayIdx});
  final List<double> values;
  final int todayIdx;

  @override
  void paint(Canvas canvas, Size size) {
    final filled = values.where((v) => v > 0).toList();
    if (filled.isEmpty) return;

    final maxV = filled.reduce(math.max);
    final n = values.length;
    final w = size.width;
    final h = size.height;
    final dx = w / (n - 1);

    final points = <Offset>[];
    for (var i = 0; i < n; i++) {
      final v = values[i];
      if (v == 0) continue;
      final x = dx * i;
      final y = h - (v / maxV) * h * .85 - 2;
      points.add(Offset(x, y));
    }
    if (points.isEmpty) return;

    // Fill area under the line.
    final fill = Path()..moveTo(points.first.dx, h);
    for (final p in points) {
      fill.lineTo(p.dx, p.dy);
    }
    fill.lineTo(points.last.dx, h);
    fill.close();

    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withValues(alpha: .35),
            AppColors.primary.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Line stroke.
    final line = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      line.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(
      line,
      Paint()
        ..color = AppColors.primary
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Today dot.
    if (todayIdx < n) {
      final v = values[todayIdx];
      if (v > 0) {
        final cx = dx * todayIdx;
        final cy = h - (v / maxV) * h * .85 - 2;
        // Halo
        canvas.drawCircle(
          Offset(cx, cy),
          7,
          Paint()..color = AppColors.primary.withValues(alpha: .3),
        );
        // Solid dot
        canvas.drawCircle(
          Offset(cx, cy),
          3.5,
          Paint()..color = AppColors.primary,
        );
        canvas.drawCircle(
          Offset(cx, cy),
          3.5,
          Paint()
            ..color = Colors.white
            ..strokeWidth = 1.6
            ..style = PaintingStyle.stroke,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.todayIdx != todayIdx;
}

// ══════════════════════════════════════════════════════════════
//  Section header
// ══════════════════════════════════════════════════════════════

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.kicker,
    required this.title,
    this.trailingPill,
    this.trailingAction,
    this.onTrailingAction,
  });
  final String kicker;
  final String title;
  final String? trailingPill;
  final String? trailingAction;
  final VoidCallback? onTrailingAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                kicker,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.muted,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -.4,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  if (trailingPill != null) ...[
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(99.r),
                      ),
                      child: Text(
                        trailingPill!,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        if (trailingAction != null)
          InkWell(
            onTap: onTrailingAction,
            borderRadius: BorderRadius.circular(8.r),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    trailingAction!,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 14.sp,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  Action card
// ══════════════════════════════════════════════════════════════

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.tint,
    required this.title,
    required this.sub,
    required this.onTap,
    this.urgent = false,
  });
  final IconData icon;
  final Color tint;
  final String title;
  final String sub;
  final VoidCallback onTap;
  final bool urgent;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: urgent ? tint.withValues(alpha: .4) : AppColors.line,
              width: urgent ? 1.4 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: urgent
                    ? tint.withValues(alpha: .14)
                    : AppColors.ink.withValues(alpha: .04),
                blurRadius: urgent ? 18 : 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: EdgeInsets.all(14.w),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      tint.withValues(alpha: .15),
                      tint.withValues(alpha: .08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: tint, size: 22.sp),
              ),
              SizedBox(width: 13.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        letterSpacing: -.2,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      sub,
                      style: GoogleFonts.inter(
                        fontSize: 11.5.sp,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.muted,
                size: 22.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  Stat tile
// ══════════════════════════════════════════════════════════════

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.big,
    required this.label,
    required this.accent,
    required this.accentSoft,
  });
  final IconData icon;
  final String big;
  final String label;
  final Color accent;
  final Color accentSoft;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: .03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [accentSoft, accentSoft.withValues(alpha: .55)],
              ),
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: accent, size: 17.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            big,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 19.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              letterSpacing: -.4,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              color: AppColors.muted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  Order card
// ══════════════════════════════════════════════════════════════

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.orderId,
    required this.customer,
    required this.avatar,
    required this.items,
    required this.price,
    required this.elapsed,
    required this.onAccept,
    this.isNew = false,
    this.accepted = false,
  });
  final String orderId;
  final String customer;
  final String avatar;
  final String items;
  final int price;
  final String elapsed;
  final bool isNew;
  final bool accepted;
  final VoidCallback onAccept;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isNew
              ? AppColors.primary.withValues(alpha: .4)
              : AppColors.line,
          width: isNew ? 1.4 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isNew
                ? AppColors.primary.withValues(alpha: .12)
                : AppColors.ink.withValues(alpha: .03),
            blurRadius: isNew ? 18 : 8,
            offset: Offset(0, isNew ? 8 : 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: accepted
                        ? const [Color(0xFF12997B), Color(0xFF0F7B5A)]
                        : const [Color(0xFFCE9520), Color(0xFFB7791F)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (accepted ? AppColors.secondary : AppColors.tier1)
                          .withValues(alpha: .35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  avatar,
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            customer,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                              letterSpacing: -.2,
                            ),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          orderId,
                          style: GoogleFonts.inter(
                            fontSize: 10.5.sp,
                            color: AppColors.muted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        if (accepted) ...[
                          Icon(
                            Icons.fiber_manual_record_rounded,
                            size: 7.sp,
                            color: AppColors.secondary,
                          ),
                          SizedBox(width: 4.w),
                        ],
                        Text(
                          elapsed,
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: accepted
                                ? AppColors.secondary
                                : AppColors.muted,
                            fontWeight: accepted
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                '₹$price',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: -.4,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.restaurant_rounded,
                  color: AppColors.inkSoft,
                  size: 14.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    items,
                    style: GoogleFonts.inter(
                      fontSize: 12.5.sp,
                      color: AppColors.inkSoft,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          if (isNew)
            Row(
              children: [
                Expanded(
                  child: _ActionBtn(
                    label: 'Reject',
                    primary: false,
                    onTap: () {},
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  flex: 2,
                  child: _ActionBtn(
                    label: 'Accept order',
                    primary: true,
                    icon: Icons.check_rounded,
                    onTap: onAccept,
                  ),
                ),
              ],
            )
          else
            _ActionBtn(
              label: 'Mark ready for pickup',
              primary: true,
              icon: Icons.local_dining_rounded,
              onTap: onAccept,
            ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.label,
    required this.primary,
    required this.onTap,
    this.icon,
  });
  final String label;
  final bool primary;
  final VoidCallback onTap;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: primary ? AppColors.ink : AppColors.cream,
      borderRadius: BorderRadius.circular(99.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(99.r),
        onTap: onTap,
        child: Container(
          height: 46.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99.r),
            boxShadow: primary
                ? [
                    BoxShadow(
                      color: AppColors.ink.withValues(alpha: .25),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16.sp,
                  color: primary ? Colors.white : AppColors.ink,
                ),
                SizedBox(width: 6.w),
              ],
              Text(
                label,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: primary ? Colors.white : AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  Closed summary — calm state shown when kitchen is offline
// ══════════════════════════════════════════════════════════════

class _ClosedSummary extends StatelessWidget {
  const _ClosedSummary({required this.onOpen});
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Big "Open kitchen" hero CTA card ──
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.r),
          child: InkWell(
            borderRadius: BorderRadius.circular(22.r),
            onTap: onOpen,
            child: Container(
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.r),
                border: Border.all(color: AppColors.line),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.ink.withValues(alpha: .04),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFE3D2), Color(0xFFFFD0B5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    alignment: Alignment.center,
                    child: Text('😴', style: TextStyle(fontSize: 28.sp)),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    'Take a break,\nyour kitchen is resting.',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -.5,
                      color: AppColors.ink,
                      height: 1.15,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Open the kitchen when you’re ready to take orders again.',
                    style: GoogleFonts.inter(
                      fontSize: 12.5.sp,
                      color: AppColors.muted,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Material(
                    color: AppColors.ink,
                    borderRadius: BorderRadius.circular(99.r),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(99.r),
                      onTap: onOpen,
                      child: Container(
                        height: 48.h,
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(99.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.ink.withValues(alpha: .25),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.power_settings_new_rounded,
                                size: 17.sp, color: Colors.white),
                            SizedBox(width: 8.w),
                            Text(
                              'Open kitchen',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: 18.h),

        // ── Yesterday's summary card ──
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.line),
            boxShadow: [
              BoxShadow(
                color: AppColors.ink.withValues(alpha: .03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'YESTERDAY',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.muted,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.history_rounded,
                      size: 15.sp, color: AppColors.muted),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹920',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -.6,
                      color: AppColors.ink,
                      height: 1,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Padding(
                    padding: EdgeInsets.only(bottom: 3.h),
                    child: Text(
                      '· 7 orders',
                      style: GoogleFonts.inter(
                        fontSize: 12.5.sp,
                        color: AppColors.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              const Divider(height: 1, color: AppColors.line),
              SizedBox(height: 14.h),
              _MiniRow(
                icon: Icons.schedule_rounded,
                label: 'Next scheduled slot',
                value: 'Lunch · 12:00 PM',
                accent: AppColors.primary,
                accentSoft: AppColors.primarySoft,
              ),
              SizedBox(height: 10.h),
              _MiniRow(
                icon: Icons.star_rounded,
                label: 'Your rating',
                value: '4.9 · 142 reviews',
                accent: const Color(0xFFE6A100),
                accentSoft: const Color(0xFFFFF3D6),
              ),
              SizedBox(height: 10.h),
              _MiniRow(
                icon: Icons.restaurant_menu_rounded,
                label: 'Dishes ready to sell',
                value: '12 on your menu',
                accent: AppColors.secondary,
                accentSoft: AppColors.secondarySoft,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniRow extends StatelessWidget {
  const _MiniRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
    required this.accentSoft,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color accent;
  final Color accentSoft;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: accentSoft,
            borderRadius: BorderRadius.circular(10.r),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 16.sp, color: accent),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.5.sp,
              color: AppColors.inkSoft,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  Tip strip
// ══════════════════════════════════════════════════════════════

class _TipStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE1F2EC), Color(0xFFD0E9DC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColors.secondary.withValues(alpha: .15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: .35),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text('💡', style: TextStyle(fontSize: 20.sp)),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lunch rush is coming',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                    letterSpacing: -.2,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Expect 4-6 more orders before 1 PM. Prep ahead to keep delivery under 25 min.',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.secondary,
                    height: 1.55,
                    fontWeight: FontWeight.w500,
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
