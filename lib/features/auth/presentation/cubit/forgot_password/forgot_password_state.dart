import 'package:equatable/equatable.dart';
import 'package:voice_ink/config/utilities/enum/bloc_api_state.dart';

class ForgotPasswordState extends Equatable {
  final NormalApiState apiState;
  final String hash;
  final String errorMessage;

  const ForgotPasswordState({
    required this.apiState,
    required this.hash,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [apiState, hash, errorMessage];

  ForgotPasswordState copyWith({
    NormalApiState? apiState,
    String? hash,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      apiState: apiState ?? this.apiState,
      hash: hash ?? this.hash,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}