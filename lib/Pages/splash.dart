import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:news_app/LocalDatabase/hive_database.dart';
import 'package:news_app/Utilities/constants.dart';
import 'package:news_app/configs/routes.dart';
import 'package:news_app/configs/size_config.dart';
import 'package:news_app/configs/theme_data.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);


  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

 @override
  void initState() {
    // TODO: implement initState
   Future.delayed(const Duration(seconds: 3), () {
     loadPage();
   });
    super.initState();
  }

///get user is loggedin or not if user is loggediIn then redirect to the home page otherwise login page.
  loadPage() {
     HiveDatabase.getLoginStatus().then((value) {
       Hive.openBox(Constants.bookmarkBox);
       Hive.openBox(Constants.userBox);
       if (value) {

         Get.offAllNamed(Routes.homePage);
       } else {
         Get.offAllNamed(Routes.login);
       }
     });
  }


  @override
  Widget build(BuildContext context) {
   SizeConfig().init(context);
    return Scaffold(
     backgroundColor: ThemeClass.purpleColor,
      body: Center(
        child:Lottie.asset('assets/img/lottieLogo.json',height: 250),
      ),
    );
  }
}