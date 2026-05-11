import 'package:dartz/dartz.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/features/folder/data/datasources/folder_remote.dart';
import 'package:voice_ink/features/folder/domain/entities/folder_entity.dart';
import 'package:voice_ink/features/folder/domain/repositories/folder_repository.dart';

class FolderRepositoryImpl extends FolderRepository {
  final FolderRemoteServices folderRemoteServices;

  FolderRepositoryImpl({required this.folderRemoteServices});

  @override
  Future<Either<Failure, FolderListEntity>> getFolders({
    required String token,
    int page = 1,
    int limit = 8,
    bool includeFileCount = true,
  }) async {
    return await folderRemoteServices.getFolders(
      token: token,
      page: page,
      limit: limit,
      includeFileCount: includeFileCount,
    );
  }

  @override
  Future<Either<Failure, List<FolderEntity>>> getFoldersTree({
    required String token,
  }) async {
    return await folderRemoteServices.getFoldersTree(token: token);
  }

  @override
  Future<Either<Failure, FolderEntity>> createFolder({
    required String token,
    required String name,
    String? description,
    String? color,
    String? parentId,
  }) async {
    return await folderRemoteServices.createFolder(
      token: token,
      name: name,
      description: description,
      color: color,
      parentId: parentId,
    );
  }
}
