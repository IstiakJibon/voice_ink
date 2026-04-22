// lib/features/settings/presentation/pages/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';
import 'package:voice_ink/features/settings/presentation/pages/meeting_integrations_screen.dart';
import 'package:voice_ink/features/settings/presentation/pages/notifications_screen.dart';
import 'package:voice_ink/features/settings/presentation/pages/profile_setting_screen.dart';
import 'package:voice_ink/features/settings/presentation/pages/subscription_plans_screen.dart';
import 'package:voice_ink/features/settings/presentation/pages/upgrade_plan_screen.dart';
import 'package:voice_ink/features/settings/presentation/pages/usage_storage_screen.dart';
import 'package:voice_ink/features/settings/presentation/pages/user_preferences_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Progress bar state (13 filled out of 40)
  final int _filledBars = 13;
  final int _totalBars = 40;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.verticalSpace,
              // Header
              _buildHeader(),
              24.verticalSpace,
              // Premium card
              _buildPremiumCard(),
              32.verticalSpace,
              // Account settings section
              _buildAccountSection(),
              24.verticalSpace,
              // Preferences section
              _buildPreferencesSection(),
              24.verticalSpace,
              // About & help section
              _buildAboutSection(),
              32.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Setting',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
            height: 25 / 20,
            letterSpacing: -0.45,
            color: const Color(0xff000000),
          ),
        ),
        // Profile button
        Container(
          width: 44.w,
          height: 44.h,
          decoration: const BoxDecoration(
            color: Color(0xffF2F2F7),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              AppAssets.person,
              width: 24.w,
              height: 24.h,
              colorFilter: const ColorFilter.mode(
                Color(0xff04071E),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff4A59FE), Color(0xff4738E2)],
        ),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current plan badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.25),
              borderRadius: BorderRadius.circular(1000.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Yellow dot
                Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffFED74A), Color(0xffFF9B05)],
                    ),
                  ),
                ),
                4.horizontalSpace,
                Text(
                  'Current Plan',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    height: 16 / 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          24.verticalSpace,
          // Plan info row
          Row(
            children: [
              // Logo icon
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppAssets.voiceInkLogo,
                    width: 24.w,
                    height: 24.h,
                  ),
                ),
              ),
              8.horizontalSpace,
              // Plan name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Premium Plan',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 15.sp,
                        height: 20 / 15,
                        letterSpacing: -0.23,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Text(
                      'VoiceInk Trial',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                        height: 25 / 20,
                        letterSpacing: -0.45,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$1.49',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                      height: 25 / 20,
                      letterSpacing: -0.45,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Per month',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.sp,
                      height: 20 / 15,
                      letterSpacing: -0.23,
                      color: const Color(0xff000000),
                    ),
                  ),
                ],
              ),
            ],
          ),
          24.verticalSpace,
          // Progress section
          Container(
            padding: EdgeInsets.all(11.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              children: [
                // Title row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Title',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                        height: 20 / 15,
                        letterSpacing: -0.23,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'sub title',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                        height: 20 / 15,
                        letterSpacing: -0.23,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                8.verticalSpace,
                // Progress bars
                _buildProgressBars(),
              ],
            ),
          ),
          24.verticalSpace,
          // Upgrade section
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              children: [
                // Crown row
                Row(
                  children: [
                    // Crown icon
                    Container(
                      width: 44.w,
                      height: 44.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xffFFDC50), Color(0xffFF9600)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(255, 189, 20, 0.1),
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(255, 189, 20, 0.09),
                            blurRadius: 5,
                            offset: Offset(1, 5),
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(255, 189, 20, 0.05),
                            blurRadius: 7,
                            offset: Offset(2, 12),
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(255, 189, 20, 0.01),
                            blurRadius: 9,
                            offset: Offset(3, 21),
                          ),
                        ],
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.crown,
                          width: 24.w,
                          height: 24.h,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    8.horizontalSpace,
                    // Text
                    Expanded(
                      child: Text(
                        'Unlock full access with no limits on transcriptions, notes, or AI features.',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                          height: 20 / 15,
                          letterSpacing: -0.23,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                12.verticalSpace,
                // Upgrade button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UpgradePlansScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: Text(
                        'Upgrade to VoiceInk Pro',
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
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBars() {
    return Row(
      children: List.generate(_totalBars, (index) {
        final isFilled = index < _filledBars;
        return Container(
          width: 4.w,
          height: 16.h,
          margin: EdgeInsets.only(right: index < _totalBars - 1 ? 4.w : 0),
          decoration: BoxDecoration(
            gradient: isFilled
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xffFFDC50), Color(0xffFF9600)],
                  )
                : null,
            color: isFilled ? null : const Color(0xffF9F9FF).withOpacity(0.25),
            borderRadius: BorderRadius.circular(9999.r),
          ),
        );
      }),
    );
  }

  Widget _buildAccountSection() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffF2F2F7)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          _buildSettingItem(
            icon: AppAssets.person,
            title: 'Profile Setting',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileSettingScreen()),
              );
            },
            showBorder: true,
          ),
          _buildSettingItem(
            icon: AppAssets.payment,
            title: 'Subscription & Plans',
            trailing: _buildBadge('Pro plan'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SubscriptionPlansScreen(),
                ),
              );
            },
            showBorder: true,
          ),
          _buildSettingItem(
            icon: AppAssets.video,
            title: 'Meeting Integrations',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MeetingIntegrationsScreen(),
                ),
              );
            },
            showBorder: true,
          ),
          _buildSettingItem(
            icon: AppAssets.hardDrive,
            title: 'Usage & Storage',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UsageStorageScreen()),
              );
            },
            showBorder: false,
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Text(
            'Preferences',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w600,
              fontSize: 17.sp,
              height: 22 / 17,
              letterSpacing: -0.43,
              color: const Color(0xff000000),
            ),
          ),
        ),
        8.verticalSpace,
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffF2F2F7)),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              _buildSettingItem(
                icon: AppAssets.notification,
                title: 'Notifications',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    ),
                  );
                },
                showBorder: true,
              ),
              _buildSettingItem(
                icon: AppAssets.lightbulb,
                title: 'User Preferences',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UserPreferencesScreen(),
                    ),
                  );
                },
                showBorder: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Text(
            'About & help',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w600,
              fontSize: 17.sp,
              height: 22 / 17,
              letterSpacing: -0.43,
              color: const Color(0xff000000),
            ),
          ),
        ),
        8.verticalSpace,
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffF2F2F7)),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              _buildSettingItem(
                icon: AppAssets.question,
                title: 'Notifications',
                onTap: () {
                  // TODO: Navigate to help
                },
                showBorder: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required String icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
    required bool showBorder,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          border: showBorder
              ? const Border(bottom: BorderSide(color: Color(0xffF2F2F7)))
              : null,
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: const Color(0xffECF4FE),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  icon,
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
            // Title
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.sp,
                  height: 22 / 17,
                  letterSpacing: -0.43,
                  color: const Color(0xff000000),
                ),
              ),
            ),
            // Trailing widget or chevron
            if (trailing != null) ...[trailing, 8.horizontalSpace],
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

  Widget _buildBadge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffF2F2F7)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.dmSans(
          fontWeight: FontWeight.w600,
          fontSize: 13.sp,
          height: 18 / 13,
          letterSpacing: -0.08,
          color: const Color(0xff999999),
        ),
      ),
    );
  }
}
