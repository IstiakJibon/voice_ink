import 'package:equatable/equatable.dart';

enum ReTranscribeStatus {
  initial,
  triggering,
  polling,
  success,
  failure,
}

class ReTranscribeState extends Equatable {
  final ReTranscribeStatus status;
  final String engineDisplayName;
  final double? progress;
  final String? errorMessage;

  const ReTranscribeState({
    this.status = ReTranscribeStatus.initial,
    this.engineDisplayName = '',
    this.progress,
    this.errorMessage,
  });

  ReTranscribeState copyWith({
    ReTranscribeStatus? status,
    String? engineDisplayName,
    double? progress,
    String? errorMessage,
  }) {
    return ReTranscribeState(
      status: status ?? this.status,
      engineDisplayName: engineDisplayName ?? this.engineDisplayName,
      progress: progress ?? this.progress,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, engineDisplayName, progress, errorMessage];
}
