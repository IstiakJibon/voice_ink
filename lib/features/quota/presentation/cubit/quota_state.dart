import 'package:equatable/equatable.dart';
import 'package:voice_ink/config/utilities/enum/bloc_api_state.dart';
import 'package:voice_ink/features/quota/domain/entities/quota_entity.dart';

class QuotaState extends Equatable {
  final NormalApiState apiState;
  final List<QuotaEntity> quotas;
  final String errorMessage;

  const QuotaState({
    required this.apiState,
    required this.quotas,
    required this.errorMessage,
  });

  QuotaEntity? get transcriptionMinutes {
    for (final q in quotas) {
      if (q.isTranscriptionMinutes) return q;
    }
    return null;
  }

  QuotaEntity? get aiChatTokens {
    for (final q in quotas) {
      if (q.isAiChatTokens) return q;
    }
    return null;
  }

  QuotaEntity? get storage {
    for (final q in quotas) {
      if (q.isStorage) return q;
    }
    return null;
  }

  QuotaState copyWith({
    NormalApiState? apiState,
    List<QuotaEntity>? quotas,
    String? errorMessage,
  }) {
    return QuotaState(
      apiState: apiState ?? this.apiState,
      quotas: quotas ?? this.quotas,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [apiState, quotas, errorMessage];
}
