import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_ink/features/files/presentation/cubit/transcript_details/transcript_detail_cubit.dart';
import 'package:voice_ink/features/files/presentation/cubit/transcript_details/transcript_detail_state.dart';

class WaveformPlayerWidget extends StatelessWidget {
  const WaveformPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TranscriptDetailCubit, TranscriptDetailState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.05),
                Theme.of(context).primaryColor.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Waveform
              _buildWaveform(context, state),
              SizedBox(height: 12.h),
              // Controls
              _buildControls(context, state),
              SizedBox(height: 8.h),
              // Time display
              _buildTimeDisplay(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWaveform(BuildContext context, TranscriptDetailState state) {
    if (state.isLoadingWaveform) {
      return SizedBox(
        height: 60.h,
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (state.waveformData.isEmpty) {
      return SizedBox(
        height: 60.h,
        child: Center(
          child: Text(
            'Loading audio...',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTapDown: (details) => _onWaveformTap(context, details, state),
      onHorizontalDragUpdate: (details) =>
          _onWaveformDrag(context, details, state),
      child: SizedBox(
        height: 60.h,
        child: CustomPaint(
          size: Size(double.infinity, 60.h),
          painter: WaveformPainter(
            waveformData: state.waveformData,
            progress: state.playbackProgress,
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

  void _onWaveformTap(
    BuildContext context,
    TapDownDetails details,
    TranscriptDetailState state,
  ) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final double progress = details.localPosition.dx / box.size.width;
    context.read<TranscriptDetailCubit>().seekToProgress(progress.clamp(0, 1));
  }

  void _onWaveformDrag(
    BuildContext context,
    DragUpdateDetails details,
    TranscriptDetailState state,
  ) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final double progress = details.localPosition.dx / box.size.width;
    context.read<TranscriptDetailCubit>().seekToProgress(progress.clamp(0, 1));
  }

  Widget _buildControls(BuildContext context, TranscriptDetailState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Skip backward 10s
        IconButton(
          onPressed: state.isAudioReady
              ? () => context.read<TranscriptDetailCubit>().skipBackward()
              : null,
          icon: Icon(
            Icons.replay_10_rounded,
            size: 28.sp,
            color: state.isAudioReady ? null : Colors.grey,
          ),
        ),
        SizedBox(width: 16.w),
        // Play/Pause
        _buildPlayPauseButton(context, state),
        SizedBox(width: 16.w),
        // Skip forward 10s
        IconButton(
          onPressed: state.isAudioReady
              ? () => context.read<TranscriptDetailCubit>().skipForward()
              : null,
          icon: Icon(
            Icons.forward_10_rounded,
            size: 28.sp,
            color: state.isAudioReady ? null : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayPauseButton(
      BuildContext context, TranscriptDetailState state) {
    final isLoading = state.audioStatus == AudioPlayerStatus.loading;
    final isReady = state.isAudioReady;

    return GestureDetector(
      onTap: isReady
          ? () => context.read<TranscriptDetailCubit>().togglePlayPause()
          : null,
      child: Container(
        width: 56.w,
        height: 56.w,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isLoading
            ? Padding(
                padding: EdgeInsets.all(16.w),
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Icon(
                state.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 32.sp,
              ),
      ),
    );
  }

  Widget _buildTimeDisplay(BuildContext context, TranscriptDetailState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          state.formattedCurrentPosition,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          state.formattedTotalDuration,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ==================== WAVEFORM PAINTER ====================

class WaveformPainter extends CustomPainter {
  final List<double> waveformData;
  final double progress;
  final Color activeColor;
  final Color inactiveColor;

  WaveformPainter({
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
    final maxBarHeight = size.height * 0.9;
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
          width: effectiveBarWidth,
          height: barHeight.clamp(4, maxBarHeight),
        ),
        Radius.circular(effectiveBarWidth / 2),
      );

      canvas.drawRRect(rect, isActive ? activePaint : inactivePaint);
    }

    // Draw cursor
    if (progress > 0 && progress < 1) {
      final cursorX = size.width * progress;
      final cursorPaint = Paint()
        ..color = activeColor
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(cursorX, centerY),
            width: 3,
            height: size.height,
          ),
          const Radius.circular(1.5),
        ),
        cursorPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.waveformData != waveformData;
  }
}
