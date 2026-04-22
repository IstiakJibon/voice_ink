import 'package:voice_ink/features/files/domain/entities/audio_file_entities.dart';

class AudioFileListModel extends AudioFileListEntities {
  AudioFileListModel({
    required super.data,
    required super.total,
    required super.page,
    required super.limit,
    required super.totalPages,
    required super.hasMore,
  });

  factory AudioFileListModel.fromJson(Map<String, dynamic> json) {
    return AudioFileListModel(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => AudioFileModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
      hasMore: json['hasMore'],
    );
  }
}

class AudioFileModel extends AudioFileEntity {
  AudioFileModel({
    required super.id,
    required super.path,
    required super.name,
    required super.originalFilename,
    required super.mimetype,
    required super.type,
    required super.status,
    required super.size,
    required super.duration,
    required super.audioFormat,
    required super.sampleRate,
    required super.channels,
    required super.bitrate,
    required super.description,
    required super.tags,
    required super.userId,
    required super.folderId,
    required super.source,
    required super.metadata,
    required super.errorMessage,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
    required super.processedAt,
    required super.isFavorite,
    required super.transcriptionStatus,
  });

  factory AudioFileModel.fromJson(Map<String, dynamic> json) {
    return AudioFileModel(
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
          ? AudioFileMetadataModel.fromJson(json['metadata'])
          : null,
      errorMessage: json['error_message'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.tryParse(json['deletedAt'])
          : null,
      processedAt: json['processedAt'] != null
          ? DateTime.tryParse(json['processedAt'])
          : null,
      isFavorite: json['isFavorite'],
      transcriptionStatus: json['transcriptionStatus'],  // Can be null
    );
  }

  /// Parse duration from either String or int
  static int _parseDuration(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) return parsed.toInt();
    }
    return 0;
  }
}

class AudioFileMetadataModel extends AudioFileMetadata {
  AudioFileMetadataModel({
    required super.source,
    required super.cloudStored,
    required super.contentType,
  });

  factory AudioFileMetadataModel.fromJson(Map<String, dynamic> json) {
    return AudioFileMetadataModel(
      source: json['source'],
      cloudStored: json['cloud_stored'],
      contentType: json['content_type'],
    );
  }
}