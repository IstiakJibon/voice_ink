import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:voice_ink/config/const/app/api_endpoints.dart';
import 'package:voice_ink/config/di/dependency_injector.dart';
import 'package:voice_ink/core/error/api_error_generator.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/core/network/dio_client/dio_client.dart';
import 'package:voice_ink/core/network/dio_client/request_params.dart';
import 'package:voice_ink/features/quota/data/models/quota_model.dart';

class QuotaRemoteServices {
  final DioClient _dioClient = sl<DioClient>();

  Future<Either<Failure, List<QuotaModel>>> getQuotaSummary({
    required String token,
  }) async {
    final APIRequestParam param = APIRequestParam(
      path: ApiEndPoints.quotaSummary,
      doCache: false,
      isRequiredAuth: true,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    return await _dioClient.get(param).then((response) {
      return response.fold((l) {
        log("Get Quota Summary Error: ${l.response?.statusCode}");
        log("Get Quota Summary Error Response: ${l.response?.data}");
        return Left(ApiErrorGenerator.apiError(l));
      }, (r) {
        try {
          log("Get Quota Summary Response: ${r.data}");
          final list = QuotaModel.listFromJson(r.data as List<dynamic>);
          return Right(list);
        } on Exception catch (e) {
          log("Get Quota Summary Parse Error: ${e.toString()}");
          return Left(InvalidFormatFailure(message: e.toString()));
        }
      });
    });
  }
}
