import 'package:dartz/dartz.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/features/auth/data/models/forgot_pass_uc.dart';
import 'package:voice_ink/features/auth/data/models/login_uc.dart';
import 'package:voice_ink/features/auth/data/models/registation_uc.dart';
import 'package:voice_ink/features/auth/data/models/reset_pass_uc.dart';
import 'package:voice_ink/features/auth/domain/entities/user_entities.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntities>> getLogin({required LoginUc loginUc});

  Future<Either<Failure, UserEntities>> registration(
      {required RegistrationUc registrationUc});

  Future<Either<Failure, String>> forgotPassword(
      {required ForgotPasswordUc forgotPasswordUc});

  Future<Either<Failure, bool>> resetPassword(
      {required ResetPasswordUc resetPasswordUc});
}