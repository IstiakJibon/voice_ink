import 'package:dartz/dartz.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/features/podcast/domain/entities/podcast_entity.dart';

abstract class PodcastRepository {
  Future<Either<Failure, List<PodcastFeedEntity>>> searchPodcasts({
    required String token,
    required String query,
    int max = 20,
  });

  Future<Either<Failure, List<PodcastEpisodeEntity>>> getEpisodes({
    required String token,
    required int feedId,
    int max = 50,
  });

  /// Returns the imported audio file's id on success.
  Future<Either<Failure, String>> downloadAndImport({
    required String token,
    required Map<String, dynamic> body,
  });
}
