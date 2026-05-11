import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:voice_ink/config/const/app/api_endpoints.dart';
import 'package:voice_ink/config/di/dependency_injector.dart';
import 'package:voice_ink/core/error/api_error_generator.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/core/network/dio_client/dio_client.dart';
import 'package:voice_ink/core/network/dio_client/request_params.dart';
import 'package:voice_ink/features/upload/data/models/upload_model.dart';
import 'package:voice_ink/features/upload/domain/repositories/upload_repository.dart';

class UploadRemoteServices {
  final DioClient _dioClient = sl<DioClient>();
  // Plain Dio for S3-style presigned PUTs (no Authorization header).
  final Dio _plainDio = Dio();

  Future<Either<Failure, List<PresignedUploadModel>>> requestPresignedUrls({
    required String token,
    required List<PresignedFileInput> files,
  }) async {
    final param = APIRequestParam(
      path: ApiEndPoints.uploadBatchPresignedUrls,
      data: {'files': files.map((f) => f.toJson()).toList()},
      doCache: false,
      isRequiredAuth: true,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    return await _dioClient.post(param).then((response) {
      return response.fold((l) {
        log("Presign Error: ${l.response?.statusCode}");
        log("Presign Error Body: ${l.response?.data}");
        return Left(ApiErrorGenerator.apiError(l));
      }, (r) {
        try {
          log("Presign Response: ${r.data}");
          return Right(PresignedUploadModel.listFromResponse(r.data));
        } on Exception catch (e) {
          return Left(InvalidFormatFailure(message: e.toString()));
        }
      });
    });
  }

  Future<Either<Failure, void>> uploadToPresignedUrl({
    required String uploadUrl,
    required String localPath,
    required String contentType,
    void Function(double progress)? onProgress,
  }) async {
    try {
      final file = File(localPath);
      final length = await file.length();
      final stream = file.openRead();

      await _plainDio.put(
        uploadUrl,
        data: stream,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: contentType,
            HttpHeaders.contentLengthHeader: length,
            'x-amz-acl': 'private',
          },
        ),
        onSendProgress: (sent, total) {
          if (total > 0 && onProgress != null) {
            onProgress(sent / total);
          }
        },
      );
      return const Right(null);
    } on DioException catch (e) {
      log("S3 Upload Error: ${e.response?.statusCode}");
      log("S3 Upload Body: ${e.response?.data}");
      return Left(ApiErrorGenerator.apiError(e));
    } catch (e) {
      log("S3 Upload Error: $e");
      return Left(InvalidFormatFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> completeBatch({
    required String token,
    required List<CompleteUploadInput> uploads,
    required bool autoTranscribe,
    required String language,
    required String provider,
  }) async {
    final param = APIRequestParam(
      path: ApiEndPoints.uploadBatchComplete,
      data: {
        'uploads': uploads.map((u) => u.toJson()).toList(),
        'auto_transcribe': autoTranscribe,
        'language': language,
        'provider': provider,
      },
      doCache: false,
      isRequiredAuth: true,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    return await _dioClient.post(param).then((response) {
      return response.fold((l) {
        log("Complete Upload Error: ${l.response?.statusCode}");
        log("Complete Upload Body: ${l.response?.data}");
        return Left(ApiErrorGenerator.apiError(l));
      }, (r) {
        log("Complete Upload Response: ${r.data}");
        return const Right(null);
      });
    });
  }
}
