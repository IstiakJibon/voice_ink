import 'dart:developer';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_ink/features/files/domain/usecases/transcript_detail_usecase.dart';
import 'package:voice_ink/features/files/presentation/cubit/export/export_state.dart';

class ExportCubit extends Cubit<ExportState> {
  final ExportTranscriptUseCase exportTranscriptUseCase;

  ExportCubit({required this.exportTranscriptUseCase})
      : super(const ExportState());

  Future<void> exportTranscript({
    required String transcriptionResultId,
    required String originalFilename,
    required String format,
    required bool includeSpeakers,
    required bool includeTimestamps,
    required bool combineParagraphs,
    required bool includeHighlights,
    String? targetLanguage,
    required String token,
  }) async {
    emit(const ExportState(status: ExportStatus.loading));

    final result = await exportTranscriptUseCase(
      transcriptionResultId: transcriptionResultId,
      format: format,
      includeSpeakers: includeSpeakers,
      includeTimestamps: includeTimestamps,
      combineParagraphs: combineParagraphs,
      includeHighlights: includeHighlights,
      targetLanguage: targetLanguage,
      token: token,
    );

    await result.fold(
      (error) async {
        emit(ExportState(
          status: ExportStatus.failure,
          errorMessage: error,
        ));
      },
      (bytes) async {
        try {
          final baseName = _buildBaseName(originalFilename);
          final ext = format.toLowerCase();
          final savedPath = await FileSaver.instance.saveFile(
            name: baseName,
            bytes: Uint8List.fromList(bytes),
            ext: ext,
            mimeType: _mimeTypeFor(ext),
          );

          log('Export saved to: $savedPath', name: 'ExportCubit');

          emit(ExportState(
            status: ExportStatus.success,
            savedFilePath: savedPath,
            savedFileName: '$baseName.$ext',
          ));
        } catch (e) {
          emit(ExportState(
            status: ExportStatus.failure,
            errorMessage: 'Failed to save file: $e',
          ));
        }
      },
    );
  }

  String _buildBaseName(String originalFilename) {
    final name = originalFilename.isEmpty ? 'transcript' : originalFilename;
    final dotIndex = name.lastIndexOf('.');
    final base = dotIndex > 0 ? name.substring(0, dotIndex) : name;
    return '${base}_voiceink';
  }

  MimeType _mimeTypeFor(String ext) {
    switch (ext) {
      case 'pdf':
        return MimeType.pdf;
      case 'docx':
        return MimeType.microsoftWord;
      case 'txt':
        return MimeType.text;
      case 'srt':
      case 'vtt':
        return MimeType.text;
      default:
        return MimeType.other;
    }
  }
}
