import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_ink/config/utilities/enum/bloc_api_state.dart';
import 'package:voice_ink/features/folder/domain/entities/folder_entity.dart';
import 'package:voice_ink/features/folder/domain/usecases/folder_usecase.dart';
import 'package:voice_ink/features/folder/presentation/cubit/folder_state.dart';

class FolderCubit extends Cubit<FolderState> {
  final FolderUseCase folderUseCase;

  FolderCubit({required this.folderUseCase}) : super(FolderState.initial());

  String _token = '';

  /// Fetch nested tree (the primary call for the folders section)
  Future<void> getFoldersTree({required String token}) async {
    _token = token;
    emit(state.copyWith(apiState: NormalApiState.loading));

    await folderUseCase.getFoldersTree(token: token).then((res) {
      res.fold((err) {
        log("Get folders tree error: ${err.toString()}");
        emit(state.copyWith(
          apiState: NormalApiState.failure,
          errorMessage: err.message,
        ));
      }, (data) {
        emit(state.copyWith(
          apiState: NormalApiState.loaded,
          tree: data,
          errorMessage: '',
        ));
      });
    }).onError((error, stackTrace) {
      log("Get folders tree error: ${error.toString()}");
      emit(state.copyWith(
        apiState: NormalApiState.failure,
        errorMessage: error.toString(),
      ));
    });
  }

  /// Toggle a folder's expansion in the tree
  void toggleExpanded(String folderId) {
    final set = {...state.expandedFolderIds};
    if (set.contains(folderId)) {
      set.remove(folderId);
    } else {
      set.add(folderId);
    }
    emit(state.copyWith(expandedFolderIds: set));
  }

  /// Select a folder (filters files by folderId). null = "All Files"
  void selectFolder(String? folderId) {
    if (state.selectedFolderId == folderId) return;
    emit(state.copyWith(
      selectedFolderId: folderId,
      clearSelectedFolderId: folderId == null,
    ));
  }

  /// Create a new folder. Refreshes the tree on success.
  Future<FolderEntity?> createFolder({
    required String name,
    String? description,
    String? color,
    String? parentId,
  }) async {
    if (_token.isEmpty) return null;
    emit(state.copyWith(isCreating: true, clearCreateError: true));

    FolderEntity? created;
    await folderUseCase
        .createFolder(
      token: _token,
      name: name,
      description: description,
      color: color,
      parentId: parentId,
    )
        .then((res) {
      res.fold((err) {
        log("Create folder error: ${err.toString()}");
        emit(state.copyWith(
          isCreating: false,
          createError: err.message,
        ));
      }, (folder) {
        created = folder;
        emit(state.copyWith(isCreating: false));
      });
    }).onError((error, stackTrace) {
      log("Create folder error: ${error.toString()}");
      emit(state.copyWith(
        isCreating: false,
        createError: error.toString(),
      ));
    });

    if (created != null) {
      await getFoldersTree(token: _token);
    }
    return created;
  }
}
