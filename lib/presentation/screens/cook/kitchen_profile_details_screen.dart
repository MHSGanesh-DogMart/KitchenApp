import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/api_endpoints.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/logger.dart';
import '../../widgets/padosi/padosi_app_bar.dart';

/// Full read-only view of the logged-in kitchen's profile, fed by
/// `GET /api/kitchen/details`. Shows every detail the cook submitted
/// during onboarding (identity, location, FSSAI, operations, documents).
class KitchenProfileDetailsScreen extends StatefulWidget {
  const KitchenProfileDetailsScreen({super.key});

  @override
  State<KitchenProfileDetailsScreen> createState() =>
      _KitchenProfileDetailsScreenState();
}

class _KitchenProfileDetailsScreenState
    extends State<KitchenProfileDetailsScreen> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _cook;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await ApiClient.instance.get(ApiEndpoints.getDetails);
      final data = res.data;
      final cook = (data is Map && data['data'] is Map)
          ? (data['data']['cook'] ?? data['data'])
          : null;
      if (cook is Map) {
        setState(() {
          _cook = Map<String, dynamic>.from(cook);
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'Could not load profile details.';
          _loading = false;
        });
      }
    } catch (e) {
      AppLogger.e('Failed to load kitchen details: $e');
      setState(() {
        _error = 'Failed to load profile. Pull to retry.';
        _loading = false;
      });
    }
  }

  // ── Value helpers ────────────────────────────────────────────────────────
  String _str(dynamic v) {
    if (v == null) return '—';
    final s = v.toString().trim();
    return s.isEmpty ? '—' : s;
  }

  String _mealsText(dynamic meals) {
    if (meals is Map) {
      final on = meals.entries
          .where((e) => e.value == true)
          .map((e) => _capitalize(e.key.toString()))
          .toList();
      return on.isEmpty ? '—' : on.join(' · ');
    }
    return _str(meals);
  }

  String _listText(dynamic v) {
    if (v is List) return v.isEmpty ? '—' : v.join(', ');
    if (v is String && v.isNotEmpty) {
      try {
        final parsed = jsonDecode(v);
        if (parsed is List) return parsed.join(', ');
      } catch (_) {}
      return v;
    }
    return '—';
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

  String _mask(dynamic v) {
    final s = v?.toString() ?? '';
    if (s.length <= 4) return s.isEmpty ? '—' : s;
    return '•••• •••• ${s.substring(s.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PadosiAppBar(title: 'Kitchen Profile', divider: true),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _ErrorView(message: _error!, onRetry: _fetch)
              : RefreshIndicator(
                  onRefresh: _fetch,
                  child: _content(),
                ),
    );
  }

  Widget _content() {
    final c = _cook!;
    final kitchenName = _str(c['kitchenName'] ?? c['name']);
    final owner = _str(c['name']);
    final status = _str(c['status']);
    final tier = c['tier'];
    final banner = (c['bannerUrl'] ?? '').toString();
    final selfie = (c['selfieUrl'] ?? '').toString();

    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 40.h),
      children: [
        // ── Hero header ──
        _HeroHeader(
          bannerUrl: banner,
          selfieUrl: selfie,
          kitchenName: kitchenName,
          owner: owner,
          status: status,
          tier: tier is int ? tier : int.tryParse('$tier') ?? 1,
        ),
        SizedBox(height: 22.h),

        if (_str(c['about']) != '—') ...[
          _Section('About'),
          Text(
            _str(c['about']),
            style: GoogleFonts.inter(
              fontSize: 13.5.sp,
              height: 1.5,
              color: AppColors.inkSoft,
            ),
          ),
          SizedBox(height: 20.h),
        ],

        _Section('Contact'),
        _InfoCard(rows: [
          _Row('Phone', _str(c['phone'])),
          _Row('WhatsApp', _str(c['whatsapp'])),
          _Row('Alt. contact', _str(c['altContact'])),
          _Row('Date of birth', _str(c['dob'])),
        ]),
        SizedBox(height: 20.h),

        _Section('Location'),
        _InfoCard(rows: [
          _Row('Address', _str(c['address'] ?? c['streetAddress'])),
          _Row('Landmark', _str(c['landmark'])),
          _Row('City', _str(c['city'])),
          _Row('State', _str(c['state'])),
          _Row('Pincode', _str(c['pincode'])),
          if (c['lat'] != null && c['lng'] != null)
            _Row('Coordinates', '${c['lat']}, ${c['lng']}'),
        ]),
        SizedBox(height: 20.h),

        _Section('Operations'),
        _InfoCard(rows: [
          _Row('Meals served', _mealsText(c['meals'])),
          _Row('Daily capacity', _str(c['capacity'])),
          _Row('Order cutoff', _str(c['cutoffNotice'])),
          _Row('Weekly off', _listText(c['weeklyOff'])),
          _Row('Cuisines', _listText(c['cuisines'])),
          _Row('Packaging', _str(c['packagingType'])),
          _Row('Delivery mode', _str(c['deliveryMode'])),
          _Row('Veg only', (c['isVegOnly'] == true) ? 'Yes' : 'No'),
        ]),
        SizedBox(height: 20.h),

        _Section('FSSAI & KYC'),
        _InfoCard(rows: [
          _Row('Has FSSAI', (c['hasExistingFssai'] == true) ? 'Yes' : 'No'),
          _Row('FSSAI number', _str(c['fssaiNumber'])),
          _Row('FSSAI expiry', _str(c['fssaiExpiry'])),
          _Row('Aadhaar', _mask(c['aadhaarNo'])),
          _Row('PAN', _mask(c['panNo'])),
        ]),
        SizedBox(height: 20.h),

        _Section('Documents'),
        _DocGrid(docs: [
          _Doc('Selfie', selfie),
          _Doc('Aadhaar', (c['aadhaarUrl'] ?? '').toString()),
          _Doc('PAN', (c['panUrl'] ?? '').toString()),
          _Doc('FSSAI', (c['fssaiUrl'] ?? '').toString()),
          _Doc('Cooking area', (c['cookingUrl'] ?? '').toString()),
          _Doc('Storage', (c['storageUrl'] ?? '').toString()),
          _Doc('Sink', (c['sinkUrl'] ?? '').toString()),
        ]),
      ],
    );
  }
}

