class RouteName {
  static RouteName? _instance;
  // Avoid self instance
  RouteName._();
  static RouteName get instance => _instance ??= RouteName._();

  static Future<String> get initialRoute async {
    return splash;
  }

  static const String splash = '/';
  static const String launcherScreen = '/launcherScreen';
  static const String landingScreen = '/landingScreen';
  static const String singUp = '/signUp';
  static const String singIn = '/signIn';
  static const String verifyEmailScreen = '/verifyEmailScreen';
  static const String forgotPassword = '/forgotPassword';
  static const String resetPassword = '/resetPassword';
  static const String home = '/home';
  static const String homeNavBar = '/homeNavBar';
  static const String files = '/files';
  static const String settings = '/settings';
  static const String notes = '/notes';
}
