import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:news_app/LocalDatabase/hive_database.dart';
import 'package:news_app/Utilities/constants.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/article.dart';
import 'package:news_app/models/user.dart';

class ApiService extends GetxController {
  // @override
  // void onInit() {
  //   super.onInit();
  //   getTopHeadLines().then((value) {
  //     change(value, status: RxStatus.success());
  //   },onError: (error){
  //     change([],status: RxStatus.error(error.toString()));
  //   });
  // }
  //
  // @override
  // void onClose() {
  //   // TODO: implement onClose
  //   super.onClose();
  // }


  RxBool isLoading = false.obs;
  int count = 20;


  Future<String?> getUserGreet() async {
    User user = await HiveDatabase.getUser();
    return "👋 Hey " + user.name!;
  }

   Future<List<Article>> getTopHeadLines(page) async {
     isLoading = RxBool(true);
     List<Article> articles;
     var url = Uri.parse(Constants.baseUrl + Constants.topHeadlines + "&apiKey=${Constants.apiKey}&pageSize=$page");
     try {
       var response = await http.get(url);
       var responseBody = jsonDecode(response.body);
       count = responseBody['totalResults'];
       print(responseBody['articles'].length);
       articles = (responseBody['articles'] as List).map((e) => Article.fromJson(e)).toList();
       isLoading = RxBool(false);
     } catch (e) {
       isLoading = RxBool(false);
       Get.snackbar("Error", "$e"   ,snackPosition: SnackPosition.BOTTOM, padding: const EdgeInsets.all(10),duration: const Duration(seconds: 3));
       return [];
     }
     return articles;
   }

   Future<List<Article>> getArticlesFromSearch(String query) async {
     isLoading = RxBool(true);
     List<Article> articles;

     var url = Uri.parse(Constants.searchUrl + query + "&sortBy=publishedAt" + "&apiKey=${Constants.apiKey}");
     try {
       var response = await http.get(url);
       var responseBody = jsonDecode(response.body);

       articles = (responseBody['articles'] as List).map((e) => Article.fromJson(e)).toList();
       // change(articles, status: RxStatus.success());

       isLoading = RxBool(false);
     } catch (e) {
       Get.snackbar("Error", "$e"   ,snackPosition: SnackPosition.BOTTOM, padding: const EdgeInsets.all(10),duration: const Duration(seconds: 3));
       isLoading = RxBool(false);
       return [];
     }
     return articles;
   }

   // Stream<BoxEvent> bookMarkArticlesStream =  Hive.box(Constants.bookmarkBox).watch(key: Constants.bookmarkList);

}