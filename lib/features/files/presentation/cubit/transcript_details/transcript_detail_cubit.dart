// Required imports:
// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:just_audio/just_audio.dart';
// + your project imports for entities, models, state, use cases

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:voice_ink/features/files/data/models/transcript_detail_model.dart';
import 'package:voice_ink/features/files/domain/entities/transcript_detail_entities.dart';
import 'package:voice_ink/features/files/domain/usecases/transcript_detail_usecase.dart';
import 'package:voice_ink/features/files/presentation/cubit/transcript_details/transcript_detail_state.dart';

class TranscriptDetailCubit extends Cubit<TranscriptDetailState> {
  final GetFileDetailUseCase getFileDetailUseCase;
  final GetStreamUrlUseCase getStreamUrlUseCase;
  final GetTranscriptionResultsUseCase getTranscriptionResultsUseCase;
  final UpdateWordTextUseCase updateWordTextUseCase;
  final UpdateWordSpeakerUseCase updateWordSpeakerUseCase;

  AudioPlayer? _audioPlayer;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  String? _currentFileId;
  String? _currentToken;

  TranscriptDetailCubit({
    required this.getFileDetailUseCase,
    required this.getStreamUrlUseCase,
    required this.getTranscriptionResultsUseCase,
    required this.updateWordTextUseCase,
    required this.updateWordSpeakerUseCase,
  }) : super(const TranscriptDetailState()) {
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer();
    _setupAudioListeners();
  }

  void _setupAudioListeners() {
    final player = _audioPlayer;
    if (player == null) return;

    _positionSubscription = player.positionStream.listen((position) {
      if (!isClosed) {
        emit(state.copyWith(currentPosition: position));
      }
    });

    _durationSubscription = player.durationStream.listen((duration) {
      if (!isClosed && duration != null) {
        emit(state.copyWith(totalDuration: duration));
      }
    });

    _playerStateSubscription = player.playerStateStream.listen((playerState) {
      if (!isClosed) {
        final status = _mapPlayerState(playerState);
        emit(state.copyWith(audioStatus: status));
      }
    });
  }

  AudioPlayerStatus _mapPlayerState(PlayerState playerState) {
    switch (playerState.processingState) {
      case ProcessingState.loading:
      case ProcessingState.buffering:
        return AudioPlayerStatus.loading;
      case ProcessingState.ready:
        return playerState.playing
            ? AudioPlayerStatus.playing
            : AudioPlayerStatus.paused;
      case ProcessingState.completed:
        return AudioPlayerStatus.paused;
      case ProcessingState.idle:
        return AudioPlayerStatus.idle;
    }
  }

  // ==================== LOAD DATA ====================

  Future<void> loadFileDetail({
    required String fileId,
    required String token,
  }) async {
    _currentFileId = fileId;
    _currentToken = token;

    emit(state.copyWith(status: TranscriptDetailStatus.loading));

    final result = await getFileDetailUseCase.call(fileId: fileId, token: token);

    result.fold(
      (error) {
        emit(state.copyWith(
          status: TranscriptDetailStatus.failure,
          errorMessage: error,
        ));
      },
      (fileDetail) {
        final editedWords = List<WordEntities>.from(
          fileDetail.transcriptionResult?.words ?? [],
        );

        emit(state.copyWith(
          status: TranscriptDetailStatus.loaded,
          fileDetail: fileDetail,
          editedWords: editedWords,
        ));

        _loadStreamUrl(fileId: fileId, token: token);
      },
    );
  }

  Future<void> _loadStreamUrl({
    required String fileId,
    required String token,
  }) async {
    final result = await getStreamUrlUseCase.call(fileId: fileId, token: token);

    result.fold(
      (error) {
        debugPrint('Failed to load stream URL: $error');
      },
      (streamUrl) {
        emit(state.copyWith(streamUrl: streamUrl));

        if (streamUrl.url != null && streamUrl.url!.isNotEmpty) {
          _initializeAudio(streamUrl.url!);
        }
      },
    );
  }

  Future<void> _initializeAudio(String url) async {
    final player = _audioPlayer;
    if (player == null) return;

    try {
      emit(state.copyWith(
        audioStatus: AudioPlayerStatus.loading,
        isLoadingWaveform: true,
      ));

      await player.setUrl(url);
      await _generateWaveformData(url);

      if (!isClosed) {
        emit(state.copyWith(
          audioStatus: AudioPlayerStatus.ready,
          isLoadingWaveform: false,
        ));
      }
    } catch (e) {
      debugPrint('Error initializing audio: $e');
      if (!isClosed) {
        emit(state.copyWith(
          audioStatus: AudioPlayerStatus.error,
          isLoadingWaveform: false,
        ));
      }
    }
  }

