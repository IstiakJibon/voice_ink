import 'package:equatable/equatable.dart';
import 'package:voice_ink/features/podcast/domain/entities/podcast_entity.dart';

enum PodcastSearchStatus { idle, searching, loaded, failed }

enum PodcastEpisodesStatus { idle, loading, loaded, failed }

enum PodcastImportStatus { idle, importing, success, failed }

class PodcastState extends Equatable {
  final String query;
  final PodcastSearchStatus searchStatus;
  final List<PodcastFeedEntity> feeds;
  final String? searchError;

  final PodcastFeedEntity? selectedFeed;
  final PodcastEpisodesStatus episodesStatus;
  final List<PodcastEpisodeEntity> episodes;
  final String? episodesError;

  final String? selectedEpisodeKey;

  final PodcastImportStatus importStatus;
  final String? importError;
  final String? importedFileId;

  const PodcastState({
    required this.query,
    required this.searchStatus,
    required this.feeds,
    required this.searchError,
    required this.selectedFeed,
    required this.episodesStatus,
    required this.episodes,
    required this.episodesError,
    required this.selectedEpisodeKey,
    required this.importStatus,
    required this.importError,
    required this.importedFileId,
  });

  factory PodcastState.initial() => const PodcastState(
        query: '',
        searchStatus: PodcastSearchStatus.idle,
        feeds: [],
        searchError: null,
        selectedFeed: null,
        episodesStatus: PodcastEpisodesStatus.idle,
        episodes: [],
        episodesError: null,
        selectedEpisodeKey: null,
        importStatus: PodcastImportStatus.idle,
        importError: null,
        importedFileId: null,
      );

  PodcastState copyWith({
    String? query,
    PodcastSearchStatus? searchStatus,
    List<PodcastFeedEntity>? feeds,
    String? searchError,
    bool clearSearchError = false,
    PodcastFeedEntity? selectedFeed,
    bool clearSelectedFeed = false,
    PodcastEpisodesStatus? episodesStatus,
    List<PodcastEpisodeEntity>? episodes,
    String? episodesError,
    bool clearEpisodesError = false,
    String? selectedEpisodeKey,
    bool clearSelectedEpisodeKey = false,
    PodcastImportStatus? importStatus,
    String? importError,
    bool clearImportError = false,
    String? importedFileId,
    bool clearImportedFileId = false,
  }) {
    return PodcastState(
      query: query ?? this.query,
      searchStatus: searchStatus ?? this.searchStatus,
      feeds: feeds ?? this.feeds,
      searchError: clearSearchError ? null : (searchError ?? this.searchError),
      selectedFeed:
          clearSelectedFeed ? null : (selectedFeed ?? this.selectedFeed),
      episodesStatus: episodesStatus ?? this.episodesStatus,
      episodes: episodes ?? this.episodes,
      episodesError:
          clearEpisodesError ? null : (episodesError ?? this.episodesError),
      selectedEpisodeKey: clearSelectedEpisodeKey
          ? null
          : (selectedEpisodeKey ?? this.selectedEpisodeKey),
      importStatus: importStatus ?? this.importStatus,
      importError: clearImportError ? null : (importError ?? this.importError),
      importedFileId:
          clearImportedFileId ? null : (importedFileId ?? this.importedFileId),
    );
  }

  @override
  List<Object?> get props => [
        query,
        searchStatus,
        feeds,
        searchError,
        selectedFeed,
        episodesStatus,
        episodes,
        episodesError,
        selectedEpisodeKey,
        importStatus,
        importError,
        importedFileId,
      ];
}
