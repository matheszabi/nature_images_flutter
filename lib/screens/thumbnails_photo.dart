import 'package:flutter/material.dart';

import '../network/pagination_helper.dart';
import '../podo/photo.dart';

class ThumbnailsPhoto {
  // Eager initialization
  static final ThumbnailsPhoto _singletonInstance = ThumbnailsPhoto._internal();

  factory ThumbnailsPhoto() {
    return _singletonInstance;
  }

  ThumbnailsPhoto._internal();

  // those are the image thumbnails cashed for image list.
  List<Image> thumbnailList = <Image>[];

  /// when is clicked to show the big image
  late String imgBigUrl;

  Future<void> loadThumbnails() async {
    for (Photo photo in PaginationHelper().pagination.photos) {
      debugPrint('Loading image thumbnail:\n ${photo.src.tiny}');
      // it seems it is not blocking! - doesn't mean it will be loaded at this point
      Image imgTiny = Image.network(photo.src.tiny);
      thumbnailList.add(imgTiny);
    }
  }
}
