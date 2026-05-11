import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_ink/features/files/domain/usecases/transcript_detail_usecase.dart';
import 'package:voice_ink/features/files/presentation/cubit/re_transcribe/re_transcribe_state.dart';

class ReTranscribeCubit extends Cubit<ReTranscribeState> {
  final TranscribeFileUseCase transcribeFileUseCase;
  final GetTranscriptionStatusUseCase getTranscriptionStatusUseCase;

  ReTranscribeCubit({
    required this.transcribeFileUseCase,
    required this.getTranscriptionStatusUseCase,
  }) : super(const ReTranscribeState());

  Timer? _pollingTimer;

  Future<void> reTranscribe({
    required String fileId,
    required String provider,
    required String engineDisplayName,
    required String token,
    String language = 'en',
    bool speakerLabels = true,
    bool sentimentAnalysis = false,
    bool entityDetection = false,
    bool topicDetection = false,
    bool autoHighlights = false,
    bool contentSafety = false,
    bool summarization = false,
    bool autoChapters = false,
    bool filterProfanity = false,
  }) async {
    _pollingTimer?.cancel();

    emit(ReTranscribeState(
      status: ReTranscribeStatus.triggering,
      engineDisplayName: engineDisplayName,
    ));

    final result = await transcribeFileUseCase(
      fileId: fileId,
      provider: provider,
      token: token,
      language: language,
      speakerLabels: speakerLabels,
      sentimentAnalysis: sentimentAnalysis,
      entityDetection: entityDetection,
      topicDetection: topicDetection,
      autoHighlights: autoHighlights,
      contentSafety: contentSafety,
      summarization: summarization,
      autoChapters: autoChapters,
      filterProfanity: filterProfanity,
    );

    await result.fold(
      (error) async {
        emit(state.copyWith(
          status: ReTranscribeStatus.failure,
          errorMessage: error,
        ));
      },
      (_) async {
        emit(state.copyWith(status: ReTranscribeStatus.polling));
        _startPolling(fileId: fileId, token: token);
      },
    );
  }

  void _startPolling({required String fileId, required String token}) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      final result = await getTranscriptionStatusUseCase(
        fileId: fileId,
        token: token,
      );

      if (isClosed) return;

      result.fold(
        (error) {
          _pollingTimer?.cancel();
          emit(state.copyWith(
            status: ReTranscribeStatus.failure,
            errorMessage: error,
          ));
        },
        (status) {
          if (status.progress != null) {
            emit(state.copyWith(progress: status.progress));
          }
          final s = status.status;
          if (s == 'completed') {
            _pollingTimer?.cancel();
            emit(state.copyWith(status: ReTranscribeStatus.success));
          } else if (s == 'failed') {
            _pollingTimer?.cancel();
            emit(state.copyWith(
              status: ReTranscribeStatus.failure,
              errorMessage: status.error ?? 'Transcription failed',
            ));
          }
        },
      );
    });
  }

  void reset() {
    _pollingTimer?.cancel();
    emit(const ReTranscribeState());
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}
