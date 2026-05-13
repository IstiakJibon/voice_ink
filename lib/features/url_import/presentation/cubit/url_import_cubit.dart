import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_ink/features/url_import/domain/usecases/url_import_usecase.dart';
import 'package:voice_ink/features/url_import/presentation/cubit/url_import_state.dart';

class UrlImportCubit extends Cubit<UrlImportState> {
  final UrlImportUseCase urlImportUseCase;

  UrlImportCubit({required this.urlImportUseCase})
      : super(UrlImportState.initial());

  void toggleAutoTranscribe(bool value) =>
      emit(state.copyWith(autoTranscribe: value));

  void toggleSpeakerIdentification(bool value) =>
      emit(state.copyWith(speakerIdentification: value));

  void resetForNewUrl() {
    emit(state.copyWith(
      checkStatus: UrlCheckStatus.idle,
      clearCheckError: true,
      clearCheckResult: true,
      importStatus: UrlImportStatus.idle,
      clearImportError: true,
      clearImportedFileId: true,
    ));
  }

  Future<void> checkUrl({
    required String token,
    required String url,
  }) async {
    emit(state.copyWith(
      checkStatus: UrlCheckStatus.checking,
      clearCheckError: true,
      clearCheckResult: true,
    ));

    await urlImportUseCase
        .checkUrl(token: token, url: url)
        .then((res) {
      res.fold((err) {
        log('Check URL error: ${err.message}');
        emit(state.copyWith(
          checkStatus: UrlCheckStatus.failed,
          checkError: err.message,
        ));
      }, (data) {
        if (data.isValid) {
          emit(state.copyWith(
            checkStatus: UrlCheckStatus.ok,
            checkResult: data,
          ));
        } else {
          emit(state.copyWith(
            checkStatus: UrlCheckStatus.failed,
            checkError: data.errorMessage ?? 'URL is not supported',
          ));
        }
      });
    }).onError((error, stackTrace) {
      log('Check URL error: $error');
      emit(state.copyWith(
        checkStatus: UrlCheckStatus.failed,
        checkError: error.toString(),
      ));
    });
  }

  Future<void> importUrl({
    required String token,
    required String url,
    String name = 'YouTube Import',
  }) async {
    emit(state.copyWith(
      importStatus: UrlImportStatus.importing,
      clearImportError: true,
      clearImportedFileId: true,
    ));

    await urlImportUseCase
        .importUrl(
      token: token,
      url: url,
      name: name,
      autoTranscribe: state.autoTranscribe,
      speakerIdentification: state.speakerIdentification,
    )
        .then((res) {
      res.fold((err) {
        log('Import URL error: ${err.message}');
        emit(state.copyWith(
          importStatus: UrlImportStatus.failed,
          importError: err.message,
        ));
      }, (data) {
        if (data.fileId == null) {
          emit(state.copyWith(
            importStatus: UrlImportStatus.failed,
            importError: data.errorMessage ?? 'Import failed',
          ));
          return;
        }
        emit(state.copyWith(
          importStatus: UrlImportStatus.success,
          importedFileId: data.fileId,
        ));
      });
    }).onError((error, stackTrace) {
      log('Import URL error: $error');
      emit(state.copyWith(
        importStatus: UrlImportStatus.failed,
        importError: error.toString(),
      ));
    });
  }
}
