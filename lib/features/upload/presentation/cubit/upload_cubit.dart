import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_ink/features/upload/domain/entities/upload_entity.dart';
import 'package:voice_ink/features/upload/domain/repositories/upload_repository.dart';
import 'package:voice_ink/features/upload/domain/usecases/upload_usecase.dart';
import 'package:voice_ink/features/upload/presentation/cubit/upload_state.dart';

class UploadCubit extends Cubit<UploadState> {
  final UploadUseCase uploadUseCase;

  UploadCubit({required this.uploadUseCase}) : super(UploadState.initial());

  void addFiles(List<UploadItem> newItems) {
    if (newItems.isEmpty) return;
    emit(state.copyWith(
      items: [...state.items, ...newItems],
      allDone: false,
      clearGlobalError: true,
    ));
  }

  void removeItem(String localId) {
    emit(state.copyWith(
      items: state.items.where((i) => i.localId != localId).toList(),
    ));
  }

  void reset() => emit(UploadState.initial());

  void _patchItem(String localId, UploadItem Function(UploadItem) update) {
    final next = state.items.map((i) {
      if (i.localId != localId) return i;
      return update(i);
    }).toList();
    emit(state.copyWith(items: next));
  }

  /// Runs the 3-step batch upload (presign → S3 PUT → complete) sequentially
  /// across pending items. Each item's progress is reflected in state.
  Future<void> startBatchUpload({
    required String token,
    required bool autoTranscribe,
    String language = 'en',
    String provider = 'assemblyai',
  }) async {
    if (state.isBusy) return;
    final pending = state.items
        .where((i) => i.stage == UploadStage.pending || i.stage == UploadStage.failed)
        .toList();
    if (pending.isEmpty) return;

    emit(state.copyWith(isBusy: true, clearGlobalError: true, allDone: false));

    // Mark all pending as presigning
    for (final item in pending) {
      _patchItem(
        item.localId,
        (i) => i.copyWith(
          stage: UploadStage.presigning,
          progress: 0,
          clearError: true,
        ),
      );
    }

    final presignRes = await uploadUseCase.requestPresignedUrls(
      token: token,
      files: pending
          .map((i) => PresignedFileInput(
                fileName: i.name,
                fileSize: i.size,
                contentType: i.contentType,
              ))
          .toList(),
    );

    final List<PresignedUploadEntity> presigned = presignRes.fold((err) {
      log('Presign failed: ${err.message}');
      for (final item in pending) {
        _patchItem(
          item.localId,
          (i) => i.copyWith(
            stage: UploadStage.failed,
            errorMessage: err.message,
          ),
        );
      }
      emit(state.copyWith(isBusy: false, globalError: err.message));
      return <PresignedUploadEntity>[];
    }, (data) => data);

    if (presigned.isEmpty) return;

    // Match presigned entries to pending items by filename (order may vary).
    final List<CompleteUploadInput> completed = [];
    for (int i = 0; i < pending.length; i++) {
      final item = pending[i];
      final match = _findMatch(presigned, item.name) ??
          (i < presigned.length ? presigned[i] : null);
      if (match == null ||
          match.uploadUrl == null ||
          match.fileId == null ||
          match.filePath == null) {
        _patchItem(
          item.localId,
          (it) => it.copyWith(
            stage: UploadStage.failed,
            errorMessage: 'No presigned URL returned',
          ),
        );
        continue;
      }
      _patchItem(
        item.localId,
        (it) => it.copyWith(
          stage: UploadStage.uploading,
          fileId: match.fileId,
          remotePath: match.filePath,
          progress: 0,
        ),
      );

      final putRes = await uploadUseCase.uploadToPresignedUrl(
        uploadUrl: match.uploadUrl!,
        localPath: item.localPath,
        contentType: item.contentType,
        onProgress: (p) {
          _patchItem(item.localId, (it) => it.copyWith(progress: p));
        },
      );

      final ok = putRes.fold((err) {
        _patchItem(
          item.localId,
          (it) => it.copyWith(
            stage: UploadStage.failed,
            errorMessage: err.message,
          ),
        );
        return false;
      }, (_) => true);

      if (!ok) continue;

      _patchItem(
        item.localId,
        (it) => it.copyWith(stage: UploadStage.completing, progress: 1),
      );

      completed.add(CompleteUploadInput(
        fileId: match.fileId!,
        filePath: match.filePath!,
        fileName: item.name,
      ));
    }

    if (completed.isEmpty) {
      emit(state.copyWith(isBusy: false, allDone: false));
      return;
    }

    final completeRes = await uploadUseCase.completeBatch(
      token: token,
      uploads: completed,
      autoTranscribe: autoTranscribe,
      language: language,
      provider: provider,
    );

    completeRes.fold((err) {
      log('Complete batch failed: ${err.message}');
      // Mark the ones that finished uploading as failed at the completion step
      for (final c in completed) {
        final localId = state.items
            .firstWhere(
              (it) => it.fileId == c.fileId,
              orElse: () => state.items.first,
            )
            .localId;
        _patchItem(
          localId,
          (it) => it.copyWith(
            stage: UploadStage.failed,
            errorMessage: err.message,
          ),
        );
      }
      emit(state.copyWith(isBusy: false, globalError: err.message));
    }, (_) {
      for (final c in completed) {
        final match = state.items.firstWhere(
          (it) => it.fileId == c.fileId,
          orElse: () => state.items.first,
        );
        _patchItem(
          match.localId,
          (it) => it.copyWith(stage: UploadStage.done, progress: 1),
        );
      }
      emit(state.copyWith(isBusy: false, allDone: true));
    });
  }

  PresignedUploadEntity? _findMatch(
    List<PresignedUploadEntity> presigned,
    String fileName,
  ) {
    for (final p in presigned) {
      if (p.fileName == fileName) return p;
    }
    return null;
  }
}
