import 'package:dartz/dartz.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/features/auth/data/datasources/auth_remote.dart';
import 'package:voice_ink/features/auth/data/models/forgot_pass_uc.dart';
import 'package:voice_ink/features/auth/data/models/login_uc.dart';
import 'package:voice_ink/features/auth/data/models/registation_uc.dart';
import 'package:voice_ink/features/auth/data/models/reset_pass_uc.dart';
import 'package:voice_ink/features/auth/domain/entities/user_entities.dart';
import 'package:voice_ink/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteServices authRemoteServices;

  AuthRepositoryImpl({required this.authRemoteServices});

  @override
  Future<Either<Failure, UserEntities>> getLogin(
      {required LoginUc loginUc}) async {
    return await authRemoteServices.getLogin(loginUc: loginUc);
  }

  @override
  Future<Either<Failure, UserEntities>> registration(
      {required RegistrationUc registrationUc}) async {
    return await authRemoteServices.registration(registrationUc: registrationUc);
  }

  @override
  Future<Either<Failure, String>> forgotPassword(
      {required ForgotPasswordUc forgotPasswordUc}) async {
    return await authRemoteServices.forgotPassword(
        forgotPasswordUc: forgotPasswordUc);
  }

  @override
  Future<Either<Failure, bool>> resetPassword(
      {required ResetPasswordUc resetPasswordUc}) async {
    return await authRemoteServices.resetPassword(
        resetPasswordUc: resetPasswordUc);
  }
}