import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../const.dart';
import '../network/pagination_helper.dart';
import '../network/pexels_api_search_nature.dart';
import 'app_initialized_home_page.dart';
import 'thumbnails_photo.dart';

class AppInitializingPage extends StatefulWidget {
  const AppInitializingPage({Key? key}) : super(key: key);

  @override
  AppInitializingPageState createState() => AppInitializingPageState();
}

// it shows where exactly is the loading process
class AppInitializingPageState extends State<AppInitializingPage> {
  String infoMessage = '';

  void changeMessageTo(String msg) {
    setState(() {
      infoMessage = msg;
    });
  }

  @override
  void initState() {
    super.initState();

    /// We require the initializers to run after the loading screen is rendered
    SchedulerBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  static const int seconds1 = 1;

  Future<void> init() async {
    await initPexels();
    await checkInternetConnection();
    await loadInitialPage();
    await loadThumbnails();

    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      /// shouldn't be able to come back to this screen if you press the Back button (on Android)
      context,
      MaterialPageRoute(builder: (context) => const AppInitialedPage()),
      result: (Route<dynamic> route) => false,
    );
  }

  Future<void> initPexels() async {
    // load the Pexels  API Key from .env file
    changeMessageTo('Loading Pexels API keys...');
    await Future.delayed(const Duration(seconds: seconds1));
    await dotenv.load(fileName: '.env');
    String? pexelsKey = dotenv.env['PEXELS_API_KEY'];
    debugPrint('pexelsKey: $pexelsKey');
    if (pexelsKey != null) {
      // store to Global variable
      PaginationHelper().pexelsApiKey = pexelsKey;
      changeMessageTo('Pexels API keys found');
      await Future.delayed(const Duration(seconds: seconds1));
    } else {
      changeMessageTo('Pexels API keys NOT found. Exiting');
      await Future.delayed(const Duration(seconds: seconds1));
      //SystemChannels.platform.invokeMethod('SystemNavigator.pop');// at iOS this will not quit
    }
    // if not found the API key, needed for authorization wait here with a message and let the user quit manually.

    while (pexelsKey == null || pexelsKey.isEmpty) {
      changeMessageTo('Pexels API keys NOT found.\nPlease exit!');
      await Future.delayed(const Duration(seconds: 10));
    }
  }

  Future<void> checkInternetConnection() async {
    // force to connect to Internet now or exit app...
    while (true) {
      changeMessageTo('Checking Internet connection...');
      await Future.delayed(const Duration(seconds: seconds1));
      try {
        // make a http request to a well know site to check the Internet connection
        // not just the network connection

        final response = await http.get(Uri.parse('http://google.com'));
        debugPrint('Status code from Google: ${response.statusCode}');

        changeMessageTo('Connected to Internet!');
        await Future.delayed(const Duration(seconds: seconds1));
        break;
      } catch (error) {
        // Error + Exception
        changeMessageTo('There is no Internet connection.\nPlease connect to Internet');
        await Future.delayed(const Duration(seconds: 5));
        continue;
      }
    }

    // it is connected to internet or exit.
  }

  Future<void> loadInitialPage() async {
    // be sure the lines above not deleted and we have a key
    assert(PaginationHelper().pexelsApiKey.isNotEmpty);

    // It is a page loading process, but it has message delivery too
    // could be extracted to a method and based a param fire an event and be a callback here to deliver those messages.

    changeMessageTo('Loading first image list data');
    await Future.delayed(const Duration(seconds: seconds1));

    var paginationInfo = await PexelsApiSearchNature().getFirstPage();

    if (paginationInfo != null) {
      changeMessageTo('Loaded the first image list data');
      await Future.delayed(const Duration(seconds: seconds1));

      // store to cache
      PaginationHelper().pagination = paginationInfo;
    } else {
      changeMessageTo("Can't load image list data!\nPlease restart the app!");
      await Future.delayed(const Duration(seconds: seconds1));
      while (true) {
        sleep(const Duration(seconds: 10));
      }
    }

    debugPrint('paginationInfo.next_page: ${paginationInfo.next_page}');
  }

  Future<void> loadThumbnails() async {
    changeMessageTo('Loading thumbnail images: ${PaginationHelper().pagination.photos.length}.');
    await Future.delayed(const Duration(seconds: 1));

    ThumbnailsPhoto().loadThumbnails();

    changeMessageTo('Image thumbnails loaded: ${ThumbnailsPhoto().thumbnailList.length}.');
    await Future.delayed(const Duration(seconds: seconds1));
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(decoration: const BoxDecoration(gradient: linearGradientRo)),
          title: const Text('Nature images'),
          elevation: 100,
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    ////
                    children: [
                      const SizedBox(width: 20, height: 20),
                      ColoredBox(
                          color: Colors.transparent,
                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
                            Text(
                              'Loading: ',
                              style: TextStyle(fontSize: 25),
                            ),
                            SizedBox(width: 20, height: 20),
                            CupertinoActivityIndicator()
                          ])),
                      const SizedBox(width: 20, height: 20),
                      ColoredBox(color: Colors.transparent, child: Text(infoMessage))
                    ]))));
  }
}
