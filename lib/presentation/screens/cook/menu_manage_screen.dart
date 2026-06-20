import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routing/route_names.dart';
import 'dish_edit_screen.dart';

/// Cook · Menu manage (Menu tab).
///
/// 2-col grid of dish cards — same visual language as the user-app
/// menu cards (hero image, badges, tinted background), but with the
/// "Add to cart" stepper replaced by an Edit action + a Live/Paused
/// toggle. Dish status and remaining qty are surfaced on the card so
/// the cook can read it at a glance.
class MenuManageScreen extends StatefulWidget {
  const MenuManageScreen({super.key});
  @override
  State<MenuManageScreen> createState() => _MenuManageScreenState();
}

class _MenuManageScreenState extends State<MenuManageScreen> {
  // Mutable list so the Live/Paused toggle survives a rebuild.
  late final List<_DishItem> _dishes = [
    _DishItem(
      name: 'Veg Thali',
      meta: 'Veg · Medium',
      price: 120,
      perDay: 20,
      sold: 8,
      tint: const Color(0xFFFFD9C8),
      image:
          'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8?w=600&q=80&auto=format&fit=crop',
      live: true,
    ),
    _DishItem(
      name: 'Rajma Chawal',
      meta: 'Veg · Mild',
      price: 90,
      perDay: 15,
      sold: 11,
      tint: const Color(0xFFFBEAC6),
      image:
          'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=600&q=80&auto=format&fit=crop',
      live: true,
    ),
    _DishItem(
      name: 'Aloo Paratha',
      meta: 'Veg · Mild · Eggless',
      price: 70,
      perDay: 10,
      sold: 10,
      tint: const Color(0xFFD6EEDF),
      image:
          'https://images.unsplash.com/photo-1626776876729-bab4369a5a5a?w=600&q=80&auto=format&fit=crop',
      live: true,
    ),
    _DishItem(
      name: 'Paneer Butter Masala',
      meta: 'Veg · Medium',
      price: 140,
      perDay: 12,
      sold: 4,
      tint: const Color(0xFFFFE0E0),
      image:
          'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=600&q=80&auto=format&fit=crop',
      live: false,
    ),
  ];

  void _toggleLive(int i) => setState(() => _dishes[i].live = !_dishes[i].live);

  DishDraft _toDraft(_DishItem d) => DishDraft(
        name: d.name,
        price: d.price,
        perDay: d.perDay,
        portion: '2 roti + dal + sabzi + rice',
        diet: 'Veg',
        eggless: true,
        spice: 'Medium',
        ingredients: 'Wheat, dal, mixed veg, ghee, spices',
        shelfLife: '2 hours',
        allergens: const {'Dairy', 'Gluten'},
        cookingMedium: 'Refined',
        description: '',
        photoUploaded: true,
        live: d.live,
      );

