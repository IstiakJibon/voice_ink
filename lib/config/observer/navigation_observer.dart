import 'dart:developer';

import 'package:flutter/material.dart';

class CustomNavigationObserver extends NavigatorObserver with ChangeNotifier {
  // Create singleton instance
  static final CustomNavigationObserver _instance =
      CustomNavigationObserver._internal();
  CustomNavigationObserver._internal();

  factory CustomNavigationObserver() {
    return _instance;
  }

  static CustomNavigationObserver get instance => _instance;
  // current route name
  ValueNotifier<String> currentRouteName = ValueNotifier<String>('');
  // current order id
  ValueNotifier<String> currentOrderId = ValueNotifier<String>('');
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    log('Route pushed: ${route.settings.name}');
    // Add your custom logic here when a route is pushed
    currentRouteName.value = route.settings.name ?? "";
    notifyListeners();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    log('Route popped: ${route.settings.name}');
    // Add your custom logic here when a route is popped

    currentRouteName.value = previousRoute?.settings.name ?? "";
    notifyListeners();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    log('Route replaced: ${newRoute!.settings.name}');
    // Add your custom logic here when a route is replaced

    currentRouteName.value = newRoute.settings.name ?? "";
    notifyListeners();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    log('Route removed: ${route.settings.name}');
    // Add your custom logic here when a route is removed

    currentRouteName.value = previousRoute?.settings.name ?? "";
    notifyListeners();
  }

  @override
  void didStartUserGesture(
      Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didStartUserGesture(route, previousRoute);
    log('User started a gesture');
    // Add your custom logic here when the user starts a gesture
  }

  updateOrderId(String orderId) {
    currentOrderId.value = orderId;
    notifyListeners();
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
    log('User stopped a gesture');
    // Add your custom logic here when the user stops a gesture
  }

  // Add more methods as needed based on your requirements
}
