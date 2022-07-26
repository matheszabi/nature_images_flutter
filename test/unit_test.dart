import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nature_images_flutter/network/pagination_helper.dart';
import 'package:http/http.dart' as http;
import 'package:nature_images_flutter/network/pexels_api_search_nature.dart';
import 'package:nature_images_flutter/podo/pagination_info.dart';

import 'unit_test.mocks.dart';

//execute the command: flutter pub run build_runner build
@GenerateMocks([http.Client]) // https://docs.flutter.dev/cookbook/testing/unit/mocking
void main() async {
  group('group1', () {
    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      await dotenv.load(fileName: '.env');
      String? pexelsKey = dotenv.env['PEXELS_API_KEY'];
      assert(pexelsKey != null);
      PaginationHelper().pexelsApiKey = pexelsKey!;
    });

    test('test_pexelsApiKey_loaded', () {
      expect(PaginationHelper().pexelsApiKey.isNotEmpty, true);
    });
    test('test_Internet_connection_400', () async {
      // SocketIO exception will thrown on no Connection
      var response = await http.get(Uri.parse('http://google.com'));

      /// Test failed. See exception logs above.
      // The test description was: Should test widget with http call
      //
      // Warning: At least one test in this suite creates an HttpClient. When
      // running a test suite that uses TestWidgetsFlutterBinding, all HTTP
      // requests will return status code 400, and no network request will
      // actually be made. Any test expecting a real network connection and
      // status code will fail.
      // To test code that needs an HttpClient, provide your own HttpClient
      // implementation to the code under test, so that your test can
      // consistently provide a testable response to the code under test.

      expect(response.statusCode, 400); //   statusCode = 400
      /// Solution
      // The error tells you what the problem is:
      // you must not execute HTTP calls in the widget tests.
      // So you need to mock that HTTP call out, so that the mock is called instead of the real HTTP call.
      // There are many options with which you can do that, e.g. using the mockito package.
    });
    test('test_pexels_call', () async {
      Map<String, String> headers = {'Authorization': PaginationHelper().pexelsApiKey};

      // https://www.pexels.com/api/documentation/#photos-search
      String testUrl = 'https://api.pexels.com/v1/search?query=nature&per_page=${PaginationHelper().perPage}';
      String testResponse =
          '{"total_results":10000,"page":1,"per_page":1,"photos":[{"id":3573351,"width":3066,"height":3968,"url":"https://www.pexels.com/photo/trees-during-day-3573351/","photographer":"Lukas Rodriguez","photographer_url":"https://www.pexels.com/@lukas-rodriguez-1845331","photographer_id":1845331,"avg_color":"#374824","src":{"original":"https://images.pexels.com/photos/3573351/pexels-photo-3573351.png","large2x":"https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940","large":"https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&h=650&w=940","medium":"https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&h=350","small":"https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&h=130","portrait":"https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800","landscape":"https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200","tiny":"https://images.pexels.com/photos/3573351/pexels-photo-3573351.png?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280"},"liked":false,"alt":"Brown Rocks During Golden Hour"}],"next_page":"https://api.pexels.com/v1/search/?page=2&per_page=1&query=nature"}';

      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse(testUrl), headers: headers)).thenAnswer((_) async => http.Response(testResponse, 200));

      //expect(await fetchAlbum(client), isA<Album>());

      PexelsApiSearchNature service = PexelsApiSearchNature(client);
      PaginationInfo? paginationInfo = await service.getFirstPage();

      expect(paginationInfo != null, true);
      PaginationHelper().pagination = paginationInfo!;

      // the next it will have this value:
      testUrl = 'https://api.pexels.com/v1/search/?page=2&per_page=1&query=nature';
      when(client.get(Uri.parse(testUrl), headers: headers)).thenAnswer((_) async => http.Response(testResponse, 200));

      paginationInfo = await service.getNextPage();
      expect(paginationInfo != null, true);
    });

    tearDown(() => {});
  });
}
