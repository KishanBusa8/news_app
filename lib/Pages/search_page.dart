import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:news_app/LocalDatabase/hive_database.dart';
import 'package:news_app/Services/api_service.dart';
import 'package:news_app/Services/google_sign_in.dart';
import 'package:news_app/configs/routes.dart';
import 'package:news_app/configs/size_config.dart';
import 'package:news_app/configs/theme_data.dart';
import 'package:news_app/customWidgets/article_widget.dart';
import 'package:news_app/customWidgets/button_widget.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/models/user.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);


  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController _controller =  TextEditingController();
  Timer? _debounce;
  int _debouncetime = 500;
  FocusNode searchFocus = FocusNode();
  late ApiService controller;
  List<Article> searchResult = [];
  bool show = true;
  bool loader = false;
  bool tap = true;
  String pastText = '';

  @override
  void initState() {
    controller = Get.find();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: ThemeClass.purpleColor,
      body: SingleChildScrollView(
        child: Container(
          height: SizeConfig.screenHeight,
          margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding:
                new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Container(

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: InkWell(
                            child: Icon(Icons.chevron_left,size: 40,),
                            onTap: () {
                              Get.back();
                            },
                          ),
                          padding: EdgeInsets.only(right: 0 , bottom: 5, top: 5),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 100,
                          child: TextFormField(
                            controller: _controller,
                            focusNode: searchFocus,
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.w500),
                            onChanged: (text) {
                              if (pastText != text) {
                                if (_debounce.isBlank! &&_debounce!.isActive) {
                                  _debounce!.cancel();
                                }
                              loader = false;
                                _debounce = Timer(
                                    Duration(milliseconds: _debouncetime), () {
                                  if (text != "") {
                                    show = false;
                                  searchResult.clear();
                                    controller
                                        .getArticlesFromSearch(text)
                                        .then((value) {
                                    pastText = text;
                                     loader = true;
                                    searchResult = value;
                                    setState(() {

                                    });
                                    });
                                  } else {
                                      pastText = text;
                                      show = true;
                                      searchResult.clear();
                                      setState(() {

                                      });
                                  }
                                });
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(color: Colors.black),
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.only(left: 20),
                              suffixIcon: _controller.text.length != 0
                                  ? IconButton(
                                  onPressed: () {
                                    _controller.clear();
                                  },
                                  icon: loader
                                      ? Icon(
                                    Icons.close,
                                    color: Colors.grey,
                                  )
                                      : Container(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(),
                                  ))
                                  : SizedBox(),
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                            ),
                          ),
                        ),
                      ],
                    )),

              ),
              Expanded(child: ListView.builder(
              itemCount: searchResult.length,
                  itemBuilder: (BuildContext context,int index){
                    return ArticleWidget(article: searchResult[index],isBookMarked: false,onAddBookMark: () {
                      HiveDatabase.setBookMark(searchResult[index]);
                    });
                  }
              ),)
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
