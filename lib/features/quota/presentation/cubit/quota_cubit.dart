import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_ink/config/utilities/enum/bloc_api_state.dart';
import 'package:voice_ink/features/quota/domain/usecases/quota_usecase.dart';
import 'package:voice_ink/features/quota/presentation/cubit/quota_state.dart';

class QuotaCubit extends Cubit<QuotaState> {
  final QuotaUseCase quotaUseCase;

  QuotaCubit({required this.quotaUseCase})
      : super(const QuotaState(
          apiState: NormalApiState.initial,
          quotas: [],
          errorMessage: '',
        ));

  Future<void> getQuotaSummary({required String token}) async {
    emit(state.copyWith(apiState: NormalApiState.loading));

    await quotaUseCase.getQuotaSummary(token: token).then((res) {
      res.fold((err) {
        log("Get quota summary error: ${err.toString()}");
        emit(state.copyWith(
          apiState: NormalApiState.failure,
          errorMessage: err.message,
        ));
      }, (data) {
        emit(state.copyWith(
          apiState: NormalApiState.loaded,
          quotas: data,
          errorMessage: '',
        ));
      });
    }).onError((error, stackTrace) {
      log("Get quota summary error: ${error.toString()}");
      emit(state.copyWith(
        apiState: NormalApiState.failure,
        errorMessage: error.toString(),
      ));
    });
  }
}
