import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_ink/features/auth/domain/entities/user_entities.dart';
import 'package:voice_ink/features/auth/presentation/cubit/authentication/authentication_cubit.dart';

extension UserExtension on BuildContext {
  AuthenticationState get state => read<AuthenticationCubit>().state;
  UserEntities get user => state.user;
  String get token => user.token;
}
