import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_ink/config/utilities/enum/bloc_api_state.dart';
import 'package:voice_ink/features/auth/data/models/forgot_pass_uc.dart';
import 'package:voice_ink/features/auth/domain/usecases/auth_usecase.dart';
import 'package:voice_ink/features/auth/presentation/cubit/forgot_password/forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthUseCase authUseCase;

  ForgotPasswordCubit({required this.authUseCase})
      : super(const ForgotPasswordState(
          apiState: NormalApiState.initial,
          hash: '',
          errorMessage: '',
        ));

  Future<void> forgotPassword(ForgotPasswordUc forgotPasswordUc) async {
    emit(state.copyWith(apiState: NormalApiState.loading));
    await authUseCase.forgotPassword(forgotPasswordUc: forgotPasswordUc).then((res) {
      res.fold((err) {
        log("Forgot password error: ${err.toString()}");
        return emit(state.copyWith(
            apiState: NormalApiState.failure, errorMessage: err.message));
      }, (hash) {
        log("Forgot password success, hash: $hash");
        return emit(state.copyWith(
            apiState: NormalApiState.loaded,
            hash: hash,
            errorMessage: ""));
      });
    }).onError((error, stackTrace) {
      log("Forgot password error: ${error.toString()}");
      emit(
        state.copyWith(
            apiState: NormalApiState.failure, errorMessage: error.toString()),
      );
    });
  }

  void resetState() {
    emit(const ForgotPasswordState(
      apiState: NormalApiState.initial,
      hash: '',
      errorMessage: '',
    ));
  }
}