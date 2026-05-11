import 'package:flutter/material.dart';

/// Handles both provider formats:
/// - AssemblyAI / Speechmatics: `"A"`, `"B"`, `"C"`...
/// - Deepgram: `"Speaker 0"`, `"Speaker 1"`...
/// Returns a 0-based speaker index.
int speakerIndexOf(String? speaker) {
  if (speaker == null || speaker.isEmpty) return 0;
  final digitMatch = RegExp(r'(\d+)').firstMatch(speaker);
  if (digitMatch != null) {
    return int.tryParse(digitMatch.group(1)!) ?? 0;
  }
  final letter = speaker.toUpperCase().codeUnitAt(0);
  final delta = letter - 'A'.codeUnitAt(0);
  return delta >= 0 && delta < 26 ? delta : 0;
}

/// 1-based speaker number for UI labels like "Speaker 1".
int speakerNumberOf(String? speaker) => speakerIndexOf(speaker) + 1;

/// Short badge letter for an avatar circle ("A", "B", ...).
String speakerBadgeLetterOf(String? speaker) {
  final index = speakerIndexOf(speaker);
  return String.fromCharCode('A'.codeUnitAt(0) + (index % 26));
}

const List<Color> _speakerColors = [
  Color(0xFF4A59FE), // Blue
  Color(0xFF10B981), // Green
  Color(0xFFF59E0B), // Orange
  Color(0xFFEF4444), // Red
  Color(0xFF8B5CF6), // Purple
  Color(0xFF06B6D4), // Cyan
];

Color speakerColorOf(String? speaker) {
  final index = speakerIndexOf(speaker);
  return _speakerColors[index % _speakerColors.length];
}
