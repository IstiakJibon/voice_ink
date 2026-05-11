import 'package:equatable/equatable.dart';

class QuotaEntity extends Equatable {
  final String? resourceType;
  final String? resourceCategory;
  final num totalAllocated;
  final num totalConsumed;
  final num totalRemaining;
  final num usagePercentage;

  const QuotaEntity({
    required this.resourceType,
    required this.resourceCategory,
    required this.totalAllocated,
    required this.totalConsumed,
    required this.totalRemaining,
    required this.usagePercentage,
  });

  bool get isTranscriptionMinutes =>
      resourceType == 'minutes' && resourceCategory == 'file_transcription';

  bool get isAiChatTokens =>
      resourceType == 'tokens' && resourceCategory == 'ai_chat';

  bool get isStorage => resourceType == 'storage_gb';

  /// Progress fraction (0.0 to 1.0) for a progress bar
  double get progress {
    if (totalAllocated <= 0) return 0;
    final p = totalConsumed / totalAllocated;
    if (p.isNaN || p.isInfinite) return 0;
    return p.clamp(0.0, 1.0);
  }

  @override
  List<Object?> get props => [
        resourceType,
        resourceCategory,
        totalAllocated,
        totalConsumed,
        totalRemaining,
        usagePercentage,
      ];
}
