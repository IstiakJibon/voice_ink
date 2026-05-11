import 'package:dartz/dartz.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/features/folder/domain/entities/folder_entity.dart';

abstract class FolderRepository {
  Future<Either<Failure, FolderListEntity>> getFolders({
    required String token,
    int page = 1,
    int limit = 8,
    bool includeFileCount = true,
  });

  Future<Either<Failure, List<FolderEntity>>> getFoldersTree({
    required String token,
  });

  Future<Either<Failure, FolderEntity>> createFolder({
    required String token,
    required String name,
    String? description,
    String? color,
    String? parentId,
  });
}
