import 'package:equatable/equatable.dart';

// ==================== STREAM URL ====================
class StreamUrlEntities extends Equatable {
  final String? url;
  final String? expiresAt;

  const StreamUrlEntities({
    this.url,
    this.expiresAt,
  });

  factory StreamUrlEntities.empty() => const StreamUrlEntities();

  @override
  List<Object?> get props => [url, expiresAt];
}

// ==================== TRANSCRIPTION RESULT META ====================
class TranscriptionResultMetaEntities extends Equatable {
  final String? id;
  final String? provider;
  final String? model;
  final String? displayName;
  final int? attemptNumber;
  final bool? isPrimary;
  final String? createdAt;
  final double? confidence;
  final int? wordCount;
  final int? duration;
  final List<String>? featuresEnabled;

  const TranscriptionResultMetaEntities({
    this.id,
    this.provider,
    this.model,
    this.displayName,
    this.attemptNumber,
    this.isPrimary,
    this.createdAt,
    this.confidence,
    this.wordCount,
    this.duration,
    this.featuresEnabled,
  });

  factory TranscriptionResultMetaEntities.empty() =>
      const TranscriptionResultMetaEntities();

  @override
  List<Object?> get props => [
        id,
        provider,
        model,
        displayName,
        attemptNumber,
        isPrimary,
        createdAt,
        confidence,
        wordCount,
        duration,
        featuresEnabled,
      ];
}

// ==================== TRANSCRIPTION RESULTS LIST ====================
class TranscriptionResultsListEntities extends Equatable {
  final List<TranscriptionResultMetaEntities> results;
  final String? primaryResultId;
  final int? totalAttempts;

  const TranscriptionResultsListEntities({
    this.results = const [],
    this.primaryResultId,
    this.totalAttempts,
  });

  factory TranscriptionResultsListEntities.empty() =>
      const TranscriptionResultsListEntities();

  @override
  List<Object?> get props => [results, primaryResultId, totalAttempts];
}

// ==================== WORD ====================
class WordEntities extends Equatable {
  final String? text;
  final int? start; // milliseconds
  final int? end; // milliseconds
  final double? confidence;
  final String? speaker;

  const WordEntities({
    this.text,
    this.start,
    this.end,
    this.confidence,
    this.speaker,
  });

  /// Start time in seconds (for audio seeking)
  double get startSeconds => (start ?? 0) / 1000.0;

  /// End time in seconds
  double get endSeconds => (end ?? 0) / 1000.0;

  /// Duration in seconds
  double get durationSeconds => endSeconds - startSeconds;

  /// Formatted timestamp (MM:SS or HH:MM:SS)
  String get formattedStart {
    final totalSeconds = (start ?? 0) ~/ 1000;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString()}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  List<Object?> get props => [text, start, end, confidence, speaker];
}

// ==================== UTTERANCE ====================
class UtteranceEntities extends Equatable {
  final String? speaker;
  final String? text;
  final double? confidence;
  final int? start; // milliseconds
  final int? end; // milliseconds
  final List<WordEntities> words;

  const UtteranceEntities({
    this.speaker,
    this.text,
    this.confidence,
    this.start,
    this.end,
    this.words = const [],
  });

  /// Start time in seconds
  double get startSeconds => (start ?? 0) / 1000.0;

  /// Formatted timestamp
  String get formattedStart {
    final totalSeconds = (start ?? 0) ~/ 1000;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString()}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  List<Object?> get props => [speaker, text, confidence, start, end, words];
}

// ==================== TRANSCRIPTION RESULT (Full) ====================
class TranscriptionResultEntities extends Equatable {
  final String? id;
  final String? jobId;
  final String? transcriptText;
  final String? confidenceScore;
  final List<WordEntities> words;
  final List<UtteranceEntities> utterances;
  final String? provider;
  final String? createdAt;
  final String? updatedAt;
  final dynamic chapters;
  final dynamic autoHighlights;
  final dynamic sentimentAnalysis;
  final dynamic entities;
  final dynamic summary;
  final List<dynamic>? keyPoints;
  final List<dynamic>? actionItems;
  final dynamic sentiment;

  const TranscriptionResultEntities({
    this.id,
    this.jobId,
    this.transcriptText,
    this.confidenceScore,
    this.words = const [],
    this.utterances = const [],
    this.provider,
    this.createdAt,
    this.updatedAt,
    this.chapters,
    this.autoHighlights,
    this.sentimentAnalysis,
    this.entities,
    this.summary,
    this.keyPoints,
    this.actionItems,
    this.sentiment,
  });

  factory TranscriptionResultEntities.empty() =>
      const TranscriptionResultEntities();

  /// Get confidence as double (0-1)
  double get confidenceValue {
    if (confidenceScore == null) return 0.0;
    return double.tryParse(confidenceScore!) ?? 0.0;
  }

  /// Get confidence as percentage string
  String get confidencePercent {
    return '${(confidenceValue * 100).toInt()}%';
  }

