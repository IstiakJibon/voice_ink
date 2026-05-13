import 'package:voice_ink/features/podcast/domain/entities/podcast_entity.dart';

class PodcastFeedModel extends PodcastFeedEntity {
  const PodcastFeedModel({
    super.id,
    super.title,
    super.author,
    super.description,
    super.image,
    super.language,
    super.episodeCount,
    super.feedUrl,
  });

  factory PodcastFeedModel.fromJson(Map<String, dynamic> json) {
    return PodcastFeedModel(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'],
      author: json['author'] ?? json['ownerName'],
      description: json['description'],
      image: json['artwork'] ?? json['image'],
      language: json['language'],
      episodeCount: (json['episodeCount'] as num?)?.toInt(),
      feedUrl: json['url'] ?? json['feedUrl'] ?? json['originalUrl'],
    );
  }

  /// Response wrapper: `{ feeds: [...], count: ... }` or a bare list.
  static List<PodcastFeedModel> listFromResponse(dynamic body) {
    if (body is List) {
      return body
          .whereType<Map<String, dynamic>>()
          .map((e) => PodcastFeedModel.fromJson(e))
          .toList();
    }
    if (body is Map<String, dynamic>) {
      final list = body['feeds'] ?? body['data'] ?? body['results'];
      if (list is List) {
        return list
            .whereType<Map<String, dynamic>>()
            .map((e) => PodcastFeedModel.fromJson(e))
            .toList();
      }
    }
    return const [];
  }
}

class PodcastEpisodeModel extends PodcastEpisodeEntity {
  const PodcastEpisodeModel({
    super.id,
    super.title,
    super.description,
    super.image,
    super.feedImage,
    super.enclosureUrl,
    super.enclosureType,
    super.enclosureLength,
    super.durationSeconds,
    super.datePublishedEpoch,
    super.datePublishedPretty,
    super.feedId,
    super.feedTitle,
  });

  factory PodcastEpisodeModel.fromJson(Map<String, dynamic> json) {
    return PodcastEpisodeModel(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'],
      description: json['description'],
      image: json['image'],
      feedImage: json['feedImage'],
      enclosureUrl: json['enclosureUrl'] ?? json['audioUrl'],
      enclosureType: json['enclosureType'],
      enclosureLength: (json['enclosureLength'] as num?)?.toInt(),
      durationSeconds: (json['duration'] as num?)?.toInt(),
      datePublishedEpoch: (json['datePublished'] as num?)?.toInt(),
      datePublishedPretty: json['datePublishedPretty'],
      feedId: (json['feedId'] as num?)?.toInt(),
      feedTitle: json['feedTitle'],
    );
  }

  /// Response wrapper: `{ items: [...], count: ... }` or a bare list.
  static List<PodcastEpisodeModel> listFromResponse(dynamic body) {
    if (body is List) {
      return body
          .whereType<Map<String, dynamic>>()
          .map((e) => PodcastEpisodeModel.fromJson(e))
          .toList();
    }
    if (body is Map<String, dynamic>) {
      final list = body['items'] ?? body['episodes'] ?? body['data'];
      if (list is List) {
        return list
            .whereType<Map<String, dynamic>>()
            .map((e) => PodcastEpisodeModel.fromJson(e))
            .toList();
      }
    }
    return const [];
  }
}
