import 'dart:developer';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:news_app/LocalDatabase/hive_database.dart';
import 'package:news_app/Services/api_service.dart';
import 'package:news_app/Utilities/constants.dart';
import 'package:news_app/configs/size_config.dart';
import 'package:news_app/configs/theme_data.dart';
import 'package:news_app/customWidgets/article_widget.dart';
import 'package:news_app/customWidgets/button_widget.dart';
import 'package:news_app/models/article.dart';
import 'package:hive_flutter/hive_flutter.dart';

// class MyHomePage extends GetWidget<ApiService> {
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: FutureBuilder(
//         future: controller.getUserGreet(),
//     builder:  (BuildContext context,
//     AsyncSnapshot<String?> snapshot) {
//           return snapshot.hasData ?  Text(snapshot.data.toString()) : Container();
//     }),
//       ),
//       body: Container(
//
//         child: SingleChildScrollView(
//           child: Column(
//
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//
//               FutureBuilder(
//                 future: controller.getTopHeadLines(),
//                   builder:  (BuildContext context,
//               AsyncSnapshot<List<Article>> snapshot) {
// print(snapshot.data!.length);
//       return snapshot.hasData ?  Container(
//         height: SizeConfig.screenHeight / 2,
//         child: ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (BuildContext context,int index){
//                 return ListTile(
//                   onTap: () {
//                     HiveDatabase.setBookMark(snapshot.data![index]);
//                   },
//                     leading: Icon(Icons.list),
//                     title:Text(snapshot.data![index].title.toString()),
//                 );
//               }
//         ),
//       ) : const CircularProgressIndicator();
//
//       }),
//               ValueListenableBuilder(
//                 valueListenable: Hive.box(Constants.bookmarkBox).listenable(),
//                 builder: (context, Box box, widget) {
//                   return Text("${box.get(Constants.bookmarkList)}");
//                 },
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _pageSize = 20;

  final PagingController<int, Article> _pagingController =
  PagingController(firstPageKey: 0);
  late ApiService apiService;
  List tabs = ["Top Headline","BookMark"];
  int tabIndex = 0;

  @override
  void initState() {
    apiService = Get.find();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final isLastPage = (_pageSize + pageKey) > apiService.count;
      final newItems = await apiService.getTopHeadLines(_pageSize);
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
          backgroundColor: ThemeClass.purpleColor,
          body: SingleChildScrollView(
            child: DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: Column(
                children: [
                  const SizedBox(height: 30,),
                  FutureBuilder(
                      future: apiService.getUserGreet(),
                      builder:  (BuildContext context,
                          AsyncSnapshot<String?> snapshot) {
                        return snapshot.hasData ?  Text(snapshot.data.toString(),style: TextStyle(color: Colors.white,fontSize: 20),) : Container();
                      }),
                  const SizedBox(height: 20,),

                  TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    isScrollable: true,
                    onTap: (i) {
                      setState(() {
                        tabIndex = i;
                      });
                    },
                    indicator: const BubbleTabIndicator(
                        indicatorHeight:
                        45.0,
                        indicatorRadius:
                        10,
                        indicatorColor:
                        Colors
                            .pink,
                        tabBarIndicatorSize:
                        TabBarIndicatorSize
                            .tab,
                        // Other flags
                        insets:
                        EdgeInsets
                            .all(
                            1),
                        padding:
                        EdgeInsets
                            .all(
                            5)), tabs: List.generate(tabs.length, (index) =>  Container(
                    padding:
                    const EdgeInsets.all(8),
                    child: Text(
                      tabs[index],
                      style: const TextStyle(
                          fontWeight:
                          FontWeight
                              .w600,
                          color: Colors.white,
                          fontSize: 18),
                    ),
                  ),),
                  ),
                  tabIndex == 0 ?  Container(
                    height: SizeConfig.screenHeight,
                    child: PagedListView<int, Article>(
                      pagingController: _pagingController,
                      padding: const EdgeInsets.only(bottom: 120),
                      builderDelegate: PagedChildBuilderDelegate<Article>(
                          animateTransitions: true,
                          noMoreItemsIndicatorBuilder: (context) => Center(child: Text('No more news found',style: TextStyle(fontSize: 20,color: Colors.white),),),
                          noItemsFoundIndicatorBuilder: (context) => Text("no items"),
                          itemBuilder: (context, item, index) =>
                              ArticleWidget(article: item,isBookMarked: false,onAddBookMark: () {
                                HiveDatabase.setBookMark(item);
                              })
                        //        ListTile(
                        //       onTap: () {
                        // HiveDatabase.setBookMark(item);
                        // },
                        //   leading: Icon(Icons.list),
                        //   title:Text(item.title.toString()),
                        // )
                      ),
                    ),
                  ) :    Container(
                    height: SizeConfig.screenHeight,
                    child: ValueListenableBuilder(
                      valueListenable: Hive.box(Constants.bookmarkBox).listenable(),
                      builder: (context, Box box, widget) {
                        // return Text("${box.get(Constants.bookmarkList)}");
                        return box.get(Constants.bookmarkList) == null  ? Center(child: Text("There is no bookmark available",style: TextStyle(color: Colors.white),),) :  Container(
                          height: SizeConfig.screenHeight / 2,
                          child: box.get(Constants.bookmarkList).length != 0 ? ListView.builder(
                              padding: const EdgeInsets.only(bottom: 120),
                              itemCount: box.get(Constants.bookmarkList).length,
                              itemBuilder: (BuildContext context,int index){
                                return ArticleWidget(article: box.get(Constants.bookmarkList)![index],isBookMarked: true, onAddBookMark: () {
                                  HiveDatabase.removeBookMark(box.get(Constants.bookmarkList)![index]);
                                });
                              }
                          ) : Center(child: Text("There is no bookmark available",style: TextStyle(color: Colors.white),),),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ));

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}