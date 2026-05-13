import 'package:equatable/equatable.dart';

class ExtractedTextEntity extends Equatable {
  final String? title;
  final String? text;

  const ExtractedTextEntity({
    this.title,
    this.text,
  });

  @override
  List<Object?> get props => [title, text];
}
