import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedTabIndex = 0; // 0 = All Activity, 1 = Mark as Read

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            _buildAppBar(),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    8.verticalSpace,
                    // Header section
                    _buildHeader(),
                    16.verticalSpace,
                    // Tab buttons
                    _buildTabButtons(),
                    // Empty state (centered in remaining space)
                    SizedBox(height: 120.h),
                    _buildEmptyState(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SizedBox(
        height: 54.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: SizedBox(
                width: 44.w,
                height: 44.h,
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
            Text(
              'Notifications',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 17.sp,
                height: 22 / 17,
                letterSpacing: -0.43,
                color: const Color(0xff000000),
              ),
            ),
            // Spacer
            SizedBox(width: 44.w),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notifications',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w600,
            fontSize: 17.sp,
            height: 22 / 17,
            letterSpacing: -0.43,
            color: const Color(0xff333333),
          ),
        ),
        8.verticalSpace,
        Text(
          'Stay updated with your transcription activity',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            height: 21 / 16,
            letterSpacing: -0.31,
            color: const Color(0xff999999),
          ),
        ),
      ],
    );
  }

  Widget _buildTabButtons() {
    return Row(
      children: [
        // All Activity button
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedTabIndex = 0;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: _selectedTabIndex == 0
                  ? const Color(0xff4A59FE)
                  : const Color(0xffF2F2F7),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              'All Activity',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 15.sp,
                height: 20 / 15,
                letterSpacing: -0.23,
                color: _selectedTabIndex == 0
                    ? Colors.white
                    : const Color(0xff3C3C43).withOpacity(0.6),
              ),
            ),
          ),
        ),
        13.horizontalSpace,
        // Mark as Read button
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedTabIndex = 1;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: _selectedTabIndex == 1
                  ? const Color(0xff4A59FE)
                  : const Color(0xffF2F2F7),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              'Mark as Read',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 15.sp,
                height: 20 / 15,
                letterSpacing: -0.23,
                color: _selectedTabIndex == 1
                    ? Colors.white
                    : const Color(0xff3C3C43).withOpacity(0.6),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon container
          Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              color: const Color(0xff4A59FE).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                AppAssets.alert,
                width: 48.w,
                height: 48.h,
                colorFilter: const ColorFilter.mode(
                  Color(0xff4A59FE),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          24.verticalSpace,
          // Title
          Text(
            'No unread notifications',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              fontSize: 17.sp,
              height: 22 / 17,
              letterSpacing: -0.43,
              color: const Color(0xff000000),
            ),
            textAlign: TextAlign.center,
          ),
          24.verticalSpace,
          // Subtitle
          SizedBox(
            width: 272.w,
            child: Text(
              "You're all caught up! Check back later for new updates.",
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 17.sp,
                height: 22 / 17,
                letterSpacing: -0.43,
                color: const Color(0xff3C3C43).withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}