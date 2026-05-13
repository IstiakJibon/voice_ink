import 'package:equatable/equatable.dart';

/// Result of the `/audio-files/check-url` endpoint — tells us whether the
/// given URL is supported and (if so) what metadata the server resolved.
class CheckUrlEntity extends Equatable {
  final bool isValid;
  final String? title;
  final String? thumbnailUrl;
  final int? durationSeconds;
  final String? errorMessage;

  const CheckUrlEntity({
    required this.isValid,
    this.title,
    this.thumbnailUrl,
    this.durationSeconds,
    this.errorMessage,
  });

  @override
  List<Object?> get props =>
      [isValid, title, thumbnailUrl, durationSeconds, errorMessage];
}

/// Result of the `/audio-files/import/url` endpoint. The server returns the
/// newly-created audio file's id (so we can open its detail screen).
class ImportUrlEntity extends Equatable {
  final String? fileId;
  final String? name;
  final String? errorMessage;

  const ImportUrlEntity({
    this.fileId,
    this.name,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [fileId, name, errorMessage];
}
