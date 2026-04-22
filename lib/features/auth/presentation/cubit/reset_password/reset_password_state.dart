import 'package:equatable/equatable.dart';
import 'package:voice_ink/config/utilities/enum/bloc_api_state.dart';

class ResetPasswordState extends Equatable {
  final NormalApiState apiState;
  final String errorMessage;

  const ResetPasswordState({
    required this.apiState,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [apiState, errorMessage];

  ResetPasswordState copyWith({
    NormalApiState? apiState,
    String? errorMessage,
  }) {
    return ResetPasswordState(
      apiState: apiState ?? this.apiState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}