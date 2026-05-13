import 'package:voice_ink/features/url_import/domain/entities/url_import_entity.dart';

class CheckUrlModel extends CheckUrlEntity {
  const CheckUrlModel({
    required super.isValid,
    super.title,
    super.thumbnailUrl,
    super.durationSeconds,
    super.errorMessage,
  });

  factory CheckUrlModel.fromJson(Map<String, dynamic> json) {
    final dur = json['duration'] ?? json['durationSeconds'];
    return CheckUrlModel(
      isValid: json['isValid'] == true ||
          json['valid'] == true ||
          json['ok'] == true ||
          (json['title'] != null && json['error'] == null),
      title: json['title'],
      thumbnailUrl: json['thumbnail'] ?? json['thumbnailUrl'],
      durationSeconds: dur is num ? dur.toInt() : null,
      errorMessage: json['error'] ?? json['message'],
    );
  }
}

class ImportUrlModel extends ImportUrlEntity {
  const ImportUrlModel({
    super.fileId,
    super.name,
    super.errorMessage,
  });

  factory ImportUrlModel.fromJson(Map<String, dynamic> json) {
    final file = json['file'] is Map<String, dynamic>
        ? json['file'] as Map<String, dynamic>
        : null;
    return ImportUrlModel(
      fileId: json['fileId'] ?? json['id'] ?? file?['id'],
      name: json['name'] ?? file?['name'],
      errorMessage: json['error'] ?? json['message'],
    );
  }
}
