// lib/features/home/presentation/widget/transcription_progress_dialog.dart

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

enum TranscriptionStepStatus { waiting, inProgress, complete }

class TranscriptionStep {
  final String title;
  TranscriptionStepStatus status;
  double progress;

  TranscriptionStep({
    required this.title,
    this.status = TranscriptionStepStatus.waiting,
    this.progress = 0,
  });
}

class TranscriptionProgressDialog extends StatefulWidget {
  final String fileName;
  final VoidCallback onComplete;
  final VoidCallback onBackgroundTap;

  const TranscriptionProgressDialog({
    super.key,
    required this.fileName,
    required this.onComplete,
    required this.onBackgroundTap,
  });

  @override
  State<TranscriptionProgressDialog> createState() =>
      _TranscriptionProgressDialogState();
}

class _TranscriptionProgressDialogState
    extends State<TranscriptionProgressDialog> {
  double _overallProgress = 0;
  Timer? _progressTimer;
  int _remainingMinutes = 2;

  final List<TranscriptionStep> _steps = [
    TranscriptionStep(title: 'Audio Analysis'),
    TranscriptionStep(title: 'Speech Recognition'),
    TranscriptionStep(title: 'Speaker Detection'),
    TranscriptionStep(title: 'Final Processing'),
  ];

  @override
  void initState() {
    super.initState();
    _startProgressSimulation();
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  void _startProgressSimulation() {
    const totalDuration = 6000; // 6 seconds
    const interval = 60; // Update every 60ms
    const steps = totalDuration ~/ interval;
    int currentStep = 0;

    _progressTimer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      currentStep++;
      final progress = (currentStep / steps).clamp(0.0, 1.0);

      setState(() {
        _overallProgress = progress;
        _updateSteps(progress);
        _remainingMinutes = ((1 - progress) * 2).ceil();
      });

      if (currentStep >= steps) {
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 300), () {
          widget.onComplete();
        });
      }
    });
  }

  void _updateSteps(double progress) {
    // Each step takes 25% of the total progress
    for (int i = 0; i < _steps.length; i++) {
      final stepStart = i * 0.25;
      final stepEnd = (i + 1) * 0.25;

      if (progress >= stepEnd) {
        _steps[i].status = TranscriptionStepStatus.complete;
        _steps[i].progress = 1.0;
      } else if (progress >= stepStart) {
        _steps[i].status = TranscriptionStepStatus.inProgress;
        _steps[i].progress = (progress - stepStart) / 0.25;
      } else {
        _steps[i].status = TranscriptionStepStatus.waiting;
        _steps[i].progress = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: 370.w,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circular Progress
            _buildCircularProgress(),
            8.verticalSpace,
            // Title
            Text(
              'Transcribing Audio',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w700,
                fontSize: 22.sp,
                height: 28 / 22,
                letterSpacing: -0.26,
                color: const Color(0xff000000),
              ),
              textAlign: TextAlign.center,
            ),
            10.verticalSpace,
            // Subtitle
            Text(
              'Converting speech to text with enhanced accuracy',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 15.sp,
                height: 20 / 15,
                letterSpacing: -0.23,
                color: const Color(0xff767679),
              ),
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            // Steps
            ..._steps.map((step) => _buildStepItem(step)),
            16.verticalSpace,
            // Time remaining
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff4A59FE)),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Processing time remaining',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      height: 18 / 14,
                      color: const Color(0xff1E222B),
                    ),
                  ),
                  Text(
                    '~$_remainingMinutes minutes',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                      height: 18 / 14,
                      color: const Color(0xff1E222B),
                    ),
                  ),
                ],
              ),
            ),
            16.verticalSpace,
            // Background button
            GestureDetector(
              onTap: widget.onBackgroundTap,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xff4A59FE),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  'Transcribe in background',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                    height: 20 / 15,
                    letterSpacing: -0.23,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularProgress() {
    return SizedBox(
      width: 112.w,
      height: 112.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer border
          Container(
            width: 112.w,
            height: 112.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xff4A59FE).withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          // Progress arc
          SizedBox(
            width: 96.w,
            height: 96.h,
            child: CustomPaint(
              painter: CircularProgressPainter(
                progress: _overallProgress,
                strokeWidth: 4.w,
                backgroundColor: const Color(0xff4A59FE).withOpacity(0.25),
                progressColor: const Color(0xff4A59FE),
              ),
            ),
          ),
          // Percentage text
          Text(
            '${(_overallProgress * 100).toInt()}%',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w500,
              fontSize: 24.sp,
              height: 32 / 24,
              color: const Color(0xff000000),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(TranscriptionStep step) {
    Color statusColor;
    String statusText;
    double opacity = 1.0;

    switch (step.status) {
      case TranscriptionStepStatus.complete:
        statusColor = const Color(0xff006400);
        statusText = 'Complete';
        break;
      case TranscriptionStepStatus.inProgress:
        statusColor = const Color(0xff4A59FE);
        statusText = 'In Progress';
        break;
      case TranscriptionStepStatus.waiting:
        statusColor = const Color(0xff1E222B);
        statusText = 'Waiting';
        opacity = 0.5;
        break;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Opacity(
                opacity: opacity,
                child: Text(
                  step.title,
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    height: 21 / 16,
                    letterSpacing: -0.31,
                    color: const Color(0xff1E222B),
                  ),
                ),
              ),
              Opacity(
                opacity: step.status == TranscriptionStepStatus.waiting ? 0.5 : 1.0,
                child: Text(
                  statusText,
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp,
                    height: 24 / 13,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          8.verticalSpace,
          // Progress bar
          Container(
            height: 8.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xff4A59FE).withOpacity(0.25),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: step.status == TranscriptionStepStatus.complete
                  ? 1.0
                  : step.progress,
              child: Container(
                decoration: BoxDecoration(
                  color: step.status == TranscriptionStepStatus.complete
                      ? const Color(0xff006400)
                      : const Color(0xff4A59FE),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}