import 'package:dartz/dartz.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/features/upload/domain/entities/upload_entity.dart';
import 'package:voice_ink/features/upload/domain/repositories/upload_repository.dart';

class UploadUseCase {
  final UploadRepository uploadRepository;

  UploadUseCase({required this.uploadRepository});

  Future<Either<Failure, List<PresignedUploadEntity>>> requestPresignedUrls({
    required String token,
    required List<PresignedFileInput> files,
  }) =>
      uploadRepository.requestPresignedUrls(token: token, files: files);

  Future<Either<Failure, void>> uploadToPresignedUrl({
    required String uploadUrl,
    required String localPath,
    required String contentType,
    void Function(double progress)? onProgress,
  }) =>
      uploadRepository.uploadToPresignedUrl(
        uploadUrl: uploadUrl,
        localPath: localPath,
        contentType: contentType,
        onProgress: onProgress,
      );

  Future<Either<Failure, void>> completeBatch({
    required String token,
    required List<CompleteUploadInput> uploads,
    required bool autoTranscribe,
    required String language,
    required String provider,
  }) =>
      uploadRepository.completeBatch(
        token: token,
        uploads: uploads,
        autoTranscribe: autoTranscribe,
        language: language,
        provider: provider,
      );
}
