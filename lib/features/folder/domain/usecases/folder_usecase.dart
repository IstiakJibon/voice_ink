import 'package:dartz/dartz.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/features/folder/domain/entities/folder_entity.dart';
import 'package:voice_ink/features/folder/domain/repositories/folder_repository.dart';

class FolderUseCase {
  final FolderRepository folderRepository;

  FolderUseCase({required this.folderRepository});

  Future<Either<Failure, FolderListEntity>> getFolders({
    required String token,
    int page = 1,
    int limit = 8,
    bool includeFileCount = true,
  }) async {
    return await folderRepository.getFolders(
      token: token,
      page: page,
      limit: limit,
      includeFileCount: includeFileCount,
    );
  }

  Future<Either<Failure, List<FolderEntity>>> getFoldersTree({
    required String token,
  }) async {
    return await folderRepository.getFoldersTree(token: token);
  }

  Future<Either<Failure, FolderEntity>> createFolder({
    required String token,
    required String name,
    String? description,
    String? color,
    String? parentId,
  }) async {
    return await folderRepository.createFolder(
      token: token,
      name: name,
      description: description,
      color: color,
      parentId: parentId,
    );
  }
}
