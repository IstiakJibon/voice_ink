import 'package:dartz/dartz.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/features/quota/domain/entities/quota_entity.dart';

abstract class QuotaRepository {
  Future<Either<Failure, List<QuotaEntity>>> getQuotaSummary({
    required String token,
  });
}
