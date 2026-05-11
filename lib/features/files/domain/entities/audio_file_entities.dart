import 'package:equatable/equatable.dart';

class AudioFileListEntities extends Equatable {
  final List<AudioFileEntity> data;
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasMore;

  const AudioFileListEntities({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasMore,
  });

  factory AudioFileListEntities.empty() {
    return const AudioFileListEntities(
      data: [],
      total: 0,
      page: 1,
      limit: 20,
      totalPages: 1,
      hasMore: false,
    );
  }

  AudioFileListEntities copyWith({
    List<AudioFileEntity>? data,
    int? total,
    int? page,
    int? limit,
    int? totalPages,
    bool? hasMore,
  }) {
    return AudioFileListEntities(
      data: data ?? this.data,
      total: total ?? this.total,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [data, total, page, limit, totalPages, hasMore];
}

class AudioFileEntity extends Equatable {
  final String? id;
  final String? path;
  final String? name;
  final String? originalFilename;
  final String? mimetype;
  final String? type;
  final String? status;
  final String? size;
  final int duration;
  final String? audioFormat;
  final int? sampleRate;
  final int? channels;
  final int? bitrate;
  final String? description;
  final dynamic tags;
  final String? userId;
  final String? folderId;
  final String? source;
  final AudioFileMetadata? metadata;
  final String? errorMessage;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final DateTime? processedAt;
  final bool? isFavorite;
  final String? transcriptionStatus;  // Made nullable

  const AudioFileEntity({
    required this.id,
    required this.path,
    required this.name,
    required this.originalFilename,
    required this.mimetype,
    required this.type,
    required this.status,
    required this.size,
    required this.duration,
    required this.audioFormat,
    required this.sampleRate,
    required this.channels,
    required this.bitrate,
    required this.description,
    required this.tags,
    required this.userId,
    required this.folderId,
    required this.source,
    required this.metadata,
    required this.errorMessage,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.processedAt,
    required this.isFavorite,
    required this.transcriptionStatus,
  });

  AudioFileEntity copyWith({
    String? id,
    String? path,
    String? name,
    String? originalFilename,
    String? mimetype,
    String? type,
    String? status,
    String? size,
    int? duration,
    String? audioFormat,
    int? sampleRate,
    int? channels,
    int? bitrate,
    String? description,
    dynamic tags,
    String? userId,
    String? folderId,
    String? source,
    AudioFileMetadata? metadata,
    String? errorMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    DateTime? processedAt,
    bool? isFavorite,
    String? transcriptionStatus,
  }) {
    return AudioFileEntity(
      id: id ?? this.id,
      path: path ?? this.path,
      name: name ?? this.name,
      originalFilename: originalFilename ?? this.originalFilename,
      mimetype: mimetype ?? this.mimetype,
      type: type ?? this.type,
      status: status ?? this.status,
      size: size ?? this.size,
      duration: duration ?? this.duration,
      audioFormat: audioFormat ?? this.audioFormat,
      sampleRate: sampleRate ?? this.sampleRate,
      channels: channels ?? this.channels,
      bitrate: bitrate ?? this.bitrate,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      userId: userId ?? this.userId,
      folderId: folderId ?? this.folderId,
      source: source ?? this.source,
      metadata: metadata ?? this.metadata,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      processedAt: processedAt ?? this.processedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      transcriptionStatus: transcriptionStatus ?? this.transcriptionStatus,
    );
  }

  /// Get formatted duration string (MM:SS or HH:MM:SS). Returns "—:—" when
  /// the backend hasn't populated the duration yet (e.g. right after upload).
  String get formattedDuration {
    if (duration <= 0) return '—:—';

    final hours = duration ~/ 3600;
    final minutes = (duration % 3600) ~/ 60;
    final seconds = duration % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get formatted date string
  String get formattedDate {
    if (createdAt == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final fileDate = DateTime(createdAt!.year, createdAt!.month, createdAt!.day);

    if (fileDate == today) {
      final difference = now.difference(createdAt!);
      if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (fileDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${_monthName(createdAt!.month)} ${createdAt!.day}';
    }
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  /// Get date group (TODAY, YESTERDAY, OLDER)
  String get dateGroup {
    if (createdAt == null) return 'OLDER';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final fileDate = DateTime(createdAt!.year, createdAt!.month, createdAt!.day);

    if (fileDate == today) {
      return 'TODAY';
    } else if (fileDate == yesterday) {
      return 'YESTERDAY';
    } else {
      return 'OLDER';
    }
  }

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
        transcriptionStatus,
      ];
}

class AudioFileMetadata extends Equatable {
  final String? source;
  final bool? cloudStored;
  final String? contentType;

  const AudioFileMetadata({
    required this.source,
    required this.cloudStored,
    required this.contentType,
  });

  @override
  List<Object?> get props => [source, cloudStored, contentType];
}