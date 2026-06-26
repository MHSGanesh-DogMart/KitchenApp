import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../controllers/menu_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routing/route_names.dart';
import '../../../models/menu_item.dart';
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
  // Card background tints, cycled across the grid.
  static const _tints = [
    Color(0xFFFFD9C8),
    Color(0xFFFBEAC6),
    Color(0xFFD6EEDF),
    Color(0xFFFFE0E0),
  ];

  List<_DishItem> _dishes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final items = await MenuApiController.instance.fetchMenus();
    if (!mounted) return;
    setState(() {
      _dishes = [
        for (var i = 0; i < items.length; i++)
          _DishItem.fromModel(items[i], _tints[i % _tints.length]),
      ];
      _loading = false;
    });
  }

  Future<void> _toggleLive(int i) async {
    final d = _dishes[i];
    final next = !d.live;
    setState(() => d.live = next);
    final ok = await MenuApiController.instance.setAvailability(d.id, next);
    if (!ok && mounted) setState(() => d.live = !next); // revert on failure
  }

  /// Open add/edit; refresh the list when something changed.
  Future<void> _openEditor({DishDraft? draft}) async {
    final result = await Navigator.pushNamed(
      context,
      RouteNames.cookDishEdit,
      arguments: draft,
    );
    if (result != null) _load();
  }

  DishDraft _toDraft(_DishItem d) {
    final m = d.model;
    return DishDraft(
      id: m.id,
      imageUrl: m.imageUrl,
      name: m.name,
      price: m.price.round(),
      perDay: m.perDay,
      portion: m.portion ?? '',
      diet: m.diet,
      eggless: m.eggless,
      spice: m.spice,
      ingredients: m.ingredients ?? '',
      shelfLife: '',
      cookingMedium: '',
      description: m.description ?? '',
      photoUploaded: (m.imageUrl ?? '').isNotEmpty,
      live: m.isAvailable,
    );
  }

  @override
  Widget build(BuildContext context) {
    final liveCount = _dishes.where((d) => d.live).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _load,
          color: AppColors.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
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
                      // _IconPill(
                      //   icon: Icons.today_rounded,
                      //   label: 'Today',
                      //   onTap: () => Navigator.pushNamed(
                      //     context,
                      //     RouteNames.cookTodaysMenu,
                      //   ),
                      // ),
                      // SizedBox(width: 8.w),
                      _AddDishBtn(onTap: () => _openEditor()),
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
              if (_loading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_dishes.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyMenu(onAdd: () => _openEditor()),
                )
              else
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
                        onEdit: () => _openEditor(draft: _toDraft(d)),
                        onToggle: () => _toggleLive(i),
                      );
                    }),
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
//  Empty state
// ══════════════════════════════════════════════════════════════

class _EmptyMenu extends StatelessWidget {
  const _EmptyMenu({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(32.w, 0, 32.w, 80.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustrative icon stack
          Container(
            width: 104.w,
            height: 104.w,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Container(
              width: 74.w,
              height: 74.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.restaurant_menu_rounded,
                size: 36.sp,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(height: 22.h),
          Text(
            'Your menu is empty',
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 19.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: -.4,
              color: AppColors.ink,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add your home-cooked dishes so customers\ncan start ordering from your kitchen.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: AppColors.muted,
              height: 1.5,
            ),
          ),
          SizedBox(height: 24.h),
          // Primary CTA
          Material(
            color: AppColors.ink,
            borderRadius: BorderRadius.circular(99.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(99.r),
              onTap: onAdd,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 14.h),
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
                    Icon(Icons.add_rounded, size: 18.sp, color: Colors.white),
                    SizedBox(width: 6.w),
                    Text(
                      'Add your first dish',
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
          SizedBox(height: 14.h),
          Text(
            'Pull down to refresh',
            style: GoogleFonts.inter(
              fontSize: 11.5.sp,
              color: AppColors.muted.withValues(alpha: .8),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  Data
// ══════════════════════════════════════════════════════════════

class _DishItem {
  _DishItem({
    required this.id,
    required this.name,
    required this.meta,
    required this.price,
    required this.perDay,
    required this.sold,
    required this.tint,
    required this.image,
    required this.live,
    required this.model,
  });

  factory _DishItem.fromModel(MenuItem m, Color tint) => _DishItem(
    id: m.id,
    name: m.name,
    meta: m.metaLine,
    price: m.price.round(),
    perDay: m.perDay,
    sold: 0, // backend has no sold-count yet
    tint: tint,
    image: m.imageUrl ?? '',
    live: m.isAvailable,
    model: m,
  );

  final String id;
  final String name;
  final String meta;
  final int price;
  final int perDay;
  final int sold;
  final Color tint;
  final String image;
  bool live;
  final MenuItem model;

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
                                child: Icon(
                                  Icons.restaurant_rounded,
                                  color: AppColors.muted,
                                  size: 30.sp,
                                ),
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
                      child: _LiveToggle(live: item.live, onTap: onToggle),
                    ),

                    // Bottom-right qty-left badge
                    if (!paused)
                      Positioned(
                        bottom: 6.h,
                        right: 6.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: .62),
                            borderRadius: BorderRadius.circular(99.r),
                          ),
                          child: Text(
                            item.soldOut ? 'Sold out' : '${item.left} left',
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
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
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
          child: Icon(Icons.edit_rounded, color: Colors.white, size: 14.sp),
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
