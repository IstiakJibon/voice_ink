import 'package:equatable/equatable.dart';
import 'package:voice_ink/config/utilities/enum/bloc_api_state.dart';
import 'package:voice_ink/features/files/domain/entities/audio_file_entities.dart';

class FilesState extends Equatable {
  final NormalApiState apiState;
  final AudioFileListEntities audioFiles;
  final List<AudioFileEntity> allFiles;
  final String errorMessage;
  final int currentPage;
  final bool isLoadingMore;
  final String sortBy;
  final String sortOrder;

  const FilesState({
    required this.apiState,
    required this.audioFiles,
    required this.allFiles,
    required this.errorMessage,
    required this.currentPage,
    required this.isLoadingMore,
    required this.sortBy,
    required this.sortOrder,
  });

  /// Group files by date (TODAY, YESTERDAY, OLDER)
  Map<String, List<AudioFileEntity>> get groupedFiles {
    final Map<String, List<AudioFileEntity>> grouped = {
      'TODAY': [],
      'YESTERDAY': [],
      'OLDER': [],
    };

    for (final file in allFiles) {
      final group = file.dateGroup;
      grouped[group]?.add(file);
    }

    // Remove empty groups
    grouped.removeWhere((key, value) => value.isEmpty);

    return grouped;
  }

  @override
  List<Object?> get props => [
        apiState,
        audioFiles,
        allFiles,
        errorMessage,
        currentPage,
        isLoadingMore,
        sortBy,
        sortOrder,
      ];

  FilesState copyWith({
    NormalApiState? apiState,
    AudioFileListEntities? audioFiles,
    List<AudioFileEntity>? allFiles,
    String? errorMessage,
    int? currentPage,
    bool? isLoadingMore,
    String? sortBy,
    String? sortOrder,
  }) {
    return FilesState(
      apiState: apiState ?? this.apiState,
      audioFiles: audioFiles ?? this.audioFiles,
      allFiles: allFiles ?? this.allFiles,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
