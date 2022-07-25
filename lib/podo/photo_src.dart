import 'package:flutter/foundation.dart';

class PhotoSrc {
  // Object
  String original;
  String large;
  String large2x;
  String medium;
  String small;
  String portrait;
  String landscape;
  String tiny;

  PhotoSrc(
      {Key? key,
      required this.original,
      required this.large,
      required this.large2x,
      required this.medium,
      required this.small,
      required this.portrait,
      required this.landscape,
      required this.tiny});

  factory PhotoSrc.fromJson(Map<String, dynamic> json) {
    return PhotoSrc(
        original: json['original'] as String,
        large: json['large'] as String,
        large2x: json['large2x'] as String,
        medium: json['medium'] as String,
        small: json['small'] as String,
        portrait: json['portrait'] as String,
        landscape: json['landscape'] as String,
        tiny: json['tiny'] as String);
  }
}
