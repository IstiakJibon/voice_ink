import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_ink/features/files/domain/entities/transcript_detail_entities.dart';
import 'package:voice_ink/features/files/presentation/cubit/transcript_details/transcript_detail_cubit.dart';
import 'package:voice_ink/features/files/presentation/cubit/transcript_details/transcript_detail_state.dart';

class AnalysisTabWidget extends StatelessWidget {
  const AnalysisTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TranscriptDetailCubit, TranscriptDetailState>(
      builder: (context, state) {
        final transcriptionResult = state.fileDetail.transcriptionResult;
        final fileDetail = state.fileDetail;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats overview
              _buildStatsSection(context, state),
              SizedBox(height: 24.h),
              // Transcription info
              _buildTranscriptionInfoSection(context, state),
              SizedBox(height: 24.h),
              // AI Features section
              _buildAIFeaturesSection(context, transcriptionResult),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsSection(BuildContext context, TranscriptDetailState state) {
    final fileDetail = state.fileDetail;
    final result = fileDetail.transcriptionResult;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.timer_outlined,
                label: 'Duration',
                value: fileDetail.formattedDuration,
                color: const Color(0xFF4A59FE),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _StatCard(
                icon: Icons.text_fields_outlined,
                label: 'Words',
                value: '${result?.wordCount ?? 0}',
                color: const Color(0xFF10B981),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.check_circle_outline,
                label: 'Confidence',
                value: result?.confidencePercent ?? '0%',
                color: const Color(0xFFF59E0B),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _StatCard(
                icon: Icons.people_outline,
                label: 'Speakers',
                value: '${result?.speakers.length ?? 0}',
                color: const Color(0xFF8B5CF6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTranscriptionInfoSection(
      BuildContext context, TranscriptDetailState state) {
    final fileDetail = state.fileDetail;
    final result = fileDetail.transcriptionResult;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transcription Details',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: 16.h),
          _InfoRow(
            label: 'Provider',
            value: result?.provider?.toUpperCase() ?? 'Unknown',
          ),
          _InfoRow(
            label: 'File Name',
            value: fileDetail.name ?? 'Unknown',
          ),
          _InfoRow(
            label: 'File Size',
            value: fileDetail.formattedSize,
          ),
          _InfoRow(
            label: 'Format',
            value: fileDetail.mimetype ?? 'Unknown',
          ),
          _InfoRow(
            label: 'Uploaded',
            value: fileDetail.formattedDateTime,
          ),
          _InfoRow(
            label: 'Status',
            value: fileDetail.transcriptionStatus ?? 'Unknown',
            valueColor: fileDetail.isTranscriptionCompleted
                ? Colors.green
                : Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildAIFeaturesSection(
    BuildContext context,
    TranscriptionResultEntities? result,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI Analysis',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        SizedBox(height: 12.h),
        // Summary
        _AIFeatureCard(
          icon: Icons.summarize_outlined,
          title: 'Summary',
          content: result?.summary,
          placeholder: 'AI summary will appear here when available',
          color: const Color(0xFF4A59FE),
        ),
        SizedBox(height: 12.h),
        // Chapters
        _AIFeatureCard(
          icon: Icons.bookmark_outline,
          title: 'Chapters',
          content: result?.chapters != null
              ? _formatChapters(result?.chapters)
              : null,
          placeholder: 'Chapter markers will appear here when available',
          color: const Color(0xFF10B981),
        ),
        SizedBox(height: 12.h),
        // Key Points
        _AIFeatureCard(
          icon: Icons.lightbulb_outline,
          title: 'Key Points',
          content: result?.keyPoints != null
              ? _formatList(result?.keyPoints)
              : null,
          placeholder: 'Key points will appear here when available',
          color: const Color(0xFFF59E0B),
        ),
        SizedBox(height: 12.h),
        // Action Items
        _AIFeatureCard(
          icon: Icons.checklist_outlined,
          title: 'Action Items',
          content: result?.actionItems != null && result!.actionItems!.isNotEmpty
              ? _formatList(result.actionItems)
              : null,
          placeholder: 'Action items will appear here when available',
          color: const Color(0xFFEF4444),
        ),
        SizedBox(height: 12.h),
        // Sentiment
        _AIFeatureCard(
          icon: Icons.emoji_emotions_outlined,
          title: 'Sentiment Analysis',
          content: result?.sentiment != null
              ? result?.sentiment.toString()
              : null,
          placeholder: 'Sentiment analysis will appear here when available',
          color: const Color(0xFF8B5CF6),
        ),
        SizedBox(height: 12.h),
        // Entities
        _AIFeatureCard(
          icon: Icons.tag_outlined,
          title: 'Detected Entities',
          content: result?.entities != null
              ? _formatEntities(result?.entities)
              : null,
          placeholder: 'Named entities will appear here when available',
          color: const Color(0xFF06B6D4),
        ),
      ],
    );
  }

  String? _formatChapters(dynamic chapters) {
    if (chapters == null) return null;
    if (chapters is List) {
      return chapters.map((c) => '• ${c['headline'] ?? c}').join('\n');
    }
    return chapters.toString();
  }

  String? _formatList(List<dynamic>? items) {
    if (items == null || items.isEmpty) return null;
    return items.map((item) => '• $item').join('\n');
  }

  String? _formatEntities(dynamic entities) {
    if (entities == null) return null;
    if (entities is List) {
      return entities.map((e) => '• ${e['text'] ?? e}').join('\n');
    }
    if (entities is Map) {
      return entities.entries
          .map((e) => '${e.key}: ${e.value}')
          .join('\n');
    }
    return entities.toString();
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20.sp, color: color),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: valueColor ?? Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AIFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? content;
  final String placeholder;
  final Color color;

  const _AIFeatureCard({
    required this.icon,
    required this.title,
    required this.content,
    required this.placeholder,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final hasContent = content != null && content!.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: hasContent ? color.withOpacity(0.3) : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, size: 18.sp, color: color),
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              const Spacer(),
              if (!hasContent)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'Coming Soon',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            hasContent ? content! : placeholder,
            style: TextStyle(
              fontSize: 13.sp,
              color: hasContent ? Colors.grey.shade700 : Colors.grey.shade400,
              fontStyle: hasContent ? FontStyle.normal : FontStyle.italic,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
