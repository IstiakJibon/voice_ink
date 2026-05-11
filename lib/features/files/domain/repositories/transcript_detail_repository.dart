import 'package:dartz/dartz.dart';
import 'package:voice_ink/features/files/domain/entities/transcript_detail_entities.dart';

abstract class TranscriptDetailRepository {
  /// Get full file details including transcription result
  Future<Either<String, FileDetailEntities>> getFileDetail({
    required String fileId,
    required String token,
  });

  /// Get signed stream URL for audio playback
  Future<Either<String, StreamUrlEntities>> getStreamUrl({
    required String fileId,
    required String token,
  });

  /// Get transcription results metadata list
  Future<Either<String, TranscriptionResultsListEntities>>
      getTranscriptionResults({
    required String fileId,
    required String token,
  });

  /// Update word text (for editor)
  Future<Either<String, bool>> updateWordText({
    required String fileId,
    required String resultId,
    required int wordIndex,
    required String newText,
    required String token,
  });

  /// Update word speaker (for editor)
  Future<Either<String, bool>> updateWordSpeaker({
    required String fileId,
    required String resultId,
    required int wordIndex,
    required String newSpeaker,
    required String token,
  });

  /// Export transcript as a file (binary)
  Future<Either<String, List<int>>> exportTranscript({
    required String transcriptionResultId,
    required String format,
    required bool includeSpeakers,
    required bool includeTimestamps,
    required bool combineParagraphs,
    required bool includeHighlights,
    String? targetLanguage,
    required String token,
  });

  /// Trigger transcription / re-transcription with the selected provider and
  /// optional feature flags (used by both the first-run "Start Transcription"
  /// flow and the engine-popup "Re-transcribe" flow).
  Future<Either<String, bool>> transcribeFile({
    required String fileId,
    required String provider,
    required String token,
    String language,
    bool speakerLabels,
    bool sentimentAnalysis,
    bool entityDetection,
    bool topicDetection,
    bool autoHighlights,
    bool contentSafety,
    bool summarization,
    bool autoChapters,
    bool filterProfanity,
  });

  /// Poll the transcription status
  Future<Either<String, TranscriptionStatusEntities>> getTranscriptionStatus({
    required String fileId,
    required String token,
  });

  /// Get the full detail of a specific transcription result (for switching views)
  Future<Either<String, TranscriptionResultEntities>>
      getTranscriptionResultDetail({
    required String resultId,
    required String token,
  });

  /// Delete a specific transcription result
  Future<Either<String, bool>> deleteTranscriptionResult({
    required String resultId,
    required String token,
  });

  /// Mark a result as primary for the file
  Future<Either<String, bool>> setPrimaryTranscriptionResult({
    required String resultId,
    required String token,
  });
}
