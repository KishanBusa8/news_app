import 'dart:convert';

import 'package:get/get.dart';
import 'package:news_app/Utilities/constants.dart';
import 'package:news_app/models/article.dart';

class Provider extends GetConnect {

  Future<List<Article>> getTopHeadLines() async{
    var url =Constants.baseUrl + Constants.topHeadlines + "&apiKey=${Constants.apiKey}";

    final response = await get(url);
    if(response.status.hasError){
      return Future.error(response.statusText!);
    } else {
      var responseBody = jsonDecode(response.body);
      return (responseBody['articles'] as List).map((e) => Article.fromJson(e)).toList();
    }
  }

}