import 'dart:convert';

import 'package:voice_ink/features/auth/domain/entities/domain_availability_entities.dart';


DomainAvailability domainAvailabilityFromJson(String str) => DomainAvailability.fromJson(json.decode(str));

String domainAvailabilityToJson(DomainAvailability data) => json.encode(data.toJson());

// ignore: must_be_immutable
class DomainAvailability extends DomainAvailabilityEntities {
    bool success;
    String message;

    DomainAvailability({
        required this.success,
        required this.message,
    }) : super(success: success, message: message); 

    factory DomainAvailability.fromJson(Map<String, dynamic> json) => DomainAvailability(
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
    };
}
