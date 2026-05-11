import 'package:voice_ink/features/quota/domain/entities/quota_entity.dart';

class QuotaModel extends QuotaEntity {
  const QuotaModel({
    required super.resourceType,
    required super.resourceCategory,
    required super.totalAllocated,
    required super.totalConsumed,
    required super.totalRemaining,
    required super.usagePercentage,
  });

  factory QuotaModel.fromJson(Map<String, dynamic> json) {
    return QuotaModel(
      resourceType: json['resourceType'],
      resourceCategory: json['resourceCategory'],
      totalAllocated: (json['totalAllocated'] as num?) ?? 0,
      totalConsumed: (json['totalConsumed'] as num?) ?? 0,
      totalRemaining: (json['totalRemaining'] as num?) ?? 0,
      usagePercentage: (json['usagePercentage'] as num?) ?? 0,
    );
  }

  static List<QuotaModel> listFromJson(List<dynamic> json) {
    return json
        .whereType<Map<String, dynamic>>()
        .map((e) => QuotaModel.fromJson(e))
        .toList();
  }
}
