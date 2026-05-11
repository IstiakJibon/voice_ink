import 'package:dartz/dartz.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/features/quota/data/datasources/quota_remote.dart';
import 'package:voice_ink/features/quota/domain/entities/quota_entity.dart';
import 'package:voice_ink/features/quota/domain/repositories/quota_repository.dart';

class QuotaRepositoryImpl extends QuotaRepository {
  final QuotaRemoteServices quotaRemoteServices;

  QuotaRepositoryImpl({required this.quotaRemoteServices});

  @override
  Future<Either<Failure, List<QuotaEntity>>> getQuotaSummary({
    required String token,
  }) async {
    return await quotaRemoteServices.getQuotaSummary(token: token);
  }
}