  @override
  Widget build(BuildContext context) {
    final liveCount = _dishes.where((d) => d.live).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── App bar ──
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 8.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Menu',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -.6,
                              color: AppColors.ink,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '$liveCount of ${_dishes.length} dishes live',
                            style: GoogleFonts.inter(
                              fontSize: 11.5.sp,
                              color: AppColors.muted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _IconPill(
                      icon: Icons.today_rounded,
                      label: 'Today',
                      onTap: () => Navigator.pushNamed(
                          context, RouteNames.cookTodaysMenu),
                    ),
                    SizedBox(width: 8.w),
                    _AddDishBtn(
                      onTap: () => Navigator.pushNamed(
                          context, RouteNames.cookDishEdit),
                    ),
                  ],
                ),
              ),
            ),

            // ── Section label ──
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 10.h),
                child: Row(
                  children: [
                    Text(
                      'ALL DISHES',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.3,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── 2-col grid ──
            SliverPadding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 110.h),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: .68,
                children: List.generate(_dishes.length, (i) {
                  final d = _dishes[i];
                  return _DishCard(
                    item: d,
                    onEdit: () => Navigator.pushNamed(
                      context,
                      RouteNames.cookDishEdit,
                      arguments: _toDraft(d),
                    ),
                    onToggle: () => _toggleLive(i),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  Data
// ══════════════════════════════════════════════════════════════

class _DishItem {
  _DishItem({
    required this.name,
    required this.meta,
    required this.price,
    required this.perDay,
    required this.sold,
    required this.tint,
    required this.image,
    required this.live,
  });
  final String name;
  final String meta;
  final int price;
  final int perDay;
  final int sold;
  final Color tint;
  final String image;
  bool live;

  int get left => (perDay - sold).clamp(0, perDay);
  bool get soldOut => left == 0;
}

// ══════════════════════════════════════════════════════════════
//  Dish card — same look as user-app, Edit instead of cart
// ══════════════════════════════════════════════════════════════

class _DishCard extends StatelessWidget {
  const _DishCard({
    required this.item,
    required this.onEdit,
    required this.onToggle,
  });
  final _DishItem item;
  final VoidCallback onEdit;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final paused = !item.live;
    return Material(
      color: item.tint,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        onTap: onEdit,
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Hero image with badges ──
              AspectRatio(
                aspectRatio: 1.08,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: SizedBox.expand(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              imageUrl: item.image,
                              fit: BoxFit.cover,
                              placeholder: (_, _) => Shimmer.fromColors(
                                baseColor: Colors.white.withValues(alpha: .35),
                                highlightColor: Colors.white,
                                child: Container(color: Colors.white),
                              ),
                              errorWidget: (_, _, _) => Container(
                                color: Colors.black.withValues(alpha: .04),
                                alignment: Alignment.center,
                                child: Icon(Icons.restaurant_rounded,
                                    color: AppColors.muted, size: 30.sp),
                              ),
                            ),
                            // Dim overlay when paused — visual cue
                            if (paused)
                              Container(
                                color: Colors.white.withValues(alpha: .55),
                              ),
                          ],
                        ),
                      ),
                    ),

                    // Top-left status pill
                    Positioned(
                      top: 6.h,
                      left: 6.w,
                      child: _StatusPill(
                        live: item.live,
                        soldOut: item.soldOut,
                      ),
                    ),

                    // Top-right Live/Paused toggle
                    Positioned(
                      top: 6.h,
                      right: 6.w,
                      child: _LiveToggle(
                        live: item.live,
                        onTap: onToggle,
                      ),
                    ),

                    // Bottom-right qty-left badge
                    if (!paused)
                      Positioned(
                        bottom: 6.h,
                        right: 6.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: .62),
                            borderRadius: BorderRadius.circular(99.r),
                          ),
                          child: Text(
                            item.soldOut
                                ? 'Sold out'
                                : '${item.left} left',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: 10.h),

              // ── Name + meta ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                            letterSpacing: -.2,
                            height: 1.1,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          item.meta,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 10.5.sp,
                            color: AppColors.ink.withValues(alpha: .65),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    // ── Price + Edit button ──
                    Row(
                      children: [
                        Text(
                          '₹${item.price}',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '· ${item.perDay}/day',
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            color: AppColors.ink.withValues(alpha: .55),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        _EditBtn(onTap: onEdit),
                      ],
                    ),
                  ],
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
//  Sub-widgets
// ══════════════════════════════════════════════════════════════

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.live, required this.soldOut});
  final bool live;
  final bool soldOut;
  @override
  Widget build(BuildContext context) {
    final (label, dotColor, fg, bg) = switch ((live, soldOut)) {
      (false, _) => (
          'PAUSED',
          AppColors.muted,
          AppColors.inkSoft,
          Colors.white,
        ),
      (true, true) => (
          'SOLD OUT',
          AppColors.primary,
          AppColors.primaryDark,
          Colors.white,
        ),
      (true, false) => (
          'LIVE',
          AppColors.success,
          AppColors.secondary,
          Colors.white,
        ),
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(99.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 5.w),
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 8.5.sp,
              fontWeight: FontWeight.w800,
              color: fg,
              letterSpacing: .6,
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveToggle extends StatelessWidget {
  const _LiveToggle({required this.live, required this.onTap});
  final bool live;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 32.w,
          height: 32.w,
          child: Icon(
            live ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: live ? AppColors.ink : AppColors.secondary,
            size: 18.sp,
          ),
        ),
      ),
    );
  }
}

class _EditBtn extends StatelessWidget {
  const _EditBtn({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.ink,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 30.w,
          height: 30.w,
          child: Icon(
            Icons.edit_rounded,
            color: Colors.white,
            size: 14.sp,
          ),
        ),
      ),
    );
  }
}

class _IconPill extends StatelessWidget {
  const _IconPill({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(99.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(99.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99.r),
            border: Border.all(color: AppColors.line),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14.sp, color: AppColors.ink),
              SizedBox(width: 5.w),
              Text(
                label,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddDishBtn extends StatelessWidget {
  const _AddDishBtn({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.ink,
      borderRadius: BorderRadius.circular(99.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(99.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.ink.withValues(alpha: .25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, size: 16.sp, color: Colors.white),
              SizedBox(width: 4.w),
              Text(
                'Dish',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