  Future<void> _generateWaveformData(String url) async {
    try {
      final uri = Uri.tryParse(url);
      if (uri == null) {
        _generateFallbackWaveform();
        return;
      }

      final client = HttpClient();
      final request = await client.getUrl(uri);
      final response = await request.close();

      if (response.statusCode != 200) {
        _generateFallbackWaveform();
        client.close();
        return;
      }

      final bytes = await _consolidateHttpClientResponseBytes(response);
      final waveformData = _extractWaveformFromBytes(bytes);

      if (!isClosed) {
        emit(state.copyWith(waveformData: waveformData));
      }

      client.close();
    } catch (e) {
      debugPrint('Error generating waveform: $e');
      _generateFallbackWaveform();
    }
  }

  Future<Uint8List> _consolidateHttpClientResponseBytes(
      HttpClientResponse response) async {
    final chunks = <List<int>>[];
    await for (final chunk in response) {
      chunks.add(chunk);
    }
    final totalLength = chunks.fold<int>(0, (sum, chunk) => sum + chunk.length);
    final result = Uint8List(totalLength);
    var offset = 0;
    for (final chunk in chunks) {
      result.setRange(offset, offset + chunk.length, chunk);
      offset += chunk.length;
    }
    return result;
  }

  List<double> _extractWaveformFromBytes(Uint8List bytes) {
    const int barCount = 100;
    final List<double> waveform = [];

    const int headerOffset = 100;
    if (bytes.length <= headerOffset) {
      return List.generate(barCount, (_) => 0.3);
    }

    final audioBytes = bytes.sublist(headerOffset);
    final int samplesPerBar = audioBytes.length ~/ barCount;

    for (int i = 0; i < barCount; i++) {
      final int start = i * samplesPerBar;
      final int end = (start + samplesPerBar).clamp(0, audioBytes.length);

      if (start >= audioBytes.length) {
        waveform.add(0.1);
        continue;
      }

      double sum = 0;
      int count = 0;
      for (int j = start; j < end; j++) {
        final int sample = (audioBytes[j] - 128).abs();
        sum += sample;
        count++;
      }

      final double avg = count > 0 ? sum / count : 0;
      final double normalized = (avg / 128).clamp(0.05, 1.0);
      waveform.add(normalized);
    }

    return _smoothWaveform(waveform);
  }

  List<double> _smoothWaveform(List<double> data) {
    if (data.length < 3) return data;

    final smoothed = <double>[];
    for (int i = 0; i < data.length; i++) {
      if (i == 0 || i == data.length - 1) {
        smoothed.add(data[i]);
      } else {
        final avg = (data[i - 1] + data[i] + data[i + 1]) / 3;
        smoothed.add(avg);
      }
    }
    return smoothed;
  }

  void _generateFallbackWaveform() {
    if (isClosed) return;

    final List<double> fallback = List.generate(100, (index) {
      final double base = 0.3;
      final double variation = 0.4 * (index % 7) / 7;
      return (base + variation).clamp(0.1, 0.9);
    });
    emit(state.copyWith(waveformData: fallback));
  }

  // ==================== AUDIO CONTROLS ====================

  Future<void> play() async {
    await _audioPlayer?.play();
  }

  Future<void> pause() async {
    await _audioPlayer?.pause();
  }

