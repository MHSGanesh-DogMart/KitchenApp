import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routing/route_names.dart';
import '_onboarding_widgets.dart';

/// Cook · Identity & KYC (2 of 6).
class CookIdentityScreen extends StatefulWidget {
  const CookIdentityScreen({super.key});
  @override
  State<CookIdentityScreen> createState() => _CookIdentityScreenState();
}

class _CookIdentityScreenState extends State<CookIdentityScreen> {
  bool _selfie = false;
  bool _aadhaar = false;
  bool _pan = false;

  final _name = TextEditingController(text: 'Sunita Sharma');
  final _dob = TextEditingController();
  final _aadhaarNo = TextEditingController();
  final _panNo = TextEditingController();
  final _whatsapp = TextEditingController();
  final _alt = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _dob.dispose();
    _aadhaarNo.dispose();
    _panNo.dispose();
    _whatsapp.dispose();
    _alt.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25),
      firstDate: DateTime(1940),
      lastDate: DateTime(now.year - 18),
      helpText: 'Your date of birth',
    );
    if (picked != null) {
      _dob.text = '${picked.day.toString().padLeft(2, '0')}/'
          '${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      step: 2,
      totalSteps: 6,
      kicker: 'Identity',
      title: "Let's verify\nit's you",
      subtitle:
          'Encrypted & reviewed only by our team. Buyers see only your name and tier.',
      gradient: const [
        Color(0xFFFFF1E9),
        Color(0xFFFFD9C8),
        Color(0xFFFFF7F1),
      ],
      ctaLabel: 'Continue to Kitchen',
      onCta: () =>
          Navigator.pushNamed(context, RouteNames.cookKitchenSafety),
      body: [
        // Selfie hero
        OnboardingSection(
          title: 'A live photo of you',
          hint: 'Face fully visible, good lighting, no filter.',
          icon: Icons.face_outlined,
        ),
        UploadTile(
          style: UploadStyle.hero,
          title: 'Take a live selfie',
          helper: 'Hold your face inside the frame',
          icon: Icons.add_a_photo_outlined,
          uploaded: _selfie,
          required: true,
          onTap: () => setState(() => _selfie = !_selfie),
        ),

        SizedBox(height: 26.h),
        OnboardingSection(
          title: 'Personal details',
          icon: Icons.person_outline_rounded,
        ),
        PremiumField(
          controller: _name,
          label: 'Full name (as on Aadhaar)',
          hint: 'Sunita Sharma',
        ),
        SizedBox(height: 10.h),
        PremiumField(
          controller: _dob,
          label: 'Date of birth',
          hint: 'DD / MM / YYYY',
          readOnly: true,
          onTap: _pickDob,
          suffixIcon: Icons.calendar_today_rounded,
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: PremiumField(
                controller: _whatsapp,
                label: 'WhatsApp',
                hint: '10 digits',
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: PremiumField(
                controller: _alt,
                label: 'Alt contact',
                hint: 'Family',
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 26.h),
        OnboardingSection(
          title: 'Aadhaar card',
          hint: 'Number + clear photo of both sides.',
          icon: Icons.badge_outlined,
        ),
        PremiumField(
          controller: _aadhaarNo,
          label: 'Aadhaar number',
          hint: '12 digits',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(12),
          ],
        ),
        SizedBox(height: 10.h),
        UploadTile(
          title: 'Aadhaar — front & back',
          helper: 'Both sides in one frame, or two photos',
          icon: Icons.cloud_upload_outlined,
          uploaded: _aadhaar,
          required: true,
          onTap: () => setState(() => _aadhaar = !_aadhaar),
        ),

        SizedBox(height: 26.h),
        OnboardingSection(
          title: 'PAN card',
          hint: 'Name on PAN must match your bank account.',
          icon: Icons.credit_card_outlined,
        ),
        PremiumField(
          controller: _panNo,
          label: 'PAN number',
          hint: 'ABCDE1234F',
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [LengthLimitingTextInputFormatter(10)],
        ),
        SizedBox(height: 10.h),
        UploadTile(
          title: 'PAN card photo',
          helper: 'Clear, all 4 corners visible',
          icon: Icons.cloud_upload_outlined,
          uploaded: _pan,
          required: true,
          onTap: () => setState(() => _pan = !_pan),
        ),

        SizedBox(height: 20.h),
        InfoCallout(
          icon: Icons.lock_outline_rounded,
          text:
              'Your documents are encrypted end-to-end. We never share them with cooks or customers.',
        ),
      ],
    );
  }
}
