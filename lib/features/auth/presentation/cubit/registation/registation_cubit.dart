import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_ink/config/utilities/enum/bloc_api_state.dart';
import 'package:voice_ink/features/auth/data/models/registation_uc.dart';
import 'package:voice_ink/features/auth/domain/entities/user_entities.dart';
import 'package:voice_ink/features/auth/domain/usecases/auth_usecase.dart';
import 'package:voice_ink/features/auth/presentation/cubit/registation/registation_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final AuthUseCase authUseCase;

  RegistrationCubit({required this.authUseCase})
      : super(
          RegistrationState(
            apiState: NormalApiState.initial,
            userEntities: UserEntities.initial(),
            errorMessage: "",
          ),
        );

  Future<void> register(RegistrationUc registrationUc) async {
    emit(state.copyWith(apiState: NormalApiState.loading));
    await authUseCase.registration(registrationUc: registrationUc).then((res) {
      res.fold((err) {
        log("Registration error: ${err.toString()}");
        return emit(state.copyWith(
            apiState: NormalApiState.failure, errorMessage: err.message));
      }, (suc) {
        return emit(state.copyWith(
            apiState: NormalApiState.loaded,
            userEntities: suc,
            errorMessage: ""));
      });
    }).onError((error, stackTrace) {
      log("Registration error: ${error.toString()}");
      emit(
        state.copyWith(
            apiState: NormalApiState.failure, errorMessage: error.toString()),
      );
    });
  }

  void resetState() {
    emit(RegistrationState(
      apiState: NormalApiState.initial,
      userEntities: UserEntities.initial(),
      errorMessage: "",
    ));
  }
}