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

  Future<List<int>> exportTranscript({
    required String transcriptionResultId,
    required String format,
    required bool includeSpeakers,
    required bool includeTimestamps,
    required bool combineParagraphs,
    required bool includeHighlights,
    String? targetLanguage,
    required String token,
  });

  Future<bool> transcribeFile({
    required String fileId,
    required String provider,
    required String token,
    String language,
    bool speakerLabels,
    bool sentimentAnalysis,
    bool entityDetection,
    bool topicDetection,
    bool autoHighlights,
    bool contentSafety,
    bool summarization,
    bool autoChapters,
    bool filterProfanity,
  });

  Future<TranscriptionStatusModel> getTranscriptionStatus({
    required String fileId,
    required String token,
  });

  Future<TranscriptionResultModel> getTranscriptionResultDetail({
    required String resultId,
    required String token,
  });

  Future<bool> deleteTranscriptionResult({
    required String resultId,
    required String token,
  });

  Future<bool> setPrimaryTranscriptionResult({
    required String resultId,
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

  @override
  Future<List<int>> exportTranscript({
    required String transcriptionResultId,
    required String format,
    required bool includeSpeakers,
    required bool includeTimestamps,
    required bool combineParagraphs,
    required bool includeHighlights,
    String? targetLanguage,
    required String token,
  }) async {
    final response = await dioClient.get(
      APIRequestParam(
        path: ApiEndPoints.exportInstant(transcriptionResultId),
        queryParameters: {
          'format': format,
          'includeSpeakers': includeSpeakers,
          'includeTimestamps': includeTimestamps,
          'combineParagraphs': combineParagraphs,
          'includeHighlights': includeHighlights,
          if (targetLanguage != null) 'targetLanguage': targetLanguage,
        },
        options: Options(
          headers: {"Authorization": "Bearer $token"},
          responseType: ResponseType.bytes,
        ),
        isRequiredAuth: true,
      ),
    );

    return response.fold(
      (error) => throw error,
      (success) => success.data as List<int>,
    );
  }

  @override
  Future<bool> transcribeFile({
    required String fileId,
    required String provider,
    required String token,
    String language = 'en',
    bool speakerLabels = true,
    bool sentimentAnalysis = false,
    bool entityDetection = false,
    bool topicDetection = false,
    bool autoHighlights = false,
    bool contentSafety = false,
    bool summarization = false,
    bool autoChapters = false,
    bool filterProfanity = false,
  }) async {
    final response = await dioClient.post(
      APIRequestParam(
        path: ApiEndPoints.audioFileTranscribe(fileId),
        data: {
          'provider': provider,
          'language': language,
          'speakerLabels': speakerLabels,
          'sentimentAnalysis': sentimentAnalysis,
          'entityDetection': entityDetection,
          'topicDetection': topicDetection,
          'autoHighlights': autoHighlights,
          'contentSafety': contentSafety,
          'summarization': summarization,
          'autoChapters': autoChapters,
          'filterProfanity': filterProfanity,
        },
        options: _authOptions(token),
        isRequiredAuth: true,
      ),
    );

    return response.fold(
      (error) => throw error,
      (success) => true,
    );
  }

  @override
  Future<TranscriptionStatusModel> getTranscriptionStatus({
    required String fileId,
    required String token,
  }) async {
    final response = await dioClient.get(
      APIRequestParam(
        path: ApiEndPoints.audioFileTranscriptionStatus(fileId),
        options: _authOptions(token),
        isRequiredAuth: true,
      ),
    );

    return response.fold(
      (error) => throw error,
      (success) => TranscriptionStatusModel.fromJson(success.data),
    );
  }

  @override
  Future<TranscriptionResultModel> getTranscriptionResultDetail({
    required String resultId,
    required String token,
  }) async {
    final response = await dioClient.get(
      APIRequestParam(
        path: ApiEndPoints.transcriptionResultDetail(resultId),
        options: _authOptions(token),
        isRequiredAuth: true,
      ),
    );

    return response.fold(
      (error) => throw error,
      (success) => TranscriptionResultModel.fromJson(success.data),
    );
  }

  @override
  Future<bool> deleteTranscriptionResult({
    required String resultId,
    required String token,
  }) async {
    final response = await dioClient.delete(
      APIRequestParam(
        path: ApiEndPoints.transcriptionResultDetail(resultId),
        options: _authOptions(token),
        isRequiredAuth: true,
      ),
    );

    return response.fold(
      (error) => throw error,
      (success) => true,
    );
  }

  @override
  Future<bool> setPrimaryTranscriptionResult({
    required String resultId,
    required String token,
  }) async {
    final response = await dioClient.put(
      APIRequestParam(
        path: ApiEndPoints.setPrimaryTranscriptionResult(resultId),
        options: _authOptions(token),
        isRequiredAuth: true,
      ),
    );

    return response.fold(
      (error) => throw error,
      (success) => true,
    );
  }
}