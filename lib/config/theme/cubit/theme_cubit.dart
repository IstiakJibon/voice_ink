import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(appTheme: AppThemeMode.system));

  void switchingThemeMode(AppThemeMode mode, BuildContext context) {
    emit(ThemeState(appTheme: mode));
  }

  bool isDarkMode(BuildContext context) {
    switch (state.appTheme) {
      case AppThemeMode.system:
        return MediaQuery.of(context).platformBrightness == Brightness.dark;
      case AppThemeMode.light:
        return false;
      default:
        return true;
    }
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    return ThemeState(
      appTheme: switch (json['appTheme']) {
        "light" => AppThemeMode.light,
        "dark" => AppThemeMode.dark,
        _ => AppThemeMode.system,
      },
    );
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return {
      'appTheme': state.appTheme.name,
    };
  }
}
