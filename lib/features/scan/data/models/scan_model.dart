import 'package:voice_ink/features/scan/domain/entities/scan_entity.dart';

class ExtractedTextModel extends ExtractedTextEntity {
  const ExtractedTextModel({super.title, super.text});

  factory ExtractedTextModel.fromJson(Map<String, dynamic> json) {
    return ExtractedTextModel(
      title: json['title'] ?? json['generatedTitle'],
      text: json['text'] ?? json['extractedText'] ?? json['content'],
    );
  }
}
