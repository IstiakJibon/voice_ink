import 'package:dartz/dartz.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/features/url_import/domain/entities/url_import_entity.dart';
import 'package:voice_ink/features/url_import/domain/repositories/url_import_repository.dart';

class UrlImportUseCase {
  final UrlImportRepository urlImportRepository;

  UrlImportUseCase({required this.urlImportRepository});

  Future<Either<Failure, CheckUrlEntity>> checkUrl({
    required String token,
    required String url,
  }) =>
      urlImportRepository.checkUrl(token: token, url: url);

  Future<Either<Failure, ImportUrlEntity>> importUrl({
    required String token,
    required String url,
    required String name,
    required bool autoTranscribe,
    required bool speakerIdentification,
    String language = 'en',
    String provider = 'assemblyai',
  }) =>
      urlImportRepository.importUrl(
        token: token,
        url: url,
        name: name,
        autoTranscribe: autoTranscribe,
        speakerIdentification: speakerIdentification,
        language: language,
        provider: provider,
      );
}
