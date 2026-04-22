import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_ink/config/utilities/extensions/user_extension.dart';
import 'package:voice_ink/features/files/presentation/cubit/transcript_details/transcript_detail_cubit.dart';
import 'package:voice_ink/features/files/presentation/cubit/transcript_details/transcript_detail_state.dart';
import 'package:voice_ink/features/files/presentation/widget/analysis_tab_widget.dart';
import 'package:voice_ink/features/files/presentation/widget/editor_tab_widget.dart';
import 'package:voice_ink/features/files/presentation/widget/transcript_tab_widget.dart';
import 'package:voice_ink/features/files/presentation/widget/waveform_player_widget.dart';


class TranscriptDetailScreen extends StatefulWidget {
  final String fileId;

  const TranscriptDetailScreen({
    super.key,
    required this.fileId,
  });

  @override
  State<TranscriptDetailScreen> createState() => _TranscriptDetailScreenState();
}

class _TranscriptDetailScreenState extends State<TranscriptDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TranscriptDetailCubit>().loadFileDetail(
            fileId: widget.fileId,
            token: context.token,
          );
    });
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      context.read<TranscriptDetailCubit>().setSelectedTab(_tabController.index);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TranscriptDetailCubit, TranscriptDetailState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == TranscriptDetailStatus.failure,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(state.errorMessage ?? 'Something went wrong'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        );
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF9FAFB),
          body: SafeArea(
            child: _buildBody(context, state),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, TranscriptDetailState state) {
    if (state.status == TranscriptDetailStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == TranscriptDetailStatus.failure) {
      return _buildErrorState(context, state);
    }

    return Column(
      children: [
        // Header with file info and waveform
        _buildHeader(context, state),
        // Tab bar
        _buildTabBar(context),
        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              TranscriptTabWidget(),
              EditorTabWidget(),
              AnalysisTabWidget(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, TranscriptDetailState state) {
    final fileDetail = state.fileDetail;

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top bar with back button and title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20.sp,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileDetail.name ?? 'Transcript',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E222B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 12.sp,
                            color: Colors.grey.shade500,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            fileDetail.formattedDate,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Icon(
                            Icons.access_time,
                            size: 12.sp,
                            color: Colors.grey.shade500,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            fileDetail.formattedDuration,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Menu button
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.grey.shade700,
                  ),
                  onSelected: (value) => _handleMenuAction(context, value),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'share',
                      child: Row(
                        children: [
                          Icon(Icons.share_outlined, size: 20),
                          SizedBox(width: 12),
                          Text('Share'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'download',
                      child: Row(
                        children: [
                          Icon(Icons.download_outlined, size: 20),
                          SizedBox(width: 12),
                          Text('Download'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 20, color: Colors.red),
                          SizedBox(width: 12),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Waveform player card
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: _buildWaveformCard(context, state),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveformCard(BuildContext context, TranscriptDetailState state) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEEF2FF), Color(0xFFE0E7FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFDBE4FF)),
      ),
      child: Row(
        children: [
          // Play/Pause button
          _buildPlayButton(context, state),
          SizedBox(width: 12.w),
          // Waveform
          Expanded(
            child: _buildWaveform(context, state),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context, TranscriptDetailState state) {
    final isLoading = state.audioStatus == AudioPlayerStatus.loading;
    final isPlaying = state.isPlaying;

    return GestureDetector(
      onTap: state.isAudioReady
          ? () => context.read<TranscriptDetailCubit>().togglePlayPause()
          : null,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: const BoxDecoration(
          color: Color(0xFF4A59FE),
          shape: BoxShape.circle,
        ),
        child: isLoading
            ? Padding(
                padding: EdgeInsets.all(10.w),
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 24.sp,
              ),
      ),
    );
  }

  Widget _buildWaveform(BuildContext context, TranscriptDetailState state) {
    if (state.isLoadingWaveform || state.waveformData.isEmpty) {
      return SizedBox(
        height: 40.h,
        child: Center(
          child: LinearProgressIndicator(
            backgroundColor: Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4A59FE)),
          ),
        ),
      );
    }

    return GestureDetector(
      onTapDown: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final localPosition = box.globalToLocal(details.globalPosition);
        final progress = (localPosition.dx - 52.w) / (box.size.width - 52.w);
        context.read<TranscriptDetailCubit>().seekToProgress(progress.clamp(0, 1));
      },
      onHorizontalDragUpdate: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final localPosition = box.globalToLocal(details.globalPosition);
        final progress = (localPosition.dx - 52.w) / (box.size.width - 52.w);
        context.read<TranscriptDetailCubit>().seekToProgress(progress.clamp(0, 1));
      },
      child: SizedBox(
        height: 40.h,
        child: CustomPaint(
          size: Size(double.infinity, 40.h),
          painter: _CompactWaveformPainter(
            waveformData: state.waveformData,
            progress: state.playbackProgress,
            activeColor: const Color(0xFF4A59FE),
            inactiveColor: const Color(0xFFCBD5E1),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF4A59FE),
          unselectedLabelColor: Colors.grey.shade600,
          indicatorColor: const Color(0xFF4A59FE),
          indicatorWeight: 2,
          labelStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.description_outlined, size: 16.sp),
                  SizedBox(width: 6.w),
                  const Text('Transcript'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_outlined, size: 16.sp),
                  SizedBox(width: 6.w),
                  const Text('Editor'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bar_chart_outlined, size: 16.sp),
                  SizedBox(width: 6.w),
                  const Text('Analysis'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, TranscriptDetailState state) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: Colors.red.shade300,
            ),
            SizedBox(height: 16.h),
            Text(
              'Failed to load transcript',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              state.errorMessage ?? 'Unknown error',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () {
                context.read<TranscriptDetailCubit>().loadFileDetail(
                      fileId: widget.fileId,
                      token: context.token,
                    );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A59FE),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'share':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.white),
                SizedBox(width: 8.w),
                const Text('Share coming soon'),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        );
        break;
      case 'download':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.white),
                SizedBox(width: 8.w),
                const Text('Download coming soon'),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(context);
        break;
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Transcript'),
          content: const Text(
            'Are you sure you want to delete this transcript? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

// Compact waveform painter for header
class _CompactWaveformPainter extends CustomPainter {
  final List<double> waveformData;
  final double progress;
  final Color activeColor;
  final Color inactiveColor;

  _CompactWaveformPainter({
    required this.waveformData,
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (waveformData.isEmpty) return;

    final barWidth = size.width / waveformData.length;
    final barSpacing = barWidth * 0.3;
    final effectiveBarWidth = barWidth - barSpacing;
    final maxBarHeight = size.height * 0.8;
    final centerY = size.height / 2;

    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.fill;

    final inactivePaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.fill;

    for (int i = 0; i < waveformData.length; i++) {
      final x = i * barWidth + barSpacing / 2;
      final barHeight = waveformData[i] * maxBarHeight;
      final isActive = (i / waveformData.length) <= progress;

      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x + effectiveBarWidth / 2, centerY),
          width: effectiveBarWidth.clamp(2, 4),
          height: barHeight.clamp(4, maxBarHeight),
        ),
        Radius.circular(effectiveBarWidth / 2),
      );

      canvas.drawRRect(rect, isActive ? activePaint : inactivePaint);
    }

    // Draw cursor line
    if (progress > 0 && progress < 1) {
      final cursorX = size.width * progress;
      final cursorPaint = Paint()
        ..color = activeColor
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(cursorX, centerY),
            width: 2,
            height: size.height,
          ),
          const Radius.circular(1),
        ),
        cursorPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CompactWaveformPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.waveformData != waveformData;
  }
}