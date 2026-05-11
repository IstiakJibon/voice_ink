import 'package:dartz/dartz.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/features/upload/domain/entities/upload_entity.dart';

class PresignedFileInput {
  final String fileName;
  final int fileSize;
  final String contentType;

  PresignedFileInput({
    required this.fileName,
    required this.fileSize,
    required this.contentType,
  });

  Map<String, dynamic> toJson() => {
        'fileName': fileName,
        'fileSize': fileSize,
        'contentType': contentType,
      };
}

class CompleteUploadInput {
  final String fileId;
  final String filePath;
  final String fileName;

  CompleteUploadInput({
    required this.fileId,
    required this.filePath,
    required this.fileName,
  });

  Map<String, dynamic> toJson() => {
        'fileId': fileId,
        'filePath': filePath,
        'fileName': fileName,
      };
}

abstract class UploadRepository {
  Future<Either<Failure, List<PresignedUploadEntity>>> requestPresignedUrls({
    required String token,
    required List<PresignedFileInput> files,
  });

  /// PUTs the raw bytes from [localPath] to the presigned S3-style [uploadUrl].
  /// Reports progress 0..1 via [onProgress] if provided.
  Future<Either<Failure, void>> uploadToPresignedUrl({
    required String uploadUrl,
    required String localPath,
    required String contentType,
    void Function(double progress)? onProgress,
  });

  Future<Either<Failure, void>> completeBatch({
    required String token,
    required List<CompleteUploadInput> uploads,
    required bool autoTranscribe,
    required String language,
    required String provider,
  });
}
