import 'package:flutter/foundation.dart';

import 'photo_src.dart';

/// https://www.pexels.com/api/documentation/#photos
///
///
// ignore_for_file: non_constant_identifier_names

class Photo {
  int id;
  int width;
  int height;
  String url;
  String photographer;
  String photographer_url;
  int photographer_id;
  String avg_color;
  PhotoSrc src;
  String alt;

  Photo(
      {Key? key,
      required this.id,
      required this.width,
      required this.height,
      required this.url,
      required this.photographer,
      required this.photographer_url,
      required this.photographer_id,
      required this.avg_color,
      required this.src,
      required this.alt});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
        id: json['id'] as int,
        width: json['width'] as int, // used in description
        height: json['height'] as int, // used in description
        url: json['url'] as String,
        photographer: json['photographer'] as String,
        photographer_url: json['photographer_url'] as String,
        photographer_id: json['photographer_id'] as int,
        avg_color: json['avg_color'] as String,
        src: PhotoSrc.fromJson(json['src']), // Hold various url for different sizes: small and original
        alt: json['alt'] as String); // used in Photo description
  }
}
