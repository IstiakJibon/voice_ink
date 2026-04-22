// lib/features/home/presentation/widget/transcript_option_popup.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';
import 'package:voice_ink/features/home/presentation/widget/delete_confirmation_dialog.dart';
import 'package:voice_ink/features/home/presentation/widget/duplicate_bottom_sheet.dart';
import 'package:voice_ink/features/home/presentation/widget/edit_details_screen.dart';
import 'package:voice_ink/features/home/presentation/widget/move_to_folder_screen.dart';
import 'package:voice_ink/features/home/presentation/widget/share_recording_screen.dart';

class TranscriptOptionsPopup extends StatelessWidget {
  final String fileName;
  final String description;

  const TranscriptOptionsPopup({
    super.key,
    required this.fileName,
    this.description = '',
  });

  static void show(
    BuildContext context,
    GlobalKey buttonKey, {
    required String fileName,
    String description = '',
  }) {
    final RenderBox? button =
        buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (button == null) return;

    final Offset position = button.localToGlobal(Offset.zero);

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
            top: position.dy + button.size.height + 8.h,
            child: TranscriptOptionsPopup(
              fileName: fileName,
              description: description,
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
              onTap: () {
                Navigator.pop(context);
                // TODO: Add to favorite
              },
            ),
            // Edit details
            _buildOption(
              context: context,
              icon: AppAssets.edit,
              label: 'Edit details',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditDetailsScreen(
                      fileName: fileName,
                      description: description,
                    ),
                  ),
                );
              },
            ),
            // Move to Folder
            _buildOption(
              context: context,
              icon: AppAssets.folder,
              label: 'Move to Folder',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MoveToFolderScreen(fileName: fileName),
                  ),
                );
              },
            ),
            // Duplicate
            _buildOption(
              context: context,
              icon: AppAssets.documentMultiple,
              label: 'Duplicate',
              onTap: () {
                Navigator.pop(context);
                DuplicateBottomSheet.show(
                  context,
                  fileName: fileName,
                  onDuplicate: () {
                    // TODO: Implement duplicate functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Recording duplicated successfully',
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: const Color(0xff333333),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
            ),
            // Divider
            _buildDivider(),
            // Share recording
            _buildOption(
              context: context,
              icon: AppAssets.share,
              label: 'Share recording',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ShareRecordingScreen(fileName: fileName),
                  ),
                );
              },
            ),
            // Download
            _buildOption(
              context: context,
              icon: AppAssets.arrowDownload,
              label: 'Download',
              onTap: () {
                Navigator.pop(context);
                // TODO: Download
              },
            ),
            // Divider
            _buildDivider(),
            // Delete Recording
            _buildOption(
              context: context,
              icon: AppAssets.delete,
              label: 'Delete Recording',
              isDestructive: true,
              onTap: () {
                Navigator.pop(context);
                DeleteConfirmationDialog.show(
                  context,
                  onDelete: () {
                    // TODO: Implement delete functionality
                    Navigator.pop(context); // Go back after deleting
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Recording deleted',
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: const Color(0xff333333),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
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
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive
        ? const Color(0xffFF383C)
        : const Color(0xff8C8C8C);
    final textColor = isDestructive
        ? const Color(0xffFF383C)
        : const Color(0xff333333);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 24.w,
              height: 24.h,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
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

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(vertical: 4.h),
      color: const Color(0xffF2F2F7),
    );
  }
}
