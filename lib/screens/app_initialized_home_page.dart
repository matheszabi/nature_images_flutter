import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nature_images_flutter/podo/photo.dart';

import '../network/pagination_helper.dart';
import '../network/pexels_api_search_nature.dart';
import 'big_image_detail_screen.dart';
import 'thumbnails_photo.dart';

class AppInitialedPage extends StatefulWidget {
  const AppInitialedPage({Key? key}) : super(key: key);

  @override
  State<AppInitialedPage> createState() => AppInitialedPageState();
}

class AppInitialedPageState extends State<AppInitialedPage> {
  @override
  Widget build(BuildContext context) {
    PaginationHelper networkParameters = PaginationHelper();

    ScrollController scrollController = ScrollController();
    String title = 'Images from Pexels, page ${networkParameters.pagination.page}';

    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = 100.0; // or something else..
      if (maxScroll - currentScroll <= delta) {
        loadNextPage();
        // reset scroll , because you will load next -> next -> next always.
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.jumpTo(maxScroll / 2);
          }
        });
      } else if (currentScroll <= delta) {
        loadPrevPage();
        // reset scroll , because you will load next -> next -> next always.
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.jumpTo(maxScroll / 2);
          }
        });
      }
    });

    var photosData = PaginationHelper().pagination.photos;
    var thumbnails = ThumbnailsPhoto().thumbnailList;

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Scrollbar(
          child: ListView.builder(
            controller: scrollController,
            itemCount: thumbnails.length,
            itemExtent: 250.0,
            // for every element in thumbnail
            itemBuilder: (context, index) {
              return InkWell(
                highlightColor: Colors.blue,
                onTap: () => onTapImageAt(index),
                child: Container(
                  margin: const EdgeInsets.all(1),
                  child: Column(
                    children: [
                      // text data loaded from response is only the current one
                      Text(photosData.elementAt(index).alt),
                      thumbnails.elementAt(index),
                      Text('${photosData.elementAt(index).width} x ${photosData.elementAt(index).height}')
                    ],
                  ),
                ),
              );
            }, //itemBuilder
          ),
        ),
      ),
    );
  }

  onTapImageAt(int index) {
    debugPrint('onTapImageAt $index');
    String url = PaginationHelper().pagination.photos.elementAt(index).src.original;
    debugPrint('Should load big image from $url');
    // store to global:
    ThumbnailsPhoto().imgBigUrl = url;

    Navigator.push(context, MaterialPageRoute(builder: (context) => const BigImageScreen()));
  }

  Future<void> loadPrevPage() async {
    debugPrint('NetworkParameters().pagination.next_page: ${PaginationHelper().pagination.prev_page}');

    if (PaginationHelper().pagination.prev_page == null) {
      return;
    }

    var paginationInfo = await PexelsApiSearchNature().getPrevPage();

    _loadPage(paginationInfo);
  }

  Future<void> loadNextPage() async {
    debugPrint('NetworkParameters().pagination.next_page: ${PaginationHelper().pagination.next_page}');

    if (PaginationHelper().pagination.next_page == null) {
      return;
    }

    var paginationInfo = await PexelsApiSearchNature().getNextPage();

    _loadPage(paginationInfo);
  }

  /// store the pagination and clear the thumb list and load thumb list
  Future<void> _loadPage(paginationInfo) async {
    if (paginationInfo != null) {
      debugPrint('NextPage response loaded.');
      // store the values:
      PaginationHelper().pagination = paginationInfo;
      // clear the old ones:
      ThumbnailsPhoto().thumbnailList.clear();
      // do the loading:
      ThumbnailsPhoto().loadThumbnails();

      debugPrint('thumbnailList.length: ${ThumbnailsPhoto().thumbnailList.length}');

      /// repaint when done
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
      // redraw?

    } else {
      // webservice call returned null:
      debugPrint("Can't load Page thumbnails !");
      Scaffold.of(context).showBottomSheet((context) => const Text("Can't load Page thumbnails !"));
    }
  }
}

// onLongPressImageAt(int index) {
// }
