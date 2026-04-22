// lib/features/notes/presentation/widget/note_options_popup.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';

class NoteOptionsPopup extends StatelessWidget {
  final VoidCallback onAddChildNote;
  final VoidCallback onDuplicate;
  final VoidCallback onPin;
  final VoidCallback onDelete;

  const NoteOptionsPopup({
    super.key,
    required this.onAddChildNote,
    required this.onDuplicate,
    required this.onPin,
    required this.onDelete,
  });

  static void show(
    BuildContext context,
    GlobalKey buttonKey, {
    required VoidCallback onAddChildNote,
    required VoidCallback onDuplicate,
    required VoidCallback onPin,
    required VoidCallback onDelete,
  }) {
    final RenderBox? button =
        buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (button == null) return;

    final Offset position = button.localToGlobal(Offset.zero);
    final Size buttonSize = button.size;

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
            top: position.dy + buttonSize.height + 8.h,
            child: NoteOptionsPopup(
              onAddChildNote: () {
                Navigator.pop(context);
                onAddChildNote();
              },
              onDuplicate: () {
                Navigator.pop(context);
                onDuplicate();
              },
              onPin: () {
                Navigator.pop(context);
                onPin();
              },
              onDelete: () {
                Navigator.pop(context);
                onDelete();
              },
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
            // Add Child note
            _buildOption(
              icon: AppAssets.note,
              label: 'Add Child note',
              onTap: onAddChildNote,
            ),
            // Duplicate
            _buildOption(
              icon: AppAssets.documentMultiple,
              label: 'Duplicate',
              onTap: onDuplicate,
            ),
            // Pin
            _buildOption(
              icon: AppAssets.pin,
              label: 'Pin',
              onTap: onPin,
            ),
            // Delete
            _buildOption(
              icon: AppAssets.delete,
              label: 'Delete',
              onTap: onDelete,
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required String icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color =
        isDestructive ? const Color(0xffFF383C) : const Color(0xff8C8C8C);
    final textColor =
        isDestructive ? const Color(0xffFF383C) : const Color(0xff333333);

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