import 'package:dartz/dartz.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/features/podcast/domain/entities/podcast_entity.dart';
import 'package:voice_ink/features/podcast/domain/repositories/podcast_repository.dart';

class PodcastUseCase {
  final PodcastRepository podcastRepository;

  PodcastUseCase({required this.podcastRepository});

  Future<Either<Failure, List<PodcastFeedEntity>>> searchPodcasts({
    required String token,
    required String query,
    int max = 20,
  }) =>
      podcastRepository.searchPodcasts(
        token: token,
        query: query,
        max: max,
      );

  Future<Either<Failure, List<PodcastEpisodeEntity>>> getEpisodes({
    required String token,
    required int feedId,
    int max = 50,
  }) =>
      podcastRepository.getEpisodes(
        token: token,
        feedId: feedId,
        max: max,
      );

  Future<Either<Failure, String>> downloadAndImport({
    required String token,
    required Map<String, dynamic> body,
  }) =>
      podcastRepository.downloadAndImport(token: token, body: body);
}
