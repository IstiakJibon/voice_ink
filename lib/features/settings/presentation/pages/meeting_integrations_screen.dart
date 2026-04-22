import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';

class MeetingIntegrationsScreen extends StatefulWidget {
  const MeetingIntegrationsScreen({super.key});

  @override
  State<MeetingIntegrationsScreen> createState() =>
      _MeetingIntegrationsScreenState();
}

class _MeetingIntegrationsScreenState extends State<MeetingIntegrationsScreen> {
  bool _autoRecordMeetings = true;
  bool _realTimeTranscription = true;

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
                    16.verticalSpace,
                    // Connected Services section
                    _buildConnectedServicesSection(),
                    32.verticalSpace,
                    // Calendar section
                    _buildCalendarSection(),
                    32.verticalSpace,
                    // Recording Settings section
                    _buildRecordingSettingsSection(),
                    24.verticalSpace,
                    // Sync info bar
                    _buildSyncInfoBar(),
                    40.verticalSpace,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            Text(
              'Meeting Integrations',
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

  // ==================== CONNECTED SERVICES SECTION ====================

  Widget _buildConnectedServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Text(
            'Connected Service',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              fontSize: 17.sp,
              height: 22 / 17,
              letterSpacing: -0.43,
              color: const Color(0xff000000),
            ),
          ),
        ),
        8.verticalSpace,
        // Services card
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffF2F2F7)),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              // Zoom (connected with extra options)
              _buildZoomServiceItem(),
              // Google Meet
              _buildServiceItem(
                icon: AppAssets.googleMeet,
                title: 'Google Meet',
                isConnected: false,
                showBorder: true,
              ),
              // Microsoft Teams
              _buildServiceItem(
                icon: AppAssets.microsoftTeams,
                title: 'Microsoft Teams',
                isConnected: false,
                showBorder: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildZoomServiceItem() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xffF2F2F7)),
        ),
      ),
      child: Column(
        children: [
          // Main row
          Row(
            children: [
              // Zoom icon
              SvgPicture.asset(
                AppAssets.zoom,
                width: 44.w,
                height: 44.h,
              ),
              4.horizontalSpace,
              // Title and description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Zoom',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        height: 21 / 16,
                        letterSpacing: -0.31,
                        color: const Color(0xff000000),
                      ),
                    ),
                    8.verticalSpace,
                    Text(
                      'Auto-record and transcribe Zoom meetings',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 15.sp,
                        height: 20 / 15,
                        letterSpacing: -0.23,
                        color: const Color(0xff999999),
                      ),
                    ),
                  ],
                ),
              ),
              // Connected button
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xffECF4FE),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  'Connected',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                    height: 20 / 15,
                    letterSpacing: -0.23,
                    color: const Color(0xff4A59FE),
                  ),
                ),
              ),
            ],
          ),
          16.verticalSpace,
          // Disconnect button
          GestureDetector(
            onTap: () {
              // TODO: Handle disconnect
            },
            child: Container(
              width: double.infinity,
              height: 44.h,
              decoration: BoxDecoration(
                color: const Color(0xffECF4FE),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Text(
                  'Disconnect',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                    height: 20 / 15,
                    letterSpacing: -0.23,
                    color: const Color(0xff4A59FE),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem({
    required String icon,
    required String title,
    required bool isConnected,
    required bool showBorder,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: showBorder
            ? const Border(
                bottom: BorderSide(color: Color(0xffF2F2F7)),
              )
            : null,
      ),
      child: Row(
        children: [
          // Service icon
          SvgPicture.asset(
            icon,
            width: 44.w,
            height: 44.h,
          ),
          8.horizontalSpace,
          // Title
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                height: 21 / 16,
                letterSpacing: -0.31,
                color: const Color(0xff000000),
              ),
            ),
          ),
          // Connect button
          GestureDetector(
            onTap: () {
              // TODO: Handle connect
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xff8C8C8C)),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                'Connect',
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
        ],
      ),
    );
  }

  // ==================== CALENDAR SECTION ====================

  Widget _buildCalendarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Text(
            'Calendar',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              fontSize: 17.sp,
              height: 22 / 17,
              letterSpacing: -0.43,
              color: const Color(0xff000000),
            ),
          ),
        ),
        8.verticalSpace,
        // Calendar card
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffF2F2F7)),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: _buildNavigationItem(
            icon: AppAssets.calendar,
            iconBgColor: const Color(0xffECF4FE),
            iconColor: const Color(0xff4A59FE),
            title: 'Calendar Access',
            subtitle: 'Sync meeting Schedules',
            onTap: () {
              // TODO: Navigate to calendar access
            },
          ),
        ),
      ],
    );
  }

  // ==================== RECORDING SETTINGS SECTION ====================

  Widget _buildRecordingSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Text(
            'Recording settings',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              fontSize: 17.sp,
              height: 22 / 17,
              letterSpacing: -0.43,
              color: const Color(0xff000000),
            ),
          ),
        ),
        8.verticalSpace,
        // Settings card
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffF2F2F7)),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              // Auto-record scheduled meetings
              _buildToggleItem(
                title: 'Auto-record scheduled meetings',
                subtitle: 'Start recording when meeting begins',
                value: _autoRecordMeetings,
                showBorder: true,
                onChanged: (value) {
                  setState(() => _autoRecordMeetings = value);
                },
              ),
              // Real-time transcription
              _buildToggleItem(
                title: 'Real-time transcription',
                subtitle: 'Generate transcript during meeting',
                value: _realTimeTranscription,
                showBorder: true,
                onChanged: (value) {
                  setState(() => _realTimeTranscription = value);
                },
              ),
              // Recording Bot
              _buildNavigationItem(
                icon: AppAssets.calendar,
                iconBgColor: const Color(0xffECF4FE),
                iconColor: const Color(0xff4A59FE),
                title: 'Recording Bot',
                subtitle: 'Customize bot name and appearance',
                onTap: () {
                  // TODO: Navigate to recording bot settings
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleItem({
    required String title,
    required String subtitle,
    required bool value,
    required bool showBorder,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        border: showBorder
            ? const Border(
                bottom: BorderSide(color: Color(0xffF2F2F7)),
              )
            : null,
      ),
      child: Row(
        children: [
          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    height: 21 / 16,
                    letterSpacing: -0.31,
                    color: const Color(0xff000000),
                  ),
                ),
                4.verticalSpace,
                Text(
                  subtitle,
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                    height: 20 / 15,
                    letterSpacing: -0.23,
                    color: const Color(0xff999999),
                  ),
                ),
              ],
            ),
          ),
          // Toggle switch
          GestureDetector(
            onTap: () => onChanged(!value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 64.w,
              height: 28.h,
              decoration: BoxDecoration(
                color: value
                    ? const Color(0xff4A59FE)
                    : const Color(0xffE9E9EB),
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment:
                    value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.all(2.w),
                  width: 39.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem({
    required String icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  width: 24.w,
                  height: 24.h,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
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
                      fontSize: 16.sp,
                      height: 21 / 16,
                      letterSpacing: -0.31,
                      color: const Color(0xff000000),
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    subtitle,
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.sp,
                      height: 20 / 15,
                      letterSpacing: -0.23,
                      color: const Color(0xff999999),
                    ),
                  ),
                ],
              ),
            ),
            // Chevron
            SvgPicture.asset(
              AppAssets.chevronRight,
              width: 24.w,
              height: 24.h,
              colorFilter: const ColorFilter.mode(
                Color(0xff4A59FE),
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== SYNC INFO BAR ====================

  Widget _buildSyncInfoBar() {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: const Color(0xffECF4FE),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppAssets.info,
            width: 24.w,
            height: 24.h,
            colorFilter: const ColorFilter.mode(
              Color(0xff04071E),
              BlendMode.srcIn,
            ),
          ),
          8.horizontalSpace,
          RichText(
            text: TextSpan(
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 15.sp,
                height: 20 / 15,
                letterSpacing: -0.23,
                color: const Color(0xff000000),
              ),
              children: [
                const TextSpan(text: 'Last synced 5 minutes ago '),
                TextSpan(
                  text: 'Sync Now',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                    height: 20 / 15,
                    letterSpacing: -0.23,
                    color: const Color(0xff4A59FE),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}