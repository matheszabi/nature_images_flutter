import '../podo/pagination_info.dart';

class PaginationHelper {
  // Eager initialization
  static final PaginationHelper _singletonInstance = PaginationHelper._internal();

  factory PaginationHelper() {
    return _singletonInstance;
  }

  PaginationHelper._internal();

  // loaded from .env  - not shared at Github
  String pexelsApiKey = '';

  // 80 is the maximum, 15 is the default, easier to test with small values
  String perPage = '80';

  // when is scrolled to bottom
  late PaginationInfo pagination;
}

// main() {
//   var s1 = MyGlobalVariables();
//   var s2 = MyGlobalVariables();
//   print(identical(s1, s2));  // true
//   print(s1 == s2);           // true
// }
