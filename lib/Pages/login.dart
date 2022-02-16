import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/Services/google_sign_in.dart';
import 'package:news_app/configs/routes.dart';
import 'package:news_app/configs/size_config.dart';
import 'package:news_app/configs/theme_data.dart';
import 'package:news_app/customWidgets/button_widget.dart';
import 'package:news_app/models/user.dart';

class LoginPage extends GetWidget<GoogleAuth> {


  login(GoogleAuth controller) async {
    controller.isLoading = true;
    User? user = await controller.googleSignIn();
    controller.isLoading = false;

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
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Obx(() =>  SizedBox(
                  width: SizeConfig.screenWidth / 2,
                  child: ButtonWidget(
                      title: 'Google SignIn',
                      isLoading: controller.isLoading,
                      onpress: () {
                        login(controller);
                      }))),

            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
