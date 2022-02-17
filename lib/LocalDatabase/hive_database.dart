import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:news_app/Utilities/constants.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/models/source.dart';
import 'package:news_app/models/user.dart';
import 'package:path_provider/path_provider.dart';

class HiveDatabase {
  //INITIALIZE DATABASE and register models for save models direct to the local databse
  static initialize() async {
    Directory directory = await getApplicationDocumentsDirectory();
    log("Initializing Hive..at $directory");
    // Hive.init(directory.path);
    Hive..init(directory.path)..registerAdapter(ArticleAdapter())..registerAdapter(SourceAdapter())..registerAdapter(UserAdapter());
  }

  /// set user is loggedIn true or false
  static setLoginStatus(bool isLoggedIn) async {
    if (!Hive.isBoxOpen(Constants.loginStatusBox)) {
      await Hive.openBox(Constants.loginStatusBox);
    }
    Hive.box(Constants.loginStatusBox).put(Constants.isLoggedIn,isLoggedIn);
  }

  /// set user in to local database
  static setUser(User user) async {
    if (!Hive.isBoxOpen(Constants.userBox)) {
      await Hive.openBox(Constants.userBox);
    }
    Hive.box(Constants.userBox).put(Constants.userData,user);
  }


  ///get user from hive local database
  static Future<User> getUser() async {
    if (!Hive.isBoxOpen(Constants.userBox)) {
      await Hive.openBox(Constants.userBox);
    }
    return Hive.box(Constants.userBox).get(Constants.userData);
  }

  /// get login statues for page redirection
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

  /// set bookmarked Article in to local database list
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
        Get.snackbar("Success!", "Added to the bookmark"   ,snackPosition: SnackPosition.BOTTOM, padding: const EdgeInsets.all(10),duration: const Duration(seconds: 2),backgroundColor: Colors.black);
      } else {
        Get.snackbar("Opps!", "This News is already added to the bookmark"   ,snackPosition: SnackPosition.BOTTOM, padding: const EdgeInsets.all(10),duration: const Duration(seconds: 2),backgroundColor: Colors.black);
      }
      Hive.box(Constants.bookmarkBox).put(Constants.bookmarkList,list);
    return true;
  }

  /// remove bookMark from the database
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