import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';

class EngineOption {
  final String id;
  final String name;
  final String tagline;
  final String description;
  final String icon;
  final Color color;
  final Color bgColor;
  final String accuracy;
  final String speed;
  final List<ProgressItem> progressItems;
  final List<String> strengths;
  final List<String> tags;

  const EngineOption({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.accuracy,
    required this.speed,
    required this.progressItems,
    required this.strengths,
    required this.tags,
  });
}

class ProgressItem {
  final String title;
  final double progress; // 0.0 to 1.0

  const ProgressItem({
    required this.title,
    required this.progress,
  });
}

class EnginePopup extends StatefulWidget {
  final String selectedEngine;
  final Function(String) onEngineSelected;

  const EnginePopup({
    super.key,
    required this.selectedEngine,
    required this.onEngineSelected,
  });

  @override
  State<EnginePopup> createState() => _EnginePopupState();
}

class _EnginePopupState extends State<EnginePopup> {
  String? _expandedEngineId;

  static final List<EngineOption> engines = [
    EngineOption(
      id: 'precision',
      name: 'Precision',
      tagline: 'Maximum Accuracy',
      description:
          'Industry-leading 95-98% accuracy on clean audio. Built for situations where every word matters-legal testimony, medical diagnoses, research interviews.',
      icon: AppAssets.target,
      color: const Color(0xff4A59FE),
      bgColor: const Color(0xffECF4FE),
      accuracy: '98%',
      speed: '85%',
      progressItems: [
        const ProgressItem(title: 'Accuracy', progress: 0.96),
        const ProgressItem(title: 'Speed', progress: 0.82),
        const ProgressItem(title: 'Language Support', progress: 0.88),
      ],
      strengths: [
        'Word Error Rate: 7-9% (industry-leading)',
        'Professional punctuation & formatting',
        'Superior entity detection (names, dates)',
      ],
      tags: ['Legal', 'Medical', 'Research'],
    ),
    EngineOption(
      id: 'velocity',
      name: 'Velocity',
      tagline: 'Lightning Fast',
      description:
          'Processes audio 40-200x faster than real-time. Get 1 hour of audio transcribed in just 90 seconds. Perfect for live meetings and high-volume processing.',
      icon: AppAssets.flash,
      color: const Color(0xff1D9D70),
      bgColor: const Color(0xffE7FDF4),
      accuracy: '95%',
      speed: '98%',
      progressItems: [
        const ProgressItem(title: 'Accuracy', progress: 0.92),
        const ProgressItem(title: 'Speed', progress: 0.97),
        const ProgressItem(title: 'Language Support', progress: 0.79),
      ],
      strengths: [
        'Word Error Rate: 7-9% (industry-leading)',
        'Professional punctuation & formatting',
        'Superior entity detection (names, dates)',
      ],
      tags: ['Live Meetings', 'Podcasts', 'High-Volume'],
    ),
    EngineOption(
      id: 'clarity',
      name: 'Clarity',
      tagline: 'Speaker Recognition Expert',
      description:
          'Advanced speaker diarization with up to 99% speaker identification accuracy. Ideal for interviews, panel discussions, and multi-speaker recordings.',
      icon: AppAssets.people,
      color: const Color(0xffFA4100),
      bgColor: const Color(0xffFFF6EB),
      accuracy: '96%',
      speed: '90%',
      progressItems: [
        const ProgressItem(title: 'Accuracy', progress: 0.94),
        const ProgressItem(title: 'Speed', progress: 0.88),
        const ProgressItem(title: 'Speaker Detection', progress: 0.99),
      ],
      strengths: [
        'Word Error Rate: 7-9% (industry-leading)',
        'Professional punctuation & formatting',
        'Superior entity detection (names, dates)',
      ],
      tags: ['Interviews', 'Panels', 'Meetings'],
    ),
    EngineOption(
      id: 'universal',
      name: 'Universal',
      tagline: 'Multilingual Master',
      description:
          'Supports 100+ languages with automatic language detection. Perfect for international teams and multilingual content.',
      icon: AppAssets.globeEngine,
      color: const Color(0xff9F17F5),
      bgColor: const Color(0xffFAF3FF),
      accuracy: '94%',
      speed: '80%',
      progressItems: [
        const ProgressItem(title: 'Accuracy', progress: 0.90),
        const ProgressItem(title: 'Speed', progress: 0.78),
        const ProgressItem(title: 'Language Support', progress: 0.99),
      ],
      strengths: [
        'Word Error Rate: 7-9% (industry-leading)',
        'Professional punctuation & formatting',
        'Superior entity detection (names, dates)',
      ],
      tags: ['Multilingual', 'International', 'Translation'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 80.h),
      alignment: Alignment.topCenter,
      child: Container(
        constraints: BoxConstraints(maxHeight: 0.75.sh),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(16.w),
              child: _buildHeader(context),
            ),
            // Engine list
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    ...engines.map((engine) => Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: _buildEngineCard(engine),
                        )),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Title section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Your Transcription Engine',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 17.sp,
                  height: 22 / 17,
                  letterSpacing: -0.43,
                  color: const Color(0xff000000),
                ),
              ),
              4.verticalSpace,
              Text(
                'Select the best model for your needs',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 15.sp,
                  height: 20 / 15,
                  letterSpacing: -0.23,
                  color: const Color(0xff3C3C43).withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        // Action buttons
        Row(
          children: [
            GestureDetector(
              onTap: () {
                // More options
              },
              child: SvgPicture.asset(
                AppAssets.more,
                width: 24.w,
                height: 24.h,
              ),
            ),
            8.horizontalSpace,
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: const Color(0xffF2F2F7),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppAssets.dismiss,
                    width: 24.w,
                    height: 24.h,
                    colorFilter: const ColorFilter.mode(
                      Color(0xff04071E),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEngineCard(EngineOption engine) {
    final isSelected = widget.selectedEngine == engine.id;
    final isExpanded = _expandedEngineId == engine.id;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_expandedEngineId == engine.id) {
            _expandedEngineId = null;
          } else {
            _expandedEngineId = engine.id;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? engine.color : const Color(0xffF2F2F7),
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              // Collapsed header
              _buildCardHeader(engine, isSelected),
              // Expanded content
              if (isExpanded) ...[
                16.verticalSpace,
                _buildExpandedContent(engine, isSelected),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader(EngineOption engine, bool isSelected) {
    return Row(
      children: [
        // Icon and info
        Expanded(
          child: Row(
            children: [
              // Icon
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: engine.bgColor,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    engine.icon,
                    width: 24.w,
                    height: 24.h,
                    colorFilter: ColorFilter.mode(engine.color, BlendMode.srcIn),
                  ),
                ),
              ),
              8.horizontalSpace,
              // Text info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row with Active badge
                    Row(
                      children: [
                        Text(
                          engine.name,
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp,
                            height: 20 / 15,
                            letterSpacing: -0.23,
                            color: const Color(0xff000000),
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: engine.bgColor,
                              borderRadius: BorderRadius.circular(24.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  AppAssets.checkmark,
                                  width: 16.w,
                                  height: 16.h,
                                  colorFilter: ColorFilter.mode(
                                    engine.color,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                4.horizontalSpace,
                                Text(
                                  'Active',
                                  style: GoogleFonts.dmSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13.sp,
                                    height: 18 / 13,
                                    letterSpacing: -0.08,
                                    color: engine.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    4.verticalSpace,
                    // Tagline
                    Text(
                      engine.tagline,
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp,
                        height: 18 / 13,
                        letterSpacing: -0.08,
                        color: engine.color,
                      ),
                    ),
                    4.verticalSpace,
                    // Stats row
                    Row(
                      children: [
                        Text(
                          '${engine.accuracy} Accuracy',
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w400,
                            fontSize: 13.sp,
                            height: 18 / 13,
                            letterSpacing: -0.08,
                            color: const Color(0xff333333),
                          ),
                        ),
                        8.horizontalSpace,
                        Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: const BoxDecoration(
                            color: Color(0xffE5E5EA),
                            shape: BoxShape.circle,
                          ),
                        ),
                        8.horizontalSpace,
                        Text(
                          '${engine.speed} Speed',
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w400,
                            fontSize: 13.sp,
                            height: 18 / 13,
                            letterSpacing: -0.08,
                            color: const Color(0xff333333),
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
        8.horizontalSpace,
        // Chevron
        Opacity(
          opacity: 0.8,
          child: SvgPicture.asset(
            AppAssets.chevronDown,
            width: 24.w,
            height: 24.h,
            colorFilter: const ColorFilter.mode(
              Color(0xff8E8E93),
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedContent(EngineOption engine, bool isSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description
        Text(
          engine.description,
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 15.sp,
            height: 20 / 15,
            letterSpacing: -0.23,
            color: const Color(0xff333333),
          ),
        ),
        16.verticalSpace,
        // Progress bars
        ...engine.progressItems.map((item) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: _buildProgressBar(item, engine.color),
            )),
        8.verticalSpace,
        // Key strengths
        Text(
          'KEY STRENGTHS',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
            height: 18 / 13,
            letterSpacing: -0.08,
            color: const Color(0xff999999),
          ),
        ),
        8.verticalSpace,
        // Strengths list
        ...engine.strengths.map((strength) => Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: _buildStrengthItem(strength, engine.color),
            )),
        12.verticalSpace,
        // Tags
        Wrap(
          spacing: 7.w,
          runSpacing: 8.h,
          children: engine.tags
              .map((tag) => Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xffF2F2F7),
                      borderRadius: BorderRadius.circular(1000.r),
                    ),
                    child: Text(
                      tag,
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 15.sp,
                        height: 20 / 15,
                        letterSpacing: -0.23,
                        color: const Color(0xff999999),
                      ),
                    ),
                  ))
              .toList(),
        ),
        16.verticalSpace,
        // Select button
        GestureDetector(
          onTap: () {
            widget.onEngineSelected(engine.id);
            Navigator.pop(context);
          },
          child: Container(
            width: double.infinity,
            height: 40.h,
            decoration: BoxDecoration(
              color: engine.color,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: Text(
                isSelected ? 'Currently Active' : 'Select ${engine.name}',
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
      ],
    );
  }

  Widget _buildProgressBar(ProgressItem item, Color color) {
    final percentage = (item.progress * 100).toInt();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                item.title,
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                  height: 18 / 13,
                  letterSpacing: -0.08,
                  color: const Color(0xff333333),
                ),
              ),
            ),
            Text(
              '$percentage%',
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
        8.verticalSpace,
        Stack(
          children: [
            // Background
            Container(
              height: 8.h,
              decoration: BoxDecoration(
                color: const Color(0xffF2F2F7),
                borderRadius: BorderRadius.circular(9999.r),
              ),
            ),
            // Progress
            FractionallySizedBox(
              widthFactor: item.progress,
              child: Container(
                height: 8.h,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(9999.r),
                    bottomLeft: Radius.circular(9999.r),
                    topRight: item.progress >= 1.0
                        ? Radius.circular(9999.r)
                        : Radius.zero,
                    bottomRight: item.progress >= 1.0
                        ? Radius.circular(9999.r)
                        : Radius.zero,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStrengthItem(String strength, Color color) {
    return Row(
      children: [
        SvgPicture.asset(
          AppAssets.checkmark,
          width: 20.w,
          height: 20.h,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        8.horizontalSpace,
        Expanded(
          child: Text(
            strength,
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400,
              fontSize: 13.sp,
              height: 18 / 13,
              letterSpacing: -0.08,
              color: const Color(0xff333333),
            ),
          ),
        ),
      ],
    );
  }
}