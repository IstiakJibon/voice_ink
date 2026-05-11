import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:voice_ink/config/const/app/api_endpoints.dart';
import 'package:voice_ink/config/di/dependency_injector.dart';
import 'package:voice_ink/core/error/api_error_generator.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/core/network/dio_client/dio_client.dart';
import 'package:voice_ink/core/network/dio_client/request_params.dart';
import 'package:voice_ink/features/files/data/models/audio_file_model.dart';
import 'package:voice_ink/features/files/domain/entities/audio_file_entities.dart';

class FilesRemoteServices {
  final DioClient _dioClient = sl<DioClient>();

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
    final buf = StringBuffer(
      '${ApiEndPoints.audioFiles}?page=$page&limit=$limit&sortBy=$sortBy&sortOrder=$sortOrder',
    );
    if (search != null && search.isNotEmpty) {
      buf.write('&search=${Uri.encodeQueryComponent(search)}');
    }
    if (source != null && source.isNotEmpty) {
      buf.write('&source=${Uri.encodeQueryComponent(source)}');
    }
    if (isFavorite != null) {
      buf.write('&isFavorite=$isFavorite');
    }
    if (folderId != null && folderId.isNotEmpty) {
      buf.write('&folderId=${Uri.encodeQueryComponent(folderId)}');
    }
    final APIRequestParam param = APIRequestParam(
      path: buf.toString(),
      doCache: false,
      isRequiredAuth: true,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    return await _dioClient.get(param).then((response) {
      return response.fold((l) {
        log("Get Audio Files Error: ${l.response?.statusCode}");
        log("Get Audio Files Error Response: ${l.response?.data}");
        return Left(ApiErrorGenerator.apiError(l));
      }, (r) {
        try {
          log("Get Audio Files Response: ${r.data}");
          final audioFileList = AudioFileListModel.fromJson(r.data);
          return Right(audioFileList);
        } on Exception catch (e) {
          log("Get Audio Files Parse Error: ${e.toString()}");
          return Left(InvalidFormatFailure(
            message: e.toString(),
          ));
        }
      });
    });
  }

  Future<Either<Failure, bool>> toggleFavorite({
    required String token,
    required String fileId,
    required bool isFavorite,
  }) async {
    final APIRequestParam param = APIRequestParam(
      path: ApiEndPoints.audioFileFavorite(fileId),
      data: {"isFavorite": isFavorite},
      doCache: false,
      isRequiredAuth: true,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    return await _dioClient.put(param).then((response) {
      return response.fold((l) {
        log("Toggle Favorite Error: ${l.response?.statusCode}");
        log("Toggle Favorite Error Response: ${l.response?.data}");
        return Left(ApiErrorGenerator.apiError(l));
      }, (r) {
        log("Toggle Favorite Response: ${r.data}");
        return const Right(true);
      });
    });
  }
}