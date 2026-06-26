import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/route_names.dart';
import '../../../../core/services/image_picker_service.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../providers/onboarding_provider.dart';
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

  bool _uploadingSelfie = false;
  bool _uploadingAadhaar = false;
  bool _uploadingPan = false;

  final _name = TextEditingController();
  final _dob = TextEditingController();
  final _aadhaarNo = TextEditingController();
  final _panNo = TextEditingController();
  final _whatsapp = TextEditingController();

  @override
  void initState() {
    super.initState();
    final p = Provider.of<OnboardingProvider>(context, listen: false);
    _name.text = p.name;
    _dob.text = p.dob;
    _whatsapp.text = p.whatsapp;
    _aadhaarNo.text = p.aadhaarNo;
    _panNo.text = p.panNo;
    _selfie = p.selfieUrl.isNotEmpty;
    _aadhaar = p.aadhaarUrl.isNotEmpty;
    _pan = p.panUrl.isNotEmpty;
  }

  @override
  void dispose() {
    _name.dispose();
    _dob.dispose();
    _aadhaarNo.dispose();
    _panNo.dispose();
    _whatsapp.dispose();
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

  Future<void> _pickAndUpload(String docType) async {
    final provider = Provider.of<OnboardingProvider>(context, listen: false);
    final file = await ImagePickerService.pickFromSheet();
    if (file == null) return;

    setState(() {
      if (docType == 'selfie') _uploadingSelfie = true;
      if (docType == 'aadhaar') _uploadingAadhaar = true;
      if (docType == 'pan') _uploadingPan = true;
    });

    final ok = await provider.uploadDocument(docType, file);

    if (mounted) {
      setState(() {
        if (docType == 'selfie') {
          _uploadingSelfie = false;
          _selfie = ok;
        }
        if (docType == 'aadhaar') {
          _uploadingAadhaar = false;
          _aadhaar = ok;
        }
        if (docType == 'pan') {
          _uploadingPan = false;
          _pan = ok;
        }
      });
      if (ok) {
        ToastService.success('${docType[0].toUpperCase()}${docType.substring(1)} uploaded successfully.');
      }
    }
  }

  void _clearDocument(String docType) {
    final provider = Provider.of<OnboardingProvider>(context, listen: false);
    provider.clearDocument(docType);
    setState(() {
      if (docType == 'selfie') _selfie = false;
      if (docType == 'aadhaar') _aadhaar = false;
      if (docType == 'pan') _pan = false;
    });
    ToastService.success('${docType[0].toUpperCase()}${docType.substring(1)} removed successfully.');
  }

  void _onContinue() {
    final p = Provider.of<OnboardingProvider>(context, listen: false);
    if (p.selfieUrl.isEmpty) {
      ToastService.error('Please upload a live selfie.');
      return;
    }
    if (_name.text.trim().isEmpty) {
      ToastService.error('Full name is required.');
      return;
    }
    if (_dob.text.trim().isEmpty) {
      ToastService.error('Date of birth is required.');
      return;
    }
    if (_whatsapp.text.trim().length != 10) {
      ToastService.error('Valid 10-digit WhatsApp number is required.');
      return;
    }
    if (_aadhaarNo.text.trim().length != 12) {
      ToastService.error('Valid 12-digit Aadhaar number is required.');
      return;
    }
    if (p.aadhaarUrl.isEmpty) {
      ToastService.error('Please upload your Aadhaar card.');
      return;
    }
    if (_panNo.text.trim().length != 10) {
      ToastService.error('Valid 10-character PAN number is required.');
      return;
    }
    if (p.panUrl.isEmpty) {
      ToastService.error('Please upload your PAN card photo.');
      return;
    }

    p.updateField(
      name: _name.text.trim(),
      dob: _dob.text.trim(),
      whatsapp: _whatsapp.text.trim(),
      altContact: '',
      aadhaarNo: _aadhaarNo.text.trim(),
      panNo: _panNo.text.trim(),
    );

    Navigator.pushNamed(context, RouteNames.cookKitchenSafety);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnboardingProvider>(context);
    return OnboardingScaffold(
      step: 2,
      totalSteps: 4,
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
      onCta: _onContinue,
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
          helper: _uploadingSelfie ? 'Uploading selfie...' : 'Hold your face inside the frame',
          icon: Icons.add_a_photo_outlined,
          uploaded: _selfie,
          required: true,
          imageUrl: provider.selfieUrl,
          onTap: () => _pickAndUpload('selfie'),
          onRemove: () => _clearDocument('selfie'),
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
          required: true,
          textCapitalization: TextCapitalization.words,
        ),
        SizedBox(height: 10.h),
        PremiumField(
          controller: _dob,
          label: 'Date of birth',
          hint: 'DD / MM / YYYY',
          readOnly: true,
          onTap: _pickDob,
          suffixIcon: Icons.calendar_today_rounded,
          required: true,
        ),
        SizedBox(height: 10.h),
        PremiumField(
          controller: _whatsapp,
          label: 'WhatsApp',
          hint: '10 digits',
          keyboardType: TextInputType.phone,
          required: true,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
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
          required: true,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(12),
          ],
        ),
        SizedBox(height: 10.h),
        UploadTile(
          title: 'Aadhaar — front & back',
          helper: _uploadingAadhaar ? 'Uploading Aadhaar...' : 'Both sides in one frame, or two photos',
          icon: Icons.cloud_upload_outlined,
          uploaded: _aadhaar,
          required: true,
          imageUrl: provider.aadhaarUrl,
          onTap: () => _pickAndUpload('aadhaar'),
          onRemove: () => _clearDocument('aadhaar'),
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
          required: true,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [LengthLimitingTextInputFormatter(10)],
        ),
        SizedBox(height: 10.h),
        UploadTile(
          title: 'PAN card photo',
          helper: _uploadingPan ? 'Uploading PAN...' : 'Clear, all 4 corners visible',
          icon: Icons.cloud_upload_outlined,
          uploaded: _pan,
          required: true,
          imageUrl: provider.panUrl,
          onTap: () => _pickAndUpload('pan'),
          onRemove: () => _clearDocument('pan'),
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
