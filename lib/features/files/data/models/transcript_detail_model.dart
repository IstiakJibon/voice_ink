// ==================== STREAM URL MODEL ====================
import 'package:voice_ink/features/files/domain/entities/transcript_detail_entities.dart';

/// Normalise a timestamp to milliseconds.
/// Providers like AssemblyAI/Speechmatics return integer milliseconds,
/// Deepgram returns double seconds (e.g. 11.84). Detect by type.
int? _parseTimestampMs(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return (value * 1000).round();
  if (value is num) return (value.toDouble() * 1000).round();
  return null;
}

class TranscriptionStatusModel extends TranscriptionStatusEntities {
  const TranscriptionStatusModel({
    super.status,
    super.progress,
    super.error,
  });

  factory TranscriptionStatusModel.fromJson(Map<String, dynamic> json) {
    return TranscriptionStatusModel(
      status: json['status'] as String?,
      progress: (json['progress'] as num?)?.toDouble(),
      error: json['error'] as String?,
    );
  }
}

class StreamUrlModel extends StreamUrlEntities {
  const StreamUrlModel({
    super.url,
    super.expiresAt,
  });

  factory StreamUrlModel.fromJson(Map<String, dynamic> json) {
    return StreamUrlModel(
      url: json['url'],
      expiresAt: json['expiresAt'],
    );
  }
}

// ==================== TRANSCRIPTION RESULT META MODEL ====================
class TranscriptionResultMetaModel extends TranscriptionResultMetaEntities {
  const TranscriptionResultMetaModel({
    super.id,
    super.provider,
    super.model,
    super.displayName,
    super.attemptNumber,
    super.isPrimary,
    super.createdAt,
    super.confidence,
    super.wordCount,
    super.duration,
    super.featuresEnabled,
  });

  factory TranscriptionResultMetaModel.fromJson(Map<String, dynamic> json) {
    return TranscriptionResultMetaModel(
      id: json['id'],
      provider: json['provider'],
      model: json['model'],
      displayName: json['displayName'],
      attemptNumber: json['attemptNumber'],
      isPrimary: json['isPrimary'],
      createdAt: json['createdAt'],
      confidence: json['confidence'] != null
          ? (json['confidence'] as num).toDouble()
          : null,
      wordCount: json['wordCount'],
      duration: json['duration'] != null
          ? (json['duration'] as num).toInt()
          : null,
      featuresEnabled: json['featuresEnabled'] != null
          ? List<String>.from(json['featuresEnabled'])
          : null,
    );
  }
}

// ==================== TRANSCRIPTION RESULTS LIST MODEL ====================
class TranscriptionResultsListModel extends TranscriptionResultsListEntities {
  const TranscriptionResultsListModel({
    super.results,
    super.primaryResultId,
    super.totalAttempts,
  });

  factory TranscriptionResultsListModel.fromJson(Map<String, dynamic> json) {
    return TranscriptionResultsListModel(
      results: json['results'] != null
          ? List<TranscriptionResultMetaEntities>.from(
              (json['results'] as List)
                  .map((e) => TranscriptionResultMetaModel.fromJson(e)),
            )
          : <TranscriptionResultMetaEntities>[],
      primaryResultId: json['primaryResultId'],
      totalAttempts: json['totalAttempts'],
    );
  }
}

// ==================== WORD MODEL ====================
class WordModel extends WordEntities {
  const WordModel({
    super.text,
    super.start,
    super.end,
    super.confidence,
    super.speaker,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      text: json['text'],
      start: _parseTimestampMs(json['start']),
      end: _parseTimestampMs(json['end']),
      confidence: json['confidence'] != null
          ? (json['confidence'] as num).toDouble()
          : null,
      speaker: json['speaker'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'start': start,
      'end': end,
      'confidence': confidence,
      'speaker': speaker,
    };
  }

  WordModel copyWith({
    String? text,
    int? start,
    int? end,
    double? confidence,
    String? speaker,
  }) {
    return WordModel(
      text: text ?? this.text,
      start: start ?? this.start,
      end: end ?? this.end,
      confidence: confidence ?? this.confidence,
      speaker: speaker ?? this.speaker,
    );
  }
}

// ==================== UTTERANCE MODEL ====================
class UtteranceModel extends UtteranceEntities {
  const UtteranceModel({
    super.speaker,
    super.text,
    super.confidence,
    super.start,
    super.end,
    super.words,
  });

  factory UtteranceModel.fromJson(Map<String, dynamic> json) {
    return UtteranceModel(
      speaker: json['speaker'],
      text: json['text'],
      confidence: json['confidence'] != null
          ? (json['confidence'] as num).toDouble()
          : null,
      start: _parseTimestampMs(json['start']),
      end: _parseTimestampMs(json['end']),
      words: json['words'] != null
          ? (json['words'] as List).map((e) => WordModel.fromJson(e)).toList()
          : [],
    );
  }

