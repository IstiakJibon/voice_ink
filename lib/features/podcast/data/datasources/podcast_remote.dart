import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:voice_ink/config/const/app/api_endpoints.dart';
import 'package:voice_ink/config/di/dependency_injector.dart';
import 'package:voice_ink/core/error/api_error_generator.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/core/network/dio_client/dio_client.dart';
import 'package:voice_ink/core/network/dio_client/request_params.dart';
import 'package:voice_ink/features/podcast/data/models/podcast_model.dart';

class PodcastRemoteServices {
  final DioClient _dioClient = sl<DioClient>();

  Future<Either<Failure, List<PodcastFeedModel>>> searchPodcasts({
    required String token,
    required String query,
    int max = 20,
  }) async {
    final param = APIRequestParam(
      path:
          '${ApiEndPoints.podcastsSearch}?q=${Uri.encodeQueryComponent(query)}&max=$max',
      doCache: false,
      isRequiredAuth: true,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    return await _dioClient.get(param).then((response) {
      return response.fold((l) {
        log('Search Podcasts Error: ${l.response?.statusCode}');
        log('Search Podcasts Body: ${l.response?.data}');
        return Left(ApiErrorGenerator.apiError(l));
      }, (r) {
        try {
          log('Search Podcasts Response: ${r.data}');
          return Right(PodcastFeedModel.listFromResponse(r.data));
        } on Exception catch (e) {
          return Left(InvalidFormatFailure(message: e.toString()));
        }
      });
    });
  }

  Future<Either<Failure, String>> downloadAndImport({
    required String token,
    required Map<String, dynamic> body,
  }) async {
    final param = APIRequestParam(
      path: ApiEndPoints.podcastsDownloadAndImport,
      data: body,
      doCache: false,
      isRequiredAuth: true,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    return await _dioClient.post(param).then((response) {
      return response.fold((l) {
        log('Podcast Download Error: ${l.response?.statusCode}');
        log('Podcast Download Body: ${l.response?.data}');
        final body = l.response?.data;
        if (body is Map<String, dynamic>) {
          final msg = body['error'] ?? body['message'];
          if (msg is String && msg.isNotEmpty) {
            return Left(InvalidFormatFailure(message: msg));
          }
        }
        return Left(ApiErrorGenerator.apiError(l));
      }, (r) {
        log('Podcast Download Response: ${r.data}');
        // The response contains the newly-created file. Extract its id.
        final data = r.data;
        if (data is Map<String, dynamic>) {
          final fileId = data['fileId'] ??
              data['id'] ??
              (data['file'] is Map ? data['file']['id'] : null);
          if (fileId is String && fileId.isNotEmpty) {
            return Right(fileId);
          }
        }
        return Left(InvalidFormatFailure(
          message: 'Import succeeded but no file id was returned',
        ));
      });
    });
  }

  Future<Either<Failure, List<PodcastEpisodeModel>>> getEpisodes({
    required String token,
    required int feedId,
    int max = 50,
  }) async {
    final param = APIRequestParam(
      path: '${ApiEndPoints.podcastsEpisodes}?feedId=$feedId&max=$max',
      doCache: false,
      isRequiredAuth: true,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
    return await _dioClient.get(param).then((response) {
      return response.fold((l) {
        log('Podcast Episodes Error: ${l.response?.statusCode}');
        log('Podcast Episodes Body: ${l.response?.data}');
        return Left(ApiErrorGenerator.apiError(l));
      }, (r) {
        try {
          log('Podcast Episodes Response: ${r.data}');
          return Right(PodcastEpisodeModel.listFromResponse(r.data));
        } on Exception catch (e) {
          return Left(InvalidFormatFailure(message: e.toString()));
        }
      });
    });
  }
}
