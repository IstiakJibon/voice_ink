import 'package:dartz/dartz.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/features/files/domain/entities/audio_file_entities.dart';
import 'package:voice_ink/features/files/domain/repositories/files_repository.dart';

class FilesUseCase {
  final FilesRepository filesRepository;

  FilesUseCase({required this.filesRepository});

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
  }) async {
    return await filesRepository.getAudioFiles(
      token: token,
      page: page,
      limit: limit,
      sortBy: sortBy,
      sortOrder: sortOrder,
      search: search,
      source: source,
      isFavorite: isFavorite,
      folderId: folderId,
    );
  }

  Future<Either<Failure, bool>> toggleFavorite({
    required String token,
    required String fileId,
    required bool isFavorite,
  }) async {
    return await filesRepository.toggleFavorite(
      token: token,
      fileId: fileId,
      isFavorite: isFavorite,
    );
  }
}