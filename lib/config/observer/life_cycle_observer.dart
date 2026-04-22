import 'package:flutter/material.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  static final LifecycleEventHandler _singleton =
      LifecycleEventHandler._internal();

  factory LifecycleEventHandler() {
    return _singleton;
  }

  LifecycleEventHandler._internal()
      : appLifecycleState = AppLifecycleState.resumed;

  AppLifecycleState appLifecycleState;

  void initialize() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    appLifecycleState = state;
  }

  bool get isAppInForeground {
    return appLifecycleState == AppLifecycleState.resumed;
  }

  // check isAppInForeground in your code

  bool get isAppInBackground {
    return appLifecycleState == AppLifecycleState.paused;
  }

  // check is App is Terminated
  bool get isAppTerminated {
    return appLifecycleState == AppLifecycleState.detached;
  }
}