  UtteranceModel copyWith({
    String? speaker,
    String? text,
    double? confidence,
    int? start,
    int? end,
    List<WordEntities>? words,
  }) {
    return UtteranceModel(
      speaker: speaker ?? this.speaker,
      text: text ?? this.text,
      confidence: confidence ?? this.confidence,
      start: start ?? this.start,
      end: end ?? this.end,
      words: words ?? this.words,
    );
  }
}

// ==================== TRANSCRIPTION RESULT MODEL ====================
class TranscriptionResultModel extends TranscriptionResultEntities {
  const TranscriptionResultModel({
    super.id,
    super.jobId,
    super.transcriptText,
    super.confidenceScore,
    super.words,
    super.utterances,
    super.provider,
    super.createdAt,
    super.updatedAt,
    super.chapters,
    super.autoHighlights,
    super.sentimentAnalysis,
    super.entities,
    super.summary,
    super.keyPoints,
    super.actionItems,
    super.sentiment,
  });

  factory TranscriptionResultModel.fromJson(Map<String, dynamic> json) {
    return TranscriptionResultModel(
      id: json['id'],
      jobId: json['job_id'],
      transcriptText: json['transcript_text'],
      confidenceScore: json['confidence_score'],
      words: json['words'] != null
          ? (json['words'] as List).map((e) => WordModel.fromJson(e)).toList()
          : [],
      utterances: json['utterances'] != null
          ? (json['utterances'] as List)
              .map((e) => UtteranceModel.fromJson(e))
              .toList()
          : [],
      provider: json['provider'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      chapters: json['chapters'],
      autoHighlights: json['auto_highlights'],
      sentimentAnalysis: json['sentiment_analysis'],
      entities: json['entities'],
      summary: json['summary'],
      keyPoints: json['key_points'],
      actionItems: json['action_items'],
      sentiment: json['sentiment'],
    );
  }
}

// ==================== FILE METADATA MODEL ====================
class FileMetadataModel extends FileMetadataEntities {
  const FileMetadataModel({
    super.source,
    super.cloudStored,
    super.contentType,
  });

  factory FileMetadataModel.fromJson(Map<String, dynamic> json) {
    return FileMetadataModel(
      source: json['source'],
      cloudStored: json['cloud_stored'],
      contentType: json['content_type'],
    );
  }
}

// ==================== USER ROLE MODEL ====================
class UserRoleModel extends UserRoleEntities {
  const UserRoleModel({super.id, super.name});

  factory UserRoleModel.fromJson(Map<String, dynamic> json) {
    return UserRoleModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

// ==================== USER STATUS MODEL ====================
class UserStatusModel extends UserStatusEntities {
  const UserStatusModel({super.id, super.name});

  factory UserStatusModel.fromJson(Map<String, dynamic> json) {
    return UserStatusModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

// ==================== FILE USER MODEL ====================
class FileUserModel extends FileUserEntities {
  const FileUserModel({
    super.id,
    super.firstName,
    super.lastName,
    super.phone,
    super.photo,
    super.avatarUrl,
    super.role,
    super.subscriptionTier,
    super.status,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
  });

  factory FileUserModel.fromJson(Map<String, dynamic> json) {
    return FileUserModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      photo: json['photo'],
      avatarUrl: json['avatarUrl'],
      role: json['role'] != null ? UserRoleModel.fromJson(json['role']) : null,
      subscriptionTier: json['subscriptionTier'],
      status: json['status'] != null
          ? UserStatusModel.fromJson(json['status'])
          : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
  }
}

// ==================== FILE DETAIL MODEL ====================
class FileDetailModel extends FileDetailEntities {
  const FileDetailModel({
    super.id,
    super.path,
    super.name,
    super.originalFilename,
    super.mimetype,
    super.type,
    super.status,
    super.size,
    super.duration,
    super.audioFormat,
    super.sampleRate,
    super.channels,
    super.bitrate,
    super.description,
    super.tags,
    super.userId,
    super.folderId,
    super.source,
    super.metadata,
    super.errorMessage,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
    super.processedAt,
    super.isFavorite,
    super.user,
    super.transcriptionStatus,
    super.transcriptionResult,
  });

  factory FileDetailModel.fromJson(Map<String, dynamic> json) {
    return FileDetailModel(
      id: json['id'],
      path: json['path'],
      name: json['name'],
      originalFilename: json['original_filename'],
      mimetype: json['mimetype'],
      type: json['type'],
      status: json['status'],
      size: json['size'],
      duration: _parseDuration(json['duration']),
      audioFormat: json['audio_format'],
      sampleRate: json['sample_rate'],
      channels: json['channels'],
      bitrate: json['bitrate'],
      description: json['description'],
      tags: json['tags'],
      userId: json['user_id'],
      folderId: json['folder_id'],
      source: json['source'],
      metadata: json['metadata'] != null
          ? FileMetadataModel.fromJson(json['metadata'])
          : null,
      errorMessage: json['error_message'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      processedAt: json['processed_at'],
      isFavorite: json['isFavorite'],
      user: json['user'] != null ? FileUserModel.fromJson(json['user']) : null,
      transcriptionStatus: json['transcriptionStatus'],
      transcriptionResult: json['transcriptionResult'] != null
          ? TranscriptionResultModel.fromJson(json['transcriptionResult'])
          : null,
    );
  }

  static int _parseDuration(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }
}
