import 'package:dartz/dartz.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/features/files/domain/entities/audio_file_entities.dart';

abstract class FilesRepository {
  Future<Either<Failure, AudioFileListEntities>> getAudioFiles({
    required String token,
    required int page,
    required int limit,
    String sortBy = 'createdAt',
    String sortOrder = 'DESC',
    String? search,
    String? source,
    bool? isFavorite,
    String? folderId,
  });

  Future<Either<Failure, bool>> toggleFavorite({
    required String token,
    required String fileId,
    required bool isFavorite,
  });
}