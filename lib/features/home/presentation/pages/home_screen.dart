import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';
import 'package:voice_ink/features/home/presentation/widget/engine_popup.dart';
import 'package:voice_ink/features/home/presentation/widget/import_option_tile.dart';
import 'package:voice_ink/features/home/presentation/widget/language_popup.dart';
import 'package:voice_ink/features/home/presentation/widget/notification_popup.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedLanguage = 'en';
  String _selectedEngine = 'precision';

  // Engine icon mapping
  String _getEngineIcon(String engineId) {
    switch (engineId) {
      case 'precision':
        return AppAssets.target;
      case 'velocity':
        return AppAssets.flash;
      case 'clarity':
        return AppAssets.people;
      case 'universal':
        return AppAssets.globeEngine;
      default:
        return AppAssets.target;
    }
  }

  // Engine color mapping
  Color _getEngineColor(String engineId) {
    switch (engineId) {
      case 'precision':
        return const Color(0xff4A59FE);
      case 'velocity':
        return const Color(0xff1D9D70);
      case 'clarity':
        return const Color(0xffFA4100);
      case 'universal':
        return const Color(0xff9F17F5);
      default:
        return const Color(0xff4A59FE);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(AppAssets.frameLogo),
                const Spacer(),
                InkWell(
                  onTap: () => _showEnginePopup(context),
                  borderRadius: BorderRadius.circular(12.r),
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: SvgPicture.asset(
                      _getEngineIcon(_selectedEngine),
                      width: 24.w,
                      height: 24.h,
                      colorFilter: ColorFilter.mode(
                        _getEngineColor(_selectedEngine),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _showNotificationPopup(context),
                  borderRadius: BorderRadius.circular(12.r),
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: SvgPicture.asset(AppAssets.notification),
                  ),
                ),
                InkWell(
                  onTap: () => _showLanguagePopup(context),
                  borderRadius: BorderRadius.circular(999.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(AppAssets.language),
                        4.horizontalSpace,
                        Text(
                          _selectedLanguage.toUpperCase(),
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 13.sp,
                            height: 18 / 13,
                            letterSpacing: -0.08,
                            color: const Color(0xff333333),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.verticalSpace,
            // Start New section
            Text(
              'Start New',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                height: 18 / 16,
                letterSpacing: -0.08,
                color: const Color(0xff000000),
              ),
            ),
            8.verticalSpace,
            // Recording card
            _buildRecordingCard(),
            32.verticalSpace,
            // Import Content section
            Text(
              'Import Content',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                height: 18 / 16,
                letterSpacing: -0.08,
                color: const Color(0xff000000),
              ),
            ),
            8.verticalSpace,
            const ImportOptionsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordingCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.8, -0.5),
          end: Alignment(1.0, 0.5),
          colors: [Color(0xff4A59FE), Color(0xff4A59FE)],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            offset: Offset(1, 2),
            blurRadius: 4,
            color: Color.fromRGBO(74, 89, 254, 0.1),
          ),
          BoxShadow(
            offset: Offset(3, 6),
            blurRadius: 7,
            color: Color.fromRGBO(74, 89, 254, 0.09),
          ),
          BoxShadow(
            offset: Offset(6, 14),
            blurRadius: 9,
            color: Color.fromRGBO(74, 89, 254, 0.05),
          ),
          BoxShadow(
            offset: Offset(12, 26),
            blurRadius: 11,
            color: Color.fromRGBO(74, 89, 254, 0.01),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status row
              Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: const Color(0xff34C759),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 0.5,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                    ),
                  ),
                  8.horizontalSpace,
                  Text(
                    'READY TO TRANSCRIBE',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                      height: 18 / 13,
                      letterSpacing: -0.08,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              4.verticalSpace,
              // Title
              Text(
                'Start new recording',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 22.sp,
                  height: 28 / 22,
                  letterSpacing: -0.26,
                  color: Colors.white,
                ),
              ),
              4.verticalSpace,
              // Subtitle
              Text(
                'Tap to record',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 13.sp,
                  height: 18 / 13,
                  letterSpacing: -0.08,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          // Microphone button
          Container(
            width: 48.w,
            height: 48.h,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 0),
                  blurRadius: 1,
                  color: Color.fromRGBO(204, 207, 244, 0.09),
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                AppAssets.microphone,
                width: 32.w,
                height: 32.h,
                colorFilter: const ColorFilter.mode(
                  Color(0xff4A59FE),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEnginePopup(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) => EnginePopup(
        selectedEngine: _selectedEngine,
        onEngineSelected: (engine) {
          setState(() => _selectedEngine = engine);
        },
      ),
    );
  }

  void _showNotificationPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) => const NotificationPopup(),
    );
  }

  void _showLanguagePopup(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) => LanguagePopup(
        selectedLanguage: _selectedLanguage,
        onLanguageSelected: (language) {
          setState(() => _selectedLanguage = language);
        },
      ),
    );
  }
}
