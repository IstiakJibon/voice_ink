import 'package:equatable/equatable.dart';
import 'package:voice_ink/features/upload/domain/entities/upload_entity.dart';

class UploadState extends Equatable {
  final List<UploadItem> items;
  final bool isBusy;
  final bool allDone;
  final String? globalError;

  const UploadState({
    required this.items,
    required this.isBusy,
    required this.allDone,
    required this.globalError,
  });

  factory UploadState.initial() => const UploadState(
        items: [],
        isBusy: false,
        allDone: false,
        globalError: null,
      );

  UploadState copyWith({
    List<UploadItem>? items,
    bool? isBusy,
    bool? allDone,
    String? globalError,
    bool clearGlobalError = false,
  }) {
    return UploadState(
      items: items ?? this.items,
      isBusy: isBusy ?? this.isBusy,
      allDone: allDone ?? this.allDone,
      globalError: clearGlobalError ? null : (globalError ?? this.globalError),
    );
  }

  bool get hasItems => items.isNotEmpty;
  int get successCount =>
      items.where((i) => i.stage == UploadStage.done).length;
  int get failedCount =>
      items.where((i) => i.stage == UploadStage.failed).length;

  @override
  List<Object?> get props => [items, isBusy, allDone, globalError];
}
