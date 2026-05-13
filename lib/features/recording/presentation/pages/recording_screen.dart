import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:voice_ink/features/recording/presentation/widget/save_recording_sheet.dart';

enum _RecordMode { dictate, preRecord }

enum _RecordState { idle, recording, stopped }

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  final AudioRecorder _recorder = AudioRecorder();
  _RecordMode _mode = _RecordMode.preRecord;
  _RecordState _state = _RecordState.idle;

  Duration _elapsed = Duration.zero;
  Timer? _timer;

  String? _recordedPath;
  int _recordedBytes = 0;

  // Static silhouette generated once. The bar *shape* never changes —
  // the whole waveform just scales up/down together with the live mic
  // volume, so it stays visually calm while still being reactive.
  static const int _barCount = 50;
  late final List<double> _waveform = _generateWaveform();

  /// 0..1 smoothed live volume (drives the scale of the whole wave).
  double _amplitude = 0.0;
  StreamSubscription<Amplitude>? _ampSub;

  List<double> _generateWaveform() {
    final rng = math.Random(DateTime.now().millisecondsSinceEpoch);
    return List<double>.generate(_barCount, (_) => 0.15 + rng.nextDouble() * 0.85);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ampSub?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _toggleRecord() async {
    if (_state == _RecordState.recording) {
      await _stop();
    } else {
      await _start();
    }
  }

  Future<void> _start() async {
    try {
      final hasPermission = await _recorder.hasPermission();
      if (!hasPermission) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission denied')),
        );
        return;
      }
      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/voiceink_recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
          numChannels: 1,
        ),
        path: path,
      );
      _recordedPath = path;
      _elapsed = Duration.zero;
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() => _elapsed += const Duration(seconds: 1));
      });
      _startAmplitudeStream();
      setState(() => _state = _RecordState.recording);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recording failed: $e')),
      );
    }
  }

  /// Subscribes to the mic amplitude (dBFS) and converts it into a 0..1
  /// scale that drives the *whole* waveform's height. Heavy smoothing
  /// keeps it calm — the bar shape never changes, only the overall amplitude.
  void _startAmplitudeStream() {
    _ampSub?.cancel();
    _ampSub = _recorder
        .onAmplitudeChanged(const Duration(milliseconds: 100))
        .listen((amp) {
      if (!mounted) return;
      // amp.current is in dBFS (~-60 silence, 0 clipping).
      final normalized = ((amp.current + 50) / 50).clamp(0.0, 1.0).toDouble();
      // Slow ease toward the new sample so it doesn't twitch on every
      // tiny fluctuation in the input.
      setState(() {
        _amplitude = _amplitude * 0.75 + normalized * 0.25;
      });
    });
  }

  Future<void> _stop() async {
    _timer?.cancel();
    _ampSub?.cancel();
    _ampSub = null;
    setState(() => _amplitude = 0.0);
    try {
      final path = await _recorder.stop();
      if (path != null) {
        _recordedPath = path;
        try {
          _recordedBytes = await File(path).length();
        } catch (_) {
          _recordedBytes = 0;
        }
      }
    } catch (_) {}
    if (!mounted) return;
    setState(() => _state = _RecordState.stopped);
  }

  Future<void> _cancel() async {
    if (_state == _RecordState.recording) {
      try {
        await _recorder.stop();
      } catch (_) {}
      _timer?.cancel();
      _ampSub?.cancel();
      _ampSub = null;
      _amplitude = 0.0;
    }
    if (_recordedPath != null) {
      try {
        final f = File(_recordedPath!);
        if (await f.exists()) await f.delete();
      } catch (_) {}
    }
    if (!mounted) return;
    setState(() {
      _state = _RecordState.idle;
      _elapsed = Duration.zero;
      _recordedPath = null;
      _recordedBytes = 0;
    });
  }

  Future<void> _openSaveSheet() async {
    final path = _recordedPath;
    if (path == null) return;
    final duration = _elapsed;
    final bytes = _recordedBytes;
    await SaveRecordingSheet.show(
      context,
      filePath: path,
      duration: duration,
      sizeBytes: bytes,
    );
  }

  String _formatTimer(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (h > 0) return '$h:$m:$s';
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              _buildTopBar(),
              16.verticalSpace,
              _buildModeTabs(),
              32.verticalSpace,
              _buildWaveCard(),
              if (_mode == _RecordMode.dictate) ...[
                16.verticalSpace,
                _buildCompletedSentencesCard(),
              ],
              32.verticalSpace,
              Text(
                _formatTimer(_elapsed),
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w300,
                  fontSize: 48.sp,
                  letterSpacing: 3,
                  color: const Color(0xff1F2937),
                ),
              ),
              40.verticalSpace,
              _buildControls(),
              24.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
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
      ],
    );
  }

  Widget _buildModeTabs() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xffE5E7EB)),
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildModeTab(
              label: 'Dictate',
              subtitle: 'Live transcription',
              isSelected: _mode == _RecordMode.dictate,
              // Recording works the same way; live-transcript streaming
              // (WebSocket) isn't wired yet, so the Dictate panel shows a
              // placeholder card. We still let users tap and record.
              onTap: _state == _RecordState.recording
                  ? null
                  : () => setState(() => _mode = _RecordMode.dictate),
            ),
            _buildModeTab(
              label: 'Pre-record',
              subtitle: 'Transcribe after',
              isSelected: _mode == _RecordMode.preRecord,
              onTap: _state == _RecordState.recording
                  ? null
                  : () => setState(() => _mode = _RecordMode.preRecord),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeTab({
    required String label,
    required String subtitle,
    required bool isSelected,
    required VoidCallback? onTap,
  }) {
    final isDisabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff4A59FE) : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
                color: isSelected
                    ? Colors.white
                    : isDisabled
                        ? const Color(0xff9CA3AF)
                        : const Color(0xff4B5563),
              ),
            ),
            2.verticalSpace,
            Text(
              subtitle,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 10.sp,
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.75)
                    : const Color(0xff9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaveCard() {
    final isRecording = _state == _RecordState.recording;
    final isStopped = _state == _RecordState.stopped;
    return Container(
      height: 132.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: const Color(0xffF7F7FA),
        border: Border.all(color: const Color(0xffE5E7EB)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Same painter the mini-player uses. While recording the bars
          // are solid blue; otherwise faded — no flicker, no bounce.
          LayoutBuilder(
            builder: (context, constraints) {
              return CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: _RecordingWaveformPainter(
                  bars: _waveform,
                  // When recording, scale all bars together with the mic
                  // volume so the wave feels alive but never jittery.
                  // Idle/Stopped show the silhouette at full amplitude.
                  amplitude: isRecording ? (0.15 + 0.85 * _amplitude) : 1.0,
                  color: isRecording
                      ? const Color(0xff4A59FE)
                      : const Color(0xff4A59FE).withValues(alpha: 0.3),
                ),
              );
            },
          ),
          if (!isRecording)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isStopped ? 'Recording Stopped' : 'Ready to Record',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: const Color(0xff4B5563),
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    isStopped
                        ? 'Tap Save to upload or X to discard'
                        : 'Click the record button to start capturing audio',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: const Color(0xff9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompletedSentencesCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffE5E7EB)),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 10.h),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xffE5E7EB)),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'COMPLETED SENTENCES',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                    letterSpacing: 0.5,
                    color: const Color(0xff6B7280),
                  ),
                ),
                10.horizontalSpace,
                Text(
                  '0 sentences',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 11.sp,
                    color: const Color(0xff9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 120.h, maxHeight: 220.h),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56.w,
                      height: 56.h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xffEFF6FF), Color(0xffEEF2FF)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.mic_none_rounded,
                        size: 26.sp,
                        color: const Color(0xff60A5FA),
                      ),
                    ),
                    12.verticalSpace,
                    Text(
                      'Start speaking to see your transcription',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                        color: const Color(0xff4B5563),
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      'Your completed sentences will appear here',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 11.sp,
                        color: const Color(0xff9CA3AF),
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
  }

  Widget _buildControls() {
    final canCancel = _state != _RecordState.idle;
    final canSave = _state == _RecordState.stopped;
    final isRecording = _state == _RecordState.recording;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSecondaryButton(
          enabled: canCancel,
          onTap: canCancel ? _cancel : null,
          child: Icon(
            Icons.close_rounded,
            size: 28.sp,
            color: const Color(0xff4A59FE),
          ),
        ),
        24.horizontalSpace,
        _buildPrimaryButton(
          onTap: _toggleRecord,
          isRecording: isRecording,
        ),
        24.horizontalSpace,
        _buildSecondaryButton(
          enabled: canSave,
          onTap: canSave ? _openSaveSheet : null,
          child: Icon(
            Icons.save_alt_rounded,
            size: 26.sp,
            color: const Color(0xff10B981),
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryButton({
    required bool enabled,
    required VoidCallback? onTap,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: enabled ? 1.0 : 0.3,
        child: Container(
          width: 60.w,
          height: 60.h,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xffE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(child: child),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required VoidCallback onTap,
    required bool isRecording,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 84.w,
        height: 84.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xff4A59FE).withValues(alpha: 0.1),
          border: Border.all(
            color: const Color(0xff4A59FE).withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Center(
          child: Container(
            width: 56.w,
            height: 56.h,
            decoration: BoxDecoration(
              shape: isRecording ? BoxShape.rectangle : BoxShape.circle,
              borderRadius:
                  isRecording ? BorderRadius.circular(8.r) : null,
              color: isRecording
                  ? const Color(0xffEF4444)
                  : const Color(0xff4A59FE).withValues(alpha: 0.0),
            ),
            child: isRecording
                ? null
                : Icon(
                    Icons.mic_rounded,
                    size: 32.sp,
                    color: const Color(0xff4A59FE),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Same shape as the mini-player's `_WaveformPainter` but without a playhead
/// split — the recording screen draws all bars in a single colour. The
/// `amplitude` (0..1) scales every bar uniformly so the wave grows and
/// shrinks with the mic volume without changing its silhouette.
class _RecordingWaveformPainter extends CustomPainter {
  final List<double> bars;
  final double amplitude;
  final Color color;

  _RecordingWaveformPainter({
    required this.bars,
    required this.amplitude,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const barWidth = 2.0;
    final gap = (size.width - bars.length * barWidth) / (bars.length - 1);
    final centerY = size.height / 2;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    for (int i = 0; i < bars.length; i++) {
      final x = i * (barWidth + gap);
      final h = size.height * bars[i] * 0.9 * amplitude;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, centerY - h / 2, barWidth, h),
        const Radius.circular(0.8),
      );
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RecordingWaveformPainter old) =>
      old.color != color ||
      old.bars != bars ||
      old.amplitude != amplitude;
}
