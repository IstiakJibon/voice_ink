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
}