  /// Get word count
  int get wordCount => words.length;

  /// Get unique speakers
  List<String> get speakers {
    final speakerSet = <String>{};
    for (final word in words) {
      if (word.speaker != null) {
        speakerSet.add(word.speaker!);
      }
    }
    return speakerSet.toList()..sort();
  }

  @override
  List<Object?> get props => [
        id,
        jobId,
        transcriptText,
        confidenceScore,
        words,
        utterances,
        provider,
        createdAt,
        updatedAt,
        chapters,
        autoHighlights,
        sentimentAnalysis,
        entities,
        summary,
        keyPoints,
        actionItems,
        sentiment,
      ];
}

// ==================== FILE METADATA ====================
class FileMetadataEntities extends Equatable {
  final String? source;
  final bool? cloudStored;
  final String? contentType;

  const FileMetadataEntities({
    this.source,
    this.cloudStored,
    this.contentType,
  });

  @override
  List<Object?> get props => [source, cloudStored, contentType];
}

// ==================== USER ROLE ====================
class UserRoleEntities extends Equatable {
  final int? id;
  final String? name;

  const UserRoleEntities({this.id, this.name});

  @override
  List<Object?> get props => [id, name];
}

// ==================== USER STATUS ====================
class UserStatusEntities extends Equatable {
  final int? id;
  final String? name;

  const UserStatusEntities({this.id, this.name});

  @override
  List<Object?> get props => [id, name];
}

// ==================== FILE USER ====================
class FileUserEntities extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? photo;
  final String? avatarUrl;
  final UserRoleEntities? role;
  final String? subscriptionTier;
  final UserStatusEntities? status;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  const FileUserEntities({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.photo,
    this.avatarUrl,
    this.role,
    this.subscriptionTier,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        phone,
        photo,
        avatarUrl,
        role,
        subscriptionTier,
        status,
        createdAt,
        updatedAt,
        deletedAt,
      ];
}

// ==================== FILE DETAIL (Main Entity) ====================
class FileDetailEntities extends Equatable {
  final String? id;
  final String? path;
  final String? name;
  final String? originalFilename;
  final String? mimetype;
  final String? type;
  final String? status;
  final String? size;
  final int duration; // seconds
  final String? audioFormat;
  final int? sampleRate;
  final int? channels;
  final int? bitrate;
  final String? description;
  final dynamic tags;
  final String? userId;
  final String? folderId;
  final String? source;
  final FileMetadataEntities? metadata;
  final String? errorMessage;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? processedAt;
  final bool? isFavorite;
  final FileUserEntities? user;
  final String? transcriptionStatus;
  final TranscriptionResultEntities? transcriptionResult;

  const FileDetailEntities({
    this.id,
    this.path,
    this.name,
    this.originalFilename,
    this.mimetype,
    this.type,
    this.status,
    this.size,
    this.duration = 0,
    this.audioFormat,
    this.sampleRate,
    this.channels,
    this.bitrate,
    this.description,
    this.tags,
    this.userId,
    this.folderId,
    this.source,
    this.metadata,
    this.errorMessage,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.processedAt,
    this.isFavorite,
    this.user,
    this.transcriptionStatus,
    this.transcriptionResult,
  });

  factory FileDetailEntities.empty() => const FileDetailEntities();

  /// Formatted duration (MM:SS or HH:MM:SS)
  String get formattedDuration {
    final hours = duration ~/ 3600;
    final minutes = (duration % 3600) ~/ 60;
    final seconds = duration % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString()}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Formatted date (e.g., "Apr 13, 2026")
  String get formattedDate {
    if (createdAt == null) return '';
    final date = DateTime.tryParse(createdAt!);
    if (date == null) return '';

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// Formatted date with time
  String get formattedDateTime {
    if (createdAt == null) return '';
    final date = DateTime.tryParse(createdAt!);
    if (date == null) return '';

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    
    return '${months[date.month - 1]} ${date.day}, ${hour}:$minute $amPm';
  }

  /// File size formatted (e.g., "1.9 MB")
  String get formattedSize {
    if (size == null) return '';
    final bytes = int.tryParse(size!) ?? 0;
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Check if transcription is completed
  bool get isTranscriptionCompleted => transcriptionStatus == 'completed';

  /// Check if transcription is processing
  bool get isTranscriptionProcessing =>
      transcriptionStatus == 'processing' || transcriptionStatus == 'pending';

  /// Check if transcription failed
  bool get isTranscriptionFailed => transcriptionStatus == 'failed';

  @override
  List<Object?> get props => [
        id,
        path,
        name,
        originalFilename,
        mimetype,
        type,
        status,
        size,
        duration,
        audioFormat,
        sampleRate,
        channels,
        bitrate,
        description,
        tags,
        userId,
        folderId,
        source,
        metadata,
        errorMessage,
        createdAt,
        updatedAt,
        deletedAt,
        processedAt,
        isFavorite,
        user,
        transcriptionStatus,
        transcriptionResult,
      ];
}
