import 'package:equatable/equatable.dart';
import 'package:voice_ink/config/utilities/enum/bloc_api_state.dart';
import 'package:voice_ink/features/folder/domain/entities/folder_entity.dart';

class FolderState extends Equatable {
  final NormalApiState apiState;
  final List<FolderEntity> tree;
  final String errorMessage;
  final bool isCreating;
  final String? createError;
  final String? selectedFolderId;
  final Set<String> expandedFolderIds;

  const FolderState({
    required this.apiState,
    required this.tree,
    required this.errorMessage,
    required this.isCreating,
    required this.createError,
    required this.selectedFolderId,
    required this.expandedFolderIds,
  });

  factory FolderState.initial() {
    return const FolderState(
      apiState: NormalApiState.initial,
      tree: [],
      errorMessage: '',
      isCreating: false,
      createError: null,
      selectedFolderId: null,
      expandedFolderIds: {},
    );
  }

  /// Total folder count across the tree (recursive)
  int get totalCount {
    int count = 0;
    void walk(List<FolderEntity> nodes) {
      for (final n in nodes) {
        count++;
        if (n.children.isNotEmpty) walk(n.children);
      }
    }

    walk(tree);
    return count;
  }

  FolderState copyWith({
    NormalApiState? apiState,
    List<FolderEntity>? tree,
    String? errorMessage,
    bool? isCreating,
    String? createError,
    bool clearCreateError = false,
    String? selectedFolderId,
    bool clearSelectedFolderId = false,
    Set<String>? expandedFolderIds,
  }) {
    return FolderState(
      apiState: apiState ?? this.apiState,
      tree: tree ?? this.tree,
      errorMessage: errorMessage ?? this.errorMessage,
      isCreating: isCreating ?? this.isCreating,
      createError:
          clearCreateError ? null : (createError ?? this.createError),
      selectedFolderId: clearSelectedFolderId
          ? null
          : (selectedFolderId ?? this.selectedFolderId),
      expandedFolderIds: expandedFolderIds ?? this.expandedFolderIds,
    );
  }

  @override
  List<Object?> get props => [
        apiState,
        tree,
        errorMessage,
        isCreating,
        createError,
        selectedFolderId,
        expandedFolderIds,
      ];
}
