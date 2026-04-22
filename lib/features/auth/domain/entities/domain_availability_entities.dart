import 'package:equatable/equatable.dart';

class DomainAvailabilityEntities extends Equatable {
    final  bool success;
    final String message;

  const DomainAvailabilityEntities({
    required this.success,
    required this.message
  });

  @override
  String toString() {
    return 'TodoEntities{domain availibility: $success, ,}';
  }

  @override
  List<Object?> get props => [
        success,message
      ];
}