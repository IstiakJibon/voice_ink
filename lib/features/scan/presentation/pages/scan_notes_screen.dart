import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voice_ink/config/utilities/extensions/user_extension.dart';
import 'package:voice_ink/features/scan/presentation/cubit/scan_cubit.dart';
import 'package:voice_ink/features/scan/presentation/cubit/scan_state.dart';

class ScanNotesScreen extends StatefulWidget {
  const ScanNotesScreen({super.key});

  @override
  State<ScanNotesScreen> createState() => _ScanNotesScreenState();
}

class _ScanNotesScreenState extends State<ScanNotesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScanCubit>().reset();
    });
  }

  Future<void> _scanWithCamera() async {
    final picker = ImagePicker();
    try {
      final shot = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );
      if (shot == null || !mounted) return;
      await context.read<ScanCubit>().extractFromFile(
            token: context.token,
            filePath: shot.path,
            fileName: shot.name,
          );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera unavailable: $e')),
      );
    }
  }

  Future<void> _uploadFromGallery() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'heic', 'pdf'],
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty || !mounted) return;
    final picked = result.files.first;
    if (picked.path == null) return;
    await context.read<ScanCubit>().extractFromFile(
          token: context.token,
          filePath: picked.path!,
          fileName: picked.name,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<ScanCubit, ScanState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTopBar(),
                  16.verticalSpace,
                  Center(
                    child: Text(
                      'Scan Notes',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w500,
                        fontSize: 24.sp,
                        height: 30 / 24,
                        color: const Color(0xff1E1E1E),
                      ),
                    ),
                  ),
                  24.verticalSpace,
                  _buildIllustration(state),
                  32.verticalSpace,
                  _buildActions(state),
                  if (state.status == ScanStatus.failed &&
                      state.errorMessage != null) ...[
                    20.verticalSpace,
                    _buildErrorBanner(state.errorMessage!),
                  ],
                  if (state.status == ScanStatus.success &&
                      state.result != null) ...[
                    20.verticalSpace,
                    _buildSuccessCard(state),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: const BoxDecoration(
              color: Color(0xffECECF2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chevron_left_rounded,
              size: 20.sp,
              color: const Color(0xff1E1E1E),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIllustration(ScanState state) {
    // Show the picked image if we have one; otherwise the placeholder.
    if (state.imagePath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Image.file(
          File(state.imagePath!),
          height: 280.h,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholder(),
        ),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 280.h,
      decoration: BoxDecoration(
        color: const Color(0xffF7F7FA),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.document_scanner_outlined,
              size: 80.sp,
              color: const Color(0xff4A59FE).withValues(alpha: 0.5),
            ),
            12.verticalSpace,
            Text(
              'Capture or upload a document\nto extract its text',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 13.sp,
                height: 18 / 13,
                color: const Color(0xff8C8C8C),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(ScanState state) {
    final isBusy = state.status == ScanStatus.extracting;
    return Row(
      children: [
        Expanded(
          child: _buildPrimaryButton(
            label: 'Scan Now',
            icon: Icons.camera_alt_rounded,
            onTap: isBusy ? null : _scanWithCamera,
            isLoading: isBusy,
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: _buildOutlinedButton(
            label: 'Upload Image',
            icon: Icons.file_upload_outlined,
            onTap: isBusy ? null : _uploadFromGallery,
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required IconData icon,
    required VoidCallback? onTap,
    required bool isLoading,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: onTap == null ? 0.6 : 1.0,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: const Color(0xff4A59FE),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  width: 16.w,
                  height: 16.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              else
                Icon(icon, size: 18.sp, color: const Color(0xffF6F6F6)),
              8.horizontalSpace,
              Text(
                isLoading ? 'Extracting…' : label,
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: const Color(0xffF6F6F6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutlinedButton({
    required String label,
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: onTap == null ? 0.6 : 1.0,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xff4A59FE), width: 1.5),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18.sp, color: const Color(0xff4A59FE)),
              8.horizontalSpace,
              Text(
                label,
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: const Color(0xff4A59FE),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xffFEF2F2),
        border: Border.all(color: const Color(0xffFECACA)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            'Failed to extract text from document: $message',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400,
              fontSize: 13.sp,
              height: 18 / 13,
              color: const Color(0xffDC2626),
            ),
          ),
          10.verticalSpace,
          GestureDetector(
            onTap: () => context.read<ScanCubit>().dismissError(),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xffDC2626),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Text(
                  'Dismiss',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessCard(ScanState state) {
    final result = state.result!;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xffF0FDF4),
        border: Border.all(color: const Color(0xffBBF7D0)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                size: 18.sp,
                color: const Color(0xff16A34A),
              ),
              8.horizontalSpace,
              Text(
                'Extracted successfully',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                  color: const Color(0xff14532D),
                ),
              ),
            ],
          ),
          12.verticalSpace,
          if (result.title != null && result.title!.isNotEmpty) ...[
            Text(
              'Title',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w500,
                fontSize: 11.sp,
                color: const Color(0xff15803D),
              ),
            ),
            4.verticalSpace,
            Text(
              result.title!,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600,
                fontSize: 15.sp,
                height: 20 / 15,
                color: const Color(0xff14532D),
              ),
            ),
            12.verticalSpace,
          ],
          Text(
            'Text',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w500,
              fontSize: 11.sp,
              color: const Color(0xff15803D),
            ),
          ),
          4.verticalSpace,
          SelectableText(
            (result.text ?? '').isEmpty
                ? 'No text was extracted.'
                : result.text!,
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400,
              fontSize: 13.sp,
              height: 18 / 13,
              color: const Color(0xff14532D),
            ),
          ),
        ],
      ),
    );
  }
}
