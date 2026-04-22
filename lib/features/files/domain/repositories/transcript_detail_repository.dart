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
}
