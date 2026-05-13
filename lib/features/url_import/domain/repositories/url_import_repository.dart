import 'package:dartz/dartz.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/features/url_import/domain/entities/url_import_entity.dart';

abstract class UrlImportRepository {
  Future<Either<Failure, CheckUrlEntity>> checkUrl({
    required String token,
    required String url,
  });

  Future<Either<Failure, ImportUrlEntity>> importUrl({
    required String token,
    required String url,
    required String name,
    required bool autoTranscribe,
    required bool speakerIdentification,
    String language = 'en',
    String provider = 'assemblyai',
  });
}
