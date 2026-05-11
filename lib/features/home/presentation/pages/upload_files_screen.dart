// lib/features/home/presentation/pages/upload_files_screen.dart

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';
import 'package:voice_ink/config/navigation/route_name.dart';
import 'package:voice_ink/config/utilities/extensions/user_extension.dart';
import 'package:voice_ink/features/files/presentation/cubit/files_cubit.dart';
import 'package:voice_ink/features/files/presentation/pages/transcript_detail_screen.dart';
import 'package:voice_ink/features/upload/domain/entities/upload_entity.dart';
import 'package:voice_ink/features/upload/presentation/cubit/upload_cubit.dart';
import 'package:voice_ink/features/upload/presentation/cubit/upload_state.dart';

class AdvancedFeature {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final Color iconColor;
  final Color bgColor;
  bool isSelected;

  AdvancedFeature({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    this.isSelected = false,
  });
}

String _mimeFromExtension(String? ext) {
  switch (ext?.toLowerCase()) {
    case 'mp3':
      return 'audio/mpeg';
    case 'wav':
      return 'audio/wav';
    case 'm4a':
      return 'audio/mp4';
    case 'mp4':
      return 'video/mp4';
    case 'mov':
      return 'video/quicktime';
    case 'avi':
      return 'video/x-msvideo';
    default:
      return 'application/octet-stream';
  }
}

class UploadFilesScreen extends StatefulWidget {
  const UploadFilesScreen({super.key});

  @override
  State<UploadFilesScreen> createState() => _UploadFilesScreenState();
}

class _UploadFilesScreenState extends State<UploadFilesScreen> {
  bool _autoTranscription = false;
  bool _advancedFeaturesExpanded = true;
  bool _hasHandledCompletion = false;

