import 'dart:developer';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:voice_ink/config/utilities/enum/bloc_api_state.dart';
import 'package:voice_ink/features/auth/data/models/login_uc.dart';
import 'package:voice_ink/features/auth/domain/entities/user_entities.dart';
import 'package:voice_ink/features/auth/domain/usecases/auth_usecase.dart';
import 'package:voice_ink/features/auth/presentation/cubit/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthUseCase authUseCase;

  LoginCubit({required this.authUseCase})
      : super(
          LoginState(
            apiState: NormalApiState.initial,
            userEntities: UserEntities.initial(),
            errorMessage: "Please Swipe Down to Refresh",
          ),
        );

  Future<void> getLogins(LoginUc loginUc) async {
    emit(state.copyWith(apiState: NormalApiState.loading));
    await authUseCase.getLogin(loginUc: loginUc).then((res) {
      res.fold((err) {
        log("call err ${err.toString()}");
        return emit(state.copyWith(
            apiState: NormalApiState.failure, errorMessage: err.message));
      }, (suc) {
        return emit(state.copyWith(
            apiState: NormalApiState.loaded,
            userEntities: suc,
            errorMessage: ""));
      });
    }).onError((error, stackTrace) {
      log("Error cubit 25 : ${error.toString()}");
      emit(
        state.copyWith(
            apiState: NormalApiState.failure, errorMessage: error.toString()),
      );
    });
  }
}