// ── Hero header ──────────────────────────────────────────────────────────────
class _HeroHeader extends StatelessWidget {
  const _HeroHeader({
    required this.bannerUrl,
    required this.selfieUrl,
    required this.kitchenName,
    required this.owner,
    required this.status,
    required this.tier,
  });

  final String bannerUrl;
  final String selfieUrl;
  final String kitchenName;
  final String owner;
  final String status;
  final int tier;

  bool get _isVerified =>
      const ['Verified', 'ACTIVE', 'Active', 'Kitchen_Approved']
          .contains(status);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // banner
          SizedBox(
            height: 110.h,
            width: double.infinity,
            child: bannerUrl.isNotEmpty
                ? Image.network(
                    bannerUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.primary.withValues(alpha: .12),
                    ),
                  )
                : Container(color: AppColors.primary.withValues(alpha: .12)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: Column(
              children: [
                Transform.translate(
                  offset: Offset(0, -28.h),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 34.r,
                      backgroundColor: AppColors.primary,
                      backgroundImage:
                          selfieUrl.isNotEmpty ? NetworkImage(selfieUrl) : null,
                      child: selfieUrl.isEmpty
                          ? Text(
                              owner.isNotEmpty ? owner[0].toUpperCase() : 'K',
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.white,
                                fontSize: 26.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, -14.h),
                  child: Column(
                    children: [
                      Text(
                        kitchenName,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 19.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'by $owner',
                        style: GoogleFonts.inter(
                          fontSize: 12.5.sp,
                          color: AppColors.muted,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Wrap(
                        spacing: 8.w,
                        children: [
                          _Pill(
                            label: _isVerified ? '✓ $status' : status,
                            color: _isVerified
                                ? const Color(0xFF1B873F)
                                : AppColors.primary,
                          ),
                          _Pill(
                            label: '🏠 Tier $tier',
                            color: AppColors.tier1,
                          ),
                        ],
                      ),
                    ],
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

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

// ── Section title ─────────────────────────────────────────────────────────────
class _Section extends StatelessWidget {
  const _Section(this.title);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.spaceGrotesk(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
          color: AppColors.muted,
        ),
      ),
    );
  }
}

// ── Info card / rows ──────────────────────────────────────────────────────────
class _Row {
  const _Row(this.label, this.value);
  final String label;
  final String value;
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.rows});
  final List<_Row> rows;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120.w,
                    child: Text(
                      rows[i].label,
                      style: GoogleFonts.inter(
                        fontSize: 12.5.sp,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      rows[i].value,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (i != rows.length - 1)
              Divider(height: 1, color: AppColors.line),
          ],
        ],
      ),
    );
  }
}

// ── Documents grid ──────────────────────────────────────────────────────────
class _Doc {
  const _Doc(this.label, this.url);
  final String label;
  final String url;
}

class _DocGrid extends StatelessWidget {
  const _DocGrid({required this.docs});
  final List<_Doc> docs;
  @override
  Widget build(BuildContext context) {
    final available = docs.where((d) => d.url.isNotEmpty).toList();
    if (available.isEmpty) {
      return Text(
        'No documents uploaded.',
        style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.muted),
      );
    }
    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: available
          .map((d) => _DocThumb(doc: d))
          .toList(),
    );
  }
}

class _DocThumb extends StatelessWidget {
  const _DocThumb({required this.doc});
  final _Doc doc;
  @override
  Widget build(BuildContext context) {
    final w = (1.sw - 40.w - 24.w) / 3; // 3 per row inside 20w padding
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(20.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: InteractiveViewer(
              child: Image.network(doc.url, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
      child: SizedBox(
        width: w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  doc.url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.line,
                    child: Icon(Icons.broken_image_outlined,
                        color: AppColors.muted, size: 22.sp),
                  ),
                  loadingBuilder: (ctx, child, progress) => progress == null
                      ? child
                      : Container(
                          color: AppColors.line,
                          child: const Center(
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              doc.label,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.inkSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error view ────────────────────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 48.sp, color: AppColors.muted),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14.sp, color: AppColors.inkSoft),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99.r),
                ),
              ),
              child: Text('Retry',
                  style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
