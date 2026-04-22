import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_ink/config/const/app/app_colors.dart';

class AppTheme {
  AppTheme._();
  ThemeData get light => lightTheme(ThemeData.light().textTheme);

  ThemeData get dark => darkTheme(ThemeData.dark().textTheme);

  static lightTheme(TextTheme textTheme) => ThemeData(
        colorScheme: lightColorScheme,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFECF2F4),
        useMaterial3: true,
        typography: Typography.material2021(),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: GoogleFonts.openSans(
              textStyle: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: const Color(0xFFFF0032),
              ),
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: GoogleFonts.sourceSans3().copyWith(
              fontSize: 18,
            ),
            backgroundColor: const Color(0xFF2B2D44),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          isDense: false,
          filled: true,
          fillColor: Colors.white,
          helperStyle: textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF8A99B0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyLarge: GoogleFonts.openSans(
            textStyle: textTheme.bodyLarge,
          ),
          bodyMedium: GoogleFonts.nunito(
            textStyle: textTheme.bodyMedium,
          ),
          labelLarge: GoogleFonts.lato(
            textStyle: textTheme.labelLarge,
          ),
          bodySmall: GoogleFonts.nunito(
            textStyle: textTheme.bodySmall,
          ),
          displayLarge: GoogleFonts.lato(
            textStyle: textTheme.displayLarge,
          ),
          displayMedium: GoogleFonts.lato(
            textStyle: textTheme.displayMedium,
          ),
          displaySmall: GoogleFonts.lato(
            textStyle: textTheme.displaySmall,
          ),
          headlineMedium: GoogleFonts.lato(
            textStyle: textTheme.headlineMedium,
          ),
          headlineSmall: GoogleFonts.openSans(
            textStyle: textTheme.headlineSmall,
          ),
          titleLarge: GoogleFonts.lato(
            textStyle: textTheme.titleLarge,
          ),
          labelSmall: GoogleFonts.lato(
            textStyle: textTheme.labelSmall,
          ),
          titleMedium: GoogleFonts.lato(
            textStyle: textTheme.titleMedium,
          ),
          titleSmall: GoogleFonts.lato(
            textStyle: textTheme.titleSmall,
          ),
        ),
      );

  static ThemeData darkTheme(TextTheme textTheme) => ThemeData.dark(
        useMaterial3: true,
      ).copyWith(
        colorScheme: darkColorScheme,
        scaffoldBackgroundColor: CupertinoColors.darkBackgroundGray,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: GoogleFonts.sourceSans3().copyWith(
              fontSize: 18,
            ),
            backgroundColor: const Color(0xFF2B2D44),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFFF0032),
            textStyle: GoogleFonts.openSans(
              textStyle: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: const Color(0xFFFF0032),
              ),
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: AppColors.black.withOpacity(0.8),
        ),
        // Google Text Theme monospace
        inputDecorationTheme: InputDecorationTheme(
          isDense: false,
          filled: true,
          fillColor: const Color(0xFF2B2D44).withOpacity(0.3),
          helperStyle: textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF8A99B0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyLarge: GoogleFonts.openSans(
            textStyle: textTheme.bodyLarge,
            color: Colors.white,
          ),
          bodyMedium: GoogleFonts.nunito(
            textStyle: textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
          labelLarge: GoogleFonts.lato(
            textStyle: textTheme.labelLarge,
          ),
          bodySmall: GoogleFonts.nunito(
            textStyle: textTheme.bodySmall?.copyWith(
              color: Colors.white,
            ),
          ),
          displayLarge: GoogleFonts.lato(
            textStyle: textTheme.displayLarge,
          ),
          displayMedium: GoogleFonts.lato(
            textStyle: textTheme.displayMedium,
          ),
          displaySmall: GoogleFonts.lato(
            textStyle: textTheme.displaySmall,
          ),
          headlineMedium: GoogleFonts.openSans(
            textStyle: textTheme.headlineMedium,
          ),
          headlineSmall: GoogleFonts.openSans(
            textStyle: textTheme.headlineSmall?.copyWith(
              color: Colors.white,
            ),
          ),
          titleLarge: GoogleFonts.lato(
            textStyle: textTheme.titleLarge,
          ),
          labelSmall: GoogleFonts.lato(
            textStyle: textTheme.labelSmall,
          ),
          titleMedium: GoogleFonts.lato(
            textStyle: textTheme.titleMedium,
          ),
          titleSmall: GoogleFonts.lato(
            textStyle: textTheme.titleSmall,
          ),
        ),
      );
}

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFBF0023),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFFFDAD7),
  onPrimaryContainer: Color(0xFF410005),
  secondary: Color(0xFF006878),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFA7EDFF),
  onSecondaryContainer: Color(0xFF001F25),
  tertiary: Color(0xFF4E57A9),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFE0E0FF),
  onTertiaryContainer: Color(0xFF020865),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFF8FDFF),
  onBackground: Color(0xFF001F25),
  surface: Color(0xFFF8FDFF),
  onSurface: Color(0xFF001F25),
  surfaceVariant: Color(0xFFF4DDDB),
  onSurfaceVariant: Color(0xFF534342),
  outline: Color(0xFF857372),
  onInverseSurface: Color(0xFFD6F6FF),
  inverseSurface: Color(0xFF00363F),
  inversePrimary: Color(0xFFFFB3AF),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFBF0023),
  outlineVariant: Color(0xFFD8C1C0),
  scrim: Color(0xFF000000),
);
const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: AppColors.primary,
  onPrimary: Color(0xFF68000E),
  primaryContainer: Color(0xFF930018),
  onPrimaryContainer: Color(0xFFFFDAD7),
  secondary: Color(0xFF53D7F2),
  onSecondary: Color(0xFF00363F),
  secondaryContainer: Color(0xFF004E5B),
  onSecondaryContainer: Color(0xFFA7EDFF),
  tertiary: Color(0xFFBDC2FF),
  onTertiary: Color(0xFF1E2678),
  tertiaryContainer: Color(0xFF363E90),
  onTertiaryContainer: Color(0xFFE0E0FF),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF001F25),
  onBackground: Color(0xFFA6EEFF),
  surface: Color(0xFF001F25),
  onSurface: Color(0xFFA6EEFF),
  surfaceVariant: Color(0xFF534342),
  onSurfaceVariant: Color(0xFFD8C1C0),
  outline: Color(0xFFA08C8B),
  onInverseSurface: Color(0xFF001F25),
  inverseSurface: Color(0xFFA6EEFF),
  inversePrimary: Color(0xFFBF0023),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFFFB3AF),
  outlineVariant: Color(0xFF534342),
  scrim: Color(0xFF000000),
);
