import 'package:dartz/dartz.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/features/scan/domain/entities/scan_entity.dart';

abstract class ScanRepository {
  Future<Either<Failure, ExtractedTextEntity>> extractText({
    required String token,
    required String filePath,
    String? fileName,
    bool generateTitle = true,
    String? titleInstruction,
  });
}
