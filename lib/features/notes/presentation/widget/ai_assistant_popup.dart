// lib/features/notes/presentation/widget/ai_assistant_popup.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';

class AIAssistantPopup extends StatelessWidget {
  final int selectedCharCount;
  final VoidCallback onPolish;
  final VoidCallback onFormat;
  final VoidCallback onSummarize;
  final VoidCallback onDismiss;

  const AIAssistantPopup({
    super.key,
    required this.selectedCharCount,
    required this.onPolish,
    required this.onFormat,
    required this.onSummarize,
    required this.onDismiss,
  });

  static void show(
    BuildContext context,
    GlobalKey buttonKey, {
    required int selectedCharCount,
    required VoidCallback onPolish,
    required VoidCallback onFormat,
    required VoidCallback onSummarize,
  }) {
    final RenderBox? button =
        buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (button == null) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (context) => Stack(
        children: [
          // Invisible barrier to detect taps outside
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            right: 35.w,
            top: 108.h,
            child: AIAssistantPopup(
              selectedCharCount: selectedCharCount,
              onPolish: () {
                Navigator.pop(context);
                onPolish();
              },
              onFormat: () {
                Navigator.pop(context);
                onFormat();
              },
              onSummarize: () {
                Navigator.pop(context);
                onSummarize();
              },
              onDismiss: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 300.w,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xffF2F2F7)),
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 13,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.09),
              blurRadius: 24,
              offset: const Offset(0, 24),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 33,
              offset: const Offset(0, 55),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.01),
              blurRadius: 39,
              offset: const Offset(0, 97),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(),
            // Polish option
            _buildOption(
              icon: AppAssets.edit,
              title: 'Polish',
              subtitle: 'Improve writing quality and clarity',
              onTap: onPolish,
            ),
            // Format option
            _buildOption(
              icon: AppAssets.documentEdit,
              title: 'Format',
              subtitle: 'Structure with headings and Lists',
              onTap: onFormat,
            ),
            // Summarize option
            _buildOption(
              icon: AppAssets.documentText,
              title: 'Summarize',
              subtitle: 'Create concise summary',
              onTap: onSummarize,
            ),
            // Footer
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xffF2F2F7)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon and title
              Row(
                children: [
                  SvgPicture.asset(
                    AppAssets.sparkle,
                    width: 24.w,
                    height: 24.h,
                    colorFilter: const ColorFilter.mode(
                      Color(0xff9747FF),
                      BlendMode.srcIn,
                    ),
                  ),
                  8.horizontalSpace,
                  Text(
                    'AI Assistant',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                      height: 20 / 15,
                      letterSpacing: -0.23,
                      color: const Color(0xff333333),
                    ),
                  ),
                ],
              ),
              // Dismiss button
              GestureDetector(
                onTap: onDismiss,
                child: SvgPicture.asset(
                  AppAssets.dismiss,
                  width: 24.w,
                  height: 24.h,
                  colorFilter: const ColorFilter.mode(
                    Color(0xff404040),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
          2.verticalSpace,
          // Selected characters count
          Text(
            '$selectedCharCount characters Selected',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              height: 16 / 12,
              color: const Color(0xff999999),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          children: [
            // Icon
            SvgPicture.asset(
              icon,
              width: 24.w,
              height: 24.h,
              colorFilter: const ColorFilter.mode(
                Color(0xff8C8C8C),
                BlendMode.srcIn,
              ),
            ),
            8.horizontalSpace,
            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                      height: 20 / 15,
                      letterSpacing: -0.23,
                      color: const Color(0xff333333),
                    ),
                  ),
                  2.verticalSpace,
                  Text(
                    subtitle,
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      height: 16 / 12,
                      color: const Color.fromRGBO(60, 60, 67, 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F7),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.r),
          bottomRight: Radius.circular(10.r),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Powered by AI',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              height: 21 / 16,
              letterSpacing: -0.31,
              color: const Color(0xff333333),
            ),
          ),
        ],
      ),
    );
  }
}