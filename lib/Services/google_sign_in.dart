import 'dart:convert';
import 'dart:developer';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_app/LocalDatabase/hive_database.dart';
import 'package:news_app/models/user.dart';


/// google auth service for sign in and sign out method
class GoogleAuth extends GetxController {
  bool isLoading = false.obs as bool;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      "https://www.googleapis.com/auth/userinfo.profile"
    ],
  );

  Future<User?> googleSignIn() async {

    try {
      googleSignOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      await  HiveDatabase.setLoginStatus(true);
      User user = User(email: googleUser!.email,id: googleUser.id,name: googleUser.displayName);
      return user;
    } catch (e) {
      Get.snackbar("Error", "$e"   ,snackPosition: SnackPosition.BOTTOM, padding: const EdgeInsets.all(10),duration: const Duration(seconds: 3));
      log("error : $e");
      return null;
    }
  }

  Future<bool> googleSignOut() async {
    // await auth.signOut();
    await _googleSignIn.signOut().then((value) {});
    await HiveDatabase.setLoginStatus(false);

    return true;
  }
}
