// lib/features/home/presentation/widget/text_selection_popup.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';

class TextSelectionPopup extends StatelessWidget {
  final VoidCallback onInsertWord;
  final VoidCallback onDeleteWord;
  final VoidCallback onSplitWord;
  final VoidCallback onSplitUnassign;
  final VoidCallback onChangeSpeaker;
  final VoidCallback onDismiss;

  const TextSelectionPopup({
    super.key,
    required this.onInsertWord,
    required this.onDeleteWord,
    required this.onSplitWord,
    required this.onSplitUnassign,
    required this.onChangeSpeaker,
    required this.onDismiss,
  });

  // Static variable to track current overlay entry
  static OverlayEntry? _currentOverlayEntry;

  // Method to dismiss any existing popup and clear selection
  static void dismiss(BuildContext? context) {
    _currentOverlayEntry?.remove();
    _currentOverlayEntry = null;
    
    // Unfocus to clear text selection
    if (context != null) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.w,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffF2F2F7)),
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 6),
            blurRadius: 13,
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.09),
            offset: Offset(0, 24),
            blurRadius: 24,
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            offset: Offset(0, 55),
            blurRadius: 33,
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.01),
            offset: Offset(0, 97),
            blurRadius: 39,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOption(
            icon: AppAssets.add,
            label: 'Insert word after',
            onTap: onInsertWord,
          ),
          _buildOption(
            icon: AppAssets.delete,
            label: 'Delete word',
            onTap: onDeleteWord,
          ),
          _buildOption(
            icon: AppAssets.arrowSplit,
            label: 'Split word',
            onTap: onSplitWord,
          ),
          // Divider
          Container(
            height: 1,
            margin: EdgeInsets.symmetric(vertical: 4.h),
            color: const Color(0xffF2F2F7),
          ),
          _buildOption(
            icon: AppAssets.cut,
            label: 'Split & unassign speaker',
            onTap: onSplitUnassign,
          ),
          _buildOption(
            icon: AppAssets.person,
            label: 'Change speaker',
            onTap: onChangeSpeaker,
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(8.w),
        child: Row(
          children: [
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
            Text(
              label,
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
      ),
    );
  }

  static void show(
    BuildContext context, {
    required Offset position,
    required VoidCallback onInsertWord,
    required VoidCallback onDeleteWord,
    required VoidCallback onSplitWord,
    required VoidCallback onSplitUnassign,
    required VoidCallback onChangeSpeaker,
    required VoidCallback onDismiss,
  }) {
    // Dismiss any existing popup first (without unfocusing yet)
    _currentOverlayEntry?.remove();
    _currentOverlayEntry = null;

    final overlay = Overlay.of(context);

    _currentOverlayEntry = OverlayEntry(
      builder: (overlayContext) {
        final screenWidth = MediaQuery.of(overlayContext).size.width;
        final screenHeight = MediaQuery.of(overlayContext).size.height;
        final popupWidth = 250.w;
        final popupHeight = 290.h;

        // Position popup centered horizontally at selection, below the selection point
        double left = position.dx - (popupWidth / 2);
        double top = position.dy + 8.h;

        // Adjust if goes off right edge
        if (left + popupWidth > screenWidth - 16.w) {
          left = screenWidth - popupWidth - 16.w;
        }
        // Adjust if goes off left edge
        if (left < 16.w) {
          left = 16.w;
        }
        // If popup would go off bottom, show it above the selection instead
        if (top + popupHeight > screenHeight - 16.h) {
          top = position.dy - popupHeight - 8.h;
        }

        return Stack(
          children: [
            // Backdrop to dismiss
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  dismiss(context);
                  onDismiss();
                },
                behavior: HitTestBehavior.opaque,
                child: const SizedBox.expand(),
              ),
            ),
            // Popup
            Positioned(
              left: left,
              top: top,
              child: Material(
                color: Colors.transparent,
                child: TextSelectionPopup(
                  onInsertWord: () {
                    dismiss(context);
                    onInsertWord();
                  },
                  onDeleteWord: () {
                    dismiss(context);
                    onDeleteWord();
                  },
                  onSplitWord: () {
                    dismiss(context);
                    onSplitWord();
                  },
                  onSplitUnassign: () {
                    dismiss(context);
                    onSplitUnassign();
                  },
                  onChangeSpeaker: () {
                    dismiss(context);
                    onChangeSpeaker();
                  },
                  onDismiss: () {
                    dismiss(context);
                    onDismiss();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(_currentOverlayEntry!);
  }
}