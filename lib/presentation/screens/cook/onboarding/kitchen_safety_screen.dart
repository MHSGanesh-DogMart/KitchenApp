import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/services/image_picker_service.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../providers/onboarding_provider.dart';
import '_onboarding_widgets.dart';

/// Cook · Location & FSSAI details (3 of 4).
class CookKitchenSafetyScreen extends StatefulWidget {
  const CookKitchenSafetyScreen({super.key});
  @override
  State<CookKitchenSafetyScreen> createState() =>
      _CookKitchenSafetyScreenState();
}

class _CookKitchenSafetyScreenState extends State<CookKitchenSafetyScreen> {
  bool _gps = true;
  bool _vegOnly = false;
  bool _hasExistingFssai = false;

  final _streetCtrl = TextEditingController();
  final _landmarkCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();
  final _pincodeCtrl = TextEditingController();

  final _fssaiNoCtrl = TextEditingController();
  final _fssaiExpiryCtrl = TextEditingController();

  bool _uploadingFssai = false;
  bool _fssaiUploaded = false;

  @override
  void initState() {
    super.initState();
    final p = Provider.of<OnboardingProvider>(context, listen: false);
    _vegOnly = p.isVegOnly;
    _streetCtrl.text = p.streetAddress;
    _landmarkCtrl.text = p.landmark;
    _cityCtrl.text = p.city;
    _stateCtrl.text = p.state;
    _pincodeCtrl.text = p.pincode;
    
    _hasExistingFssai = p.hasExistingFssai;
    _fssaiNoCtrl.text = p.fssaiNumber;
    _fssaiExpiryCtrl.text = p.fssaiExpiry;
    _fssaiUploaded = p.fssaiUrl.isNotEmpty;
  }

