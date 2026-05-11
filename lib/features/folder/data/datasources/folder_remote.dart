import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:voice_ink/config/const/app/api_endpoints.dart';
import 'package:voice_ink/config/di/dependency_injector.dart';
import 'package:voice_ink/core/error/api_error_generator.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/core/network/dio_client/dio_client.dart';
import 'package:voice_ink/core/network/dio_client/request_params.dart';
import 'package:voice_ink/features/folder/data/models/folder_model.dart';

class FolderRemoteServices {
  final DioClient _dioClient = sl<DioClient>();

  Future<Either<Failure, FolderListModel>> getFolders({
    required String token,
    int page = 1,
    int limit = 8,
    bool includeFileCount = true,
  }) async {
    final param = APIRequestParam(
      path:
          '${ApiEndPoints.folders}?page=$page&limit=$limit&includeFileCount=$includeFileCount',
      doCache: false,
      isRequiredAuth: true,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    return await _dioClient.get(param).then((response) {
      return response.fold((l) {
        log("Get Folders Error: ${l.response?.statusCode}");
        log("Get Folders Error Response: ${l.response?.data}");
        return Left(ApiErrorGenerator.apiError(l));
      }, (r) {
        try {
          log("Get Folders Response: ${r.data}");
          return Right(FolderListModel.fromJson(r.data as Map<String, dynamic>));
        } on Exception catch (e) {
          log("Get Folders Parse Error: ${e.toString()}");
          return Left(InvalidFormatFailure(message: e.toString()));
        }
      });
    });
  }

  Future<Either<Failure, List<FolderModel>>> getFoldersTree({
    required String token,
    bool includeFileCount = true,
  }) async {
    final param = APIRequestParam(
      path:
          '${ApiEndPoints.foldersTree}?includeFileCount=$includeFileCount',
      doCache: false,
      isRequiredAuth: true,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    return await _dioClient.get(param).then((response) {
      return response.fold((l) {
        log("Get Folders Tree Error: ${l.response?.statusCode}");
        log("Get Folders Tree Error Response: ${l.response?.data}");
        return Left(ApiErrorGenerator.apiError(l));
      }, (r) {
        try {
          log("Get Folders Tree Response: ${r.data}");
          return Right(FolderModel.listFromJson(r.data as List<dynamic>));
        } on Exception catch (e) {
          log("Get Folders Tree Parse Error: ${e.toString()}");
          return Left(InvalidFormatFailure(message: e.toString()));
        }
      });
    });
  }

  Future<Either<Failure, FolderModel>> createFolder({
    required String token,
    required String name,
    String? description,
    String? color,
    String? parentId,
  }) async {
    final param = APIRequestParam(
      path: ApiEndPoints.folders,
      data: {
        'name': name,
        'description': description,
        'color': color,
        'parentId': parentId,
      },
      doCache: false,
      isRequiredAuth: true,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    return await _dioClient.post(param).then((response) {
      return response.fold((l) {
        log("Create Folder Error: ${l.response?.statusCode}");
        log("Create Folder Error Response: ${l.response?.data}");
        return Left(ApiErrorGenerator.apiError(l));
      }, (r) {
        try {
          log("Create Folder Response: ${r.data}");
          return Right(FolderModel.fromJson(r.data as Map<String, dynamic>));
        } on Exception catch (e) {
          log("Create Folder Parse Error: ${e.toString()}");
          return Left(InvalidFormatFailure(message: e.toString()));
        }
      });
    });
  }
}
