import 'dart:developer';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:news_app/Utilities/constants.dart';
import 'package:path_provider/path_provider.dart';

class HiveDatabase {
  //INITIALIZE DATABASE
  static initialize() async {
    Directory directory = await getApplicationDocumentsDirectory();
    log("Initializing Hive..at $directory");
    // Hive.init(directory.path);
    Hive.init(directory.path);
  }
  static setLoginStatus(bool isLoggedIn) async {
    if (!Hive.isBoxOpen(Constants.loginStatusBox)) {
      await Hive.openBox(Constants.loginStatusBox);
    }
    Hive.box(Constants.loginStatusBox).put(Constants.isLoggedIn,isLoggedIn);
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
}