  @override
  void dispose() {
    _streetCtrl.dispose();
    _landmarkCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _pincodeCtrl.dispose();
    _fssaiNoCtrl.dispose();
    _fssaiExpiryCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFssaiExpiry() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 365)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 5)),
      helpText: 'FSSAI License Expiry Date',
    );
    if (picked != null) {
      setState(() {
        _fssaiExpiryCtrl.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _pickAndUploadFssai() async {
    final provider = Provider.of<OnboardingProvider>(context, listen: false);
    final file = await ImagePickerService.pickFromSheet();
    if (file == null) return;
    setState(() => _uploadingFssai = true);
    final ok = await provider.uploadDocument('fssai', file);
    if (mounted) {
      setState(() {
        _uploadingFssai = false;
        _fssaiUploaded = ok;
      });
      if (ok) ToastService.success('FSSAI Certificate uploaded.');
    }
  }

  void _clearFssai() {
    Provider.of<OnboardingProvider>(context, listen: false).clearDocument('fssai');
    setState(() => _fssaiUploaded = false);
    ToastService.success('FSSAI Certificate removed.');
  }

  void _onContinue() {
    final p = Provider.of<OnboardingProvider>(context, listen: false);
    
    if (!_gps) {
      ToastService.error('Please pin your kitchen location.');
      return;
    }
    if (_streetCtrl.text.trim().isEmpty) {
      ToastService.error('Street address is required.');
      return;
    }
    if (_cityCtrl.text.trim().isEmpty) {
      ToastService.error('City is required.');
      return;
    }
    if (_stateCtrl.text.trim().isEmpty) {
      ToastService.error('State is required.');
      return;
    }
    if (_pincodeCtrl.text.trim().length != 6) {
      ToastService.error('Valid 6-digit Pincode is required.');
      return;
    }

    if (_hasExistingFssai) {
      if (_fssaiNoCtrl.text.trim().length != 14) {
        ToastService.error('Valid 14-digit FSSAI License Number is required.');
        return;
      }
      if (_fssaiExpiryCtrl.text.trim().isEmpty) {
        ToastService.error('FSSAI Expiry Date is required.');
        return;
      }
      if (p.fssaiUrl.isEmpty) {
        ToastService.error('Please upload your FSSAI Certificate photo.');
        return;
      }
    }

    p.updateField(
      isVegOnly: _vegOnly,
      lat: 17.4451,
      lng: 78.3502,
      streetAddress: _streetCtrl.text.trim(),
      landmark: _landmarkCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      state: _stateCtrl.text.trim(),
      pincode: _pincodeCtrl.text.trim(),
      hasExistingFssai: _hasExistingFssai,
      fssaiNumber: _hasExistingFssai ? _fssaiNoCtrl.text.trim() : '',
      fssaiExpiry: _hasExistingFssai ? _fssaiExpiryCtrl.text.trim() : '',
    );

    Navigator.pushNamed(context, RouteNames.cookOperations);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnboardingProvider>(context);

    return OnboardingScaffold(
      step: 3,
      totalSteps: 4,
      kicker: 'Location & FSSAI',
      title: 'Kitchen location\n& FSSAI license',
      subtitle: 'Where is your kitchen located, and what is your FSSAI license status?',
      gradient: const [Color(0xFFE1F2EC), Color(0xFFCFE9DC), Color(0xFFF1F8F4)],
      ctaLabel: 'Continue to Operations',
      onCta: _onContinue,
      body: [
        OnboardingSection(
          title: 'Pin your location',
          hint: 'Helps delivery partners reach you fast.',
          icon: Icons.location_on_outlined,
        ),
        _GpsCard(pinned: _gps, onTap: () => setState(() => _gps = !_gps)),

        SizedBox(height: 26.h),
        OnboardingSection(
          title: 'Structured Address',
          hint: 'Enter your complete address details.',
          icon: Icons.home_outlined,
        ),
        PremiumField(
          controller: _streetCtrl,
          label: 'House No, Building & Street',
          hint: 'Flat 402, Lotus Heights, Outer Ring Road',
          required: true,
          textCapitalization: TextCapitalization.words,
        ),
        SizedBox(height: 10.h),
        PremiumField(
          controller: _landmarkCtrl,
          label: 'Landmark (Optional)',
          hint: 'e.g. Near HDFC Bank ATM',
          textCapitalization: TextCapitalization.words,
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: PremiumField(
                controller: _cityCtrl,
                label: 'City',
                hint: 'Hyderabad',
                required: true,
                textCapitalization: TextCapitalization.words,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: PremiumField(
                controller: _stateCtrl,
                label: 'State',
                hint: 'Telangana',
                required: true,
                textCapitalization: TextCapitalization.words,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        PremiumField(
          controller: _pincodeCtrl,
          label: 'Pincode',
          hint: '6 digits',
          keyboardType: TextInputType.number,
          required: true,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
        ),

        SizedBox(height: 26.h),
        OnboardingSection(
          title: 'FSSAI License status',
          hint: 'Select your current FSSAI status.',
          icon: Icons.verified_user_outlined,
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _hasExistingFssai = false),
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: !_hasExistingFssai ? AppColors.secondarySoft : AppColors.surface,
                    border: Border.all(
                      color: !_hasExistingFssai ? AppColors.secondary : AppColors.line,
                      width: !_hasExistingFssai ? 1.4 : 1,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      Text('🎟️', style: TextStyle(fontSize: 22.sp)),
                      SizedBox(height: 6.h),
                      Text(
                        'Apply for Basic',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'We register you (~₹100/yr)',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          color: AppColors.muted,
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
                onTap: () => setState(() => _hasExistingFssai = true),
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: _hasExistingFssai ? AppColors.secondarySoft : AppColors.surface,
                    border: Border.all(
                      color: _hasExistingFssai ? AppColors.secondary : AppColors.line,
                      width: _hasExistingFssai ? 1.4 : 1,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      Text('📜', style: TextStyle(fontSize: 22.sp)),
                      SizedBox(height: 6.h),
                      Text(
                        'I have a license',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Enter number & upload cert',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_hasExistingFssai) ...[
          SizedBox(height: 16.h),
          PremiumField(
            controller: _fssaiNoCtrl,
            label: 'FSSAI License number',
            hint: '14 digits',
            keyboardType: TextInputType.number,
            required: true,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(14),
            ],
          ),
          SizedBox(height: 10.h),
          PremiumField(
            controller: _fssaiExpiryCtrl,
            label: 'FSSAI Expiry date',
            hint: 'YYYY-MM-DD',
            readOnly: true,
            onTap: _pickFssaiExpiry,
            suffixIcon: Icons.calendar_today_rounded,
            required: true,
          ),
          SizedBox(height: 10.h),
          UploadTile(
            title: 'FSSAI Certificate photo',
            helper: _uploadingFssai ? 'Uploading...' : 'Clear photo of license certificate',
            icon: Icons.cloud_upload_outlined,
            uploaded: _fssaiUploaded,
            required: true,
            imageUrl: provider.fssaiUrl,
            onTap: _pickAndUploadFssai,
            onRemove: _clearFssai,
          ),
        ],

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
