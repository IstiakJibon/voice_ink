import 'package:dartz/dartz.dart';
import 'package:voice_ink/core/error/error.dart';
import 'package:voice_ink/features/scan/data/datasources/scan_remote.dart';
import 'package:voice_ink/features/scan/domain/entities/scan_entity.dart';
import 'package:voice_ink/features/scan/domain/repositories/scan_repository.dart';

class ScanRepositoryImpl extends ScanRepository {
  final ScanRemoteServices scanRemoteServices;

  ScanRepositoryImpl({required this.scanRemoteServices});

  @override
  Future<Either<Failure, ExtractedTextEntity>> extractText({
    required String token,
    required String filePath,
    String? fileName,
    bool generateTitle = true,
    String? titleInstruction,
  }) async {
    return await scanRemoteServices.extractText(
      token: token,
      filePath: filePath,
      fileName: fileName,
      generateTitle: generateTitle,
      titleInstruction: titleInstruction,
    );
  }
}
