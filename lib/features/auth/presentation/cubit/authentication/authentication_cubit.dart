import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:voice_ink/features/auth/domain/entities/user_entities.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends HydratedCubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationState.initial());

  void makeAuthenticate({required final UserEntities user}) {
    emit(AuthenticationState.initial());
    log("authislog : ${user.token}");
    emit(state.copyWith(
      user: user,
      isLoggedIn: true,
    ));
  }

  @override
  AuthenticationState? fromJson(Map<String, dynamic> json) {
    log("json = $json");
    return AuthenticationState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(AuthenticationState state) {
    return state.toMap();
  }

  void logout() {
    emit(AuthenticationState.initial());
  }
}