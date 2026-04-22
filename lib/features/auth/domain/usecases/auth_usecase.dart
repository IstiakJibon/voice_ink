import 'package:dartz/dartz.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/features/auth/data/models/forgot_pass_uc.dart';
import 'package:voice_ink/features/auth/data/models/login_uc.dart';
import 'package:voice_ink/features/auth/data/models/registation_uc.dart';
import 'package:voice_ink/features/auth/data/models/reset_pass_uc.dart';
import 'package:voice_ink/features/auth/domain/entities/user_entities.dart';
import 'package:voice_ink/features/auth/domain/repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository authRepository;

  AuthUseCase({required this.authRepository});

  Future<Either<Failure, UserEntities>> getLogin(
      {required LoginUc loginUc}) async {
    return await authRepository.getLogin(loginUc: loginUc);
  }

  Future<Either<Failure, UserEntities>> registration(
      {required RegistrationUc registrationUc}) async {
    return await authRepository.registration(registrationUc: registrationUc);
  }

  Future<Either<Failure, String>> forgotPassword(
      {required ForgotPasswordUc forgotPasswordUc}) async {
    return await authRepository.forgotPassword(
        forgotPasswordUc: forgotPasswordUc);
  }

  Future<Either<Failure, bool>> resetPassword(
      {required ResetPasswordUc resetPasswordUc}) async {
    return await authRepository.resetPassword(
        resetPasswordUc: resetPasswordUc);
  }
}