import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:voice_ink/config/const/app/api_endpoints.dart';
import 'package:voice_ink/config/di/dependency_injector.dart';
import 'package:voice_ink/core/error/api_error_generator.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/core/network/dio_client/dio_client.dart';
import 'package:voice_ink/core/network/dio_client/request_params.dart';
import 'package:voice_ink/features/auth/data/models/forgot_pass_uc.dart';
import 'package:voice_ink/features/auth/data/models/login_uc.dart';
import 'package:voice_ink/features/auth/data/models/registation_uc.dart';
import 'package:voice_ink/features/auth/data/models/reset_pass_uc.dart';
import 'package:voice_ink/features/auth/data/models/user_model.dart';

class AuthRemoteServices {
  final DioClient _dioClient = sl<DioClient>();

  Future<Either<Failure, UserModel>> getLogin(
      {required LoginUc loginUc}) async {
    final APIRequestParam param = APIRequestParam(
      path: ApiEndPoints.login,
      data: loginUc.toJson(),
      doCache: false,
      isRequiredAuth: false,
    );
    return await _dioClient.post(param).then((response) {
      return response.fold((l) {
        log("Login Error Exception : ${l.response?.statusCode}");
        log("Login Error Response : ${l.response?.data}");
        return Left(ApiErrorGenerator.apiError(l));
      }, (r) {
        try {
          log("Login Response: ${r.data}");
          UserModel userModel = UserModel.fromJson(r.data);
          return Right(userModel);
        } on Exception catch (e) {
          log("Login Parse Error: ${e.toString()}");
          return Left(InvalidFormatFailure(
            message: e.toString(),
          ));
        }
      });
    });
  }

  Future<Either<Failure, UserModel>> registration(
      {required RegistrationUc registrationUc}) async {
    final APIRequestParam param = APIRequestParam(
      path: ApiEndPoints.regiserLogin,
      data: registrationUc.toJson(),
      doCache: false,
      isRequiredAuth: false,
    );
    return await _dioClient.post(param).then((response) {
      return response.fold((l) {
        log("Registration Error Exception : ${l.response?.statusCode}");
        log("Registration Error Response : ${l.response?.data}");
        return Left(ApiErrorGenerator.apiError(l));
      }, (r) {
        try {
          log("Registration Response: ${r.data}");
          UserModel userModel = UserModel.fromJson(r.data);
          return Right(userModel);
        } on Exception catch (e) {
          log("Registration Parse Error: ${e.toString()}");
          return Left(InvalidFormatFailure(
            message: e.toString(),
          ));
        }
      });
    });
  }

  Future<Either<Failure, String>> forgotPassword(
      {required ForgotPasswordUc forgotPasswordUc}) async {
    final APIRequestParam param = APIRequestParam(
      path: ApiEndPoints.forgotPassword,
      data: forgotPasswordUc.toJson(),
      doCache: false,
      isRequiredAuth: false,
    );
    return await _dioClient.post(param).then((response) {
      return response.fold((l) {
        log("Forgot Password Error Exception : ${l.response?.statusCode}");
        log("Forgot Password Error Response : ${l.response?.data}");
        return Left(ApiErrorGenerator.apiError(l));
      }, (r) {
        try {
          log("Forgot Password Response: ${r.data}");
          // Extract hash from response if available
          final hash = r.data['hash']?.toString() ?? '';
          return Right(hash);
        } on Exception catch (e) {
          log("Forgot Password Parse Error: ${e.toString()}");
          return Left(InvalidFormatFailure(
            message: e.toString(),
          ));
        }
      });
    });
  }

  Future<Either<Failure, bool>> resetPassword(
      {required ResetPasswordUc resetPasswordUc}) async {
    final APIRequestParam param = APIRequestParam(
      path: ApiEndPoints.resetPassword,
      data: resetPasswordUc.toJson(),
      doCache: false,
      isRequiredAuth: false,
    );
    return await _dioClient.post(param).then((response) {
      return response.fold((l) {
        log("Reset Password Error Exception : ${l.response?.statusCode}");
        log("Reset Password Error Response : ${l.response?.data}");
        return Left(ApiErrorGenerator.apiError(l));
      }, (r) {
        try {
          log("Reset Password Response: ${r.data}");
          return const Right(true);
        } on Exception catch (e) {
          log("Reset Password Parse Error: ${e.toString()}");
          return Left(InvalidFormatFailure(
            message: e.toString(),
          ));
        }
      });
    });
  }
}