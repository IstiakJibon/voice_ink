import 'package:equatable/equatable.dart';
import 'package:voice_ink/features/files/domain/entities/transcript_detail_entities.dart';

enum TranscriptDetailStatus {
  initial,
  loading,
  loaded,
  failure,
}

enum AudioPlayerStatus {
  idle,
  loading,
  ready,
  playing,
  paused,
  error,
}

class TranscriptDetailState extends Equatable {
  // API States
  final TranscriptDetailStatus status;
  final String? errorMessage;
  final FileDetailEntities fileDetail;
  final StreamUrlEntities streamUrl;
  final TranscriptionResultsListEntities transcriptionResultsMeta;

  // Audio Player States
  final AudioPlayerStatus audioStatus;
  final Duration currentPosition;
  final Duration totalDuration;
  final List<double> waveformData; // Normalized 0-1 values for waveform bars
  final bool isLoadingWaveform;

  // UI States
  final int selectedTabIndex;
  final int? highlightedWordIndex;
  final bool isEditMode;
  final List<WordEntities> editedWords; // Local copy for editing
  final bool hasUnsavedChanges;

  // Editor States
  final int? selectedWordForEdit;
  final bool isUpdatingWord;

  // Multi-result picker States
  final String? selectedResultId;
  final bool isSwitchingResult;
  final bool resultsListLoaded;

  const TranscriptDetailState({
    this.status = TranscriptDetailStatus.initial,
    this.errorMessage,
    this.fileDetail = const FileDetailEntities(),
    this.streamUrl = const StreamUrlEntities(),
    this.transcriptionResultsMeta = const TranscriptionResultsListEntities(),
    this.audioStatus = AudioPlayerStatus.idle,
    this.currentPosition = Duration.zero,
    this.totalDuration = Duration.zero,
    this.waveformData = const [],
    this.isLoadingWaveform = false,
    this.selectedTabIndex = 0,
    this.highlightedWordIndex,
    this.isEditMode = false,
    this.editedWords = const [],
    this.hasUnsavedChanges = false,
    this.selectedWordForEdit,
    this.isUpdatingWord = false,
    this.selectedResultId,
    this.isSwitchingResult = false,
    this.resultsListLoaded = false,
  });

  TranscriptDetailState copyWith({
    TranscriptDetailStatus? status,
    String? errorMessage,
    FileDetailEntities? fileDetail,
    StreamUrlEntities? streamUrl,
    TranscriptionResultsListEntities? transcriptionResultsMeta,
    AudioPlayerStatus? audioStatus,
    Duration? currentPosition,
    Duration? totalDuration,
    List<double>? waveformData,
    bool? isLoadingWaveform,
    int? selectedTabIndex,
    int? highlightedWordIndex,
    bool clearHighlightedWord = false,
    bool? isEditMode,
    List<WordEntities>? editedWords,
    bool? hasUnsavedChanges,
    int? selectedWordForEdit,
    bool clearSelectedWordForEdit = false,
    bool? isUpdatingWord,
    String? selectedResultId,
    bool clearSelectedResultId = false,
    bool? isSwitchingResult,
    bool? resultsListLoaded,
  }) {
    return TranscriptDetailState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      fileDetail: fileDetail ?? this.fileDetail,
      streamUrl: streamUrl ?? this.streamUrl,
      transcriptionResultsMeta:
          transcriptionResultsMeta ?? this.transcriptionResultsMeta,
      audioStatus: audioStatus ?? this.audioStatus,
      currentPosition: currentPosition ?? this.currentPosition,
      totalDuration: totalDuration ?? this.totalDuration,
      waveformData: waveformData ?? this.waveformData,
      isLoadingWaveform: isLoadingWaveform ?? this.isLoadingWaveform,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      highlightedWordIndex: clearHighlightedWord
          ? null
          : (highlightedWordIndex ?? this.highlightedWordIndex),
      isEditMode: isEditMode ?? this.isEditMode,
      editedWords: editedWords ?? this.editedWords,
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
      selectedWordForEdit: clearSelectedWordForEdit
          ? null
          : (selectedWordForEdit ?? this.selectedWordForEdit),
      isUpdatingWord: isUpdatingWord ?? this.isUpdatingWord,
      selectedResultId: clearSelectedResultId
          ? null
          : (selectedResultId ?? this.selectedResultId),
      isSwitchingResult: isSwitchingResult ?? this.isSwitchingResult,
      resultsListLoaded: resultsListLoaded ?? this.resultsListLoaded,
    );
  }

  /// Get the current word based on audio position
  int? get currentWordIndex {
    if (fileDetail.transcriptionResult == null) return null;
    final words = fileDetail.transcriptionResult!.words;
    final positionMs = currentPosition.inMilliseconds;

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      if (word.start != null && word.end != null) {
        if (positionMs >= word.start! && positionMs <= word.end!) {
          return i;
        }
      }
    }
    return null;
  }

  /// Get words to display (edited version if in edit mode, otherwise original)
  List<WordEntities> get displayWords {
    if (isEditMode && editedWords.isNotEmpty) {
      return editedWords;
    }
    return fileDetail.transcriptionResult?.words ?? [];
  }

  /// Get utterances grouped by speaker (consecutive same-speaker merged)
  List<UtteranceEntities> get utterances {
    return fileDetail.transcriptionResult?.mergedUtterances ?? [];
  }

  /// Get formatted current position
  String get formattedCurrentPosition {
    final minutes = currentPosition.inMinutes;
    final seconds = currentPosition.inSeconds % 60;
    return '${minutes.toString()}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get formatted total duration
  String get formattedTotalDuration {
    final minutes = totalDuration.inMinutes;
    final seconds = totalDuration.inSeconds % 60;
    return '${minutes.toString()}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get playback progress (0-1)
  double get playbackProgress {
    if (totalDuration.inMilliseconds == 0) return 0;
    return currentPosition.inMilliseconds / totalDuration.inMilliseconds;
  }

  /// Check if data is loaded
  bool get isLoaded => status == TranscriptDetailStatus.loaded;

  /// Check if audio is ready
  bool get isAudioReady =>
      audioStatus == AudioPlayerStatus.ready ||
      audioStatus == AudioPlayerStatus.playing ||
      audioStatus == AudioPlayerStatus.paused;

  /// Check if playing
  bool get isPlaying => audioStatus == AudioPlayerStatus.playing;

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        fileDetail,
        streamUrl,
        transcriptionResultsMeta,
        audioStatus,
        currentPosition,
        totalDuration,
        waveformData,
        isLoadingWaveform,
        selectedTabIndex,
        highlightedWordIndex,
        isEditMode,
        editedWords,
        hasUnsavedChanges,
        selectedWordForEdit,
        isUpdatingWord,
        selectedResultId,
        isSwitchingResult,
        resultsListLoaded,
      ];
}