  final List<AdvancedFeature> _features = [
    AdvancedFeature(
      id: 'speaker',
      title: 'Speaker Identification',
      subtitle: 'Detect different speakers',
      icon: AppAssets.sparkle,
      iconColor: const Color(0xff404040),
      bgColor: const Color(0xffF2F2F7),
    ),
    AdvancedFeature(
      id: 'entity',
      title: 'Entity Detection',
      subtitle: 'Identify names, places, dates',
      icon: AppAssets.tag,
      iconColor: const Color(0xff4A59FE),
      bgColor: const Color(0xffECF4FE),
      isSelected: true,
    ),
    AdvancedFeature(
      id: 'chapters',
      title: 'Auto Chapters',
      subtitle: 'Segment content by topic',
      icon: AppAssets.taskList,
      iconColor: const Color(0xff404040),
      bgColor: const Color(0xffF2F2F7),
    ),
    AdvancedFeature(
      id: 'moderation',
      title: 'Content Moderation',
      subtitle: 'Flag sensitive content',
      icon: AppAssets.shield,
      iconColor: const Color(0xff404040),
      bgColor: const Color(0xffF2F2F7),
    ),
    AdvancedFeature(
      id: 'sentiment',
      title: 'Sentiment Analysis',
      subtitle: 'Detect emotional tone',
      icon: AppAssets.emoji,
      iconColor: const Color(0xff404040),
      bgColor: const Color(0xffF2F2F7),
    ),
    AdvancedFeature(
      id: 'topic',
      title: 'Topic Detection',
      subtitle: 'Extract main topics',
      icon: AppAssets.chat,
      iconColor: const Color(0xff404040),
      bgColor: const Color(0xffF2F2F7),
    ),
    AdvancedFeature(
      id: 'summary',
      title: 'Summarization',
      subtitle: 'Generate concise summary',
      icon: AppAssets.scratchpadGrey,
      iconColor: const Color(0xff404040),
      bgColor: const Color(0xffF2F2F7),
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UploadCubit>().reset();
    });
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a', 'mp4', 'mov', 'avi'],
      allowMultiple: true,
      withReadStream: false,
    );
    if (result == null || result.files.isEmpty || !mounted) return;

    final items = <UploadItem>[];
    for (final f in result.files) {
      if (f.path == null) continue;
      items.add(UploadItem(
        localId: '${DateTime.now().microsecondsSinceEpoch}-${f.name}',
        name: f.name,
        size: f.size,
        localPath: f.path!,
        contentType: _mimeFromExtension(f.extension),
      ));
    }
    if (items.isEmpty) return;

    final uploadCubit = context.read<UploadCubit>();
    uploadCubit.addFiles(items);
    _hasHandledCompletion = false;
    await uploadCubit.startBatchUpload(
      token: context.token,
      autoTranscribe: _autoTranscription,
    );
  }

  void _onUploadComplete() {
    if (_hasHandledCompletion || !mounted) return;
    _hasHandledCompletion = true;

    // Pick the first successfully uploaded file to open in detail.
    final uploadState = context.read<UploadCubit>().state;
    final firstDone = uploadState.items.firstWhere(
      (i) => i.stage == UploadStage.done && i.fileId != null,
      orElse: () => uploadState.items.isNotEmpty
          ? uploadState.items.first
          : const UploadItem(
              localId: '',
              name: '',
              size: 0,
              localPath: '',
              contentType: '',
            ),
    );
    final fileId = firstDone.fileId;

    // Refresh the Files list so the new uploads show up immediately.
    context.read<FilesCubit>().refreshFiles();

    final navigator = Navigator.of(context);
    // Replace the stack with HomeNavbar on the Files tab; pressing back from
    // the detail screen lands the user on the Files tab.
    navigator.pushNamedAndRemoveUntil(
      RouteName.homeNavBar,
      (route) => false,
      arguments: 1,
    );
    if (fileId == null || fileId.isEmpty) return;
    navigator.push(
      MaterialPageRoute(
        builder: (_) => TranscriptDetailScreen(
          fileId: fileId,
          autoTranscribeOnArrival: _autoTranscription,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadCubit, UploadState>(
      listenWhen: (prev, curr) => !prev.allDone && curr.allDone,
      listener: (context, state) => _onUploadComplete(),
      child: Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SizedBox(
                height: 54.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
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
                    ),
                    Text(
                      'Upload files',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 17.sp,
                        height: 22 / 17,
                        letterSpacing: -0.43,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    8.verticalSpace,
                    _buildUploadArea(),
                    22.verticalSpace,
                    BlocBuilder<UploadCubit, UploadState>(
                      buildWhen: (prev, curr) =>
                          prev.hasItems != curr.hasItems,
                      builder: (context, state) {
                        if (!state.hasItems) return const SizedBox.shrink();
                        return Padding(
                          padding: EdgeInsets.only(bottom: 22.h),
                          child: _buildFileProgressList(),
                        );
                      },
                    ),
                    _buildTranscriptionCard(),
                    32.verticalSpace,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildUploadArea() {
    return GestureDetector(
      onTap: _pickFiles,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 68.w, vertical: 24.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromRGBO(120, 120, 120, 0.2),
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: const Color(0xffECF4FE),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.cloudUpload,
                  width: 24.w,
                  height: 24.h,
                  colorFilter: const ColorFilter.mode(
                    Color(0xff4A59FE),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            8.verticalSpace,
            Text(
              'Tap to browse',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600,
                fontSize: 17.sp,
                height: 22 / 17,
                letterSpacing: -0.43,
                color: const Color(0xff000000),
              ),
            ),
            2.verticalSpace,
            Text(
              'Audio & Video supported (Max 10 files)',
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
    );
  }

  Widget _buildFileProgressList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Text(
            'File Progress',
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
        BlocBuilder<UploadCubit, UploadState>(
          builder: (context, state) {
            return Column(
              children: List.generate(state.items.length, (index) {
                final item = state.items[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < state.items.length - 1 ? 12.h : 0,
                  ),
                  child: _buildFileProgressItem(item),
                );
              }),
            );
          },
        ),
      ],
    );
  }

  String _itemStatusLabel(UploadItem item) {
    switch (item.stage) {
      case UploadStage.pending:
        return 'Pending';
      case UploadStage.presigning:
        return 'Preparing…';
      case UploadStage.uploading:
        return '${(item.progress * 100).toInt()}%';
      case UploadStage.completing:
        return 'Finalizing…';
      case UploadStage.done:
        return 'Done';
      case UploadStage.failed:
        return 'Failed';
    }
  }

  Color _itemStatusColor(UploadItem item) {
    switch (item.stage) {
      case UploadStage.done:
        return const Color(0xff006400);
      case UploadStage.failed:
        return const Color(0xffFE4A4D);
      default:
        return const Color(0xff4A59FE);
    }
  }

  Widget _buildFileProgressItem(UploadItem item) {
    final isFailed = item.stage == UploadStage.failed;
    final isDone = item.stage == UploadStage.done;
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffF2F2F7)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: const Color(0xffECF4FE),
              border: Border.all(
                color: const Color(0xff4A59FE),
                width: 1.5,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                AppAssets.cloudUpload,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          height: 20 / 14,
                          color: const Color(0xff000000),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      _itemStatusLabel(item),
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        height: 20 / 14,
                        color: _itemStatusColor(item),
                      ),
                    ),
                  ],
                ),
                8.verticalSpace,
                Container(
                  height: 8.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xffF2F2F7),
                    borderRadius: BorderRadius.circular(9999.r),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: isDone ? 1.0 : item.progress.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isFailed
                            ? const Color(0xffFE4A4D)
                            : (isDone
                                ? const Color(0xff006400)
                                : const Color(0xff4A59FE)),
                        borderRadius: BorderRadius.circular(9999.r),
                      ),
                    ),
                  ),
                ),
                if (isFailed && item.errorMessage != null) ...[
                  6.verticalSpace,
                  Text(
                    item.errorMessage!,
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: const Color(0xffFE4A4D),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranscriptionCard() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffF2F2F7)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xffF2F2F7)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffECF4FE),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.sparkle,
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Auto Transcription',
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
                        'Start processing immediately',
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
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _autoTranscription = !_autoTranscription;
                    });
                  },
                  child: Container(
                    width: 64.w,
                    height: 28.h,
                    decoration: BoxDecoration(
                      color: _autoTranscription
                          ? const Color(0xff4A59FE)
                          : const Color(0xffE5E5EA),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      alignment: _autoTranscription
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: 24.w,
                        height: 24.h,
                        margin: EdgeInsets.symmetric(horizontal: 2.w),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_autoTranscription) ...[
            GestureDetector(
              onTap: () {
                setState(() {
                  _advancedFeaturesExpanded = !_advancedFeaturesExpanded;
                });
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ADVANCED FEATURES',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        height: 21 / 16,
                        letterSpacing: -0.31,
                        color: const Color.fromRGBO(60, 60, 67, 0.6),
                      ),
                    ),
                    AnimatedRotation(
                      turns: _advancedFeaturesExpanded ? 0 : 0.25,
                      duration: const Duration(milliseconds: 200),
                      child: SvgPicture.asset(
                        AppAssets.chevronDown,
                        width: 24.w,
                        height: 24.h,
                        colorFilter: const ColorFilter.mode(
                          Color(0xff04071E),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_advancedFeaturesExpanded)
              ...List.generate(_features.length, (index) {
                final feature = _features[index];
                return _buildFeatureTile(feature);
              }),
            if (_advancedFeaturesExpanded) 20.verticalSpace,
          ],
        ],
      ),
    );
  }

  Widget _buildFeatureTile(AdvancedFeature feature) {
    return GestureDetector(
      onTap: () {
        setState(() {
          feature.isSelected = !feature.isSelected;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: feature.isSelected
                    ? const Color(0xffECF4FE)
                    : feature.bgColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  feature.icon,
                  width: 24.w,
                  height: 24.h,
                  colorFilter: ColorFilter.mode(
                    feature.isSelected
                        ? const Color(0xff4A59FE)
                        : feature.iconColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            8.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        feature.title,
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          height: 21 / 16,
                          letterSpacing: -0.31,
                          color: const Color(0xff000000),
                        ),
                      ),
                      8.horizontalSpace,
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [Color(0xffA338FF), Color(0xff624DFB)],
                          ),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          'Pro',
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                            height: 21 / 16,
                            letterSpacing: -0.31,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  4.verticalSpace,
                  Text(
                    feature.subtitle,
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
            SvgPicture.asset(
              feature.isSelected
                  ? AppAssets.checkboxChecked
                  : AppAssets.checkboxUnchecked,
              width: 24.w,
              height: 24.h,
              colorFilter: ColorFilter.mode(
                feature.isSelected
                    ? const Color(0xff4A59FE)
                    : const Color(0xff8C8C8C),
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}