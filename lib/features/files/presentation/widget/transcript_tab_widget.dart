import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:voice_ink/config/const/app/app_assets.dart';
import 'package:voice_ink/features/files/domain/entities/transcript_detail_entities.dart';
import 'package:voice_ink/features/files/presentation/cubit/transcript_details/transcript_detail_cubit.dart';
import 'package:voice_ink/features/files/presentation/cubit/transcript_details/transcript_detail_state.dart';

/// Transcript Tab - Matches Figma design
/// Info card with stats + Export/Re-transcribe buttons
/// Transcript card with utterances (avatar, speaker name, timestamp, text)
class TranscriptTabWidget extends StatelessWidget {
  const TranscriptTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TranscriptDetailCubit, TranscriptDetailState>(
      builder: (context, state) {
        final transcriptionResult = state.fileDetail.transcriptionResult;
        final utterances = state.utterances;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              // Info Card
              _buildInfoCard(context, transcriptionResult),
              SizedBox(height: 32.h),
              // Transcript Card
              _buildTranscriptCard(context, state, utterances),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    TranscriptionResultEntities? result,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFF2F2F7)),
      ),
      child: Column(
        children: [
          // Stats row (wrapping)
          Column(
            crossAxisAlignment: .start,
            children: [
              // Engine chip
              Row(
                children: [
                  _buildStatChip(
                    icon: AppAssets.target,
                    iconColor: const Color(0xFF4A59FE),
                    text: 'Engine: ${result?.provider ?? 'Precision'}',
                  ),
                  8.horizontalSpace,
                  // Confidence chip
                  _buildStatChip(
                    icon: AppAssets.checkmarkRound,
                    iconColor: const Color(0x993C3C43),
                    text: '${result?.confidencePercent ?? '0%'} Confidence',
                  ),
                ],
              ),
              8.verticalSpace,
              // Words chip
              _buildStatChip(
                icon: AppAssets.documentText,
                iconColor: const Color(0x993C3C43),
                text: '${result?.wordCount ?? 0} Words',
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Divider
          Container(height: 1, color: const Color(0xFFF2F2F7)),
          SizedBox(height: 16.h),
          // Buttons row
          Row(
            children: [
              // Export button (blue filled)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Export coming soon'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A59FE),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon(
                        //   Icons.file_upload_outlined,
                        //   size: 20.sp,
                        //   color: Colors.white,
                        // ),
                        SvgPicture.asset(
                          AppAssets.arrowExport,
                          width: 20.w,
                          height: 20.h,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),

                        SizedBox(width: 4.w),
                        Text(
                          'Export Transcript',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: -0.23,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              // Re-transcribe button (gray with blue text)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Re-transcribe coming soon'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F7),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppAssets.arrowReset,
                          width: 20.w,
                          height: 20.h,
                          colorFilter: const ColorFilter.mode(
                            const Color(0xFF4A59FE),
                            BlendMode.srcIn,
                          ),
                        ),

                        SizedBox(width: 4.w),
                        Text(
                          'Re-transcribe',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4A59FE),
                            letterSpacing: -0.23,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required String icon,
    required Color iconColor,
    required String text,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            width: 16.w,
            height: 16.h,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0x993C3C43),
              letterSpacing: -0.23,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranscriptCard(
    BuildContext context,
    TranscriptDetailState state,
    List<UtteranceEntities> utterances,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFF2F2F7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TRANSCRIPT',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF404040),
                        letterSpacing: -0.43,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Audio automatically follows transcript timestamps',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF999999),
                        letterSpacing: -0.31,
                        height: 1.31,
                      ),
                    ),
                  ],
                ),
              ),
              // AI Chat button
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('AI Chat coming soon'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E222B),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppAssets.chat,
                        width: 16.w,
                        height: 16.h,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'AI CHAT',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: -0.23,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Utterances
          if (utterances.isEmpty)
            _buildEmptyState()
          else
            ...utterances.asMap().entries.map((entry) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: _UtteranceBlock(
                  utterance: entry.value,
                  utteranceIndex: entry.key,
                  state: state,
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.all(32.w),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.text_snippet_outlined,
              size: 48.sp,
              color: const Color(0xFF999999),
            ),
            SizedBox(height: 12.h),
            Text(
              'No transcript available',
              style: TextStyle(fontSize: 16.sp, color: const Color(0xFF999999)),
            ),
          ],
        ),
      ),
    );
  }
}

class _UtteranceBlock extends StatelessWidget {
  final UtteranceEntities utterance;
  final int utteranceIndex;
  final TranscriptDetailState state;

  const _UtteranceBlock({
    required this.utterance,
    required this.utteranceIndex,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = _isActiveUtterance();
    final speaker = utterance.speaker ?? 'A';
    final speakerNumber = speaker.codeUnitAt(0) - 'A'.codeUnitAt(0) + 1;

    return GestureDetector(
      onTap: () {
        // Seek to start of this utterance
        if (utterance.start != null) {
          context.read<TranscriptDetailCubit>().seekToMilliseconds(
            utterance.start!,
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F9FB),
            borderRadius: BorderRadius.circular(10.r),
            border: isActive
                ? Border.all(color: const Color(0xFF4A59FE), width: 1.5)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Avatar + Speaker Name | Timestamp
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Avatar + Speaker
                  Row(
                    children: [
                      _buildAvatar(speaker),
                      SizedBox(width: 8.w),
                      Text(
                        'Speaker $speakerNumber',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF333333),
                          letterSpacing: -0.31,
                        ),
                      ),
                    ],
                  ),
                  // Timestamp
                  Text(
                    utterance.formattedStart,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF999999),
                      letterSpacing: -0.31,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              // Text content
              Text(
                utterance.text ?? '',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF333333),
                  letterSpacing: -0.31,
                  height: 1.31,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isActiveUtterance() {
    final currentMs = state.currentPosition.inMilliseconds;
    return utterance.start != null &&
        utterance.end != null &&
        currentMs >= utterance.start! &&
        currentMs <= utterance.end!;
  }

  Widget _buildAvatar(String speaker) {
    // Get avatar image based on speaker
    // For now, using colored circle with letter
    final color = _getSpeakerColor(speaker);

    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Center(
        child: Text(
          speaker,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Color _getSpeakerColor(String speaker) {
    final colors = [
      const Color(0xFF4A59FE), // Blue
      const Color(0xFF10B981), // Green
      const Color(0xFFF59E0B), // Orange
      const Color(0xFFEF4444), // Red
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFF06B6D4), // Cyan
    ];

    final index = speaker.codeUnitAt(0) - 'A'.codeUnitAt(0);
    return colors[index.abs() % colors.length];
  }
}
