import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/services/image_picker_service.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/config/api_endpoints.dart';
import '../../../../core/utils/logger.dart';
import '../../../../providers/onboarding_provider.dart';
import '_onboarding_widgets.dart';

/// Cook onboarding · Choose tier & Branding profile (1 of 4).
class CookTierScreen extends StatefulWidget {
  const CookTierScreen({super.key});
  @override
  State<CookTierScreen> createState() => _CookTierScreenState();
}

class _CookTierScreenState extends State<CookTierScreen> {
  int _tier = 1;
  final _kitchenNameCtrl = TextEditingController();
  final _aboutCtrl = TextEditingController();

  bool _uploadingBanner = false;
  bool _bannerUploaded = false;

  List<String> _allCuisines = [];
  final List<String> _selectedCuisines = [];
  bool _loadingCuisines = true;

  @override
  void initState() {
    super.initState();
    final p = Provider.of<OnboardingProvider>(context, listen: false);
    _tier = p.tier;
    _kitchenNameCtrl.text = p.kitchenName;
    _aboutCtrl.text = p.about;
    _selectedCuisines.addAll(p.cuisines);
    _bannerUploaded = p.bannerUrl.isNotEmpty;
    _fetchCuisines();
  }

  @override
  void dispose() {
    _kitchenNameCtrl.dispose();
    _aboutCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchCuisines() async {
    try {
      final res = await ApiClient.instance.get(ApiEndpoints.getCuisines);
      if (res.statusCode == 200 && res.data != null) {
        final success = res.data['success'] as bool? ?? false;
        final list = res.data['data'] as List?;
        if (success && list != null) {
          setState(() {
            _allCuisines = list
                .map((item) => (item['name'] ?? '').toString())
                .where((n) => n.isNotEmpty)
                .toList();
            _loadingCuisines = false;
          });
          return;
        }
      }
    } catch (e) {
      AppLogger.e('Error fetching cuisines', e);
    }
    // Fallback cuisines if API fails
    setState(() {
      _allCuisines = [
        'North Indian',
        'South Indian',
        'Chinese',
        'Continental',
        'Street Food',
        'Biryani',
        'Healthy & Diet',
        'Desserts',
      ];
      _loadingCuisines = false;
    });
  }

  Future<void> _pickAndUploadBanner() async {
    final provider = Provider.of<OnboardingProvider>(context, listen: false);
    final file = await ImagePickerService.pickFromSheet();
    if (file == null) return;
    setState(() => _uploadingBanner = true);
    final ok = await provider.uploadDocument('banner', file);
    if (mounted) {
      setState(() {
        _uploadingBanner = false;
        _bannerUploaded = ok;
      });
      if (ok) ToastService.success('Banner image uploaded successfully.');
    }
  }

  void _clearBanner() {
    Provider.of<OnboardingProvider>(
      context,
      listen: false,
    ).clearDocument('banner');
    setState(() => _bannerUploaded = false);
    ToastService.success('Banner image removed.');
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnboardingProvider>(context);

    return OnboardingScaffold(
      step: 1,
      totalSteps: 4,
      kicker: 'Welcome aboard',
      title: "Choose how\nyou'll sell",
      subtitle: 'Setup your kitchen tier and storefront profile branding.',
      ctaLabel: 'Continue to Identity',
      onCta: () {
        if (_kitchenNameCtrl.text.trim().isEmpty) {
          ToastService.error('Kitchen name is required.');
          return;
        }
        if (_aboutCtrl.text.trim().isEmpty) {
          ToastService.error('About description is required.');
          return;
        }
        if (_selectedCuisines.isEmpty) {
          ToastService.error('Please select at least one cuisine.');
          return;
        }
        if (provider.bannerUrl.isEmpty) {
          ToastService.error('Please upload a storefront banner image.');
          return;
        }

        provider.setTier(_tier);
        provider.updateField(
          kitchenName: _kitchenNameCtrl.text.trim(),
          about: _aboutCtrl.text.trim(),
          cuisines: _selectedCuisines,
        );
        Navigator.pushNamed(context, RouteNames.cookIdentity);
      },
      body: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _tier = 1),
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: _tier == 1 ? AppColors.primarySoft : AppColors.surface,
                    border: Border.all(
                      color: _tier == 1 ? AppColors.primary : AppColors.line,
                      width: _tier == 1 ? 1.4 : 1,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      Text('🏠', style: TextStyle(fontSize: 22.sp)),
                      SizedBox(height: 6.h),
                      Text(
                        'Home Chef',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Tier 1',
                        style: GoogleFonts.inter(
                          fontSize: 10.5.sp,
                          color: AppColors.muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _tier = 2),
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: _tier == 2 ? AppColors.primarySoft : AppColors.surface,
                    border: Border.all(
                      color: _tier == 2 ? AppColors.primary : AppColors.line,
                      width: _tier == 2 ? 1.4 : 1,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      Text('🏢', style: TextStyle(fontSize: 22.sp)),
                      SizedBox(height: 6.h),
                      Text(
                        'Verified Kitchen',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Tier 2',
                        style: GoogleFonts.inter(
                          fontSize: 10.5.sp,
                          color: AppColors.muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: _tier == 1 ? AppColors.tier1Soft : AppColors.tier2Soft,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: _tier == 1
                  ? AppColors.tier1.withValues(alpha: .35)
                  : AppColors.tier2.withValues(alpha: .35),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('💡', style: TextStyle(fontSize: 14.sp)),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  _tier == 1
                      ? 'Tier 1 Home Chef: For small-scale home cooks. Requires Aadhaar, PAN, bank account, and FSSAI Basic registration (~₹100/yr).'
                      : 'Tier 2 Verified Kitchen: For licensed commercial setups. Requires FSSAI License, GST, and business details. Higher order limits.',
                  style: GoogleFonts.inter(
                    fontSize: 11.5.sp,
                    color: _tier == 1 ? AppColors.tier1 : AppColors.tier2,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // SizedBox(height: 16.h),
        // InfoCallout(
        //   icon: Icons.verified_user_outlined,
        //   text: 'You can upgrade your tier anytime from Settings.',
        // ),
        SizedBox(height: 26.h),
        OnboardingSection(
          title: 'Kitchen Details',
          hint: 'This is visible to buyers on the platform.',
          icon: Icons.storefront_outlined,
        ),
        PremiumField(
          controller: _kitchenNameCtrl,
          label: 'Kitchen name',
          hint: "e.g. Sita's Homestyle Bites",
          required: true,
          textCapitalization: TextCapitalization.words,
        ),
        SizedBox(height: 10.h),
        PremiumField(
          controller: _aboutCtrl,
          label: 'About / bio',
          hint: "e.g. Cooking authentic food for over 10 years...",
          maxLines: 2,
          required: true,
          textCapitalization: TextCapitalization.sentences,
        ),

        SizedBox(height: 26.h),
        OnboardingSection(
          title: 'Cuisines specialization',
          hint: 'Select the cuisines you cook.',
          icon: Icons.restaurant_menu_outlined,
        ),
        _loadingCuisines
            ? const Center(child: CircularProgressIndicator())
            : Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: _allCuisines.map((cuisine) {
                  final selected = _selectedCuisines.contains(cuisine);
                  return FilterChip(
                    label: Text(cuisine),
                    selected: selected,
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          _selectedCuisines.add(cuisine);
                        } else {
                          _selectedCuisines.remove(cuisine);
                        }
                      });
                    },
                    selectedColor: AppColors.primarySoft,
                    checkmarkColor: AppColors.primaryDark,
                    labelStyle: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected
                          ? AppColors.primaryDark
                          : AppColors.inkSoft,
                    ),
                    backgroundColor: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99.r),
                      side: BorderSide(
                        color: selected ? AppColors.primary : AppColors.line,
                      ),
                    ),
                  );
                }).toList(),
              ),

        SizedBox(height: 26.h),
        OnboardingSection(
          title: 'Storefront banner image',
          hint: 'Upload a beautiful image of your storefront or dishes.',
          icon: Icons.image_outlined,
        ),
        UploadTile(
          style: UploadStyle.hero,
          title: 'Upload banner image',
          helper: _uploadingBanner
              ? 'Uploading...'
              : 'Hold your phone sideways for landscape shots',
          icon: Icons.cloud_upload_outlined,
          uploaded: _bannerUploaded,
          required: true,
          imageUrl: provider.bannerUrl,
          onTap: _pickAndUploadBanner,
          onRemove: _clearBanner,
        ),
      ],
    );
  }
}

