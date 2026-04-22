// lib/features/home/presentation/widget/duplicate_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';

class DuplicateBottomSheet extends StatelessWidget {
  final String fileName;
  final VoidCallback onDuplicate;

  const DuplicateBottomSheet({
    super.key,
    required this.fileName,
    required this.onDuplicate,
  });

  static void show(
    BuildContext context, {
    required String fileName,
    required VoidCallback onDuplicate,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DuplicateBottomSheet(
        fileName: fileName,
        onDuplicate: onDuplicate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(38.r),
          topRight: Radius.circular(38.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 75,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Toolbar
          _buildToolbar(context),
          // Description
          18.verticalSpace,
          _buildDescription(),
          30.verticalSpace,
          // Buttons
          _buildButtons(context),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(38.r),
          topRight: Radius.circular(38.r),
        ),
      ),
      child: Column(
        children: [
          // Grabber
          Container(
            margin: EdgeInsets.only(top: 5.h),
            width: 36.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: const Color(0xffCFCFCF),
              borderRadius: BorderRadius.circular(100.r),
            ),
          ),
          16.verticalSpace,
          // Title row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              crossAxisAlignment: .end,
              children: [
                // Title
                Expanded(
                  child: Text(
                    'Duplicate Recording',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                      height: 25 / 20,
                      letterSpacing: -0.45,
                      color: const Color(0xff333333),
                    ),
                  ),
                ),
                // Close button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset(
                    AppAssets.close,
                    width: 44.w,
                    height: 44.h,
                    colorFilter: const ColorFilter.mode(
                      Color(0xff999999),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        'This will create a new copy of "$fileName" with all associated transcripts and analysis.',
        style: GoogleFonts.dmSans(
          fontWeight: FontWeight.w400,
          fontSize: 16.sp,
          height: 21 / 16,
          letterSpacing: -0.31,
          color: const Color(0xff000000),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 16.h,
        bottom: 32.h
      ),
      child: Column(
        children: [
          // Duplicate button
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              onDuplicate();
            },
            child: Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: const Color(0xff4A59FE),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Text(
                  'Duplicate',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 17.sp,
                    height: 22 / 17,
                    letterSpacing: -0.43,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          8.verticalSpace,
          // Cancel button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: const Color(0xffF2F2F7),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Text(
                  'Cancel',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 17.sp,
                    height: 22 / 17,
                    letterSpacing: -0.43,
                    color: const Color(0xff333333),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}