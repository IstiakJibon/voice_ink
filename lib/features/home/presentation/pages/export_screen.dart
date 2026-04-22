import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';
import 'package:voice_ink/features/home/presentation/widget/dashed_border_painter.dart';

class ExportScreen extends StatefulWidget {
  final String fileName;

  const ExportScreen({
    super.key,
    required this.fileName,
  });

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  String _selectedFormat = 'PDF';
  bool _moreOptionsExpanded = true;
  bool _translateTranscript = true;
  String _selectedLanguage = 'Spanish';

  // More options checkboxes
  bool _includeTimestamps = true;
  bool _includeSpeakerLabels = true;
  bool _includeConfidenceScores = true;
  bool _includeAudioHighlights = true;

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
                    16.verticalSpace,
                    // Transcript info
                    _buildTranscriptInfo(),
                    16.verticalSpace,
                    // Preview button
                    _buildPreviewButton(),
                    40.verticalSpace,
                    // File format
                    _buildFileFormatSection(),
                    22.verticalSpace,
                    // More options
                    _buildMoreOptionsSection(),
                    16.verticalSpace,
                    // Divider
                    _buildDivider(),
                    24.verticalSpace,
                    // Translate transcript
                    _buildTranslateSection(),
                    40.verticalSpace,
                    // Action buttons
                    _buildActionButtons(),
                    32.verticalSpace,
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
    return Padding(
      padding: EdgeInsets.only(right: 16.w, top: 5.h,bottom: 5.h),
      child: Row(
        children: [
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
          Expanded(
            child: Center(
              child: Text(
                'Export',
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
          // Spacer for centering
          SizedBox(width: 44.w),
        ],
      ),
    );
  }

  Widget _buildTranscriptInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transcript',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            fontSize: 17.sp,
            height: 22 / 17,
            letterSpacing: -0.43,
            color: const Color(0xff000000),
          ),
        ),
        8.verticalSpace,
        Text(
          'Filename: ${widget.fileName}',
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

Widget _buildPreviewButton() {
  return GestureDetector(
    onTap: () {
      // TODO: Preview functionality
    },
    child: CustomPaint(
      painter: DashedBorderPainter(
        color: const Color(0xff404040),
        strokeWidth: 1.5,
        dashWidth: 6,
        dashSpace: 4,
        borderRadius: 10.r,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppAssets.eye,
              width: 24.w,
              height: 24.h,
              colorFilter: const ColorFilter.mode(
                Color(0xff404040),
                BlendMode.srcIn,
              ),
            ),
            8.horizontalSpace,
            Text(
              'Preview transcript',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 15.sp,
                height: 20 / 15,
                letterSpacing: -0.23,
                color: const Color(0xff333333),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildFileFormatSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'File format',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            height: 21 / 16,
            letterSpacing: -0.31,
            color: const Color(0xff000000),
          ),
        ),
        8.verticalSpace,
        GestureDetector(
          onTap: () {
            _showFormatPicker();
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffF2F2F7)),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedFormat,
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                    height: 20 / 15,
                    letterSpacing: -0.23,
                    color: const Color(0xff333333),
                  ),
                ),
                SvgPicture.asset(
                  AppAssets.chevronDown,
                  width: 20.w,
                  height: 20.h,
                  colorFilter: const ColorFilter.mode(
                    Color(0xff404040),
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoreOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _moreOptionsExpanded = !_moreOptionsExpanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'More option',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  height: 21 / 16,
                  letterSpacing: -0.31,
                  color: const Color(0xff000000),
                ),
              ),
              AnimatedRotation(
                turns: _moreOptionsExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: SvgPicture.asset(
                  AppAssets.chevronDown,
                  width: 20.w,
                  height: 20.h,
                  colorFilter: const ColorFilter.mode(
                    Color(0xff404040),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_moreOptionsExpanded) ...[
          8.verticalSpace,
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffF2F2F7)),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              children: [
                _buildCheckboxOption(
                  'Include timestamps',
                  _includeTimestamps,
                  (value) => setState(() => _includeTimestamps = value),
                ),
                16.verticalSpace,
                _buildCheckboxOption(
                  'Include speaker labels',
                  _includeSpeakerLabels,
                  (value) => setState(() => _includeSpeakerLabels = value),
                ),
                16.verticalSpace,
                _buildCheckboxOption(
                  'Include confidence scores (if available)',
                  _includeConfidenceScores,
                  (value) => setState(() => _includeConfidenceScores = value),
                ),
                16.verticalSpace,
                _buildCheckboxOption(
                  'Include audio highlights',
                  _includeAudioHighlights,
                  (value) => setState(() => _includeAudioHighlights = value),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCheckboxOption(
    String label,
    bool value,
    Function(bool) onChanged,
  ) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Container(
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: value ? const Color(0xff4A59FE) : Colors.transparent,
              border: value
                  ? null
                  : Border.all(color: const Color(0xff8C8C8C), width: 1.5),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: value
                ? Center(
                    child: SvgPicture.asset(
                      AppAssets.checkmark,
                      width: 16.w,
                      height: 16.h,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  )
                : null,
          ),
          8.horizontalSpace,
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 15.sp,
                height: 20 / 15,
                letterSpacing: -0.23,
                color: const Color(0xff333333),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      color: const Color(0xffF2F2F7),
    );
  }

  Widget _buildTranslateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toggle row
        Row(
          children: [
            SvgPicture.asset(
              AppAssets.globe,
              width: 24.w,
              height: 24.h,
              colorFilter: const ColorFilter.mode(
                Color(0xff404040),
                BlendMode.srcIn,
              ),
            ),
            8.horizontalSpace,
            Expanded(
              child: Text(
                'Translate transcript',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  height: 21 / 16,
                  letterSpacing: -0.31,
                  color: const Color(0xff000000),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _translateTranscript = !_translateTranscript;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 64.w,
                height: 28.h,
                decoration: BoxDecoration(
                  color: _translateTranscript
                      ? const Color(0xff4A59FE)
                      : const Color(0xffE5E5EA),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 200),
                  alignment: _translateTranscript
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    width: 24.w,
                    height: 24.h,
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
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
        if (_translateTranscript) ...[
          16.verticalSpace,
          // Target language
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Target language',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  height: 21 / 16,
                  letterSpacing: -0.31,
                  color: const Color(0xff000000),
                ),
              ),
              8.verticalSpace,
              GestureDetector(
                onTap: () {
                  _showLanguagePicker();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffF2F2F7)),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedLanguage,
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                          height: 20 / 15,
                          letterSpacing: -0.23,
                          color: const Color(0xff333333),
                        ),
                      ),
                      SvgPicture.asset(
                        AppAssets.chevronDown,
                        width: 20.w,
                        height: 20.h,
                        colorFilter: const ColorFilter.mode(
                          Color(0xff404040),
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          24.verticalSpace,
          // Info card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xffF2F2F7),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      AppAssets.info,
                      width: 20.w,
                      height: 20.h,
                      colorFilter: const ColorFilter.mode(
                        Color(0xff04071E),
                        BlendMode.srcIn,
                      ),
                    ),
                    8.horizontalSpace,
                    Text(
                      'Info',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        height: 21 / 16,
                        letterSpacing: -0.31,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ],
                ),
                8.verticalSpace,
                Text(
                  'Translation will be applied during export (may take up to 5 minutes for long transcripts)',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    height: 21 / 16,
                    letterSpacing: -0.31,
                    color: const Color(0xff999999),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          // Export button
          GestureDetector(
            onTap: () {
              // TODO: Export functionality
              Navigator.pop(context);
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xff4A59FE),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Text(
                  'Export',
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
          16.verticalSpace,
          // Cancel button
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.r),
              ),
              child: Center(
                child: Text(
                  'Cancel',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                    height: 20 / 15,
                    letterSpacing: -0.23,
                    color: const Color(0xff333333),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFormatPicker() {
    final formats = ['PDF', 'DOCX', 'TXT', 'SRT', 'VTT'];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          16.verticalSpace,
          Container(
            width: 36.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: const Color(0xffCFCFCF),
              borderRadius: BorderRadius.circular(100.r),
            ),
          ),
          16.verticalSpace,
          ...formats.map((format) => ListTile(
                title: Text(
                  format,
                  style: GoogleFonts.dmSans(
                    fontWeight: _selectedFormat == format
                        ? FontWeight.w600
                        : FontWeight.w400,
                    fontSize: 16.sp,
                    color: const Color(0xff333333),
                  ),
                ),
                trailing: _selectedFormat == format
                    ? SvgPicture.asset(
                        AppAssets.checkmark,
                        width: 24.w,
                        height: 24.h,
                        colorFilter: const ColorFilter.mode(
                          Color(0xff4A59FE),
                          BlendMode.srcIn,
                        ),
                      )
                    : null,
                onTap: () {
                  setState(() {
                    _selectedFormat = format;
                  });
                  Navigator.pop(context);
                },
              )),
          32.verticalSpace,
        ],
      ),
    );
  }

  void _showLanguagePicker() {
    final languages = [
      'Spanish',
      'French',
      'German',
      'Portuguese',
      'Italian',
      'Chinese',
      'Japanese',
      'Korean',
      'Arabic',
      'Hindi',
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          16.verticalSpace,
          Container(
            width: 36.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: const Color(0xffCFCFCF),
              borderRadius: BorderRadius.circular(100.r),
            ),
          ),
          16.verticalSpace,
          SizedBox(
            height: 300.h,
            child: ListView.builder(
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final language = languages[index];
                return ListTile(
                  title: Text(
                    language,
                    style: GoogleFonts.dmSans(
                      fontWeight: _selectedLanguage == language
                          ? FontWeight.w600
                          : FontWeight.w400,
                      fontSize: 16.sp,
                      color: const Color(0xff333333),
                    ),
                  ),
                  trailing: _selectedLanguage == language
                      ? SvgPicture.asset(
                          AppAssets.checkmark,
                          width: 24.w,
                          height: 24.h,
                          colorFilter: const ColorFilter.mode(
                            Color(0xff4A59FE),
                            BlendMode.srcIn,
                          ),
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedLanguage = language;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          32.verticalSpace,
        ],
      ),
    );
  }
}