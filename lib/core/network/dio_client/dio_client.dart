import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:voice_ink/config/const/app/api_endpoints.dart';
import 'package:voice_ink/core/network/dio_client/api_provider.dart';
import 'package:voice_ink/core/network/dio_client/interceptor/auth_interceptor.dart';
import 'package:voice_ink/core/network/dio_client/request_params.dart';
import 'package:voice_ink/features/auth/presentation/cubit/authentication/authentication_cubit.dart';

class DioClient implements ApiProvider {
  final AuthenticationCubit authCubit;

  // Private constructor
  DioClient._internal({required this.authCubit}) {
    _dio = _createDio();
  }

  // Singleton instance
  static DioClient? _instance;

  // Factory constructor to provide the singleton instance
  factory DioClient({
    required AuthenticationCubit authCubit,
  }) {
    _instance ??= DioClient._internal(authCubit: authCubit);
    return _instance!;
  }

  late final Dio _dio;

  Dio get dio => _dio;
  CancelToken cancelToken = CancelToken();

  Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndPoints.baseUrl, // Replace with your base URL
        connectTimeout: const Duration(milliseconds: 100000),
        receiveTimeout: const Duration(milliseconds: 50000),
        followRedirects: false,

        contentType: "application/json",
      ),
    );

    // LogInterceptor
    addLogInterceptor(dio);
    return dio;
  }

  void addLogInterceptor(Dio dio) {
    // LogInterceptor
    dio.interceptors.add(LogInterceptor(
      request: true,
      responseBody: true,
      requestBody: true,
      requestHeader: true,
      responseHeader: true,
      error: true,
      logPrint: (object) => log("$object "),
    ));
  }

  void addAuthInterCeptor(Dio dio) {
    // Add AuthInterceptor
    dio.interceptors.add(AuthInterceptor(
      authCubit: authCubit,
      cancelToken: cancelToken,
    ));
  }

  @override
  Future<Either<DioException, Response>> delete(APIRequestParam param) async {
    if (param.isRequiredAuth) {
      addAuthInterCeptor(_dio);
    }
    // if (param.options != null && param.options!.headers != null) {
    //   if (param.options!.headers!["Authorization"] != null) {
    //     addAuthInterCeptor(dio);
    //   }
    // }

    return await Task(() async => await _dio.delete(param.path,
        queryParameters: param.queryParameters,
        options: param.options)).attempt().run().then((either) {
      return either.fold((l) {
        return Left(l as DioException);
      }, (r) {
        return Right(r);
      });
    });
  }

  @override
  Future<Either<DioException, Response>> get(APIRequestParam param) async {
    if (param.isRequiredAuth) {
      addAuthInterCeptor(_dio);
    }
    return await Task(() async => await _dio.get(param.path,
        queryParameters: param.queryParameters,
        options: param.options)).attempt().run().then((either) {
      return either.fold((l) {
        return Left(l as DioException);
      }, (r) {
        return Right(r);
      });
    });
  }

  @override
  Future<Either<DioException, Response>> patch(APIRequestParam param) async {
    if (param.isRequiredAuth) {
      addAuthInterCeptor(_dio);
    }
    return await Task(() async => await _dio.patch(param.path,
        data: param.data,
        queryParameters: param.queryParameters,
        options: param.options)).attempt().run().then((either) {
      return either.fold((l) {
        return Left(l as DioException);
      }, (r) {
        return Right(r);
      });
    });
  }

  @override
  Future<Either<DioException, Response>> post(APIRequestParam param) async {
    if (param.isRequiredAuth) {
      addAuthInterCeptor(_dio);
    }
    return await Task(() async => await _dio.post(param.path,
        data: param.data,
        queryParameters: param.queryParameters,
        options: param.options)).attempt().run().then((either) {
      return either.fold((l) {
        return Left(l as DioException);
      }, (r) {
        return Right(r);
      });
    });
  }

  @override
  Future<Either<DioException, Response>> put(APIRequestParam param) async {
    if (param.isRequiredAuth) {
      addAuthInterCeptor(_dio);
    }
    return await Task(() async => await _dio.put(param.path,
        queryParameters: param.queryParameters,
        options: param.options)).attempt().run().then((either) {
      return either.fold((l) {
        return Left(l as DioException);
      }, (r) {
        return Right(r);
      });
    });
  }

  @override
  Future<Either<DioException, Response>> download(APIRequestParam param) {
    throw UnimplementedError();
  }
}
