import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:voice_ink/config/const/app/app_constant.dart';
import 'package:voice_ink/config/const/app/state_management_provider.dart';
import 'package:voice_ink/config/di/dependency_injector.dart';
import 'package:voice_ink/config/navigation/app_route.dart';
import 'package:voice_ink/config/navigation/route_name.dart';
import 'package:voice_ink/config/observer/life_cycle_observer.dart';
import 'package:voice_ink/config/observer/navigation_observer.dart';
import 'package:voice_ink/config/theme/app_theme.dart';
import 'package:voice_ink/config/theme/cubit/theme_cubit.dart';
// ------------------------------Firebase Background notification handler------------------------
// @pragma("vm:entry-point")
// Future<void> firebaseBackgroundNotificationHandler(
//     RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await NotificationManager.instance.generate(message);
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LifecycleEventHandler().initialize();
  final AppRouter router = AppRouter();
  final routeObserver = CustomNavigationObserver();
  
  // --------------Hydrated Bloc---------------------------- 
  // MUST initialize BEFORE configureDependencies()
    final storageDirectory = await getApplicationDocumentsDirectory();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(storageDirectory.path),
  );
  // --------------Dependencies Injector ----------------------------
  await configureDependencies();

  // --------------Hydrated Bloc end------------------------
  /// --------------------Always initialize Awesome Notifications------------------------
  // await NotificationManager.instance.configure();

  // -----------------------------Firebase Background Notification End------------------------
  // FirebaseMessaging.onBackgroundMessage(firebaseBackgroundNotificationHandler);
  // Pass all uncaught "fatal" errors from the framework to Crashlytics

  // --------------Error handling [FirebaseCrashlytics] ---------------------------
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };
  // Wrap your app

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Locks the app to portrait mode
  ]).then((_) {
    runApp(MultiProvider(
        providers: StateManagementProviders.providers,
        child: MyApp(router: router, routeObserver: routeObserver)));
    //  analyticsObserver: observer,
  });
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.router,
    required this.routeObserver,
  });
  final AppRouter router;
  final CustomNavigationObserver routeObserver;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // NotificationManager.instance.setListeners();
    // NotificationManager.instance.setForegroundNotificationPresentationOptions();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    _updateSystemOverlay();
  }

  void _updateSystemOverlay() {
    final isDarkMode =
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: !isDarkMode ? Colors.black : Colors.white,
        systemNavigationBarIconBrightness:
            isDarkMode ? Brightness.light : Brightness.dark,
        statusBarIconBrightness:
            isDarkMode ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(402, 874),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            final textTheme = Theme.of(context).textTheme;
            return MaterialApp(
              title: AppConstants.appName,
              debugShowCheckedModeBanner: false,
              navigatorObservers: [CustomNavigationObserver()],
              themeMode: ThemeMode.system,
              navigatorKey: AppRouter.navigatorKey,
              theme: AppTheme.lightTheme(textTheme),
              darkTheme: AppTheme.lightTheme(textTheme),
              onGenerateRoute: widget.router.generateRoute,
              initialRoute: RouteName.splash,
              // home: LauncherScreen(),
            );
          },
        );
      },
    );
  }
}
