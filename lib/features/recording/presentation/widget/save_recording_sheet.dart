import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/navigation/route_name.dart';
import 'package:voice_ink/config/utilities/extensions/user_extension.dart';
import 'package:voice_ink/features/files/presentation/cubit/files_cubit.dart';
import 'package:voice_ink/features/files/presentation/pages/transcript_detail_screen.dart';
import 'package:voice_ink/features/upload/domain/entities/upload_entity.dart';
import 'package:voice_ink/features/upload/presentation/cubit/upload_cubit.dart';
import 'package:voice_ink/features/upload/presentation/cubit/upload_state.dart';

class SaveRecordingSheet extends StatefulWidget {
  final String filePath;
  final Duration duration;
  final int sizeBytes;

  const SaveRecordingSheet({
    super.key,
    required this.filePath,
    required this.duration,
    required this.sizeBytes,
  });

  static Future<void> show(
    BuildContext context, {
    required String filePath,
    required Duration duration,
    required int sizeBytes,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SaveRecordingSheet(
        filePath: filePath,
        duration: duration,
        sizeBytes: sizeBytes,
      ),
    );
  }

  @override
  State<SaveRecordingSheet> createState() => _SaveRecordingSheetState();
}

class _SaveRecordingSheetState extends State<SaveRecordingSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _tagsController;

  bool _autoTranscribe = true;
  bool _speakerIdentification = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _defaultName());
    _descriptionController = TextEditingController();
    _tagsController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  String _defaultName() {
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour12 = now.hour == 0
        ? 12
        : (now.hour > 12 ? now.hour - 12 : now.hour);
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    final mm = now.minute.toString().padLeft(2, '0');
    return 'Recording - ${months[now.month - 1]} ${now.day}, ${now.year}, '
        '${hour12.toString().padLeft(2, '0')}:$mm $ampm';
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  Future<void> _onSave() async {
    if (_saving) return;
    final name = _nameController.text.trim().isEmpty
        ? _defaultName()
        : _nameController.text.trim();

    setState(() => _saving = true);

    final navigator = Navigator.of(context);
    final uploadCubit = context.read<UploadCubit>();
    final filesCubit = context.read<FilesCubit>();
    final token = context.token;

    final file = File(widget.filePath);
    final fileName = '$name.m4a';

    uploadCubit.reset();
    uploadCubit.addFiles([
      UploadItem(
        localId: 'rec-${DateTime.now().microsecondsSinceEpoch}',
        name: fileName,
        size: widget.sizeBytes > 0
            ? widget.sizeBytes
            : await file.length(),
        localPath: widget.filePath,
        contentType: 'audio/mp4',
      ),
    ]);

    // Listen once for terminal state, then close the sheet + navigate.
    late final void Function() listener;
    listener = () {
      final s = uploadCubit.state;
      if (s.allDone || s.failedCount > 0) {
        uploadCubit.stream.listen((_) {}); // no-op to prevent leak warning
        if (!mounted) return;
        final firstDone = s.items.firstWhere(
          (i) => i.stage == UploadStage.done && i.fileId != null,
          orElse: () => s.items.isNotEmpty
              ? s.items.first
              : const UploadItem(
                  localId: '',
                  name: '',
                  size: 0,
                  localPath: '',
                  contentType: '',
                ),
        );
        final fileId = firstDone.fileId;
        if (fileId != null && fileId.isNotEmpty) {
          filesCubit.refreshFiles();
          navigator.pop(); // close save sheet
          // Clear stack and land on Files tab.
          navigator.pushNamedAndRemoveUntil(
            RouteName.homeNavBar,
            (route) => false,
            arguments: 1,
          );
          navigator.push(
            MaterialPageRoute(
              builder: (_) => TranscriptDetailScreen(
                fileId: fileId,
                autoTranscribeOnArrival: _autoTranscribe,
              ),
            ),
          );
        } else {
          if (!mounted) return;
          setState(() => _saving = false);
          final err = s.items.isNotEmpty ? s.items.first.errorMessage : null;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(err ?? 'Upload failed')),
          );
        }
      }
    };
    final sub = uploadCubit.stream.listen((_) => listener());

    await uploadCubit.startBatchUpload(
      token: token,
      autoTranscribe: _autoTranscribe,
    );

    // Fire once after the future completes in case allDone fired before
    // the listener was attached.
    listener();
    // Make sure the listener isn't kept indefinitely.
    Future.delayed(const Duration(seconds: 60), () => sub.cancel());
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: mediaQuery.viewInsets.bottom,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        constraints: BoxConstraints(
          maxHeight: mediaQuery.size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCompleteCard(),
                    16.verticalSpace,
                    _buildLabeledField(
                      label: 'Recording name',
                      child: _buildTextField(
                        controller: _nameController,
                        hint: 'Enter recording name',
                      ),
                    ),
                    16.verticalSpace,
                    _buildLabeledField(
                      label: 'Description',
                      optional: true,
                      child: _buildTextField(
                        controller: _descriptionController,
                        hint: 'Add notes about this recording...',
                        maxLines: 2,
                      ),
                    ),
                    16.verticalSpace,
                    _buildLabeledField(
                      label: 'Tags',
                      optional: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField(
                            controller: _tagsController,
                            hint: 'meeting, work, important (comma-separated)',
                          ),
                          4.verticalSpace,
                          Text(
                            'Separate tags with commas (e.g., meeting, work, important)',
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 11.sp,
                              color: const Color(0xff6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    16.verticalSpace,
                    _buildSaveLocationButton(),
                    16.verticalSpace,
                    _buildProcessingOptions(),
                  ],
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xffE5E7EB)),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Save Recording',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
              color: const Color(0xff111827),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompleteCard() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xffF9FAFB),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: const Color(0xffDBEAFE),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.visibility_rounded,
              size: 18.sp,
              color: const Color(0xff2563EB),
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recording Complete',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    color: const Color(0xff111827),
                  ),
                ),
                2.verticalSpace,
                Text(
                  '${_formatDuration(widget.duration)} • ${_formatSize(widget.sizeBytes)}',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    color: const Color(0xff6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledField({
    required String label,
    bool optional = false,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
                color: const Color(0xff374151),
              ),
            ),
            if (optional) ...[
              4.horizontalSpace,
              Text(
                '(optional)',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  color: const Color(0xff9CA3AF),
                ),
              ),
            ],
          ],
        ),
        8.verticalSpace,
        child,
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
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
        fillColor: const Color(0xffF9FAFB),
        contentPadding:
            EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Color(0xffE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Color(0xffE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide:
              const BorderSide(color: Color(0xff3B82F6), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildSaveLocationButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xffF9FAFB),
        border: Border.all(color: const Color(0xffE5E7EB)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(Icons.folder_outlined,
              size: 18.sp, color: const Color(0xff9CA3AF)),
          8.horizontalSpace,
          Text(
            'Save to Recordings',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
              color: const Color(0xff374151),
            ),
          ),
          const Spacer(),
          Icon(Icons.keyboard_arrow_down_rounded,
              size: 18.sp, color: const Color(0xff9CA3AF)),
        ],
      ),
    );
  }

  Widget _buildProcessingOptions() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffE5E7EB)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.settings_outlined,
                  size: 18.sp, color: const Color(0xff4B5563)),
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
            value: _autoTranscribe,
            onChanged: (v) => setState(() => _autoTranscribe = v),
          ),
          10.verticalSpace,
          _buildOptionCheckCard(
            emoji: '👥',
            title: 'Speaker Identification',
            subtitle: 'Identify different speakers',
            value: _speakerIdentification,
            onChanged: (v) => setState(() => _speakerIdentification = v),
          ),
          14.verticalSpace,
          _buildAdvancedPlaceholder(),
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
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: value ? const Color(0xffEFF6FF) : Colors.white,
          border: Border.all(
            color: value
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
                      Flexible(
                        child: Text(
                          title,
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                            color: const Color(0xff111827),
                          ),
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

  Widget _buildAdvancedPlaceholder() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xffF9FAFB),
        border: Border.all(color: const Color(0xffE5E7EB)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(Icons.settings_outlined,
              size: 16.sp, color: const Color(0xff6B7280)),
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
          Icon(Icons.keyboard_arrow_down_rounded,
              size: 18.sp, color: const Color(0xff9CA3AF)),
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

  Widget _buildFooter() {
    return BlocBuilder<UploadCubit, UploadState>(
      builder: (context, uploadState) {
        final isBusy = _saving || uploadState.isBusy;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xffE5E7EB))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: isBusy ? null : () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp,
                    color: const Color(0xff374151),
                  ),
                ),
              ),
              8.horizontalSpace,
              GestureDetector(
                onTap: isBusy ? null : _onSave,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: isBusy ? 0.6 : 1.0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 18.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: const Color(0xff2563EB),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isBusy) ...[
                          SizedBox(
                            width: 14.w,
                            height: 14.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          8.horizontalSpace,
                        ],
                        Text(
                          isBusy ? 'Saving…' : 'Save and Process',
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 13.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
