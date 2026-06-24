import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/services/image_picker_service.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../providers/onboarding_provider.dart';
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
  bool _gps = true;
  bool _vegOnly = false;

  bool _uploadingCooking = false;
  bool _uploadingStorage = false;
  bool _uploadingSink = false;

  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final p = Provider.of<OnboardingProvider>(context, listen: false);
    _cooking = p.cookingUrl.isNotEmpty;
    _storage = p.storageUrl.isNotEmpty;
    _sink = p.sinkUrl.isNotEmpty;
    _vegOnly = p.isVegOnly;
    _addressController.text = p.address;
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUpload(String docType) async {
    final provider = Provider.of<OnboardingProvider>(context, listen: false);
    final file = await ImagePickerService.pickFromSheet();
    if (file == null) return;

    setState(() {
      if (docType == 'cooking') _uploadingCooking = true;
      if (docType == 'storage') _uploadingStorage = true;
      if (docType == 'sink') _uploadingSink = true;
    });

    final ok = await provider.uploadDocument(docType, file);

    if (mounted) {
      setState(() {
        if (docType == 'cooking') {
          _uploadingCooking = false;
          _cooking = ok;
        }
        if (docType == 'storage') {
          _uploadingStorage = false;
          _storage = ok;
        }
        if (docType == 'sink') {
          _uploadingSink = false;
          _sink = ok;
        }
      });
      if (ok) {
        ToastService.success('${docType[0].toUpperCase()}${docType.substring(1)} photo uploaded successfully.');
      }
    }
  }

  void _clearDocument(String docType) {
    final provider = Provider.of<OnboardingProvider>(context, listen: false);
    provider.clearDocument(docType);
    setState(() {
      if (docType == 'cooking') _cooking = false;
      if (docType == 'storage') _storage = false;
      if (docType == 'sink') _sink = false;
    });
    ToastService.success('${docType[0].toUpperCase()}${docType.substring(1)} photo removed.');
  }

  void _onContinue() {
    final p = Provider.of<OnboardingProvider>(context, listen: false);
    if (p.cookingUrl.isEmpty) {
      ToastService.error('Cooking area photo is required.');
      return;
    }
    if (p.storageUrl.isEmpty) {
      ToastService.error('Storage / fridge photo is required.');
      return;
    }
    if (p.sinkUrl.isEmpty) {
      ToastService.error('Sink / washing area photo is required.');
      return;
    }
    if (!_gps) {
      ToastService.error('Please pin your kitchen location.');
      return;
    }
    if (_addressController.text.trim().isEmpty) {
      ToastService.error('Kitchen address is required.');
      return;
    }

    p.updateField(
      isVegOnly: _vegOnly,
      lat: 17.4451,
      lng: 78.3502,
      address: _addressController.text.trim(),
    );

    Navigator.pushNamed(context, RouteNames.cookFssai);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnboardingProvider>(context);
    return OnboardingScaffold(
      step: 3,
      totalSteps: 5,
      kicker: 'Your kitchen',
      title: 'Show off your\nkitchen',
      subtitle:
          'Real photos build trust. Customers want to see where their food is cooked.',
      gradient: const [Color(0xFFE1F2EC), Color(0xFFCFE9DC), Color(0xFFF1F8F4)],
      ctaLabel: 'Continue to FSSAI',
      onCta: _onContinue,
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
                helper: _uploadingCooking ? 'Uploading...' : '',
                icon: Icons.local_fire_department_outlined,
                uploaded: _cooking,
                required: true,
                imageUrl: provider.cookingUrl,
                onTap: () => _pickAndUpload('cooking'),
                onRemove: () => _clearDocument('cooking'),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: UploadTile(
                style: UploadStyle.square,
                title: 'Storage /\nfridge',
                helper: _uploadingStorage ? 'Uploading...' : '',
                icon: Icons.kitchen_outlined,
                uploaded: _storage,
                required: true,
                imageUrl: provider.storageUrl,
                onTap: () => _pickAndUpload('storage'),
                onRemove: () => _clearDocument('storage'),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: UploadTile(
                style: UploadStyle.square,
                title: 'Sink /\nwashing',
                helper: _uploadingSink ? 'Uploading...' : '',
                icon: Icons.water_drop_outlined,
                uploaded: _sink,
                required: true,
                imageUrl: provider.sinkUrl,
                onTap: () => _pickAndUpload('sink'),
                onRemove: () => _clearDocument('sink'),
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

        SizedBox(height: 26.h),
        OnboardingSection(
          title: 'Kitchen Address',
          hint: 'House/Flat number, Building, Street, Area',
          icon: Icons.home_outlined,
        ),
        TextFormField(
          controller: _addressController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'Enter your complete kitchen address',
            hintStyle: GoogleFonts.inter(
              fontSize: 13.5.sp,
              color: AppColors.muted,
            ),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: AppColors.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: AppColors.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          ),
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: AppColors.ink,
          ),
        ),

        SizedBox(height: 26.h),
        OnboardingSection(
          title: 'About your kitchen',
          icon: Icons.restaurant_outlined,
        ),
        _VegOnlyCard(
          value: _vegOnly,
          onChanged: (v) => setState(() => _vegOnly = v),
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
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              pinned ? 'Location pinned' : 'Pin my exact location',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                                letterSpacing: -.1,
                              ),
                            ),
                          ),
                          if (!pinned) ...[
                            SizedBox(width: 6.w),
                            const Text(
                              '*',
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ],
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
