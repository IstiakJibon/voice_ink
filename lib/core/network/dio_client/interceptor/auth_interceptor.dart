import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:voice_ink/config/navigation/route_name.dart';
import 'package:voice_ink/config/observer/navigation_observer.dart';
import 'package:voice_ink/config/utilities/utils.dart' as AppRouter;
import 'package:voice_ink/features/auth/presentation/cubit/authentication/authentication_cubit.dart';

class AuthInterceptor extends Interceptor {
  final AuthenticationCubit authCubit;
  CancelToken cancelToken;

  AuthInterceptor({required this.authCubit, required this.cancelToken});
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      CustomNavigationObserver routeOBJ = CustomNavigationObserver.instance;
      final currentRoute = routeOBJ.currentRouteName.value;
      log("AuthState...before $currentRoute");
      if (currentRoute != RouteName.singIn) {
        AppRouter.navigatorKey.currentState?.pushNamed(
          RouteName.singIn,
        );
        // AppToast.toast(msg: "You need to Login.", type: ToastEnum.error);
        authCubit.logout();
      }
      log("AuthState...after $currentRoute");

      // Cancel all pending requests
      cancelToken.cancel("Request cancelled due to unauthorized access");
    }
    super.onError(err, handler);
  }
}