// lib/features/home/presentation/pages/edit_details_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';

class EditDetailsScreen extends StatefulWidget {
  final String fileName;
  final String description;

  const EditDetailsScreen({
    super.key,
    required this.fileName,
    this.description = '',
  });

  @override
  State<EditDetailsScreen> createState() => _EditDetailsScreenState();
}

class _EditDetailsScreenState extends State<EditDetailsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.fileName);
    _descriptionController = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

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
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    24.verticalSpace,
                    // Name field
                    _buildNameField(),
                    24.verticalSpace,
                    // Description field
                    _buildDescriptionField(),
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
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
          // Title
          Expanded(
            child: Center(
              child: Text(
                'Edit Details',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 17.sp,
                  height: 22 / 17,
                  letterSpacing: -0.43,
                  color: const Color(0xff000000),
                ),
              ),
            ),
          ),
          // Save button
          GestureDetector(
            onTap: () {
              // TODO: Save changes
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xff4A59FE),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                'Save',
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
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Name',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 15.sp,
            height: 20 / 15,
            letterSpacing: -0.23,
            color: const Color(0xff999999),
          ),
        ),
        8.verticalSpace,
        TextFormField(
          controller: _nameController,
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 15.sp,
            height: 20 / 15,
            letterSpacing: -0.23,
            color: const Color(0xff333333),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF2F2F7),
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
            hintText: 'Enter name',
            hintStyle: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400,
              fontSize: 15.sp,
              height: 20 / 15,
              letterSpacing: -0.23,
              color: const Color(0xff999999),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 15.sp,
            height: 20 / 15,
            letterSpacing: -0.23,
            color: const Color(0xff999999),
          ),
        ),
        8.verticalSpace,
        TextFormField(
          controller: _descriptionController,
          maxLines: 3,
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 15.sp,
            height: 20 / 15,
            letterSpacing: -0.23,
            color: const Color(0xff333333),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF2F2F7),
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
            hintText: 'Enter description',
            hintStyle: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400,
              fontSize: 15.sp,
              height: 20 / 15,
              letterSpacing: -0.23,
              color: const Color(0xff999999),
            ),
          ),
        ),
      ],
    );
  }
}