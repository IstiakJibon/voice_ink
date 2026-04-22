// lib/features/home/presentation/pages/move_to_folder_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';

class FolderItem {
  final String id;
  final String name;

  const FolderItem({required this.id, required this.name});
}

class MoveToFolderScreen extends StatefulWidget {
  final String fileName;

  const MoveToFolderScreen({super.key, required this.fileName});

  @override
  State<MoveToFolderScreen> createState() => _MoveToFolderScreenState();
}

class _MoveToFolderScreenState extends State<MoveToFolderScreen> {
  final List<FolderItem> _folders = const [
    FolderItem(id: '1', name: 'Project Alpha'),
    FolderItem(id: '2', name: 'Interviews'),
    FolderItem(id: '3', name: 'Ideas'),
    FolderItem(id: '4', name: 'Personal'),
    FolderItem(id: '5', name: 'Archive'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.folderB,
                        width: 24.w,
                        height: 24.h,
                        colorFilter: const ColorFilter.mode(
                          Color(0xff4A59FE),
                          BlendMode.srcIn,
                        ),
                      ),
                      8.horizontalSpace,
                      Text(
                        'Select Destination',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 17.sp,
                          height: 22 / 17,
                          letterSpacing: -0.43,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ],
                  ),
                  8.verticalSpace,

                  // Subtitle
                  // Replace the subtitle Text widget with this:
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        height: 21 / 16,
                        letterSpacing: -0.31,
                        color: const Color(0xff999999),
                      ),
                      children: [
                        const TextSpan(text: 'Choose a folder to move "'),
                        TextSpan(
                          text: widget.fileName,
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            height: 21 / 16,
                            letterSpacing: -0.31,
                            color: Colors.black,
                          ),
                        ),
                        const TextSpan(text: '" into'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.verticalSpace,
                    // Folder list
                    ..._folders.map(
                      (folder) => Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: _buildFolderItem(folder),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44.w,
              height: 44.h,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.backButton,
                  width: 32.w,
                  height: 32.h,
                  colorFilter: const ColorFilter.mode(
                    Color(0xff04071E),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          8.horizontalSpace,
          Text(
            'Move to Folder',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w600,
              fontSize: 17.sp,
              height: 22 / 17,
              letterSpacing: -0.43,
              color: const Color(0xff000000),
            ),
          ),
        ],
      ),
    );
  }

  void _showMoveConfirmationDialog(FolderItem folder) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 315.w,
            padding: EdgeInsets.only(
              left: 24.w,
              right: 24.w,
              top: 24.h,
              bottom: 8.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title and description
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    children: [
                      // Title
                      Text(
                        'Move to ${folder.name}?',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                          height: 25 / 20,
                          letterSpacing: -0.45,
                          color: const Color(0xff000000),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      8.verticalSpace,
                      // Description
                      Text(
                        'Are you sure you want to move this recording to ${folder.name}?',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 17.sp,
                          height: 22 / 17,
                          letterSpacing: -0.43,
                          color: const Color(0xff000000),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      24.verticalSpace,
                      // Buttons
                      Column(
                        children: [
                          // Move button
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context); // Close dialog
                              Navigator.pop(
                                context,
                              ); // Go back to previous screen
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Moved to "${folder.name}"',
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
                            child: Container(
                              width: double.infinity,
                              height: 44.h,
                              decoration: BoxDecoration(
                                color: const Color(0xff4A59FE),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Center(
                                child: Text(
                                  'Move',
                                  style: GoogleFonts.dmSans(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.sp,
                                    height: 20 / 15,
                                    letterSpacing: -0.23,
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
                              height: 44.h,
                              decoration: BoxDecoration(
                                color: const Color(0xffF2F2F7),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Center(
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.dmSans(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.sp,
                                    height: 20 / 15,
                                    letterSpacing: -0.23,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFolderItem(FolderItem folder) {
    return GestureDetector(
      onTap: () => _showMoveConfirmationDialog(folder),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffD9D9D9)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            // Folder icon container
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: const Color(0xffECF4FE),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.folderB,
                  width: 24.w,
                  height: 24.h,
                  colorFilter: const ColorFilter.mode(
                    Color(0xff4A59FE),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            8.horizontalSpace,
            // Folder name
            Expanded(
              child: Text(
                folder.name,
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  height: 21 / 16,
                  letterSpacing: -0.31,
                  color: const Color(0xff000000),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