  Future<void> togglePlayPause() async {
    if (state.isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> seekTo(Duration position) async {
    await _audioPlayer?.seek(position);
  }

  Future<void> seekToMilliseconds(int milliseconds) async {
    await _audioPlayer?.seek(Duration(milliseconds: milliseconds));
  }

  Future<void> seekToWord(int wordIndex) async {
    final words = state.displayWords;
    if (wordIndex < 0 || wordIndex >= words.length) return;

    final word = words[wordIndex];
    if (word.start != null) {
      await seekToMilliseconds(word.start!);
      emit(state.copyWith(highlightedWordIndex: wordIndex));

      if (!state.isPlaying) {
        await play();
      }
    }
  }

  void seekToProgress(double progress) {
    final position = Duration(
      milliseconds: (state.totalDuration.inMilliseconds * progress).toInt(),
    );
    seekTo(position);
  }

  Future<void> skipForward({int seconds = 10}) async {
    final newPosition = state.currentPosition + Duration(seconds: seconds);
    final clampedPosition = newPosition > state.totalDuration
        ? state.totalDuration
        : newPosition;
    await seekTo(clampedPosition);
  }

  Future<void> skipBackward({int seconds = 10}) async {
    final newPosition = state.currentPosition - Duration(seconds: seconds);
    final clampedPosition =
        newPosition < Duration.zero ? Duration.zero : newPosition;
    await seekTo(clampedPosition);
  }

  // ==================== UI CONTROLS ====================

  void setSelectedTab(int index) {
    emit(state.copyWith(selectedTabIndex: index));
  }

  void setHighlightedWord(int? index) {
    if (index == null) {
      emit(state.copyWith(clearHighlightedWord: true));
    } else {
      emit(state.copyWith(highlightedWordIndex: index));
    }
  }

  // ==================== EDITOR FUNCTIONS ====================

  void enterEditMode() {
    final currentWords = List<WordEntities>.from(
      state.fileDetail.transcriptionResult?.words ?? [],
    );
    emit(state.copyWith(
      isEditMode: true,
      editedWords: currentWords,
    ));
  }

  void exitEditMode({bool discardChanges = false}) {
    if (discardChanges) {
      final originalWords = List<WordEntities>.from(
        state.fileDetail.transcriptionResult?.words ?? [],
      );
      emit(state.copyWith(
        isEditMode: false,
        editedWords: originalWords,
        hasUnsavedChanges: false,
        clearSelectedWordForEdit: true,
      ));
    } else {
      emit(state.copyWith(
        isEditMode: false,
        clearSelectedWordForEdit: true,
      ));
    }
  }

  void selectWordForEdit(int? wordIndex) {
    if (wordIndex == null) {
      emit(state.copyWith(clearSelectedWordForEdit: true));
    } else {
      emit(state.copyWith(selectedWordForEdit: wordIndex));
    }
  }

  void updateWordTextLocally(int wordIndex, String newText) {
    if (wordIndex < 0 || wordIndex >= state.editedWords.length) return;

    final updatedWords = List<WordEntities>.from(state.editedWords);
    final oldWord = updatedWords[wordIndex];

    updatedWords[wordIndex] = WordModel(
      text: newText,
      start: oldWord.start,
      end: oldWord.end,
      confidence: oldWord.confidence,
      speaker: oldWord.speaker,
    );

    emit(state.copyWith(
      editedWords: updatedWords,
      hasUnsavedChanges: true,
    ));
  }

  void updateWordSpeakerLocally(int wordIndex, String newSpeaker) {
    if (wordIndex < 0 || wordIndex >= state.editedWords.length) return;

    final updatedWords = List<WordEntities>.from(state.editedWords);
    final oldWord = updatedWords[wordIndex];

    updatedWords[wordIndex] = WordModel(
      text: oldWord.text,
      start: oldWord.start,
      end: oldWord.end,
      confidence: oldWord.confidence,
      speaker: newSpeaker,
    );

    emit(state.copyWith(
      editedWords: updatedWords,
      hasUnsavedChanges: true,
    ));
  }

  void updateUtteranceSpeakerLocally(int utteranceIndex, String newSpeaker) {
    final utterances = state.utterances;
    if (utteranceIndex < 0 || utteranceIndex >= utterances.length) return;

    final utterance = utterances[utteranceIndex];
    final updatedWords = List<WordEntities>.from(state.editedWords);

    for (int i = 0; i < updatedWords.length; i++) {
      final word = updatedWords[i];
      if (word.start != null &&
          utterance.start != null &&
          utterance.end != null) {
        if (word.start! >= utterance.start! && word.start! <= utterance.end!) {
          updatedWords[i] = WordModel(
            text: word.text,
            start: word.start,
            end: word.end,
            confidence: word.confidence,
            speaker: newSpeaker,
          );
        }
      }
    }

    emit(state.copyWith(
      editedWords: updatedWords,
      hasUnsavedChanges: true,
    ));
  }

  Future<void> saveChanges() async {
    if (!state.hasUnsavedChanges) return;
    if (_currentFileId == null || _currentToken == null) return;

    emit(state.copyWith(isUpdatingWord: true));

    // TODO: When API is available, sync changes to server
    await Future.delayed(const Duration(milliseconds: 500));

    emit(state.copyWith(
      isUpdatingWord: false,
      hasUnsavedChanges: false,
    ));
  }

  // ==================== CLEANUP ====================

  @override
  Future<void> close() async {
    await _positionSubscription?.cancel();
    await _durationSubscription?.cancel();
    await _playerStateSubscription?.cancel();
    await _audioPlayer?.dispose();
    _audioPlayer = null;
    return super.close();
  }
}