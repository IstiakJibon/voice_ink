import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_ink/config/utilities/speaker_utils.dart';
import 'package:voice_ink/features/files/domain/entities/transcript_detail_entities.dart';
import 'package:voice_ink/features/files/presentation/cubit/transcript_details/transcript_detail_cubit.dart';
import 'package:voice_ink/features/files/presentation/cubit/transcript_details/transcript_detail_state.dart';

/// Editor Tab - Matches Figma design
/// Top card: Edit Transcript header + Speakers panel
/// Transcript card: Undo/Redo toolbar + Utterance blocks with tappable words
class EditorTabWidget extends StatefulWidget {
  const EditorTabWidget({super.key});

  @override
  State<EditorTabWidget> createState() => _EditorTabWidgetState();
}

class _EditorTabWidgetState extends State<EditorTabWidget> {
  bool _isTipVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TranscriptDetailCubit, TranscriptDetailState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              // Undo/Redo/Save toolbar card
              _buildToolbarCard(context, state),
              SizedBox(height: 32.h),
              // Speakers Card
              _buildSpeakersCard(context, state),
              SizedBox(height: 32.h),
              // Transcript Editor Card
              _buildTranscriptEditorCard(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSpeakersCard(BuildContext context, TranscriptDetailState state) {
    final speakers = state.fileDetail.transcriptionResult?.speakers ?? ['A'];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFF2F2F7)),
      ),
      child: Column(
        children: [
          // Header with border-bottom
          Container(
            padding: EdgeInsets.only(bottom: 12.h),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFF2F2F7)),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Edit Transcript',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF404040),
                    letterSpacing: -0.31,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => setState(() => _isTipVisible = !_isTipVisible),
                  child: Icon(
                    Icons.help_outline,
                    size: 20.sp,
                    color: const Color(0xFF404040),
                  ),
                ),
              ],
            ),
          ),
          if (_isTipVisible) ...[
            SizedBox(height: 16.h),
            _buildEditorGesturesTip(),
          ],
          SizedBox(height: 16.h),
          // Speakers section
          Column(
            children: [
              // Speakers header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Speakers',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF333333),
                      letterSpacing: -0.43,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Add Speaker coming soon'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A59FE),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, size: 20.sp, color: Colors.white),
                          SizedBox(width: 8.w),
                          Text(
                            'Add Speakers',
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
              SizedBox(height: 24.h),
              // Speaker chips
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: speakers.asMap().entries.map((entry) {
                    final speaker = entry.value;
                    final speakerNumber = entry.key + 1;
                    final color = speakerColorOf(speaker);
                    final badge = speakerBadgeLetterOf(speaker);

                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F7),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 32.w,
                            height: 32.w,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                badge,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
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
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditorGesturesTip() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF4A59FE).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20.sp,
                color: const Color(0xFF4A59FE),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Editor Gestures',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF4A59FE),
                    letterSpacing: -0.31,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _isTipVisible = false),
                child: Icon(
                  Icons.close,
                  size: 20.sp,
                  color: const Color(0xFF4A59FE),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Tap to seek timestamp',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: -0.31,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Double-tap to edit word',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: -0.31,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Long-press for options',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: -0.31,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranscriptEditorCard(
    BuildContext context,
    TranscriptDetailState state,
  ) {
    final utterances = state.utterances;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFF2F2F7)),
      ),
      child: Column(
        children: [
          // Utterances
          if (utterances.isEmpty)
            _buildEmptyState()
          else
            ...utterances.asMap().entries.map((entry) {
              return Padding(
                padding: EdgeInsets.all(8.w),
                child: _EditorUtteranceBlock(
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

  Widget _buildToolbarCard(
    BuildContext context,
    TranscriptDetailState state,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFF2F2F7)),
      ),
      child: Row(
        children: [
          // Undo button
          GestureDetector(
            onTap: () {
              // TODO: Implement undo
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.undo,
                    size: 20.sp,
                    color: const Color(0xFF404040),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Undo',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF404040),
                      letterSpacing: -0.31,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 16.w),
          // Vertical divider
          Container(
            width: 1,
            height: 27.h,
            color: const Color(0xFF8C8C8C),
          ),
          SizedBox(width: 16.w),
          // Redo button
          GestureDetector(
            onTap: () {
              // TODO: Implement redo
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.redo,
                    size: 20.sp,
                    color: const Color(0xFF404040),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Redo',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF404040),
                      letterSpacing: -0.31,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          // Save Changes button
          GestureDetector(
            onTap: () {
              if (state.hasUnsavedChanges) {
                context.read<TranscriptDetailCubit>().saveChanges();
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              height: 40.h,
              decoration: BoxDecoration(
                color: const Color(0xFF4A59FE),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: -0.31,
                  ),
                ),
              ),
            ),
          ),
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
              Icons.edit_note_outlined,
              size: 48.sp,
              color: const Color(0xFF999999),
            ),
            SizedBox(height: 12.h),
            Text(
              'No transcript to edit',
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF999999),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class _EditorUtteranceBlock extends StatelessWidget {
  final UtteranceEntities utterance;
  final int utteranceIndex;
  final TranscriptDetailState state;

  const _EditorUtteranceBlock({
    required this.utterance,
    required this.utteranceIndex,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final speaker = utterance.speaker ?? 'A';
    final speakerNumber = speakerNumberOf(speaker);
    final color = speakerColorOf(speaker);
    final badge = speakerBadgeLetterOf(speaker);
    final words = _resolveWords();

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left column: avatar + speaker + timestamp (fixed width like web's w-24)
          SizedBox(
            width: 64.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _showSpeakerPicker(context),
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        badge,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                GestureDetector(
                  onTap: () => _showSpeakerPicker(context),
                  child: Text(
                    'Speaker $speakerNumber',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF4B5563),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 11.sp,
                      color: const Color(0xFF9CA3AF),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      utterance.formattedStart,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          // Right column: tappable words flowing
          Expanded(child: _buildTappableWords(context, words)),
        ],
      ),
    );
  }

  /// Returns the word list to render. Three-tier fallback so the UI always
  /// shows tappable word spans (matching the web), regardless of which API
  /// shape the selected transcription result was parsed from:
  ///   1. utterance.words  (when present)
  ///   2. top-level words filtered by utterance's time range
  ///   3. split utterance.text on whitespace into synthetic WordEntities
  List<WordEntities> _resolveWords() {
    if (utterance.words.isNotEmpty) return utterance.words;

    final allWords = state.displayWords;
    final uStart = utterance.start;
    final uEnd = utterance.end;
    if (uStart != null && uEnd != null) {
      final filtered = allWords.where((w) {
        final ws = w.start;
        return ws != null && ws >= uStart && ws <= uEnd;
      }).toList();
      if (filtered.isNotEmpty) return filtered;
    }

    final text = utterance.text;
    if (text == null || text.trim().isEmpty) return const [];
    return text
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .map((t) => WordEntities(
              text: t,
              start: uStart,
              end: uEnd,
              speaker: utterance.speaker,
            ))
        .toList();
  }

  Widget _buildTappableWords(BuildContext context, List<WordEntities> words) {
    if (words.isEmpty) {
      return Text(
        utterance.text ?? '',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF1F2937),
          height: 1.5,
        ),
      );
    }
    return Wrap(
      spacing: 2.w,
      runSpacing: 2.h,
      children: words.map((word) {
        final globalIndex = _findGlobalIndex(word);
        final isCurrentWord = state.currentWordIndex == globalIndex;
        return _TappableWord(
          word: word,
          globalWordIndex: globalIndex,
          isCurrentWord: isCurrentWord,
        );
      }).toList(),
    );
  }

  int _findGlobalIndex(WordEntities word) {
    final allWords = state.displayWords;
    for (int i = 0; i < allWords.length; i++) {
      if (allWords[i].start == word.start && allWords[i].text == word.text) {
        return i;
      }
    }
    return 0;
  }


  void _showSpeakerPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (bottomSheetContext) {
        return _SpeakerPickerSheet(
          currentSpeaker: utterance.speaker ?? 'A',
          onSpeakerSelected: (newSpeaker) {
            context
                .read<TranscriptDetailCubit>()
                .updateUtteranceSpeakerLocally(utteranceIndex, newSpeaker);
            Navigator.pop(bottomSheetContext);
          },
        );
      },
    );
  }

}

class _TappableWord extends StatelessWidget {
  final WordEntities word;
  final int globalWordIndex;
  final bool isCurrentWord;

  const _TappableWord({
    required this.word,
    required this.globalWordIndex,
    required this.isCurrentWord,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Single tap: seek to timestamp
        context.read<TranscriptDetailCubit>().seekToWord(globalWordIndex);
      },
      onDoubleTap: () {
        // Double tap: edit word
        _showWordEditDialog(context);
      },
      onLongPress: () {
        // Long press: show options menu
        _showOptionsMenu(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: isCurrentWord
              ? const Color(0xFF4A59FE).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(2.r),
          border: isCurrentWord
              ? Border.all(color: const Color(0xFF4A59FE), width: 0.5)
              : null,
        ),
        child: Text(
          '${word.text ?? ''} ',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF333333),
            letterSpacing: -0.31,
            height: 1.75, // line-height 28px / font-size 16px
          ),
        ),
      ),
    );
  }

  void _showWordEditDialog(BuildContext context) {
    final controller = TextEditingController(text: word.text ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          title: Text(
            'Edit Word',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF333333),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF333333),
                ),
                decoration: InputDecoration(
                  labelText: 'Word',
                  labelStyle: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF999999),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Color(0xFFF2F2F7)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Color(0xFF4A59FE)),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14.sp,
                    color: const Color(0xFF999999),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    word.formattedStart,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF999999),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Icon(
                    Icons.person_outline,
                    size: 14.sp,
                    color: const Color(0xFF999999),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Speaker ${word.speaker ?? "?"}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF999999),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                context.read<TranscriptDetailCubit>().updateWordTextLocally(
                      globalWordIndex,
                      controller.text,
                    );
                Navigator.pop(dialogContext);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A59FE),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (dialogContext) {
        return Stack(
          children: [
            // Dismiss on tap outside
            GestureDetector(
              onTap: () => Navigator.pop(dialogContext),
              child: Container(color: Colors.transparent),
            ),
            // Options popup
            Center(
              child: Container(
                width: 238.w,
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: const Color(0xFFF2F2F7)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 13,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.09),
                      blurRadius: 24,
                      offset: const Offset(0, 24),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 33,
                      offset: const Offset(0, 55),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.01),
                      blurRadius: 39,
                      offset: const Offset(0, 97),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildPopupOption(
                      icon: Icons.add,
                      label: 'Insert word after',
                      onTap: () {
                        Navigator.pop(dialogContext);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Insert word coming soon'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        );
                      },
                    ),
                    _buildPopupOption(
                      icon: Icons.delete_outline,
                      label: 'Delete word',
                      onTap: () {
                        Navigator.pop(dialogContext);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Delete word coming soon'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        );
                      },
                    ),
                    _buildPopupOption(
                      icon: Icons.call_split,
                      label: 'Split word',
                      onTap: () {
                        Navigator.pop(dialogContext);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Split word coming soon'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        );
                      },
                    ),
                    // Divider
                    Container(
                      height: 1,
                      color: const Color(0xFFF2F2F7),
                    ),
                    _buildPopupOption(
                      icon: Icons.content_cut,
                      label: 'Split & unassign speaker',
                      onTap: () {
                        Navigator.pop(dialogContext);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Split & unassign speaker coming soon',
                            ),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        );
                      },
                    ),
                    _buildPopupOption(
                      icon: Icons.person_outline,
                      label: 'Change speaker',
                      onTap: () {
                        Navigator.pop(dialogContext);
                        _showSpeakerPickerForWord(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPopupOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        height: 44.h,
        child: Row(
          children: [
            Icon(icon, size: 24.sp, color: const Color(0xFF8C8C8C)),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF333333),
                letterSpacing: -0.31,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSpeakerPickerForWord(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (bottomSheetContext) {
        return _SpeakerPickerSheet(
          currentSpeaker: word.speaker ?? 'A',
          onSpeakerSelected: (newSpeaker) {
            context
                .read<TranscriptDetailCubit>()
                .updateWordSpeakerLocally(globalWordIndex, newSpeaker);
            Navigator.pop(bottomSheetContext);
          },
        );
      },
    );
  }
}

class _SpeakerPickerSheet extends StatelessWidget {
  final String currentSpeaker;
  final Function(String) onSpeakerSelected;

  const _SpeakerPickerSheet({
    required this.currentSpeaker,
    required this.onSpeakerSelected,
  });

  @override
  Widget build(BuildContext context) {
    final speakers = ['A', 'B', 'C', 'D', 'E', 'F'];

    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Assign Speaker',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF333333),
              letterSpacing: -0.43,
            ),
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: speakers.asMap().entries.map((entry) {
              final speaker = entry.value;
              final speakerNumber = entry.key + 1;
              final isSelected = speaker == currentSpeaker;
              final color = speakerColorOf(speaker);

              return GestureDetector(
                onTap: () => onSpeakerSelected(speaker),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? color : const Color(0xFFF2F2F7),
                    borderRadius: BorderRadius.circular(10.r),
                    border: isSelected
                        ? Border.all(color: color, width: 2)
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : color,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            speaker,
                            style: TextStyle(
                              color: isSelected ? color : Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Speaker $speakerNumber',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : const Color(0xFF333333),
                          letterSpacing: -0.31,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

}