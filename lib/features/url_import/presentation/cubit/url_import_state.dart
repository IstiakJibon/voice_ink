import 'package:equatable/equatable.dart';
import 'package:voice_ink/features/url_import/domain/entities/url_import_entity.dart';

enum UrlCheckStatus { idle, checking, ok, failed }

enum UrlImportStatus { idle, importing, success, failed }

class UrlImportState extends Equatable {
  final UrlCheckStatus checkStatus;
  final UrlImportStatus importStatus;
  final CheckUrlEntity? checkResult;
  final String? checkError;
  final String? importedFileId;
  final String? importError;
  final bool autoTranscribe;
  final bool speakerIdentification;

  const UrlImportState({
    required this.checkStatus,
    required this.importStatus,
    required this.checkResult,
    required this.checkError,
    required this.importedFileId,
    required this.importError,
    required this.autoTranscribe,
    required this.speakerIdentification,
  });

  factory UrlImportState.initial() => const UrlImportState(
        checkStatus: UrlCheckStatus.idle,
        importStatus: UrlImportStatus.idle,
        checkResult: null,
        checkError: null,
        importedFileId: null,
        importError: null,
        autoTranscribe: true,
        speakerIdentification: true,
      );

  UrlImportState copyWith({
    UrlCheckStatus? checkStatus,
    UrlImportStatus? importStatus,
    CheckUrlEntity? checkResult,
    bool clearCheckResult = false,
    String? checkError,
    bool clearCheckError = false,
    String? importedFileId,
    bool clearImportedFileId = false,
    String? importError,
    bool clearImportError = false,
    bool? autoTranscribe,
    bool? speakerIdentification,
  }) {
    return UrlImportState(
      checkStatus: checkStatus ?? this.checkStatus,
      importStatus: importStatus ?? this.importStatus,
      checkResult: clearCheckResult ? null : (checkResult ?? this.checkResult),
      checkError: clearCheckError ? null : (checkError ?? this.checkError),
      importedFileId:
          clearImportedFileId ? null : (importedFileId ?? this.importedFileId),
      importError: clearImportError ? null : (importError ?? this.importError),
      autoTranscribe: autoTranscribe ?? this.autoTranscribe,
      speakerIdentification:
          speakerIdentification ?? this.speakerIdentification,
    );
  }

  @override
  List<Object?> get props => [
        checkStatus,
        importStatus,
        checkResult,
        checkError,
        importedFileId,
        importError,
        autoTranscribe,
        speakerIdentification,
      ];
}
