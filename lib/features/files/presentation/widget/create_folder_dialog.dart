import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateFolderDialog extends StatefulWidget {
  final Function(String folderName) onCreate;

  const CreateFolderDialog({
    super.key,
    required this.onCreate,
  });

  static Future<void> show(BuildContext context, Function(String) onCreate) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => CreateFolderDialog(onCreate: onCreate),
    );
  }

  @override
  State<CreateFolderDialog> createState() => _CreateFolderDialogState();
}

class _CreateFolderDialogState extends State<CreateFolderDialog> {
  final TextEditingController _folderNameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus the text field when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _folderNameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 38.w),
      child: Container(
        width: 315.w,
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Input
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        'Create new folder in Home',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                          height: 25 / 20,
                          letterSpacing: -0.45,
                          color: Colors.black,
                        ),
                      ),
                      16.verticalSpace,
                      // Folder name label
                      Text(
                        'Folder name',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                          height: 20 / 15,
                          letterSpacing: -0.23,
                          color: const Color(0xff999999),
                        ),
                      ),
                      8.verticalSpace,
                      // Text input
                      Container(
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: const Color(0xffF2F2F7),
                          border: Border.all(color: const Color(0xff4A59FE)),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: TextField(
                          controller: _folderNameController,
                          focusNode: _focusNode,
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w400,
                            fontSize: 15.sp,
                            height: 20 / 15,
                            letterSpacing: -0.23,
                            color: const Color(0xff333333),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter folder name',
                            hintStyle: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 15.sp,
                              height: 20 / 15,
                              letterSpacing: -0.23,
                              color: const Color(0xff999999),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 14.h,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  16.verticalSpace,
                  // Buttons
                  Column(
                    children: [
                      // Create button
                      GestureDetector(
                        onTap: () {
                          final folderName = _folderNameController.text.trim();
                          if (folderName.isNotEmpty) {
                            widget.onCreate(folderName);
                            Navigator.pop(context);
                          }
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
                              'Create',
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
                        onTap: () {
                          Navigator.pop(context);
                        },
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
                                color: Colors.black,
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
    );
  }
}