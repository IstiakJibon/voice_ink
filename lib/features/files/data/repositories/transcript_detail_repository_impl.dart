import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:voice_ink/features/files/data/datasources/transcript_detail_remote.dart';
import 'package:voice_ink/features/files/domain/entities/transcript_detail_entities.dart';
import 'package:voice_ink/features/files/domain/repositories/transcript_detail_repository.dart';

class TranscriptDetailRepositoryImpl implements TranscriptDetailRepository {
  final TranscriptDetailRemoteDataSource remoteDataSource;

  TranscriptDetailRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, FileDetailEntities>> getFileDetail({
    required String fileId,
    required String token,
  }) async {
    try {
      final result = await remoteDataSource.getFileDetail(
        fileId: fileId,
        token: token,
      );
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, StreamUrlEntities>> getStreamUrl({
    required String fileId,
    required String token,
  }) async {
    try {
      final result = await remoteDataSource.getStreamUrl(
        fileId: fileId,
        token: token,
      );
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, TranscriptionResultsListEntities>>
      getTranscriptionResults({
    required String fileId,
    required String token,
  }) async {
    try {
      final result = await remoteDataSource.getTranscriptionResults(
        fileId: fileId,
        token: token,
      );
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, bool>> updateWordText({
    required String fileId,
    required String resultId,
    required int wordIndex,
    required String newText,
    required String token,
  }) async {
    try {
      final result = await remoteDataSource.updateWordText(
        fileId: fileId,
        resultId: resultId,
        wordIndex: wordIndex,
        newText: newText,
        token: token,
      );
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, bool>> updateWordSpeaker({
    required String fileId,
    required String resultId,
    required int wordIndex,
    required String newSpeaker,
    required String token,
  }) async {
    try {
      final result = await remoteDataSource.updateWordSpeaker(
        fileId: fileId,
        resultId: resultId,
        wordIndex: wordIndex,
        newSpeaker: newSpeaker,
        token: token,
      );
      return Right(result);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  String _handleError(dynamic e) {
    if (e is DioException) {
      if (e.response?.data != null && e.response?.data['message'] != null) {
        return e.response?.data['message'];
      }
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timeout. Please try again.';
        case DioExceptionType.connectionError:
          return 'No internet connection.';
        default:
          return e.message ?? 'Something went wrong';
      }
    }
    return e.toString();
  }
}
