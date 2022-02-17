import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:news_app/Utilities/constants.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/models/source.dart';
import 'package:news_app/models/user.dart';
import 'package:path_provider/path_provider.dart';

class HiveDatabase {
  //INITIALIZE DATABASE
  static initialize() async {
    Directory directory = await getApplicationDocumentsDirectory();
    log("Initializing Hive..at $directory");
    // Hive.init(directory.path);
    Hive..init(directory.path)..registerAdapter(ArticleAdapter())..registerAdapter(SourceAdapter())..registerAdapter(UserAdapter());
  }
  static setLoginStatus(bool isLoggedIn) async {
    if (!Hive.isBoxOpen(Constants.loginStatusBox)) {
      await Hive.openBox(Constants.loginStatusBox);
    }
    Hive.box(Constants.loginStatusBox).put(Constants.isLoggedIn,isLoggedIn);
  }
  static setUser(User user) async {
    if (!Hive.isBoxOpen(Constants.userBox)) {
      await Hive.openBox(Constants.userBox);
    }
    Hive.box(Constants.userBox).put(Constants.userData,user);
  }

  static Future<User> getUser() async {
    if (!Hive.isBoxOpen(Constants.userBox)) {
      await Hive.openBox(Constants.userBox);
    }
    return Hive.box(Constants.userBox).get(Constants.userData);
  }

  static Future<bool> getLoginStatus() async {
    if (await Hive.boxExists(Constants.loginStatusBox)) {
      if (!Hive.isBoxOpen(Constants.loginStatusBox)) {
        await Hive.openBox(Constants.loginStatusBox);
      }
      bool status = Hive.box(Constants.loginStatusBox).get(Constants.isLoggedIn);
      return status;
    } else {
      return false;
    }
  }
  static Future<List<Article>> getBookMarkArticles() async {
    if (await Hive.boxExists(Constants.bookmarkBox)) {
      if (!Hive.isBoxOpen(Constants.bookmarkBox)) {
        await Hive.openBox(Constants.bookmarkBox);
      }
      List list = Hive.box(Constants.bookmarkBox).get(Constants.bookmarkList);
      List<Article> articles = list.map((e) => Article.fromJson(e)).toList();
      return articles;
    } else {
      return [];
    }
  }
  static Future setBookMark(Article article) async {
      if (!Hive.isBoxOpen(Constants.bookmarkBox)) {
        await Hive.openBox(Constants.bookmarkBox);
      }
      List list = [];
      if (Hive.box(Constants.bookmarkBox).get(Constants.bookmarkList) != null) {
        list =   Hive.box(Constants.bookmarkBox).get(Constants.bookmarkList);
      }
      if (list.where((element) => (element.source.id == article.source!.id && element.title == article.title)).isEmpty) {
        list.add(article);
      }
      print(list);

      Hive.box(Constants.bookmarkBox).put(Constants.bookmarkList,list);

    return true;
  }
  static Future removeBookMark(Article article) async {
    if (!Hive.isBoxOpen(Constants.bookmarkBox)) {
      await Hive.openBox(Constants.bookmarkBox);
    }
    List list = [];
    if (Hive.box(Constants.bookmarkBox).get(Constants.bookmarkList) != null) {
      list =   Hive.box(Constants.bookmarkBox).get(Constants.bookmarkList);
    }
    list.removeWhere((element) => (element.source.id == article.source!.id && element.title == article.title));
    print(list);

    Hive.box(Constants.bookmarkBox).put(Constants.bookmarkList,list);

    return true;
  }
}