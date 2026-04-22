import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_ink/config/utilities/enum/bloc_api_state.dart';
import 'package:voice_ink/features/auth/data/models/reset_pass_uc.dart';
import 'package:voice_ink/features/auth/domain/usecases/auth_usecase.dart';
import 'package:voice_ink/features/auth/presentation/cubit/reset_password/reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final AuthUseCase authUseCase;

  ResetPasswordCubit({required this.authUseCase})
      : super(const ResetPasswordState(
          apiState: NormalApiState.initial,
          errorMessage: '',
        ));

  Future<void> resetPassword(ResetPasswordUc resetPasswordUc) async {
    emit(state.copyWith(apiState: NormalApiState.loading));
    await authUseCase.resetPassword(resetPasswordUc: resetPasswordUc).then((res) {
      res.fold((err) {
        log("Reset password error: ${err.toString()}");
        return emit(state.copyWith(
            apiState: NormalApiState.failure, errorMessage: err.message));
      }, (success) {
        log("Reset password success");
        return emit(state.copyWith(
            apiState: NormalApiState.loaded,
            errorMessage: ""));
      });
    }).onError((error, stackTrace) {
      log("Reset password error: ${error.toString()}");
      emit(
        state.copyWith(
            apiState: NormalApiState.failure, errorMessage: error.toString()),
      );
    });
  }

  void resetState() {
    emit(const ResetPasswordState(
      apiState: NormalApiState.initial,
      errorMessage: '',
    ));
  }
}