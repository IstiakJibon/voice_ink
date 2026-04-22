import 'package:dio/dio.dart';
import 'package:voice_ink/config/const/app/api_endpoints.dart';
import 'package:voice_ink/core/network/dio_client/dio_client.dart';
import 'package:voice_ink/core/network/dio_client/request_params.dart';
import 'package:voice_ink/features/files/data/models/transcript_detail_model.dart';

abstract class TranscriptDetailRemoteDataSource {
  Future<FileDetailModel> getFileDetail({
    required String fileId,
    required String token,
  });

  Future<StreamUrlModel> getStreamUrl({
    required String fileId,
    required String token,
  });

  Future<TranscriptionResultsListModel> getTranscriptionResults({
    required String fileId,
    required String token,
  });

  Future<bool> updateWordText({
    required String fileId,
    required String resultId,
    required int wordIndex,
    required String newText,
    required String token,
  });

  Future<bool> updateWordSpeaker({
    required String fileId,
    required String resultId,
    required int wordIndex,
    required String newSpeaker,
    required String token,
  });
}

class TranscriptDetailRemoteDataSourceImpl
    implements TranscriptDetailRemoteDataSource {
  final DioClient dioClient;

  TranscriptDetailRemoteDataSourceImpl({required this.dioClient});

  Options _authOptions(String token) {
    return Options(headers: {"Authorization": "Bearer $token"});
  }

  @override
  Future<FileDetailModel> getFileDetail({
    required String fileId,
    required String token,
  }) async {
    final response = await dioClient.get(
      APIRequestParam(
        path: ApiEndPoints.audioFileDetail(fileId),
        options: _authOptions(token),
        isRequiredAuth: true,
      ),
    );

    return response.fold(
      (error) => throw error,
      (success) => FileDetailModel.fromJson(success.data),
    );
  }

  @override
  Future<StreamUrlModel> getStreamUrl({
    required String fileId,
    required String token,
  }) async {
    final response = await dioClient.get(
      APIRequestParam(
        path: ApiEndPoints.fileStreamUrl(fileId),
        options: _authOptions(token),
        isRequiredAuth: true,
      ),
    );

    return response.fold(
      (error) => throw error,
      (success) => StreamUrlModel.fromJson(success.data),
    );
  }

  @override
  Future<TranscriptionResultsListModel> getTranscriptionResults({
    required String fileId,
    required String token,
  }) async {
    final response = await dioClient.get(
      APIRequestParam(
        path: ApiEndPoints.transcriptionResults(fileId),
        options: _authOptions(token),
        isRequiredAuth: true,
      ),
    );

    return response.fold(
      (error) => throw error,
      (success) => TranscriptionResultsListModel.fromJson(success.data),
    );
  }

  @override
  Future<bool> updateWordText({
    required String fileId,
    required String resultId,
    required int wordIndex,
    required String newText,
    required String token,
  }) async {
    // TODO: Implement when API endpoint is available
    // final response = await dioClient.patch(
    //   APIRequestParam(
    //     path: ApiEndPoints.updateTranscriptionWord(resultId),
    //     data: {
    //       'wordIndex': wordIndex,
    //       'text': newText,
    //     },
    //     options: _authOptions(token),
    //     isRequiredAuth: true,
    //   ),
    // );
    // return response.fold(
    //   (error) => throw error,
    //   (success) => success.statusCode == 200,
    // );
    return true;
  }

  @override
  Future<bool> updateWordSpeaker({
    required String fileId,
    required String resultId,
    required int wordIndex,
    required String newSpeaker,
    required String token,
  }) async {
    // TODO: Implement when API endpoint is available
    return true;
  }
}