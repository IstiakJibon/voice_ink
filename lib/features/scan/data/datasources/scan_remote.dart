import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:voice_ink/config/const/app/api_endpoints.dart';
import 'package:voice_ink/config/di/dependency_injector.dart';
import 'package:voice_ink/core/error/api_error_generator.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/core/network/dio_client/dio_client.dart';
import 'package:voice_ink/core/network/dio_client/request_params.dart';
import 'package:voice_ink/features/scan/data/models/scan_model.dart';

const _defaultTitleInstruction =
    'Analyze the scanned content and create a concise, descriptive title '
    '(max 60 characters) that captures the main topic or purpose of the '
    'document. The title should be clear and professional.';

class ScanRemoteServices {
  final DioClient _dioClient = sl<DioClient>();

  Future<Either<Failure, ExtractedTextModel>> extractText({
    required String token,
    required String filePath,
    String? fileName,
    bool generateTitle = true,
    String? titleInstruction,
  }) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      ),
      'generateTitle': generateTitle.toString(),
      'titleInstruction': titleInstruction ?? _defaultTitleInstruction,
    });

    final param = APIRequestParam(
      path: ApiEndPoints.aiExtractText,
      data: form,
      doCache: false,
      isRequiredAuth: true,
      options: Options(
        headers: {"Authorization": "Bearer $token"},
        contentType: 'multipart/form-data',
      ),
    );
    return await _dioClient.post(param).then((response) {
      return response.fold((l) {
        log('Extract Text Error: ${l.response?.statusCode}');
        log('Extract Text Body: ${l.response?.data}');
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
          log('Extract Text Response: ${r.data}');
          return Right(
            ExtractedTextModel.fromJson(r.data as Map<String, dynamic>),
          );
        } on Exception catch (e) {
          return Left(InvalidFormatFailure(message: e.toString()));
        }
      });
    });
  }
}
