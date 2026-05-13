import 'package:equatable/equatable.dart';

class PodcastFeedEntity extends Equatable {
  /// Podcast Index feed id (used to fetch episodes).
  final int? id;
  final String? title;
  final String? author;
  final String? description;
  final String? image;
  final String? language;
  final int? episodeCount;
  /// RSS feed URL — sent as `feedUrl` to `/podcasts/download-and-import`.
  final String? feedUrl;

  const PodcastFeedEntity({
    this.id,
    this.title,
    this.author,
    this.description,
    this.image,
    this.language,
    this.episodeCount,
    this.feedUrl,
  });

  @override
  List<Object?> get props =>
      [id, title, author, description, image, language, episodeCount, feedUrl];
}

class PodcastEpisodeEntity extends Equatable {
  final int? id;
  final String? title;
  final String? description;
  final String? image;
  final String? feedImage;
  final String? enclosureUrl; // direct mp3 — used for import
  final String? enclosureType;
  final int? enclosureLength;
  final int? durationSeconds;
  final int? datePublishedEpoch;
  final String? datePublishedPretty;
  final int? feedId;
  final String? feedTitle;

  const PodcastEpisodeEntity({
    this.id,
    this.title,
    this.description,
    this.image,
    this.feedImage,
    this.enclosureUrl,
    this.enclosureType,
    this.enclosureLength,
    this.durationSeconds,
    this.datePublishedEpoch,
    this.datePublishedPretty,
    this.feedId,
    this.feedTitle,
  });

  bool get hasAudio => enclosureUrl != null && enclosureUrl!.isNotEmpty;

  /// Formatted duration like "2h 42m" or "47m".
  String get formattedDuration {
    final s = durationSeconds ?? 0;
    if (s <= 0) return '—';
    final h = s ~/ 3600;
    final m = (s % 3600) ~/ 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }

  /// "May 12, 2026" — uses datePublishedPretty if provided, else epoch.
  String get formattedDate {
    if (datePublishedPretty != null && datePublishedPretty!.isNotEmpty) {
      return datePublishedPretty!;
    }
    final epoch = datePublishedEpoch;
    if (epoch == null || epoch == 0) return '';
    final dt = DateTime.fromMillisecondsSinceEpoch(epoch * 1000);
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        image,
        feedImage,
        enclosureUrl,
        enclosureType,
        enclosureLength,
        durationSeconds,
        datePublishedEpoch,
        datePublishedPretty,
        feedId,
        feedTitle,
      ];
}
