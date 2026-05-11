import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_ink/config/utilities/extensions/user_extension.dart';
import 'package:voice_ink/features/files/presentation/cubit/re_transcribe/re_transcribe_cubit.dart';
import 'package:voice_ink/features/files/presentation/cubit/re_transcribe/re_transcribe_state.dart';

class _Feature {
  final String name;
  final String description;
  final bool defaultOn;
  final bool isPro;
  final String flagKey;

  const _Feature({
    required this.name,
    required this.description,
    required this.defaultOn,
    required this.isPro,
    required this.flagKey,
  });
}

const List<_Feature> _features = [
  _Feature(
    name: 'Speaker identification',
    description: 'Identify different speakers in the conversation',
    defaultOn: true,
    isPro: false,
    flagKey: 'speakerLabels',
  ),
  _Feature(
    name: 'Sentiment analysis',
    description: 'Analyze emotional tone and sentiment',
    defaultOn: true,
    isPro: false,
    flagKey: 'sentimentAnalysis',
  ),
  _Feature(
    name: 'Entity detection',
    description: 'Extract names, places, organizations',
    defaultOn: true,
    isPro: false,
    flagKey: 'entityDetection',
  ),
  _Feature(
    name: 'Topic detection',
    description: 'Identify main topics and themes',
    defaultOn: true,
    isPro: false,
    flagKey: 'topicDetection',
  ),
  _Feature(
    name: 'Auto highlights',
    description: 'Automatically detect important moments',
    defaultOn: true,
    isPro: false,
    flagKey: 'autoHighlights',
  ),
  _Feature(
    name: 'Auto chapters',
    description: 'Automatically divide content into chapters',
    defaultOn: true,
    isPro: true,
    flagKey: 'autoChapters',
  ),
  _Feature(
    name: 'Content safety',
    description: 'Detect inappropriate content',
    defaultOn: true,
    isPro: true,
    flagKey: 'contentSafety',
  ),
  _Feature(
    name: 'Summarization',
    description: 'Generate automatic summaries',
    defaultOn: true,
    isPro: false,
    flagKey: 'summarization',
  ),
  _Feature(
    name: 'Profanity filter',
    description: 'Filter out inappropriate language',
    defaultOn: false,
    isPro: false,
    flagKey: 'filterProfanity',
  ),
];

class ReadyToTranscribeView extends StatefulWidget {
  final String fileId;
  final String? transcriptionStatus;

  const ReadyToTranscribeView({
    super.key,
    required this.fileId,
    required this.transcriptionStatus,
  });

  @override
  State<ReadyToTranscribeView> createState() => _ReadyToTranscribeViewState();
}

class _ReadyToTranscribeViewState extends State<ReadyToTranscribeView> {
  late Map<String, bool> _selected;

  @override
  void initState() {
    super.initState();
    _selected = {
      for (final f in _features) f.flagKey: f.defaultOn,
    };
  }

  int get _selectedCount => _selected.values.where((v) => v).length;

