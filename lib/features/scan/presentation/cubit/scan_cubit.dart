import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_ink/features/scan/domain/usecases/scan_usecase.dart';
import 'package:voice_ink/features/scan/presentation/cubit/scan_state.dart';

class ScanCubit extends Cubit<ScanState> {
  final ScanUseCase scanUseCase;

  ScanCubit({required this.scanUseCase}) : super(ScanState.initial());

  void dismissError() {
    emit(state.copyWith(
      status: ScanStatus.idle,
      clearError: true,
    ));
  }

  void reset() => emit(ScanState.initial());

  Future<void> extractFromFile({
    required String token,
    required String filePath,
    required String fileName,
  }) async {
    emit(state.copyWith(
      status: ScanStatus.extracting,
      imagePath: filePath,
      imageName: fileName,
      clearResult: true,
      clearError: true,
    ));

    await scanUseCase
        .extractText(
      token: token,
      filePath: filePath,
      fileName: fileName,
    )
        .then((res) {
      res.fold((err) {
        log('Scan error: ${err.message}');
        emit(state.copyWith(
          status: ScanStatus.failed,
          errorMessage: err.message,
        ));
      }, (data) {
        emit(state.copyWith(
          status: ScanStatus.success,
          result: data,
        ));
      });
    }).onError((error, stackTrace) {
      log('Scan error: $error');
      emit(state.copyWith(
        status: ScanStatus.failed,
        errorMessage: error.toString(),
      ));
    });
  }
}
