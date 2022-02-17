import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:news_app/Services/google_sign_in.dart';
import 'package:news_app/configs/routes.dart';
import 'package:news_app/configs/size_config.dart';
import 'package:news_app/configs/theme_data.dart';
import 'package:news_app/customWidgets/button_widget.dart';
import 'package:news_app/models/user.dart';

class LoginPage extends GetWidget<GoogleAuth> {


  login(GoogleAuth controller) async {
    controller.isLoading = RxBool(true);
    User? user = await controller.googleSignIn();
    controller.isLoading = RxBool(false);

    if (user != null) {
      Get.offAllNamed(Routes.homePage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeClass.purpleColor,
      body: SingleChildScrollView(
        child: Container(
          height: SizeConfig.screenHeight,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Lottie.asset('assets/img/googleLogo.json',height: 200),
              SizedBox(height: 10,),
              SizedBox(
                  width: SizeConfig.screenWidth,
                  child: ButtonWidget(
                      title: 'SignIn with Google',
                      isLoading: controller.isLoading.value,
                      onpress: () {
                        login(controller);
                      }))

            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
