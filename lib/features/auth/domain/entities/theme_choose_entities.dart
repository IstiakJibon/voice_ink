import 'package:equatable/equatable.dart';
import 'package:voice_ink/features/auth/data/models/theme_choose_model.dart';

// ignore: must_be_immutable
class ThemeChooseEntities extends Equatable {
  final List<ThemeChoose> themeChoose;

  const ThemeChooseEntities({
    required this.themeChoose,
  });

  @override
  String toString() {
    return 'TodoEntities{themeChoose: $themeChoose, ,}';
  }

  @override
  List<Object?> get props => [
        themeChoose,
      ];
}
