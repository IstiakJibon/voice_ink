import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';

class UserPreferencesScreen extends StatefulWidget {
  const UserPreferencesScreen({super.key});

  @override
  State<UserPreferencesScreen> createState() => _UserPreferencesScreenState();
}

class _UserPreferencesScreenState extends State<UserPreferencesScreen> {
  // User Preferences state
  String _darkMode = 'Light';
  String _appLanguage = 'English';
  String _recordingLanguage = 'English';
  String _preferredEngine = 'Whisper V3';
  bool _speakerDiarization = true;
  bool _autoPunctuation = true;
  bool _pushNotifications = true;
  String _soundEffects = 'Default';
  bool _autoStartTranscription = true;
  bool _backgroundRecording = true;

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
                    // User Preferences section
                    _buildSectionHeader('User Preferences'),
                    8.verticalSpace,
                    _buildPreferencesCard([
                      _buildPreferenceItemWithButton(
                        icon: AppAssets.theme,
                        title: 'Dark Mode',
                        subtitle: 'Always light',
                        buttonLabel: _darkMode,
                        onTap: () => _showDarkModeOptions(),
                        showBorder: false,
                      ),
                    ]),
                    16.verticalSpace,
                    // Language & Region section
                    _buildSectionHeader('Language & Region'),
                    8.verticalSpace,
                    _buildPreferencesCard([
                      _buildPreferenceItemWithButton(
                        icon: AppAssets.globe,
                        title: 'App Language',
                        subtitle: 'Change app interface language',
                        buttonLabel: _appLanguage,
                        onTap: () => _showLanguageOptions(),
                        showBorder: true,
                      ),
                      _buildPreferenceItemWithButton(
                        icon: AppAssets.mic,
                        title: 'Default Recording Language',
                        subtitle: 'Auto-selected when recording',
                        buttonLabel: _recordingLanguage,
                        onTap: () => _showRecordingLanguageOptions(),
                        showBorder: false,
                      ),
                    ]),
                    16.verticalSpace,
                    // Transcription section
                    _buildSectionHeader('Transcription'),
                    8.verticalSpace,
                    _buildPreferencesCard([
                      _buildPreferenceItemWithButton(
                        icon: AppAssets.target,
                        title: 'Preferred Engine',
                        subtitle: 'Maximum Accuracy',
                        buttonLabel: _preferredEngine,
                        onTap: () => _showEngineOptions(),
                        showBorder: true,
                      ),
                      _buildPreferenceItemWithToggle(
                        icon: AppAssets.mic,
                        title: 'Speaker Diarization',
                        subtitle: 'Identify different speakers',
                        value: _speakerDiarization,
                        onChanged: (value) {
                          setState(() {
                            _speakerDiarization = value;
                          });
                        },
                        showBorder: true,
                      ),
                      _buildPreferenceItemWithToggle(
                        icon: AppAssets.textField,
                        title: 'Auto Punctuation',
                        subtitle: 'Add punctuation automatically',
                        value: _autoPunctuation,
                        onChanged: (value) {
                          setState(() {
                            _autoPunctuation = value;
                          });
                        },
                        showBorder: false,
                      ),
                    ]),
                    16.verticalSpace,
                    // Notifications section
                    _buildSectionHeader('Notifications'),
                    8.verticalSpace,
                    _buildPreferencesCard([
                      _buildPreferenceItemWithToggle(
                        icon: AppAssets.notification,
                        title: 'Push Notifications',
                        subtitle: 'Recording and processing updates',
                        value: _pushNotifications,
                        onChanged: (value) {
                          setState(() {
                            _pushNotifications = value;
                          });
                        },
                        showBorder: true,
                      ),
                      _buildPreferenceItemWithButton(
                        icon: AppAssets.speaker,
                        title: 'Sound Effects',
                        subtitle: 'Auto-selected when recording',
                        buttonLabel: _soundEffects,
                        onTap: () => _showSoundEffectsOptions(),
                        showBorder: false,
                      ),
                    ]),
                    16.verticalSpace,
                    // Recording section
                    _buildSectionHeader('Recording'),
                    8.verticalSpace,
                    _buildPreferencesCard([
                      _buildPreferenceItemWithToggle(
                        icon: null,
                        title: 'Auto-start transcription',
                        subtitle: 'Begin transcribing immediately after recording',
                        value: _autoStartTranscription,
                        onChanged: (value) {
                          setState(() {
                            _autoStartTranscription = value;
                          });
                        },
                        showBorder: true,
                        hasIcon: false,
                      ),
                      _buildPreferenceItemWithToggle(
                        icon: null,
                        title: 'Background Recording',
                        subtitle: 'Continue recording when app is in background',
                        value: _backgroundRecording,
                        onChanged: (value) {
                          setState(() {
                            _backgroundRecording = value;
                          });
                        },
                        showBorder: false,
                        hasIcon: false,
                      ),
                    ]),
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
              'User Preferences',
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.roboto(
        fontWeight: FontWeight.w600,
        fontSize: 17.sp,
        height: 22 / 17,
        letterSpacing: -0.43,
        color: const Color(0xff000000),
      ),
    );
  }

  Widget _buildPreferencesCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffF2F2F7)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildPreferenceItemWithButton({
    required String? icon,
    required String title,
    required String subtitle,
    required String buttonLabel,
    required VoidCallback onTap,
    required bool showBorder,
    bool hasIcon = true,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 20.h),
      decoration: BoxDecoration(
        border: showBorder
            ? const Border(
                bottom: BorderSide(color: Color(0xffF2F2F7)),
              )
            : null,
      ),
      child: Row(
        children: [
          // Icon
          if (hasIcon && icon != null) ...[
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
          ],
          // Text content
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
                    fontSize: 13.sp,
                    height: 18 / 13,
                    letterSpacing: -0.08,
                    color: const Color(0xff999999),
                  ),
                ),
              ],
            ),
          ),
          // Button
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff8C8C8C)),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                buttonLabel,
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w400,
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

  Widget _buildPreferenceItemWithToggle({
    required String? icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool showBorder,
    bool hasIcon = true,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 20.h),
      decoration: BoxDecoration(
        border: showBorder
            ? const Border(
                bottom: BorderSide(color: Color(0xffF2F2F7)),
              )
            : null,
      ),
      child: Row(
        children: [
          // Icon
          if (hasIcon && icon != null) ...[
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
          ],
          // Text content
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
                    fontSize: 13.sp,
                    height: 18 / 13,
                    letterSpacing: -0.08,
                    color: const Color(0xff999999),
                  ),
                ),
              ],
            ),
          ),
          // Custom Toggle
          _buildCustomToggle(value, onChanged),
        ],
      ),
    );
  }

  Widget _buildCustomToggle(bool value, ValueChanged<bool> onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 64.w,
        height: 28.h,
        decoration: BoxDecoration(
          color: value ? const Color(0xff4A59FE) : const Color(0xffE9E9EB),
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 39.w,
            height: 24.h,
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100.r),
            ),
          ),
        ),
      ),
    );
  }

  void _showDarkModeOptions() {
    _showOptionsBottomSheet(
      'Dark Mode',
      ['Light', 'Dark', 'System'],
      _darkMode,
      (value) {
        setState(() {
          _darkMode = value;
        });
      },
    );
  }

  void _showLanguageOptions() {
    _showOptionsBottomSheet(
      'App Language',
      ['English', 'Bengali', 'Spanish', 'French', 'German'],
      _appLanguage,
      (value) {
        setState(() {
          _appLanguage = value;
        });
      },
    );
  }

  void _showRecordingLanguageOptions() {
    _showOptionsBottomSheet(
      'Recording Language',
      ['English', 'Bengali', 'Spanish', 'French', 'German', 'Auto-detect'],
      _recordingLanguage,
      (value) {
        setState(() {
          _recordingLanguage = value;
        });
      },
    );
  }

  void _showEngineOptions() {
    _showOptionsBottomSheet(
      'Preferred Engine',
      ['Whisper V3', 'Whisper V2', 'Fast Mode'],
      _preferredEngine,
      (value) {
        setState(() {
          _preferredEngine = value;
        });
      },
    );
  }

  void _showSoundEffectsOptions() {
    _showOptionsBottomSheet(
      'Sound Effects',
      ['Default', 'Minimal', 'None'],
      _soundEffects,
      (value) {
        setState(() {
          _soundEffects = value;
        });
      },
    );
  }

  void _showOptionsBottomSheet(
    String title,
    List<String> options,
    String currentValue,
    ValueChanged<String> onSelected,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              16.verticalSpace,
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xffE0E0E0),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              16.verticalSpace,
              Text(
                title,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w600,
                  fontSize: 17.sp,
                  height: 22 / 17,
                  letterSpacing: -0.43,
                  color: const Color(0xff000000),
                ),
              ),
              16.verticalSpace,
              ...options.map((option) => ListTile(
                    title: Text(
                      option,
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        color: const Color(0xff000000),
                      ),
                    ),
                    trailing: currentValue == option
                        ? Icon(
                            Icons.check,
                            color: const Color(0xff4A59FE),
                            size: 24.w,
                          )
                        : null,
                    onTap: () {
                      onSelected(option);
                      Navigator.pop(context);
                    },
                  )),
              16.verticalSpace,
            ],
          ),
        );
      },
    );
  }
}