import 'package:flutter/material.dart';
import 'package:voice_ink/config/navigation/route_name.dart';
import 'package:voice_ink/features/auth/presentation/pages/forgot_password.dart';
import 'package:voice_ink/features/auth/presentation/pages/reset_password_screen.dart';
import 'package:voice_ink/features/auth/presentation/pages/sign_in.dart';
import 'package:voice_ink/features/auth/presentation/pages/sign_up.dart';
import 'package:voice_ink/features/auth/presentation/pages/verify_email_otp_screen.dart';
import 'package:voice_ink/features/files/presentation/pages/files_screen.dart';
import 'package:voice_ink/features/home/presentation/pages/home_screen.dart';
import 'package:voice_ink/features/home_navbar/presentation/pages/home_bottom_navbar.dart';
import 'package:voice_ink/features/launcher/presentation/pages/landing_screen.dart';
import 'package:voice_ink/features/launcher/presentation/pages/launcher_screen.dart';
import 'package:voice_ink/features/notes/presentation/pages/notes_screen.dart';
import 'package:voice_ink/features/settings/presentation/pages/settings_screen.dart';
import 'package:voice_ink/features/splash/presentation/pages/splash_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );

      case RouteName.launcherScreen:
        return MaterialPageRoute(
          builder: (_) => const LauncherScreen(),
          settings: settings,
        );

      case RouteName.landingScreen:
        return MaterialPageRoute(
          builder: (_) => const LandingScreen(),
          settings: settings,
        );
      case RouteName.singIn:
        return MaterialPageRoute(
          builder: (_) => const SignInScreen(),
          settings: settings,
        );
            case RouteName.homeNavBar:
        return MaterialPageRoute(
          builder: (_) => const HomeNavbar(),
          settings: settings,
        );
            case RouteName.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
            case RouteName.files:
        return MaterialPageRoute(
          builder: (_) => const FilesScreen(),
          settings: settings,
        );
            case RouteName.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
          settings: settings,
        );
            case RouteName.notes:
        return MaterialPageRoute(
          builder: (_) => const NotesScreen(),
          settings: settings,
        );
      case RouteName.resetPassword:
      final args = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) =>  ResetPasswordScreen(
            hash: args,
          ),
          settings: settings,
        );
      case RouteName.forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
          settings: settings,
        );
      case RouteName.verifyEmailScreen:
        final args = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => VerifyEmailScreen(email: args),
          settings: settings,
        );
      case RouteName.singUp:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
          settings: settings,
        );
      // case RouteName.registationScreen:
      //   final args = settings.arguments as RegistrationUc?;
      //   return MaterialPageRoute(
      //     builder: (_) => RegistationScreen(
      //       registrationUc: args!,
      //     ),
      //     settings: settings,
      //   );

      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
    }
  }
}
