import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_ink/config/di/dependency_injector.dart';
import 'package:voice_ink/config/utilities/extensions/user_extension.dart';
import 'package:voice_ink/config/utilities/speaker_utils.dart';
import 'package:voice_ink/features/files/domain/entities/transcript_detail_entities.dart';
import 'package:voice_ink/features/files/domain/usecases/transcript_detail_usecase.dart';
import 'package:voice_ink/features/files/presentation/cubit/transcript_details/transcript_detail_cubit.dart';
import 'package:voice_ink/features/files/presentation/cubit/transcript_details/transcript_detail_state.dart';

const Map<String, _EnginePreset> _engineByProvider = {
  'assemblyai': _EnginePreset(
    displayName: 'Precision',
    bgColor: Color(0xFFDBEAFE),
    textColor: Color(0xFF1E40AF),
  ),
  'deepgram': _EnginePreset(
    displayName: 'Velocity',
    bgColor: Color(0xFFDCFCE7),
    textColor: Color(0xFF166534),
  ),
  'speechmatics': _EnginePreset(
    displayName: 'Clarity',
    bgColor: Color(0xFFFFEDD5),
    textColor: Color(0xFF9A3412),
  ),
  'whisper': _EnginePreset(
    displayName: 'Universal',
    bgColor: Color(0xFFF3E8FF),
    textColor: Color(0xFF6B21A8),
  ),
};

const _EnginePreset _fallbackPreset = _EnginePreset(
  displayName: 'Engine',
  bgColor: Color(0xFFF2F2F7),
  textColor: Color(0xFF404040),
);

class _EnginePreset {
  final String displayName;
  final Color bgColor;
  final Color textColor;

  const _EnginePreset({
    required this.displayName,
    required this.bgColor,
    required this.textColor,
  });
}

_EnginePreset _presetFor(String? provider) {
  if (provider == null) return _fallbackPreset;
  return _engineByProvider[provider.toLowerCase()] ?? _fallbackPreset;
}

/// Side-column theming for the compare view (positional: first = blue, second = green).
class _ColumnTheme {
  final Color borderColor;
  final Color headerBg;
  final Color headerBorder;
  final Color titleColor;
  final Color subtitleColor;
  final Color avatarBg;
  final Color avatarText;

  const _ColumnTheme({
    required this.borderColor,
    required this.headerBg,
    required this.headerBorder,
    required this.titleColor,
    required this.subtitleColor,
    required this.avatarBg,
    required this.avatarText,
  });
}

const _ColumnTheme _blueColumn = _ColumnTheme(
  borderColor: Color(0xFFBFDBFE),
  headerBg: Color(0xFFEFF6FF),
  headerBorder: Color(0xFFBFDBFE),
  titleColor: Color(0xFF1E3A8A),
  subtitleColor: Color(0xFF1D4ED8),
  avatarBg: Color(0xFFDBEAFE),
  avatarText: Color(0xFF2563EB),
);

const _ColumnTheme _greenColumn = _ColumnTheme(
  borderColor: Color(0xFFBBF7D0),
  headerBg: Color(0xFFF0FDF4),
  headerBorder: Color(0xFFBBF7D0),
  titleColor: Color(0xFF14532D),
  subtitleColor: Color(0xFF15803D),
  avatarBg: Color(0xFFDCFCE7),
  avatarText: Color(0xFF16A34A),
);

enum _PickerMode { normal, picking, comparing }

class TranscriptionResultsPicker extends StatefulWidget {
  const TranscriptionResultsPicker({super.key});

  @override
  State<TranscriptionResultsPicker> createState() =>
      _TranscriptionResultsPickerState();
}

