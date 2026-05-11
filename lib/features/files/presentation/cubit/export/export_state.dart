import 'package:equatable/equatable.dart';

enum ExportStatus { initial, loading, success, failure }

class ExportState extends Equatable {
  final ExportStatus status;
  final String? errorMessage;
  final String? savedFilePath;
  final String? savedFileName;

  const ExportState({
    this.status = ExportStatus.initial,
    this.errorMessage,
    this.savedFilePath,
    this.savedFileName,
  });

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        savedFilePath,
        savedFileName,
      ];
}
