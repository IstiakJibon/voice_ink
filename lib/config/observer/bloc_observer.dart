import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppGlobalBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log('[BLoc-Observer] ${bloc.runtimeType} $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('[BLoc-Observer] ${bloc.runtimeType} $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log('[BLoc-Observer] ${bloc.runtimeType} $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('[BLoc-Observer] ${bloc.runtimeType} $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}
