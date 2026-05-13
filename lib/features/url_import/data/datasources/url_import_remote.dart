import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:voice_ink/config/const/app/api_endpoints.dart';
import 'package:voice_ink/config/di/dependency_injector.dart';
import 'package:voice_ink/core/error/api_error_generator.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/core/network/dio_client/dio_client.dart';
import 'package:voice_ink/core/network/dio_client/request_params.dart';
import 'package:voice_ink/features/url_import/data/models/url_import_model.dart';

class UrlImportRemoteServices {
  final DioClient _dioClient = sl<DioClient>();

  Future<Either<Failure, CheckUrlModel>> checkUrl({
    required String token,
    required String url,
  }) async {
    final param = APIRequestParam(
      path: ApiEndPoints.audioFilesCheckUrl,
      data: {'url': url},
      doCache: false,
      isRequiredAuth: true,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    return await _dioClient.post(param).then((response) {
      return response.fold((l) {
        log("Check URL Error: ${l.response?.statusCode}");
        log("Check URL Body: ${l.response?.data}");
        // Backend leaks the raw error string; surface what it sends.
        final body = l.response?.data;
        if (body is Map<String, dynamic>) {
          final msg = body['error'] ?? body['message'];
          if (msg is String && msg.isNotEmpty) {
            return Left(InvalidFormatFailure(message: msg));
          }
        }
        return Left(ApiErrorGenerator.apiError(l));
      }, (r) {
        try {
          log("Check URL Response: ${r.data}");
          return Right(
            CheckUrlModel.fromJson(r.data as Map<String, dynamic>),
          );
        } on Exception catch (e) {
          return Left(InvalidFormatFailure(message: e.toString()));
        }
      });
    });
  }

  Future<Either<Failure, ImportUrlModel>> importUrl({
    required String token,
    required String url,
    required String name,
    required bool autoTranscribe,
    required bool speakerIdentification,
    String language = 'en',
    String provider = 'assemblyai',
  }) async {
    // Body shape per OpenAPI spec at /api/docs-json: only url,
    // auto_transcribe (snake_case), language, provider are honored.
    // We pass the spec-compliant fields and also include the web-style
    // extras (name, processingOptions) for forward-compat in case the
    // backend later wires them up.
    final param = APIRequestParam(
      path: ApiEndPoints.audioFilesImportUrl,
      data: {
        'url': url,
        'auto_transcribe': autoTranscribe,
        'language': language,
        'provider': provider,
        'name': name,
        'processingOptions': {
          'speakerIdentification': speakerIdentification,
        },
      },
      doCache: false,
      isRequiredAuth: true,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    return await _dioClient.post(param).then((response) {
      return response.fold((l) {
        log("Import URL Error: ${l.response?.statusCode}");
        log("Import URL Body: ${l.response?.data}");
        final body = l.response?.data;
        if (body is Map<String, dynamic>) {
          final msg = body['error'] ?? body['message'];
          if (msg is String && msg.isNotEmpty) {
            return Left(InvalidFormatFailure(message: msg));
          }
        }
        return Left(ApiErrorGenerator.apiError(l));
      }, (r) {
        try {
          log("Import URL Response: ${r.data}");
          return Right(
            ImportUrlModel.fromJson(r.data as Map<String, dynamic>),
          );
        } on Exception catch (e) {
          return Left(InvalidFormatFailure(message: e.toString()));
        }
      });
    });
  }
}
