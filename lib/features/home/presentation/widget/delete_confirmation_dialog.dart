// lib/features/home/presentation/widget/delete_confirmation_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteConfirmationDialog({
    super.key,
    required this.onDelete,
  });

  static void show(BuildContext context, {required VoidCallback onDelete}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => DeleteConfirmationDialog(onDelete: onDelete),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
              // Content
              Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  children: [
                    // Title
                    Text(
                      'Delete recording?',
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
                      'This action cannot be undone. This will permanently delete the recording and all associated transcripts.',
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
                        // Delete button (Red)
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            onDelete();
                          },
                          child: Container(
                            width: double.infinity,
                            height: 44.h,
                            decoration: BoxDecoration(
                              color: const Color(0xffFF383C),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: Text(
                                'Delete',
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
    );
  }
}