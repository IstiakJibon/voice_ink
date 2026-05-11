import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_ink/config/utilities/enum/bloc_api_state.dart';
import 'package:voice_ink/features/files/domain/entities/audio_file_entities.dart';
import 'package:voice_ink/features/files/domain/usecases/files_usecase.dart';
import 'package:voice_ink/features/files/presentation/cubit/files_state.dart';

class FilesCubit extends Cubit<FilesState> {
  final FilesUseCase filesUseCase;

  FilesCubit({required this.filesUseCase})
      : super(FilesState(
          apiState: NormalApiState.initial,
          audioFiles: AudioFileListEntities.empty(),
          allFiles: [],
          errorMessage: '',
          currentPage: 1,
          isLoadingMore: false,
          sortBy: 'createdAt',
          sortOrder: 'DESC',
        ));

  static const int _limit = 20;
  String _token = '';
  Timer? _searchDebounce;

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  /// Fetch initial files (page 1)
  Future<void> getAudioFiles({required String token}) async {
    _token = token;
    emit(state.copyWith(
      apiState: NormalApiState.loading,
      currentPage: 1,
      allFiles: [],
    ));

    await filesUseCase
        .getAudioFiles(
      token: token,
      page: 1,
      limit: _limit,
      sortBy: state.sortBy,
      sortOrder: state.sortOrder,
      search: state.searchQuery,
      source: state.filterSourceParam,
      isFavorite: state.filterFavoriteParam,
      folderId: state.folderId,
    )
        .then((res) {
      res.fold((err) {
        log("Get audio files error: ${err.toString()}");
        emit(state.copyWith(
          apiState: NormalApiState.failure,
          errorMessage: err.message,
        ));
      }, (data) {
        log("Get audio files success: ${data.data.length} files");
        emit(state.copyWith(
          apiState: NormalApiState.loaded,
          audioFiles: data,
          allFiles: data.data,
          currentPage: data.page,
          errorMessage: '',
        ));
      });
    }).onError((error, stackTrace) {
      log("Get audio files error: ${error.toString()}");
      emit(state.copyWith(
        apiState: NormalApiState.failure,
        errorMessage: error.toString(),
      ));
    });
  }

  /// Load more files (pagination)
  Future<void> loadMoreFiles() async {
    // Don't load if already loading or no more data
    if (state.isLoadingMore || !state.audioFiles.hasMore || _token.isEmpty) {
      return;
    }

    final nextPage = state.currentPage + 1;

    emit(state.copyWith(isLoadingMore: true));

    await filesUseCase
        .getAudioFiles(
      token: _token,
      page: nextPage,
      limit: _limit,
      sortBy: state.sortBy,
      sortOrder: state.sortOrder,
      search: state.searchQuery,
      source: state.filterSourceParam,
      isFavorite: state.filterFavoriteParam,
      folderId: state.folderId,
    )
        .then((res) {
      res.fold((err) {
        log("Load more files error: ${err.toString()}");
        emit(state.copyWith(
          isLoadingMore: false,
          errorMessage: err.message,
        ));
      }, (data) {
        log("Load more files success: ${data.data.length} more files");
        // Append new files to existing list
        final updatedFiles = [...state.allFiles, ...data.data];
        emit(state.copyWith(
          audioFiles: data,
          allFiles: updatedFiles,
          currentPage: data.page,
          isLoadingMore: false,
          errorMessage: '',
        ));
      });
    }).onError((error, stackTrace) {
      log("Load more files error: ${error.toString()}");
      emit(state.copyWith(
        isLoadingMore: false,
        errorMessage: error.toString(),
      ));
    });
  }

  /// Refresh files (pull to refresh)
  Future<void> refreshFiles() async {
    if (_token.isEmpty) return;
    emit(state.copyWith(currentPage: 1, allFiles: []));
    await getAudioFiles(token: _token);
  }

  /// Change sort options and reload
  Future<void> changeSortOption({
    required String sortBy,
    required String sortOrder,
  }) async {
    if (_token.isEmpty) return;
    emit(state.copyWith(
      sortBy: sortBy,
      sortOrder: sortOrder,
      currentPage: 1,
      allFiles: [],
    ));
    await getAudioFiles(token: _token);
  }

  /// Change filter chip (All / Uploads / Favorites / Imported) — server-side
  Future<void> changeFilter(FilesFilter filter) async {
    if (state.filter == filter || _token.isEmpty) return;
    emit(state.copyWith(
      filter: filter,
      currentPage: 1,
      allFiles: [],
    ));
    await getAudioFiles(token: _token);
  }

  /// Select a folder to filter files by. Pass null to show all files.
  Future<void> selectFolder(String? folderId) async {
    if (state.folderId == folderId || _token.isEmpty) return;
    emit(state.copyWith(
      folderId: folderId,
      clearFolderId: folderId == null,
      currentPage: 1,
      allFiles: [],
    ));
    await getAudioFiles(token: _token);
  }

  /// Search files (debounced 350ms). Empty query reloads full list.
  void searchFiles(String query) {
    _searchDebounce?.cancel();
    final trimmed = query.trim();
    if (trimmed == state.searchQuery) return;

    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (_token.isEmpty) return;
      emit(state.copyWith(
        searchQuery: trimmed,
        currentPage: 1,
        allFiles: [],
      ));
      getAudioFiles(token: _token);
    });
  }

  /// Toggle favorite with optimistic update (revert on failure)
  Future<void> toggleFavorite({required String fileId}) async {
    if (_token.isEmpty) return;

    final index = state.allFiles.indexWhere((f) => f.id == fileId);
    if (index == -1) return;

    final original = state.allFiles[index];
    final newValue = !(original.isFavorite ?? false);

    final optimisticList = [...state.allFiles];
    optimisticList[index] = original.copyWith(isFavorite: newValue);
    emit(state.copyWith(allFiles: optimisticList));

    await filesUseCase
        .toggleFavorite(
      token: _token,
      fileId: fileId,
      isFavorite: newValue,
    )
        .then((res) {
      res.fold((err) {
        log("Toggle favorite error: ${err.toString()}");
        final revertList = [...state.allFiles];
        final i = revertList.indexWhere((f) => f.id == fileId);
        if (i != -1) {
          revertList[i] = revertList[i].copyWith(isFavorite: !newValue);
          emit(state.copyWith(
            allFiles: revertList,
            errorMessage: err.message,
          ));
        }
      }, (_) {
        log("Toggle favorite success: $fileId -> $newValue");
      });
    }).onError((error, stackTrace) {
      log("Toggle favorite error: ${error.toString()}");
      final revertList = [...state.allFiles];
      final i = revertList.indexWhere((f) => f.id == fileId);
      if (i != -1) {
        revertList[i] = revertList[i].copyWith(isFavorite: !newValue);
        emit(state.copyWith(allFiles: revertList));
      }
    });
  }
}