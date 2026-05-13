import 'package:equatable/equatable.dart';
import 'package:voice_ink/features/scan/domain/entities/scan_entity.dart';

enum ScanStatus { idle, extracting, success, failed }

class ScanState extends Equatable {
  final ScanStatus status;
  final String? imagePath;
  final String? imageName;
  final ExtractedTextEntity? result;
  final String? errorMessage;

  const ScanState({
    required this.status,
    required this.imagePath,
    required this.imageName,
    required this.result,
    required this.errorMessage,
  });

  factory ScanState.initial() => const ScanState(
        status: ScanStatus.idle,
        imagePath: null,
        imageName: null,
        result: null,
        errorMessage: null,
      );

  ScanState copyWith({
    ScanStatus? status,
    String? imagePath,
    bool clearImagePath = false,
    String? imageName,
    bool clearImageName = false,
    ExtractedTextEntity? result,
    bool clearResult = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ScanState(
      status: status ?? this.status,
      imagePath: clearImagePath ? null : (imagePath ?? this.imagePath),
      imageName: clearImageName ? null : (imageName ?? this.imageName),
      result: clearResult ? null : (result ?? this.result),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, imagePath, imageName, result, errorMessage];
}
