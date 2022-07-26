/// Requirement: check the Internet first
///
/// https://www.pexels.com/api/documentation/#photos-search
///
///     curl -H "Authorization: 563492ad6f917000010000019adb10e9f7534a52bba8bf9a7d8fda20"
///        "https://api.pexels.com/v1/search?query=nature&per_page=1"
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../podo/pagination_info.dart';
import 'pagination_helper.dart';

class PexelsApiSearchNature {
  /// https://docs.flutter.dev/cookbook/testing/unit/mocking
  ///
  ///Provide an http.Client to the function. This allows providing the correct http.Client depending on the situation.
  ///For Flutter and server-side projects, provide an http.IOClient.
  ///For Browser apps, provide an http.BrowserClient.
  ///For tests, provide a mock http.Client.
  ///
  // Use the provided client to fetch data from the internet,
  // rather than the static http.get() method, which is difficult to mock.
  final http.Client _client;

  PexelsApiSearchNature(this._client);

  //
  Future<PaginationInfo?> getFirstPage() async {
    String url = 'https://api.pexels.com/v1/search?query=nature&per_page=${PaginationHelper().perPage}';
    return _getPage(url);
  }

  Future<PaginationInfo?> _getPage(String url) async {
    Map<String, String> headers = {'Authorization': PaginationHelper().pexelsApiKey};

    debugPrint('_getPage() url: $url');

    final response = await _client.get(Uri.parse(url), headers: headers);
    debugPrint('Status code from Pexels: ${response.statusCode}');

    if (response.statusCode == 200) {
      debugPrint('Pexels response.body: \n${response.body}');

      var start = DateTime.now().millisecondsSinceEpoch;
      var data = jsonDecode(response.body); // 1y old iPhone debug: 7 milliseconds; Old Android: Debug:  24 milliseconds , Release: 18 milliseconds
      var endDecode = DateTime.now().millisecondsSinceEpoch;
      PaginationInfo paginationInfo =
          PaginationInfo.fromJson(data); // 1y old iPhone debug: 0 milliseconds;  Old Android: Debug: 2 milliseconds, Release: 0 milliseconds
      var endParse = DateTime.now().millisecondsSinceEpoch;
      debugPrint('searchResponseOK.photos.length: \n${paginationInfo.photos.length}');
      debugPrint('Benchmarks:');
      debugPrint('jsonDecode(response.body): ${endDecode - start} milliseconds');
      debugPrint('PaginationInfo.fromJson(data): ${endParse - endDecode} milliseconds');
      debugPrint('total: ${endParse - start} milliseconds');

      return paginationInfo;
    } else {
      debugPrint('Pexels response.statusCode: \n${response.statusCode}');
      return null;
    }
  }

  Future<PaginationInfo?> getNextPage() async {
    String url = PaginationHelper().pagination.next_page!;
    return _getPage(url);
  }

  Future<PaginationInfo?> getPrevPage() async {
    String url = PaginationHelper().pagination.prev_page!;
    return _getPage(url);
  }
}
