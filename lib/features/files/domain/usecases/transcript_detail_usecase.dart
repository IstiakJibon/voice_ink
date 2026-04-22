import 'package:dartz/dartz.dart';
import 'package:voice_ink/features/files/domain/entities/transcript_detail_entities.dart';
import 'package:voice_ink/features/files/domain/repositories/transcript_detail_repository.dart';

// ==================== GET FILE DETAIL USE CASE ====================
class GetFileDetailUseCase {
  final TranscriptDetailRepository repository;

  GetFileDetailUseCase({required this.repository});

  Future<Either<String, FileDetailEntities>> call({
    required String fileId,
    required String token,
  }) {
    return repository.getFileDetail(fileId: fileId, token: token);
  }
}

// ==================== GET STREAM URL USE CASE ====================
class GetStreamUrlUseCase {
  final TranscriptDetailRepository repository;

  GetStreamUrlUseCase({required this.repository});

  Future<Either<String, StreamUrlEntities>> call({
    required String fileId,
    required String token,
  }) {
    return repository.getStreamUrl(fileId: fileId, token: token);
  }
}

// ==================== GET TRANSCRIPTION RESULTS USE CASE ====================
class GetTranscriptionResultsUseCase {
  final TranscriptDetailRepository repository;

  GetTranscriptionResultsUseCase({required this.repository});

  Future<Either<String, TranscriptionResultsListEntities>> call({
    required String fileId,
    required String token,
  }) {
    return repository.getTranscriptionResults(fileId: fileId, token: token);
  }
}

// ==================== UPDATE WORD TEXT USE CASE ====================
class UpdateWordTextUseCase {
  final TranscriptDetailRepository repository;

  UpdateWordTextUseCase({required this.repository});

  Future<Either<String, bool>> call({
    required String fileId,
    required String resultId,
    required int wordIndex,
    required String newText,
    required String token,
  }) {
    return repository.updateWordText(
      fileId: fileId,
      resultId: resultId,
      wordIndex: wordIndex,
      newText: newText,
      token: token,
    );
  }
}

// ==================== UPDATE WORD SPEAKER USE CASE ====================
class UpdateWordSpeakerUseCase {
  final TranscriptDetailRepository repository;

  UpdateWordSpeakerUseCase({required this.repository});

  Future<Either<String, bool>> call({
    required String fileId,
    required String resultId,
    required int wordIndex,
    required String newSpeaker,
    required String token,
  }) {
    return repository.updateWordSpeaker(
      fileId: fileId,
      resultId: resultId,
      wordIndex: wordIndex,
      newSpeaker: newSpeaker,
      token: token,
    );
  }
}
