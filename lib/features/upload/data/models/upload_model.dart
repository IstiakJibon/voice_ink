import 'package:voice_ink/features/upload/domain/entities/upload_entity.dart';

class PresignedUploadModel extends PresignedUploadEntity {
  const PresignedUploadModel({
    required super.fileId,
    required super.fileName,
    required super.filePath,
    required super.uploadUrl,
    required super.contentType,
  });

  /// The backend may return: `fileId`, `fileName`, `filePath`, `uploadUrl` (or
  /// `presignedUrl`), and `contentType`. We accept either key for the URL.
  factory PresignedUploadModel.fromJson(Map<String, dynamic> json) {
    return PresignedUploadModel(
      fileId: json['fileId'] ?? json['id'],
      fileName: json['fileName'] ?? json['originalFilename'],
      filePath: json['filePath'] ?? json['path'],
      uploadUrl: json['uploadUrl'] ?? json['presignedUrl'] ?? json['url'],
      contentType: json['contentType'] ?? json['mimetype'],
    );
  }

  /// Response shape `{"files": [...]}` or a bare list.
  static List<PresignedUploadModel> listFromResponse(dynamic body) {
    if (body is List) {
      return body
          .whereType<Map<String, dynamic>>()
          .map((e) => PresignedUploadModel.fromJson(e))
          .toList();
    }
    if (body is Map<String, dynamic>) {
      final list = body['files'] ?? body['uploads'] ?? body['data'];
      if (list is List) {
        return list
            .whereType<Map<String, dynamic>>()
            .map((e) => PresignedUploadModel.fromJson(e))
            .toList();
      }
    }
    return const [];
  }
}
