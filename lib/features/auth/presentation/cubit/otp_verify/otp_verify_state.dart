
// import 'package:equatable/equatable.dart';
// import 'package:voice_ink/config/utilities/enum/bloc_api_state.dart';
// import 'package:voice_ink/features/auth/domain/entities/user_entities.dart';

// class OtpVerifyState extends Equatable {
//   final NormalApiState apiState;
//   final String errorMessage;
//   final UserEntities userEntities;
//   const OtpVerifyState({
//     required this.apiState,
//     required this.errorMessage,
//     required this.userEntities,
//   });

//   @override
//   List<Object?> get props => [
//         apiState,
//         errorMessage,
//         userEntities,
//       ];

//   OtpVerifyState copyWith({
//     NormalApiState? apiState,
//     String? errorMessage,
//     String? email,
//     UserEntities? userEntities,
//   }) {
//     return OtpVerifyState(
//       apiState: apiState ?? this.apiState,
//       userEntities: userEntities ?? this.userEntities,
//       errorMessage: errorMessage ?? this.errorMessage,
//     );
//   }
// }