class _TranscriptionResultsPickerState
    extends State<TranscriptionResultsPicker> {
  bool _expanded = false;
  _PickerMode _mode = _PickerMode.normal;
  final Set<String> _selectedForCompare = <String>{};

  // Comparison data
  TranscriptionResultEntities? _detailA;
  TranscriptionResultEntities? _detailB;
  TranscriptionResultMetaEntities? _metaA;
  TranscriptionResultMetaEntities? _metaB;
  bool _compareLoading = false;
  String? _compareError;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TranscriptDetailCubit, TranscriptDetailState>(
      buildWhen: (prev, curr) =>
          prev.transcriptionResultsMeta != curr.transcriptionResultsMeta ||
          prev.selectedResultId != curr.selectedResultId ||
          prev.isSwitchingResult != curr.isSwitchingResult,
      builder: (context, state) {
        final results = state.transcriptionResultsMeta.results;
        if (results.isEmpty) return const SizedBox.shrink();

        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFFF2F2F7)),
          ),
          child: _buildContent(context, state, results),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    TranscriptDetailState state,
    List<TranscriptionResultMetaEntities> results,
  ) {
    final hasMultiple = results.length > 1;

    switch (_mode) {
      case _PickerMode.comparing:
        return _buildComparingView();
      case _PickerMode.picking:
        return _buildPickingView(results);
      case _PickerMode.normal:
        final primaryResultId = state.transcriptionResultsMeta.primaryResultId;
        final selected = results.firstWhere(
          (r) => r.id == state.selectedResultId,
          orElse: () => results.first,
        );
        final others = results.where((r) => r.id != selected.id).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, results),
            SizedBox(height: 12.h),
            if (!hasMultiple)
              _buildPlainRow(selected)
            else
              _buildDropdown(
                context: context,
                selected: selected,
                others: others,
                primaryResultId: primaryResultId,
                isBusy: state.isSwitchingResult,
              ),
          ],
        );
    }
  }

  // ==================== HEADER (normal mode) ====================

  Widget _buildHeader(
    BuildContext context,
    List<TranscriptionResultMetaEntities> results,
  ) {
    final count = results.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Transcription Results ($count)',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111827),
                letterSpacing: -0.23,
              ),
            ),
            if (count > 1) ...[
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A59FE).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'Multiple versions available',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF4A59FE),
                  ),
                ),
              ),
            ],
          ],
        ),
        if (count >= 2) ...[
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: _startPicking,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.08),
                  border: Border.all(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.compare_arrows,
                      size: 12.sp,
                      color: const Color(0xFF7C3AED),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Compare',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF7C3AED),
                        letterSpacing: -0.08,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ==================== PICKING MODE ====================

  void _startPicking() {
    setState(() {
      _mode = _PickerMode.picking;
      _selectedForCompare.clear();
    });
  }

  void _cancelPicking() {
    setState(() {
      _mode = _PickerMode.normal;
      _selectedForCompare.clear();
    });
  }

  Widget _buildPickingView(List<TranscriptionResultMetaEntities> results) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select 2 transcripts to compare',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          _selectedForCompare.length == 2
              ? 'Tap Compare to continue'
              : 'Selected: ${_selectedForCompare.length} / 2',
          style: TextStyle(
            fontSize: 11.sp,
            color: const Color(0xFF6B7280),
          ),
        ),
        SizedBox(height: 12.h),
        ...results.map(
          (r) => Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: _buildPickableRow(r),
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _cancelPicking,
                child: Container(
                  height: 36.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F7),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF374151),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: _selectedForCompare.length == 2
                    ? () => _confirmPicking(results)
                    : null,
                child: Opacity(
                  opacity: _selectedForCompare.length == 2 ? 1 : 0.4,
                  child: Container(
                    height: 36.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C3AED),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'Compare',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPickableRow(TranscriptionResultMetaEntities result) {
    final id = result.id;
    if (id == null) return const SizedBox.shrink();
    final isSelected = _selectedForCompare.contains(id);
    final atLimit = _selectedForCompare.length >= 2 && !isSelected;
    final preset = _presetFor(result.provider);
    final confidencePercent = result.confidence == null
        ? null
        : '${(result.confidence! * 100).round()}%';

    return GestureDetector(
      onTap: atLimit
          ? null
          : () {
              setState(() {
                if (isSelected) {
                  _selectedForCompare.remove(id);
                } else {
                  _selectedForCompare.add(id);
                }
              });
            },
      child: Opacity(
        opacity: atLimit ? 0.4 : 1,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF7C3AED).withValues(alpha: 0.06)
                : Colors.white,
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF7C3AED)
                  : const Color(0xFFE5E7EB),
              width: isSelected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Container(
                width: 18.w,
                height: 18.w,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF7C3AED)
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF7C3AED)
                        : const Color(0xFF9CA3AF),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: isSelected
                    ? Icon(Icons.check, size: 12.sp, color: Colors.white)
                    : null,
              ),
              SizedBox(width: 8.w),
              _engineBadge(preset),
              SizedBox(width: 6.w),
              Text(
                '${result.wordCount ?? 0}w',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFF6B7280),
                ),
              ),
              if (confidencePercent != null) ...[
                SizedBox(width: 6.w),
                Text(
                  confidencePercent,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _confirmPicking(List<TranscriptionResultMetaEntities> results) {
    if (_selectedForCompare.length != 2) return;
    final idList = _selectedForCompare.toList();
    final a = results.firstWhere((r) => r.id == idList[0]);
    final b = results.firstWhere((r) => r.id == idList[1]);
    setState(() {
      _metaA = a;
      _metaB = b;
      _mode = _PickerMode.comparing;
      _compareLoading = true;
      _compareError = null;
      _detailA = null;
      _detailB = null;
    });
    _fetchComparePair();
  }

  // ==================== COMPARING MODE ====================

  Future<void> _fetchComparePair() async {
    final token = context.token;
    final useCase = sl<GetTranscriptionResultDetailUseCase>();
    final idA = _metaA?.id ?? '';
    final idB = _metaB?.id ?? '';
    if (idA.isEmpty || idB.isEmpty) {
      setState(() {
        _compareError = 'Missing result id';
        _compareLoading = false;
      });
      return;
    }

    final results = await Future.wait([
      useCase(resultId: idA, token: token),
      useCase(resultId: idB, token: token),
    ]);

    if (!mounted) return;

    TranscriptionResultEntities? a;
    TranscriptionResultEntities? b;
    String? err;
    results[0].fold((e) => err = e, (v) => a = v);
    results[1].fold((e) => err ??= e, (v) => b = v);

    setState(() {
      _detailA = a;
      _detailB = b;
      _compareError = a == null && b == null ? err : null;
      _compareLoading = false;
    });
  }

  void _exitComparison() {
    setState(() {
      _mode = _PickerMode.normal;
      _detailA = null;
      _detailB = null;
      _metaA = null;
      _metaB = null;
      _compareError = null;
      _compareLoading = false;
      _selectedForCompare.clear();
    });
  }

  Widget _buildComparingView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCompareBanner(),
        SizedBox(height: 10.h),
        _buildCompareBox(),
      ],
    );
  }

  Widget _buildCompareBanner() {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        border: Border.all(color: const Color(0xFFDDD6FE)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: const BoxDecoration(
              color: Color(0xFFEDE9FE),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.compare_arrows,
              size: 14.sp,
              color: const Color(0xFF7C3AED),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Comparison Mode Active',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF4C1D95),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Viewing results side-by-side',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: const Color(0xFF6D28D9),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _exitComparison,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                color: const Color(0xFFEDE9FE),
              ),
              child: Text(
                'Exit',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6D28D9),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompareBox() {
    if (_compareLoading) {
      return SizedBox(
        height: 200.h,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_compareError != null) {
      return SizedBox(
        height: 120.h,
        child: Center(
          child: Text(
            _compareError!,
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFFEF4444)),
          ),
        ),
      );
    }
    return SizedBox(
      height: 360.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _ComparisonColumn(
              theme: _blueColumn,
              engineName: _presetFor(_metaA?.provider).displayName,
              engineLabel: 'Engine 1',
              result: _detailA,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _ComparisonColumn(
              theme: _greenColumn,
              engineName: _presetFor(_metaB?.provider).displayName,
              engineLabel: 'Engine 2',
              result: _detailB,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== NORMAL MODE HELPERS ====================

  Widget _buildPlainRow(TranscriptionResultMetaEntities result) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: _resultInfo(result, isPrimary: false, showPrimaryBadge: false),
    );
  }

  Widget _buildDropdown({
    required BuildContext context,
    required TranscriptionResultMetaEntities selected,
    required List<TranscriptionResultMetaEntities> others,
    required String? primaryResultId,
    required bool isBusy,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          _buildExpandableRow(
            context: context,
            result: selected,
            isPrimary:
                primaryResultId != null && primaryResultId == selected.id,
            isSelected: true,
            isBusy: isBusy,
            showChevron: true,
          ),
          if (_expanded) ...[
            const Divider(height: 1, color: Color(0xFFF2F2F7)),
            ...others.map((r) => Column(
                  children: [
                    _buildExpandableRow(
                      context: context,
                      result: r,
                      isPrimary:
                          primaryResultId != null && primaryResultId == r.id,
                      isSelected: false,
                      isBusy: isBusy,
                      showChevron: false,
                    ),
                    if (r != others.last)
                      const Divider(height: 1, color: Color(0xFFF2F2F7)),
                  ],
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildExpandableRow({
    required BuildContext context,
    required TranscriptionResultMetaEntities result,
    required bool isPrimary,
    required bool isSelected,
    required bool isBusy,
    required bool showChevron,
  }) {
    return GestureDetector(
      onTap: isBusy
          ? null
          : () {
              if (showChevron) {
                setState(() => _expanded = !_expanded);
              } else {
                final id = result.id;
                if (id == null) return;
                context
                    .read<TranscriptDetailCubit>()
                    .selectTranscriptionResult(resultId: id);
                setState(() => _expanded = false);
              }
            },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        color: isSelected
            ? const Color(0xFF4A59FE).withValues(alpha: 0.04)
            : Colors.transparent,
        child: Row(
          children: [
            Expanded(
              child: _resultInfo(
                result,
                isPrimary: isPrimary,
                showPrimaryBadge: true,
              ),
            ),
            SizedBox(width: 6.w),
            if (!isPrimary)
              _MiniButton(
                label: 'Set active',
                isDestructive: false,
                onTap: isBusy ? null : () => _confirmSetPrimary(context, result),
              ),
            if (!isPrimary) SizedBox(width: 4.w),
            _MiniButton(
              label: 'Delete',
              isDestructive: true,
              onTap: isBusy ? null : () => _confirmDelete(context, result),
            ),
            if (showChevron) ...[
              SizedBox(width: 4.w),
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 18.sp,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _resultInfo(
    TranscriptionResultMetaEntities result, {
    required bool isPrimary,
    required bool showPrimaryBadge,
  }) {
    final preset = _presetFor(result.provider);
    final confidence = result.confidence;
    final confidencePercent =
        confidence == null ? null : '${(confidence * 100).round()}%';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _engineBadge(preset),
        SizedBox(width: 6.w),
        Text(
          '${result.wordCount ?? 0}w',
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6B7280),
          ),
        ),
        if (confidencePercent != null) ...[
          SizedBox(width: 6.w),
          Text(
            confidencePercent,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF10B981),
            ),
          ),
        ],
        if (showPrimaryBadge && isPrimary) ...[
          SizedBox(width: 6.w),
          Icon(Icons.star, size: 12.sp, color: const Color(0xFFF59E0B)),
          SizedBox(width: 2.w),
          Text(
            'Active',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFF59E0B),
            ),
          ),
        ],
      ],
    );
  }

  Widget _engineBadge(_EnginePreset preset) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: preset.bgColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        preset.displayName,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          color: preset.textColor,
          letterSpacing: -0.08,
        ),
      ),
    );
  }

  Future<void> _confirmSetPrimary(
    BuildContext context,
    TranscriptionResultMetaEntities result,
  ) async {
    final id = result.id;
    if (id == null) return;
    final cubit = context.read<TranscriptDetailCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await _showConfirmDialog(
      context: context,
      title: 'Set active',
      body:
          'Make "${_presetFor(result.provider).displayName}" the active transcript for this file?',
      confirmLabel: 'Set active',
      destructive: false,
    );
    if (confirmed != true) return;
    final ok = await cubit.setPrimaryTranscriptionResult(resultId: id);
    if (!ok) return;
    messenger.showSnackBar(
      SnackBar(
        content: const Text('Set as active'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    TranscriptionResultMetaEntities result,
  ) async {
    final id = result.id;
    if (id == null) return;
    final cubit = context.read<TranscriptDetailCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await _showConfirmDialog(
      context: context,
      title: 'Delete transcription',
      body:
          'Delete the "${_presetFor(result.provider).displayName}" transcript? This cannot be undone.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (confirmed != true) return;
    final ok = await cubit.deleteTranscriptionResult(resultId: id);
    if (!ok) return;
    messenger.showSnackBar(
      SnackBar(
        content: const Text('Transcription deleted'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  Future<bool?> _showConfirmDialog({
    required BuildContext context,
    required String title,
    required String body,
    required String confirmLabel,
    required bool destructive,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
        content: Text(
          body,
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF4B5563),
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              confirmLabel,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: destructive
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF4A59FE),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isDestructive;

  const _MiniButton({
    required this.label,
    required this.onTap,
    required this.isDestructive,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? const Color(0xFFEF4444)
        : const Color(0xFF4A59FE);
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: enabled ? 1 : 0.4,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: -0.08,
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== COMPARE VIEW ====================

class _ComparisonColumn extends StatelessWidget {
  final _ColumnTheme theme;
  final String engineName;
  final String engineLabel;
  final TranscriptionResultEntities? result;

  const _ComparisonColumn({
    required this.theme,
    required this.engineName,
    required this.engineLabel,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final utterances = result?.mergedUtterances ?? const [];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: theme.borderColor),
        borderRadius: BorderRadius.circular(10.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: theme.headerBg,
              border: Border(
                bottom: BorderSide(color: theme.headerBorder),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  engineName,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.titleColor,
                  ),
                ),
                Text(
                  engineLabel,
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.subtitleColor,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: utterances.isEmpty
                ? Center(
                    child: Text(
                      result == null ? 'Failed to load' : 'No utterances',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(6.w),
                    itemCount: utterances.length,
                    separatorBuilder: (_, _) => SizedBox(height: 6.h),
                    itemBuilder: (context, index) => _CompareUtteranceRow(
                      utterance: utterances[index],
                      theme: theme,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _CompareUtteranceRow extends StatelessWidget {
  final UtteranceEntities utterance;
  final _ColumnTheme theme;

  const _CompareUtteranceRow({required this.utterance, required this.theme});

  @override
  Widget build(BuildContext context) {
    final speaker = utterance.speaker ?? 'A';
    final speakerNumber = speakerNumberOf(speaker);
    final badge = speakerBadgeLetterOf(speaker);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          utterance.formattedStart,
          style: TextStyle(
            fontSize: 9.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6B7280),
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16.w,
              height: 16.w,
              decoration: BoxDecoration(
                color: theme.avatarBg,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                badge,
                style: TextStyle(
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.avatarText,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Flexible(
              child: Text(
                'Speaker $speakerNumber',
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF374151),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        Text(
          utterance.text ?? '',
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF1F2937),
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
