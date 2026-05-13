import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';
import 'package:voice_ink/config/utilities/extensions/user_extension.dart';
import 'package:voice_ink/features/files/presentation/cubit/files_cubit.dart';
import 'package:voice_ink/features/files/presentation/pages/transcript_detail_screen.dart';
import 'package:voice_ink/features/url_import/presentation/cubit/url_import_cubit.dart';
import 'package:voice_ink/features/url_import/presentation/cubit/url_import_state.dart';

class YouTubeImportScreen extends StatefulWidget {
  const YouTubeImportScreen({super.key});

  @override
  State<YouTubeImportScreen> createState() => _YouTubeImportScreenState();
}

class _YouTubeImportScreenState extends State<YouTubeImportScreen> {
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UrlImportCubit>().resetForNewUrl();
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  bool get _hasUrl => _urlController.text.trim().isNotEmpty;

  void _onCheck() {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;
    FocusScope.of(context).unfocus();
    context.read<UrlImportCubit>().checkUrl(
          token: context.token,
          url: url,
        );
  }

  Future<void> _onImport() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;
    FocusScope.of(context).unfocus();
    final cubit = context.read<UrlImportCubit>();
    final filesCubit = context.read<FilesCubit>();
    final navigator = Navigator.of(context);
    await cubit.importUrl(token: context.token, url: url);
    if (!mounted) return;
    final state = cubit.state;
    if (state.importStatus == UrlImportStatus.success &&
        state.importedFileId != null) {
      // Refresh files list and pop into Files tab with the new detail open.
      filesCubit.refreshFiles();
      navigator.pop();
      navigator.push(
        MaterialPageRoute(
          builder: (_) => TranscriptDetailScreen(
            fileId: state.importedFileId!,
            autoTranscribeOnArrival: state.autoTranscribe,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<UrlImportCubit, UrlImportState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xffE5E5EA)),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    24.verticalSpace,
                    _buildSourceCard(),
                    24.verticalSpace,
                    _buildUrlSection(state),
                    24.verticalSpace,
                    _buildProcessingOptions(state),
                    24.verticalSpace,
                    _buildImportButton(state),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: const BoxDecoration(
              color: Color(0xffECECF2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chevron_left_rounded,
              size: 20.sp,
              color: const Color(0xff1E1E1E),
            ),
          ),
        ),
        12.horizontalSpace,
        Text(
          'Import from YouTube',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w500,
            fontSize: 22.sp,
            height: 28 / 22,
            color: const Color(0xff1E1E1E),
          ),
        ),
      ],
    );
  }

  Widget _buildSourceCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffE5E5EA)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xffFE4A4D).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: SvgPicture.asset(
              AppAssets.youtube,
              width: 28.w,
              height: 28.h,
              colorFilter: const ColorFilter.mode(
                Color(0xffFE4A4D),
                BlendMode.srcIn,
              ),
            ),
          ),
          12.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'YouTube Video',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w500,
                  fontSize: 15.sp,
                  height: 20 / 15,
                  color: const Color(0xff1E222B),
                ),
              ),
              2.verticalSpace,
              Text(
                'Import audio from any video',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  height: 16 / 12,
                  color: const Color(0xff8C8C8C),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUrlSection(UrlImportState state) {
    final isChecking = state.checkStatus == UrlCheckStatus.checking;
    final errorText = state.checkStatus == UrlCheckStatus.failed
        ? state.checkError
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Video URL',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w500,
            fontSize: 15.sp,
            height: 20 / 15,
            color: const Color(0xff1E222B),
          ),
        ),
        12.verticalSpace,
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _urlController,
                keyboardType: TextInputType.url,
                onChanged: (_) {
                  // Clear stale check result whenever the URL changes.
                  if (state.checkStatus != UrlCheckStatus.idle ||
                      state.importStatus != UrlImportStatus.idle) {
                    context.read<UrlImportCubit>().resetForNewUrl();
                  }
                  setState(() {});
                },
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  color: const Color(0xff1E222B),
                ),
                decoration: InputDecoration(
                  hintText: 'https://www.youtube.com/watch?v=MK4lz....',
                  hintStyle: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: const Color(0xff9CA3AF),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 14.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: Color(0xffD1D5DB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: Color(0xffD1D5DB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: Color(0xff4A59FE)),
                  ),
                ),
              ),
            ),
            10.horizontalSpace,
            GestureDetector(
              onTap: (isChecking || !_hasUrl) ? null : _onCheck,
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: const Color(0xffF3F4F6),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    if (isChecking)
                      SizedBox(
                        width: 16.w,
                        height: 16.h,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xff4B5563),
                          ),
                        ),
                      )
                    else
                      Icon(
                        Icons.open_in_new_rounded,
                        size: 16.sp,
                        color: const Color(0xff4B5563)
                            .withValues(alpha: _hasUrl ? 1.0 : 0.4),
                      ),
                    6.horizontalSpace,
                    Text(
                      'Check',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: const Color(0xff4B5563)
                            .withValues(alpha: _hasUrl ? 1.0 : 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (errorText != null) ...[
          10.verticalSpace,
          _buildErrorBanner(errorText),
        ],
        if (state.checkStatus == UrlCheckStatus.ok &&
            state.checkResult?.title != null) ...[
          10.verticalSpace,
          _buildSuccessBanner(state.checkResult!.title!),
        ],
        10.verticalSpace,
        Text(
          'Supports videos up to 2 hours in length',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w500,
            fontSize: 11.sp,
            color: const Color(0xff1E222B),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorBanner(String text) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xffFEF2F2),
        border: Border.all(color: const Color(0xffFECACA)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 16.sp,
            color: const Color(0xffDC2626),
          ),
          8.horizontalSpace,
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                height: 16 / 12,
                color: const Color(0xffB91C1C),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessBanner(String title) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xffECFDF5),
        border: Border.all(color: const Color(0xffA7F3D0)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 16.sp,
            color: const Color(0xff059669),
          ),
          8.horizontalSpace,
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                height: 16 / 12,
                color: const Color(0xff065F46),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingOptions(UrlImportState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Processing Option',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w500,
            fontSize: 15.sp,
            height: 20 / 15,
            color: const Color(0xff1E222B),
          ),
        ),
        16.verticalSpace,
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xffECECF2)),
          ),
          child: Column(
            children: [
              _buildToggleRow(
                title: 'Auto Transcribe',
                subtitle: 'Automatically transcribe after import',
                value: state.autoTranscribe,
                onChanged: (v) => context
                    .read<UrlImportCubit>()
                    .toggleAutoTranscribe(v),
                isFirst: true,
              ),
              Container(height: 1, color: const Color(0xffECECF2)),
              _buildToggleRow(
                title: 'Speaker Detection',
                subtitle: 'Identify different speakers',
                value: state.speakerIdentification,
                onChanged: (v) => context
                    .read<UrlImportCubit>()
                    .toggleSpeakerIdentification(v),
                isFirst: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isFirst,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp,
                    height: 18 / 13,
                    color: const Color(0xff1E222B),
                  ),
                ),
                2.verticalSpace,
                Text(
                  subtitle,
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 10.sp,
                    height: 14 / 10,
                    color: const Color(0xff1E222B),
                  ),
                ),
              ],
            ),
          ),
          _buildToggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildToggle({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 44.w,
        height: 24.h,
        decoration: BoxDecoration(
          color: value ? const Color(0xff4A59FE) : const Color(0xffE5E5EA),
          borderRadius: BorderRadius.circular(99.r),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            width: 18.w,
            height: 18.h,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImportButton(UrlImportState state) {
    final isImporting = state.importStatus == UrlImportStatus.importing;
    final canImport = !isImporting && _hasUrl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.importStatus == UrlImportStatus.failed &&
            state.importError != null)
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _buildErrorBanner(state.importError!),
          ),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: canImport ? _onImport : null,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: canImport ? 1.0 : 0.5,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: const Color(0xff4A59FE),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isImporting) ...[
                      SizedBox(
                        width: 16.w,
                        height: 16.h,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      8.horizontalSpace,
                    ],
                    Text(
                      isImporting ? 'Importing…' : 'Import Video',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                        height: 20 / 15,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
