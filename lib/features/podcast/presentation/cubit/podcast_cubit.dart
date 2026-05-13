import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_ink/features/podcast/domain/entities/podcast_entity.dart';
import 'package:voice_ink/features/podcast/domain/usecases/podcast_usecase.dart';
import 'package:voice_ink/features/podcast/presentation/cubit/podcast_state.dart';

class PodcastCubit extends Cubit<PodcastState> {
  final PodcastUseCase podcastUseCase;

  PodcastCubit({required this.podcastUseCase}) : super(PodcastState.initial());

  Timer? _searchDebounce;
  String? _token;

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  void reset() => emit(PodcastState.initial());

  /// Debounced search: 400ms after last keystroke; min 3 chars.
  void searchDebounced({required String token, required String query}) {
    _token = token;
    _searchDebounce?.cancel();
    final trimmed = query.trim();

    emit(state.copyWith(query: trimmed));

    if (trimmed.length < 3) {
      emit(state.copyWith(
        searchStatus: PodcastSearchStatus.idle,
        feeds: const [],
        clearSearchError: true,
      ));
      return;
    }

    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      _runSearch(trimmed);
    });
  }

  Future<void> _runSearch(String query) async {
    final token = _token;
    if (token == null) return;
    emit(state.copyWith(
      searchStatus: PodcastSearchStatus.searching,
      clearSearchError: true,
    ));
    await podcastUseCase
        .searchPodcasts(token: token, query: query)
        .then((res) {
      res.fold((err) {
        log('Podcast search error: ${err.message}');
        emit(state.copyWith(
          searchStatus: PodcastSearchStatus.failed,
          searchError: err.message,
        ));
      }, (feeds) {
        emit(state.copyWith(
          searchStatus: PodcastSearchStatus.loaded,
          feeds: feeds,
        ));
      });
    }).onError((error, stackTrace) {
      log('Podcast search error: $error');
      emit(state.copyWith(
        searchStatus: PodcastSearchStatus.failed,
        searchError: error.toString(),
      ));
    });
  }

  Future<void> selectFeed({
    required String token,
    required PodcastFeedEntity feed,
  }) async {
    _token = token;
    if (feed.id == null) return;
    emit(state.copyWith(
      selectedFeed: feed,
      episodesStatus: PodcastEpisodesStatus.loading,
      episodes: const [],
      clearEpisodesError: true,
      clearSelectedEpisodeKey: true,
    ));
    await podcastUseCase
        .getEpisodes(token: token, feedId: feed.id!)
        .then((res) {
      res.fold((err) {
        log('Podcast episodes error: ${err.message}');
        emit(state.copyWith(
          episodesStatus: PodcastEpisodesStatus.failed,
          episodesError: err.message,
        ));
      }, (episodes) {
        emit(state.copyWith(
          episodesStatus: PodcastEpisodesStatus.loaded,
          episodes: episodes,
        ));
      });
    }).onError((error, stackTrace) {
      log('Podcast episodes error: $error');
      emit(state.copyWith(
        episodesStatus: PodcastEpisodesStatus.failed,
        episodesError: error.toString(),
      ));
    });
  }

  void backToShows() {
    emit(state.copyWith(
      clearSelectedFeed: true,
      episodes: const [],
      episodesStatus: PodcastEpisodesStatus.idle,
      clearEpisodesError: true,
      clearSelectedEpisodeKey: true,
    ));
  }

  void selectEpisode(String? episodeKey) {
    emit(state.copyWith(
      selectedEpisodeKey: episodeKey,
      clearSelectedEpisodeKey: episodeKey == null,
      // Reset import state when picking a different episode.
      importStatus: PodcastImportStatus.idle,
      clearImportError: true,
      clearImportedFileId: true,
    ));
  }

  /// POSTs to `/v1/podcasts/download-and-import` with the exact payload
  /// shape the web sends. Returns the new fileId or null on failure.
  Future<String?> startPodcastImport({
    required String token,
    required Map<String, dynamic> body,
  }) async {
    emit(state.copyWith(
      importStatus: PodcastImportStatus.importing,
      clearImportError: true,
      clearImportedFileId: true,
    ));

    String? fileId;
    await podcastUseCase
        .downloadAndImport(token: token, body: body)
        .then((res) {
      res.fold((err) {
        log('Podcast import error: ${err.message}');
        emit(state.copyWith(
          importStatus: PodcastImportStatus.failed,
          importError: err.message,
        ));
      }, (id) {
        fileId = id;
        emit(state.copyWith(
          importStatus: PodcastImportStatus.success,
          importedFileId: id,
        ));
      });
    }).onError((error, stackTrace) {
      log('Podcast import error: $error');
      emit(state.copyWith(
        importStatus: PodcastImportStatus.failed,
        importError: error.toString(),
      ));
    });
    return fileId;
  }
}
