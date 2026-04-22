// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

class ImageSliderEntities extends Equatable {
  final String image_url;
  final String? path_type;
  final String? url;

  const ImageSliderEntities({
    required this.image_url,
    this.path_type,
    this.url,
  });

  @override
  List<Object?> get props => [image_url, path_type, url];
}
