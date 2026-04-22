import 'package:flutter/material.dart';

extension ColorExt on String {
  Color get hexToColor => Color(int.parse('0xFF$hexColorString(this)'));
}

extension ColorToValue on Color {
  String get colorValue => '#${valueToHex(this)}';
}

String valueToHex(Color color) {
  return color.value.toRadixString(16).substring(2);
}

String hexColorString(String hexColor) {
  return hexColor.length == 7 ? hexColor.substring(1, 7) : hexColor;
}
