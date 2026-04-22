part of 'theme_cubit.dart';

enum AppThemeMode { light, dark, system }

class ThemeState extends Equatable {
  final AppThemeMode appTheme;
  const ThemeState({required this.appTheme});

  @override
  List<Object?> get props => [appTheme];
}
