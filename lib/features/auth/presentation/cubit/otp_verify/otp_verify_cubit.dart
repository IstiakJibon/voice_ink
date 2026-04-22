// import 'dart:developer';
// import 'package:hydrated_bloc/hydrated_bloc.dart';
// import 'package:voice_ink/config/utilities/enum/bloc_api_state.dart';
// import 'package:voice_ink/features/auth/data/models/otpVerifyUc.dart';
// import 'package:voice_ink/features/auth/data/models/user_model.dart';
// import 'package:voice_ink/features/auth/domain/entities/user_entities.dart';
// import 'package:voice_ink/features/auth/domain/usecases/auth_usecase.dart';
// import 'package:voice_ink/features/auth/presentation/cubit/otp_verify/otp_verify_state.dart';

// class OtpVerifyCubit extends Cubit<OtpVerifyState> {
//   final AuthUseCase authUseCase;

//   OtpVerifyCubit({required this.authUseCase})
//       : super(
//           OtpVerifyState(
//             apiState: NormalApiState.initial,
//             userEntities: UserEntities(
//                 user: User(
//                     id: 0,
//                     type: '',
//                     avatar: '',
//                     firstName: '',
//                     lastName: '',
//                     email: '',
//                     phone: '',
//                     gender: '',
//                     status: '',
//                     shop: Shop(
//                       type: "",
//                       status: "",
//                       slug: "",
//                       name: "",
//                       selectedOrderStatus: [],
//                       typeId: "",
//                       logo: "",
//                       favicon: "",
//                       customDomain: "",
//                       address: "",
//                       contactNumber: "",
//                       certificateArn: "",
//                       domainRecord: "",
//                       certificateStatus: "",
//                       partnerId: 0,
//                       packageId: 0,
//                       packagePrice: 0,
//                       themeId: 0,
//                       metaTitle: "",
//                       metaDescription: "",
//                       metaKeywords: "",
//                       metaLogo: "",
//                       facebookPixelKey: '',
//                       pixelAccessToken: "",
//                       facebookPageId: "",
//                       whatsappNumber: "",
//                       googleAnalyticsKey: "",
//                       googleTagManagerKey: "",
//                       googleAdwordsKey: "",
//                       packageStartDate: "",
//                       packageExpiryDate: "",
//                       deletedAt: "",
//                       id: 0,
//                       domainStatus: "",
//                       shopSetup: false,
//                       createdAt: DateTime.now(),
//                       updatedAt: DateTime.now(),
//                     ),
//                     adminType: '',
//                     permissions: []),
//                 accessToken: ''),
//             errorMessage: "Please Swipe Down to Refresh",
//           ),
//         );

//   int packageId = 0;

//   Future<void> getOtpVerify(OtpVerifyUc otpVerifyUc) async {
//     emit(state.copyWith(apiState: NormalApiState.loading));
//     await authUseCase.otpVerify(otpVerifyUc: otpVerifyUc).then((res) {
//       res.fold((err) {
//         log("call err ${err.toString()}");
//         return emit(state.copyWith(
//             apiState: NormalApiState.failure, errorMessage: err.message));
//       }, (suc) {
//         return emit(state.copyWith(
//             apiState: NormalApiState.loaded,
//             userEntities: suc,
//             errorMessage: ""));
//       });
//     }).onError((error, stackTrace) {
//       log("Error cubit 2 : ${error.toString()}");
//       emit(
//         state.copyWith(
//             apiState: NormalApiState.failure, errorMessage: error.toString()),
//       );
//     });
//   }
// }
