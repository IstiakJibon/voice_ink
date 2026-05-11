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

// ==================== EXPORT TRANSCRIPT USE CASE ====================
class ExportTranscriptUseCase {
  final TranscriptDetailRepository repository;

  ExportTranscriptUseCase({required this.repository});

  Future<Either<String, List<int>>> call({
    required String transcriptionResultId,
    required String format,
    required bool includeSpeakers,
    required bool includeTimestamps,
    required bool combineParagraphs,
    required bool includeHighlights,
    String? targetLanguage,
    required String token,
  }) {
    return repository.exportTranscript(
      transcriptionResultId: transcriptionResultId,
      format: format,
      includeSpeakers: includeSpeakers,
      includeTimestamps: includeTimestamps,
      combineParagraphs: combineParagraphs,
      includeHighlights: includeHighlights,
      targetLanguage: targetLanguage,
      token: token,
    );
  }
}

// ==================== TRANSCRIBE FILE USE CASE ====================
class TranscribeFileUseCase {
  final TranscriptDetailRepository repository;

  TranscribeFileUseCase({required this.repository});

  Future<Either<String, bool>> call({
    required String fileId,
    required String provider,
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
  }) {
    return repository.transcribeFile(
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
  }
}

// ==================== GET TRANSCRIPTION STATUS USE CASE ====================
class GetTranscriptionStatusUseCase {
  final TranscriptDetailRepository repository;

  GetTranscriptionStatusUseCase({required this.repository});

  Future<Either<String, TranscriptionStatusEntities>> call({
    required String fileId,
    required String token,
  }) {
    return repository.getTranscriptionStatus(fileId: fileId, token: token);
  }
}

// ==================== GET TRANSCRIPTION RESULT DETAIL USE CASE ====================
class GetTranscriptionResultDetailUseCase {
  final TranscriptDetailRepository repository;

  GetTranscriptionResultDetailUseCase({required this.repository});

  Future<Either<String, TranscriptionResultEntities>> call({
    required String resultId,
    required String token,
  }) {
    return repository.getTranscriptionResultDetail(
      resultId: resultId,
      token: token,
    );
  }
}

// ==================== DELETE TRANSCRIPTION RESULT USE CASE ====================
class DeleteTranscriptionResultUseCase {
  final TranscriptDetailRepository repository;

  DeleteTranscriptionResultUseCase({required this.repository});

  Future<Either<String, bool>> call({
    required String resultId,
    required String token,
  }) {
    return repository.deleteTranscriptionResult(
      resultId: resultId,
      token: token,
    );
  }
}

// ==================== SET PRIMARY TRANSCRIPTION RESULT USE CASE ====================
class SetPrimaryTranscriptionResultUseCase {
  final TranscriptDetailRepository repository;

  SetPrimaryTranscriptionResultUseCase({required this.repository});

  Future<Either<String, bool>> call({
    required String resultId,
    required String token,
  }) {
    return repository.setPrimaryTranscriptionResult(
      resultId: resultId,
      token: token,
    );
  }
}
