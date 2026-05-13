import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/utilities/extensions/user_extension.dart';
import 'package:voice_ink/features/files/presentation/cubit/files_cubit.dart';
import 'package:voice_ink/features/files/presentation/pages/transcript_detail_screen.dart';
import 'package:voice_ink/features/url_import/presentation/cubit/url_import_cubit.dart';
import 'package:voice_ink/features/url_import/presentation/cubit/url_import_state.dart';

class FromUrlImportScreen extends StatefulWidget {
  const FromUrlImportScreen({super.key});

  @override
  State<FromUrlImportScreen> createState() => _FromUrlImportScreenState();
}

class _FromUrlImportScreenState extends State<FromUrlImportScreen> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

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
    _nameController.dispose();
    super.dispose();
  }

  bool get _hasUrl => _urlController.text.trim().isNotEmpty;

  String _deriveName() {
    final manual = _nameController.text.trim();
    if (manual.isNotEmpty) return manual;
    final url = _urlController.text.trim();
    if (url.isEmpty) return 'URL Import';
    final uri = Uri.tryParse(url);
    if (uri == null || uri.pathSegments.isEmpty) return 'URL Import';
    final last = uri.pathSegments.last;
    return last.isEmpty ? 'URL Import' : last;
  }

  Future<void> _onImport() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;
    FocusScope.of(context).unfocus();
    final cubit = context.read<UrlImportCubit>();
    final filesCubit = context.read<FilesCubit>();
    final navigator = Navigator.of(context);
    await cubit.importUrl(
      token: context.token,
      url: url,
      name: _deriveName(),
    );
    if (!mounted) return;
    final state = cubit.state;
    if (state.importStatus == UrlImportStatus.success &&
        state.importedFileId != null) {
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
                    _buildHero(),
                    24.verticalSpace,
                    _buildUrlCard(state),
                    20.verticalSpace,
                    _buildProcessingCard(state),
                    20.verticalSpace,
                    _buildImportButton(state),
                    20.verticalSpace,
                    _buildSupportedUrlsCard(),
                    14.verticalSpace,
                    _buildImportantNotesCard(),
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
          'Import from URL',
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

  Widget _buildHero() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: const Color(0xffDBEAFE),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.link_rounded,
                size: 26.sp,
                color: const Color(0xff2563EB),
              ),
            ),
            12.horizontalSpace,
            Text(
              'Import from URL',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w700,
                fontSize: 22.sp,
                height: 28 / 22,
                color: const Color(0xff0F172A),
              ),
            ),
          ],
        ),
        10.verticalSpace,
        Text(
          'Import audio directly from any public URL',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 13.sp,
            height: 18 / 13,
            color: const Color(0xff6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildUrlCard(UrlImportState state) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffE5E7EB)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Audio URL',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
              color: const Color(0xff374151),
            ),
          ),
          8.verticalSpace,
          _buildTextField(
            controller: _urlController,
            hint: 'https://example.com/audio.mp3',
            keyboardType: TextInputType.url,
            onChanged: (_) {
              if (state.importStatus != UrlImportStatus.idle) {
                context.read<UrlImportCubit>().resetForNewUrl();
              }
              setState(() {});
            },
          ),
          16.verticalSpace,
          Text(
            'File Name (Optional)',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
              color: const Color(0xff374151),
            ),
          ),
          8.verticalSpace,
          _buildTextField(
            controller: _nameController,
            hint: 'my-audio.mp3',
            keyboardType: TextInputType.text,
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required TextInputType keyboardType,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: GoogleFonts.dmSans(
        fontWeight: FontWeight.w400,
        fontSize: 14.sp,
        color: const Color(0xff111827),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.dmSans(
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: const Color(0xff9CA3AF),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
          borderSide: const BorderSide(color: Color(0xff3B82F6), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildProcessingCard(UrlImportState state) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffE5E7EB)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.settings_outlined,
                size: 18.sp,
                color: const Color(0xff4B5563),
              ),
              8.horizontalSpace,
              Text(
                'Processing Options',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: const Color(0xff111827),
                ),
              ),
            ],
          ),
          14.verticalSpace,
          _buildOptionCheckCard(
            emoji: '🎯',
            title: 'Auto Transcribe',
            subtitle: 'Automatically start transcription',
            value: state.autoTranscribe,
            onChanged: (v) =>
                context.read<UrlImportCubit>().toggleAutoTranscribe(v),
          ),
          10.verticalSpace,
          _buildOptionCheckCard(
            emoji: '👥',
            title: 'Speaker Identification',
            subtitle: 'Identify different speakers',
            value: state.speakerIdentification,
            onChanged: (v) =>
                context.read<UrlImportCubit>().toggleSpeakerIdentification(v),
          ),
          14.verticalSpace,
          _buildAdvancedFeaturesButton(),
          14.verticalSpace,
          _buildProcessingTimeNote(),
        ],
      ),
    );
  }

  Widget _buildOptionCheckCard({
    required String emoji,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final selected = value;
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: selected ? const Color(0xffEFF6FF) : Colors.white,
          border: Border.all(
            color: selected
                ? const Color(0xffBFDBFE)
                : const Color(0xffE5E7EB),
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 18.w,
              height: 18.h,
              child: Checkbox(
                value: value,
                onChanged: (v) => onChanged(v ?? false),
                activeColor: const Color(0xff2563EB),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(emoji, style: TextStyle(fontSize: 16.sp)),
                      8.horizontalSpace,
                      Text(
                        title,
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp,
                          color: const Color(0xff111827),
                        ),
                      ),
                    ],
                  ),
                  2.verticalSpace,
                  Text(
                    subtitle,
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 11.sp,
                      height: 14 / 11,
                      color: const Color(0xff6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedFeaturesButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xffF9FAFB),
        border: Border.all(color: const Color(0xffE5E7EB)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.settings_outlined,
            size: 16.sp,
            color: const Color(0xff6B7280),
          ),
          8.horizontalSpace,
          Text(
            'Advanced AI Features',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
              color: const Color(0xff374151),
            ),
          ),
          6.horizontalSpace,
          Text(
            '(0 selected)',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400,
              fontSize: 11.sp,
              color: const Color(0xff9CA3AF),
            ),
          ),
          const Spacer(),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18.sp,
            color: const Color(0xff9CA3AF),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingTimeNote() {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xffEFF6FF),
        border: Border.all(color: const Color(0xffBFDBFE)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 11.sp,
            height: 15 / 11,
            color: const Color(0xff1E40AF),
          ),
          children: const [
            TextSpan(text: '⏱️ '),
            TextSpan(
              text: 'Processing Time: ',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text:
                  "Transcription typically takes 1-3 minutes for most recordings. You'll receive a notification when it's complete, and you can continue using the app while processing runs in the background.",
            ),
          ],
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
        GestureDetector(
          onTap: canImport ? _onImport : null,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: canImport ? 1.0 : 0.5,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: const Color(0xff2563EB),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  ] else
                    Icon(
                      Icons.download_rounded,
                      size: 18.sp,
                      color: Colors.white,
                    ),
                  8.horizontalSpace,
                  Text(
                    isImporting ? 'Importing…' : 'Import Audio',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
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

  Widget _buildSupportedUrlsCard() {
    return _buildBulletInfoCard(
      title: 'Supported URLs',
      titleColor: const Color(0xff1E3A8A),
      bodyColor: const Color(0xff1E40AF),
      bg: const Color(0xffEFF6FF),
      border: const Color(0xffBFDBFE),
      items: const [
        'Direct audio file links (MP3, WAV, M4A, etc.)',
        'Publicly accessible audio URLs',
        'Cloud storage links (Dropbox, Google Drive public links)',
        'Podcast episode direct links',
      ],
    );
  }

  Widget _buildImportantNotesCard() {
    return _buildBulletInfoCard(
      title: 'Important Notes',
      titleColor: const Color(0xff78350F),
      bodyColor: const Color(0xff92400E),
      bg: const Color(0xffFFFBEB),
      border: const Color(0xffFDE68A),
      items: const [
        'URL must be publicly accessible (no authentication required)',
        'File size limit: 2GB',
        'Supported formats: MP3, WAV, M4A, FLAC, OGG',
        'Processing time depends on file size',
      ],
    );
  }

  Widget _buildBulletInfoCard({
    required String title,
    required Color titleColor,
    required Color bodyColor,
    required Color bg,
    required Color border,
    required List<String> items,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
              color: titleColor,
            ),
          ),
          8.verticalSpace,
          for (final item in items)
            Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Text(
                '• $item',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  height: 16 / 12,
                  color: bodyColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
