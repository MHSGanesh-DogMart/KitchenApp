import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/app_colors.dart';
import 'navigation_service.dart';
import 'permission_service.dart';

class ImagePickerService {
  ImagePickerService._();

  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickFromSheet({
    int imageQuality = 85,
    double? maxWidth = 1600,
  }) async {
    final ctx = NavigationService.context;
    if (ctx == null) return null;

    final source = await showModalBottomSheet<ImageSource>(
      context: ctx,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (c) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.line,
                    borderRadius: BorderRadius.circular(99.r),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                'UPLOAD PHOTO',
                textAlign: TextAlign.center,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.muted,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Select document or photo source',
                textAlign: TextAlign.center,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              SizedBox(height: 22.h),
              Row(
                children: [
                  Expanded(
                    child: _buildSourceCard(
                      context: c,
                      icon: Icons.photo_camera_rounded,
                      iconColor: AppColors.primary,
                      bgColor: AppColors.primarySoft,
                      title: 'Camera',
                      subtitle: 'Take a live photo',
                      source: ImageSource.camera,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: _buildSourceCard(
                      context: c,
                      icon: Icons.photo_library_rounded,
                      iconColor: AppColors.secondary,
                      bgColor: AppColors.secondarySoft,
                      title: 'Gallery / File',
                      subtitle: 'Choose from storage',
                      source: ImageSource.gallery,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (source == null) return null;

    final ok = source == ImageSource.camera
        ? await PermissionService.camera()
        : await PermissionService.photos();
    if (!ok) return null;

    final picked = await _picker.pickImage(
      source: source,
      imageQuality: imageQuality,
      maxWidth: maxWidth,
    );
    if (picked == null) return null;
    return _compress(File(picked.path));
  }

  static Widget _buildSourceCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
    required ImageSource source,
  }) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.line, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withValues(alpha: .04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () => Navigator.pop(context, source),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 22.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  title,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 10.5.sp,
                    color: AppColors.muted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<List<File>> pickMultiple({
    int imageQuality = 85,
    int limit = 10,
  }) async {
    final ok = await PermissionService.photos();
    if (!ok) return [];
    final picked = await _picker.pickMultiImage(imageQuality: imageQuality, limit: limit);
    final result = <File>[];
    for (final x in picked) {
      final f = await _compress(File(x.path));
      if (f != null) result.add(f);
    }
    return result;
  }

  static Future<File?> _compress(File file) async {
    try {
      final dir = await getTemporaryDirectory();
      final target =
          '${dir.path}/c_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        target,
        quality: 80,
        minWidth: 1080,
      );
      return result != null ? File(result.path) : file;
    } catch (_) {
      return file;
    }
  }
}
