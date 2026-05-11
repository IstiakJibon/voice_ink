import 'package:dartz/dartz.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/features/upload/data/datasources/upload_remote.dart';
import 'package:voice_ink/features/upload/domain/entities/upload_entity.dart';
import 'package:voice_ink/features/upload/domain/repositories/upload_repository.dart';

class UploadRepositoryImpl extends UploadRepository {
  final UploadRemoteServices uploadRemoteServices;

  UploadRepositoryImpl({required this.uploadRemoteServices});

  @override
  Future<Either<Failure, List<PresignedUploadEntity>>> requestPresignedUrls({
    required String token,
    required List<PresignedFileInput> files,
  }) async {
    return await uploadRemoteServices.requestPresignedUrls(
      token: token,
      files: files,
    );
  }

  @override
  Future<Either<Failure, void>> uploadToPresignedUrl({
    required String uploadUrl,
    required String localPath,
    required String contentType,
    void Function(double progress)? onProgress,
  }) async {
    return await uploadRemoteServices.uploadToPresignedUrl(
      uploadUrl: uploadUrl,
      localPath: localPath,
      contentType: contentType,
      onProgress: onProgress,
    );
  }

  @override
  Future<Either<Failure, void>> completeBatch({
    required String token,
    required List<CompleteUploadInput> uploads,
    required bool autoTranscribe,
    required String language,
    required String provider,
  }) async {
    return await uploadRemoteServices.completeBatch(
      token: token,
      uploads: uploads,
      autoTranscribe: autoTranscribe,
      language: language,
      provider: provider,
    );
  }
}
