import 'package:equatable/equatable.dart';

class PresignedUploadEntity extends Equatable {
  final String? fileId;
  final String? fileName;
  final String? filePath;
  final String? uploadUrl;
  final String? contentType;

  const PresignedUploadEntity({
    required this.fileId,
    required this.fileName,
    required this.filePath,
    required this.uploadUrl,
    required this.contentType,
  });

  @override
  List<Object?> get props => [fileId, fileName, filePath, uploadUrl, contentType];
}

enum UploadStage {
  pending,
  presigning,
  uploading,
  completing,
  done,
  failed,
}

class UploadItem extends Equatable {
  /// Local-only id used to track this item in the cubit until [fileId] arrives.
  final String localId;
  final String name;
  final int size;
  final String localPath;
  final String contentType;
  final UploadStage stage;
  final double progress;
  final String? fileId;
  final String? remotePath;
  final String? errorMessage;

  const UploadItem({
    required this.localId,
    required this.name,
    required this.size,
    required this.localPath,
    required this.contentType,
    this.stage = UploadStage.pending,
    this.progress = 0,
    this.fileId,
    this.remotePath,
    this.errorMessage,
  });

  UploadItem copyWith({
    UploadStage? stage,
    double? progress,
    String? fileId,
    String? remotePath,
    String? errorMessage,
    bool clearError = false,
  }) {
    return UploadItem(
      localId: localId,
      name: name,
      size: size,
      localPath: localPath,
      contentType: contentType,
      stage: stage ?? this.stage,
      progress: progress ?? this.progress,
      fileId: fileId ?? this.fileId,
      remotePath: remotePath ?? this.remotePath,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get isTerminal =>
      stage == UploadStage.done || stage == UploadStage.failed;

  @override
  List<Object?> get props => [
        localId,
        name,
        size,
        localPath,
        contentType,
        stage,
        progress,
        fileId,
        remotePath,
        errorMessage,
      ];
}
