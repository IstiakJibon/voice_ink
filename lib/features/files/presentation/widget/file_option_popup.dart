import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';

class FileOptionsPopup extends StatelessWidget {
  const FileOptionsPopup({super.key});

  static void show(BuildContext context, GlobalKey buttonKey) {
    final RenderBox? button =
        buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (button == null) return;

    final Offset position = button.localToGlobal(Offset.zero);
    final Size screenSize = MediaQuery.of(context).size;

    // Calculate position - show above or below based on available space
    double top = position.dy + button.size.height + 8.h;
    
    // If popup would go off screen bottom, show it above the button
    if (top + 224.h > screenSize.height) {
      top = position.dy - 224.h - 8.h;
    }

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
            right: 16.w,
            top: top,
            child: const FileOptionsPopup(),
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
        width: 220.w,
        padding: EdgeInsets.all(8.w),
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
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add to favorite
            _buildOption(
              context: context,
              icon: AppAssets.heart,
              label: 'Add to favorite',
            ),
            // Move to Folder
            _buildOption(
              context: context,
              icon: AppAssets.folder,
              label: 'Move to Folder',
            ),
            // Share recording
            _buildOption(
              context: context,
              icon: AppAssets.share,
              label: 'Share recording',
            ),
            // Divider
            Container(
              height: 1,
              margin: EdgeInsets.symmetric(vertical: 4.h),
              color: const Color(0xffF2F2F7),
            ),
            // Delete Recording
            _buildOption(
              context: context,
              icon: AppAssets.delete,
              label: 'Delete Recording',
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required String icon,
    required String label,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? const Color(0xffFF383C) : const Color(0xff8C8C8C);
    final textColor = isDestructive ? const Color(0xffFF383C) : const Color(0xff333333);

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.all(8.w),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 24.w,
              height: 24.h,
              colorFilter: ColorFilter.mode(
                color,
                BlendMode.srcIn,
              ),
            ),
            8.horizontalSpace,
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                height: 21 / 16,
                letterSpacing: -0.31,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}