  bool _isProcessing(String? status) =>
      status == 'processing' || status == 'pending';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReTranscribeCubit, ReTranscribeState>(
      builder: (context, rtState) {
        final fileStatus = widget.transcriptionStatus;
        final isJobBusy = rtState.status == ReTranscribeStatus.triggering ||
            rtState.status == ReTranscribeStatus.polling;
        final showProcessing = isJobBusy || _isProcessing(fileStatus);

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              _buildHero(showProcessing: showProcessing),
              SizedBox(height: 24.h),
              if (showProcessing)
                _buildProcessingBanner(rtState)
              else
                _buildFeaturesCard(),
              SizedBox(height: 16.h),
              _buildProcessingTimeNote(),
              SizedBox(height: 20.h),
              _buildPrimaryButton(showProcessing: showProcessing),
              SizedBox(height: 12.h),
              Text(
                '💡 Tip: Audio will automatically sync with transcript timestamps once processing is complete',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHero({required bool showProcessing}) {
    return Column(
      children: [
        Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3B82F6), Color(0xFF4F46E5)],
            ),
          ),
          child: Icon(
            showProcessing ? Icons.hourglass_top : Icons.play_arrow,
            size: 28.sp,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          showProcessing ? 'Transcribing…' : 'Ready to Transcribe',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
            letterSpacing: -0.4,
          ),
        ),
        SizedBox(height: 6.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            showProcessing
                ? 'Transcription is running. You\'ll see the result here when it\'s ready.'
                : 'Configure your transcription settings below. Select the AI-powered features you need for this recording.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF6B7280),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEFF6FF), Color(0xFFEEF2FF)],
              ),
              border: const Border(
                bottom: BorderSide(color: Color(0xFFE5E7EB)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transcription Features',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '$_selectedCount of ${_features.length} features selected',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    _legendDot(
                      const Color(0xFF10B981),
                      'Included',
                    ),
                    SizedBox(width: 12.w),
                    _legendDot(
                      const Color(0xFFA855F7),
                      'Premium',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              children: _features
                  .map((f) => Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: _buildFeatureRow(f),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureRow(_Feature feature) {
    final isOn = _selected[feature.flagKey] ?? false;
    return GestureDetector(
      onTap: () =>
          setState(() => _selected[feature.flagKey] = !isOn),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isOn
              ? const Color(0xFF4A59FE).withValues(alpha: 0.05)
              : Colors.white,
          border: Border.all(
            color: isOn ? const Color(0xFF4A59FE) : const Color(0xFFE5E7EB),
            width: isOn ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 18.w,
              height: 18.w,
              decoration: BoxDecoration(
                color: isOn ? const Color(0xFF4A59FE) : Colors.transparent,
                border: Border.all(
                  color:
                      isOn ? const Color(0xFF4A59FE) : const Color(0xFF9CA3AF),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: isOn
                  ? Icon(Icons.check, size: 12.sp, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          feature.name,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF111827),
                          ),
                        ),
                      ),
                      if (feature.isPro) ...[
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFA855F7),
                                Color(0xFF6366F1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            'Pro',
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    feature.description,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFF6B7280),
                      height: 1.35,
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

  Widget _buildProcessingTimeNote() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        border: Border.all(color: const Color(0xFFFDE68A)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('⏱️', style: TextStyle(fontSize: 18.sp)),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Processing Time',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF92400E),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Transcription typically takes 1-3 minutes for most recordings. You\'ll receive a notification when it\'s complete, and you can continue using the app while processing runs in the background.',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF92400E),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingBanner(ReTranscribeState rtState) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        border: Border.all(color: const Color(0xFFBFDBFE)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24.w,
            height: 24.w,
            child: const CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Color(0xFF2563EB),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              rtState.status == ReTranscribeStatus.triggering
                  ? 'Starting transcription…'
                  : 'Processing your audio. This may take a moment.',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF1E40AF),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton({required bool showProcessing}) {
    final disabled = showProcessing;
    return GestureDetector(
      onTap: disabled ? null : _start,
      child: Opacity(
        opacity: disabled ? 0.6 : 1,
        child: Container(
          height: 48.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            gradient: const LinearGradient(
              colors: [Color(0xFF2563EB), Color(0xFF4F46E5)],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.play_arrow, size: 18.sp, color: Colors.white),
              SizedBox(width: 6.w),
              Text(
                showProcessing ? 'Transcribing…' : 'Start Transcription',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _start() {
    final cubit = context.read<ReTranscribeCubit>();
    cubit.reTranscribe(
      fileId: widget.fileId,
      provider: 'assemblyai',
      engineDisplayName: 'Precision',
      token: context.token,
      speakerLabels: _selected['speakerLabels'] ?? false,
      sentimentAnalysis: _selected['sentimentAnalysis'] ?? false,
      entityDetection: _selected['entityDetection'] ?? false,
      topicDetection: _selected['topicDetection'] ?? false,
      autoHighlights: _selected['autoHighlights'] ?? false,
      contentSafety: _selected['contentSafety'] ?? false,
      summarization: _selected['summarization'] ?? false,
      autoChapters: _selected['autoChapters'] ?? false,
      filterProfanity: _selected['filterProfanity'] ?? false,
    );
  }
}

/// Helper used by transcript_tab_widget to decide which view to render.
bool isTranscriptionReadyToView(String? status) =>
    status == 'completed';

/// Returns true while a transcription is being initiated or running.
bool isTranscriptionInProgress(
  ReTranscribeStatus jobStatus,
  String? fileStatus,
) {
  if (jobStatus == ReTranscribeStatus.triggering ||
      jobStatus == ReTranscribeStatus.polling) {
    return true;
  }
  return fileStatus == 'processing' || fileStatus == 'pending';
}
