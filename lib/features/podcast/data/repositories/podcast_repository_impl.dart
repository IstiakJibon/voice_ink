import 'package:dartz/dartz.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/features/podcast/data/datasources/podcast_remote.dart';
import 'package:voice_ink/features/podcast/domain/entities/podcast_entity.dart';
import 'package:voice_ink/features/podcast/domain/repositories/podcast_repository.dart';

class PodcastRepositoryImpl extends PodcastRepository {
  final PodcastRemoteServices podcastRemoteServices;

  PodcastRepositoryImpl({required this.podcastRemoteServices});

  @override
  Future<Either<Failure, List<PodcastFeedEntity>>> searchPodcasts({
    required String token,
    required String query,
    int max = 20,
  }) =>
      podcastRemoteServices.searchPodcasts(
        token: token,
        query: query,
        max: max,
      );

  @override
  Future<Either<Failure, List<PodcastEpisodeEntity>>> getEpisodes({
    required String token,
    required int feedId,
    int max = 50,
  }) =>
      podcastRemoteServices.getEpisodes(
        token: token,
        feedId: feedId,
        max: max,
      );

  @override
  Future<Either<Failure, String>> downloadAndImport({
    required String token,
    required Map<String, dynamic> body,
  }) =>
      podcastRemoteServices.downloadAndImport(token: token, body: body);
}
