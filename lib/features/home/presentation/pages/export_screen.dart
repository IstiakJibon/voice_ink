import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';
import 'package:voice_ink/config/di/dependency_injector.dart';
import 'package:voice_ink/config/utilities/extensions/user_extension.dart';
import 'package:voice_ink/features/files/presentation/cubit/export/export_cubit.dart';
import 'package:voice_ink/features/files/presentation/cubit/export/export_state.dart';
import 'package:voice_ink/features/home/presentation/widget/dashed_border_painter.dart';

class ExportScreen extends StatefulWidget {
  final String transcriptionResultId;
  final String fileName;

  const ExportScreen({
    super.key,
    required this.transcriptionResultId,
    required this.fileName,
  });

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  static const Map<String, String> _languageCodes = {
    'English': 'en',
    'Spanish': 'es',
    'French': 'fr',
    'German': 'de',
    'Japanese': 'ja',
    'Chinese': 'zh',
  };

  String _selectedFormat = 'PDF';
  bool _moreOptionsExpanded = true;
  bool _translateTranscript = false;
  String _selectedLanguage = 'English';

  bool _showSpeakerNames = true;
  bool _showTimestamps = true;
  bool _combineParagraphs = true;
  bool _includeHighlights = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExportCubit>(
      create: (_) => sl<ExportCubit>(),
      child: BlocConsumer<ExportCubit, ExportState>(
        listener: (blocContext, state) {
          if (state.status == ExportStatus.success) {
            ScaffoldMessenger.of(blocContext).showSnackBar(
              SnackBar(
                content: Text(
                  'Exported: ${state.savedFileName ?? ''}\n${state.savedFilePath ?? ''}',
                ),
                duration: const Duration(seconds: 8),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            );
            Navigator.pop(blocContext);
          }
          if (state.status == ExportStatus.failure) {
            ScaffoldMessenger.of(blocContext).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Export failed'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            );
          }
        },
        builder: (blocContext, state) {
          final isLoading = state.status == ExportStatus.loading;
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          16.verticalSpace,
                          _buildTranscriptInfo(),
                          16.verticalSpace,
                          _buildPreviewButton(),
                          40.verticalSpace,
                          _buildFileFormatSection(),
                          22.verticalSpace,
                          _buildMoreOptionsSection(),
                          16.verticalSpace,
                          _buildDivider(),
                          24.verticalSpace,
                          _buildTranslateSection(),
                          40.verticalSpace,
                          _buildActionButtons(blocContext, isLoading),
                          32.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(right: 16.w, top: 5.h, bottom: 5.h),
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
                'More options',
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
                  'Show speaker names',
                  _showSpeakerNames,
                  (value) => setState(() => _showSpeakerNames = value),
                ),
                16.verticalSpace,
                _buildCheckboxOption(
                  'Show timestamps',
                  _showTimestamps,
                  (value) => setState(() => _showTimestamps = value),
                ),
                16.verticalSpace,
                _buildCheckboxOption(
                  'Combine paragraphs of the same speaker',
                  _combineParagraphs,
                  (value) => setState(() => _combineParagraphs = value),
                ),
                16.verticalSpace,
                _buildCheckboxOption(
                  'Include highlights',
                  _includeHighlights,
                  (value) => setState(() => _includeHighlights = value),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
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

  Widget _buildActionButtons(BuildContext blocContext, bool isLoading) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          GestureDetector(
            onTap: isLoading ? null : () => _onExportPressed(blocContext),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xff4A59FE),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: isLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
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
          GestureDetector(
            onTap: isLoading ? null : () => Navigator.pop(context),
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

  void _onExportPressed(BuildContext blocContext) {
    blocContext.read<ExportCubit>().exportTranscript(
          transcriptionResultId: widget.transcriptionResultId,
          originalFilename: widget.fileName,
          format: _selectedFormat.toLowerCase(),
          includeSpeakers: _showSpeakerNames,
          includeTimestamps: _showTimestamps,
          combineParagraphs: _combineParagraphs,
          includeHighlights: _includeHighlights,
          targetLanguage: _translateTranscript
              ? _languageCodes[_selectedLanguage]
              : null,
          token: context.token,
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
    final languages = _languageCodes.keys.toList();
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
