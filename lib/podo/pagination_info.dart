import 'package:flutter/foundation.dart';

import 'photo.dart';

///
/// {
//   "total_results": 10000,
//   "page": 1,
//   "per_page": 1,
//   "photos": [
//     {
//       "id": 3573351,
//       "width": 3066,
//       "height": 3968,
//       "url": "https://www.pexels.com/photo/trees-during-day-3573351/",
//       "photographer": "Lukas Rodriguez",
//       "photographer_url": "https://www.pexels.com/@lukas-rodriguez-1845331",
//       "photographer_id": 1845331,
//       "avg_color": "#374824",
//       "src": {
//         "original": "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png",
//         "large2x": "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
//         "large": "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&h=650&w=940",
//         "medium": "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&h=350",
//         "small": "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&h=130",
//         "portrait": "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800",
//         "landscape": "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200",
//         "tiny": "https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280"
//       },
//       "liked": false,
//       "alt": "Brown Rocks During Golden Hour"
//     }
//   ],
//   "next_page": "https://api.pexels.com/v1/search/?page=2&per_page=1&query=nature"
// }

// ignore_for_file: non_constant_identifier_names

class PaginationInfo {
  List<Photo> photos;
  int page;
  int per_page;
  int total_results;
  String? prev_page;
  String? next_page;

  PaginationInfo({Key? key, required this.photos, required this.page, required this.per_page, required this.total_results, this.prev_page, this.next_page});

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    List<dynamic> photosDataList = json['photos']; // _GrowableList
    List<Photo> photos = <Photo>[];
    for (var element in photosDataList) {
      var photo = Photo.fromJson(element);
      photos.add(photo);
    }

    return PaginationInfo(
        page: json['page'] as int,
        per_page: json['per_page'] as int,
        total_results: json['total_results'] as int,
        prev_page: json['prev_page'] as String?, //type 'Null' is not a subtype of type 'String' in type cast
        next_page: json['next_page'] as String?,
        photos: photos);
  }
}
