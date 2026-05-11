import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:voice_ink/config/di/dependency_injector.dart';
import 'package:voice_ink/config/utilities/extensions/user_extension.dart';
import 'package:voice_ink/features/files/domain/entities/audio_file_entities.dart';
import 'package:voice_ink/features/files/domain/usecases/transcript_detail_usecase.dart';
import 'package:voice_ink/features/files/presentation/cubit/files_cubit.dart';

class MiniPlayerSheet extends StatefulWidget {
  final AudioFileEntity file;

  const MiniPlayerSheet({super.key, required this.file});

  static Future<void> show(BuildContext context, AudioFileEntity file) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => MiniPlayerSheet(file: file),
    );
  }

  @override
  State<MiniPlayerSheet> createState() => _MiniPlayerSheetState();
}

class _MiniPlayerSheetState extends State<MiniPlayerSheet> {
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _stateSub;
  StreamSubscription<Duration?>? _durationSub;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isLoading = true;
  String? _error;
  double _speed = 1.0;
  double _volume = 0.8;

  static const List<double> _speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
  late final List<double> _waveform;

  @override
  void initState() {
    super.initState();
    _waveform = _generateWaveform();
    _player.setVolume(_volume);
    _loadStream();
    _positionSub = _player.positionStream.listen((pos) {
      if (mounted) setState(() => _position = pos);
    });
    _durationSub = _player.durationStream.listen((d) {
      if (d != null && mounted) setState(() => _duration = d);
    });
    _stateSub = _player.playerStateStream.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _stateSub?.cancel();
    _durationSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  List<double> _generateWaveform() {
    final rng = math.Random(widget.file.id?.hashCode ?? 42);
    return List.generate(50, (_) => 0.15 + rng.nextDouble() * 0.85);
  }

  Future<void> _loadStream() async {
    if (widget.file.id == null) {
      setState(() {
        _isLoading = false;
        _error = 'Missing file id';
      });
      return;
    }
    try {
      final usecase = sl<GetStreamUrlUseCase>();
      final res = await usecase.call(
        fileId: widget.file.id!,
        token: context.token,
      );
      await res.fold((err) async {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _error = err;
        });
      }, (data) async {
        final url = data.url;
        if (url == null || url.isEmpty) {
          if (!mounted) return;
          setState(() {
            _isLoading = false;
            _error = 'Stream URL not available';
          });
          return;
        }
        await _player.setUrl(url);
        if (!mounted) return;
        setState(() => _isLoading = false);
        await _player.play();
      });
    } catch (e) {
      log('MiniPlayer load error: $e');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _togglePlay() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> _skip(Duration delta) async {
    final target = _position + delta;
    if (target.isNegative) {
      await _player.seek(Duration.zero);
    } else if (target > _duration) {
      await _player.seek(_duration);
    } else {
      await _player.seek(target);
    }
  }

  Future<void> _seekToFraction(double fraction) async {
    if (_duration.inMilliseconds == 0) return;
    final target = Duration(
      milliseconds: (_duration.inMilliseconds * fraction).round(),
    );
    await _player.seek(target);
  }

  String _format(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: EdgeInsets.all(12.w),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            8.verticalSpace,
            if (_isLoading)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: const Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              _buildError()
            else ...[
              _buildWaveform(),
              4.verticalSpace,
              _buildTimeRow(),
              8.verticalSpace,
              _buildTransport(),
              10.verticalSpace,
              _buildBottomRow(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            widget.file.name ?? widget.file.originalFilename ?? 'Untitled',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              height: 18 / 14,
              letterSpacing: -0.08,
              color: const Color(0xff1E222B),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Icon(
              Icons.close_rounded,
              size: 20.sp,
              color: const Color(0xff8C8C8C),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildError() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Center(
        child: Text(
          _error ?? 'Failed to load audio',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 13.sp,
            color: const Color(0xffFE4A4D),
          ),
        ),
      ),
    );
  }

  Widget _buildWaveform() {
    final progress = _duration.inMilliseconds == 0
        ? 0.0
        : (_position.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0);
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xffF7F7FA),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) {
              final fraction =
                  (details.localPosition.dx / constraints.maxWidth)
                      .clamp(0.0, 1.0);
              _seekToFraction(fraction);
            },
            child: CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: _WaveformPainter(
                bars: _waveform,
                progress: progress,
                active: const Color(0xff4A59FE),
                inactive: const Color(0xff4A59FE).withValues(alpha: 0.3),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _format(_position),
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w500,
            fontSize: 11.sp,
            color: const Color(0xff8C8C8C),
          ),
        ),
        Text(
          _format(_duration),
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w500,
            fontSize: 11.sp,
            color: const Color(0xff8C8C8C),
          ),
        ),
      ],
    );
  }

  Widget _buildTransport() {
    final isPlaying = _player.playing;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => _skip(const Duration(seconds: -10)),
          icon: const Icon(Icons.replay_10_rounded),
          color: const Color(0xff1E222B),
          iconSize: 26.sp,
        ),
        12.horizontalSpace,
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xff4A59FE), Color(0xff5B6AFF)],
            ),
          ),
          padding: EdgeInsets.all(12.w),
          child: GestureDetector(
            onTap: _togglePlay,
            child: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
        ),
        12.horizontalSpace,
        IconButton(
          onPressed: () => _skip(const Duration(seconds: 10)),
          icon: const Icon(Icons.forward_10_rounded),
          color: const Color(0xff1E222B),
          iconSize: 26.sp,
        ),
      ],
    );
  }

  Widget _buildBottomRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xffF7F7FA),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(Icons.volume_up_rounded,
              size: 16.sp, color: const Color(0xff8C8C8C)),
          6.horizontalSpace,
          SizedBox(
            width: 60.w,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape:
                    const RoundSliderOverlayShape(overlayRadius: 12),
                activeTrackColor: const Color(0xff4A59FE),
                inactiveTrackColor: const Color(0xffE5E5EA),
                thumbColor: const Color(0xff4A59FE),
              ),
              child: Slider(
                value: _volume,
                min: 0,
                max: 1,
                onChanged: (v) {
                  setState(() => _volume = v);
                  _player.setVolume(v);
                },
              ),
            ),
          ),
          12.horizontalSpace,
          Text(
            'Speed',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w500,
              fontSize: 11.sp,
              color: const Color(0xff8C8C8C),
            ),
          ),
          6.horizontalSpace,
          DropdownButton<double>(
            value: _speed,
            underline: const SizedBox.shrink(),
            isDense: true,
            iconSize: 16.sp,
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w500,
              fontSize: 11.sp,
              color: const Color(0xff1E222B),
            ),
            items: _speeds
                .map((s) => DropdownMenuItem(
                      value: s,
                      child: Text('${_trimSpeed(s)}x'),
                    ))
                .toList(),
            onChanged: (v) {
              if (v == null) return;
              setState(() => _speed = v);
              _player.setSpeed(v);
            },
          ),
          const Spacer(),
          _circleAction(
            icon: (widget.file.isFavorite ?? false)
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            color: (widget.file.isFavorite ?? false)
                ? const Color(0xffFE4A4D)
                : const Color(0xff1E222B),
            onTap: () {
              if (widget.file.id != null) {
                context.read<FilesCubit>().toggleFavorite(fileId: widget.file.id!);
              }
            },
          ),
        ],
      ),
    );
  }

  String _trimSpeed(double s) {
    if (s == s.roundToDouble()) return s.toInt().toString();
    return s.toString();
  }

  Widget _circleAction({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Icon(icon, size: 18.sp, color: color),
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final List<double> bars;
  final double progress;
  final Color active;
  final Color inactive;

  _WaveformPainter({
    required this.bars,
    required this.progress,
    required this.active,
    required this.inactive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = 2.0;
    final gap = (size.width - bars.length * barWidth) / (bars.length - 1);
    final centerY = size.height / 2;
    final progressX = size.width * progress;
    for (int i = 0; i < bars.length; i++) {
      final x = i * (barWidth + gap);
      final h = size.height * bars[i] * 0.9;
      final paint = Paint()
        ..color = x < progressX ? active : inactive
        ..style = PaintingStyle.fill;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, centerY - h / 2, barWidth, h),
        const Radius.circular(0.8),
      );
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter old) =>
      old.progress != progress || old.bars != bars;
}
