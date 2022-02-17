
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/configs/dimens.dart';
import 'package:news_app/configs/theme_data.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget(
      {Key? key,
        required this.title,
         this.isLoading = false,
        this.isDisable = false,
        required this.onpress})
      : super(key: key);

  final bool isLoading;
  final String title;
  final Function onpress;
  final bool isDisable;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        splashFactory: isDisable ? NoSplash.splashFactory : null,
        shadowColor: isDisable
            ? MaterialStateProperty.all<Color>(Colors.transparent)
            : null,
        shape: MaterialStateProperty.resolveWith(
              (states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Dimens.buttonOutlineBorderRadius,
            ),
          ),
        ),
        backgroundColor: !isDisable
            ? MaterialStateProperty.resolveWith(
                (states) => ThemeClass.pinkColor)
            : MaterialStateProperty.resolveWith(
                (states) => ThemeClass.pinkColor.withOpacity(0.7)),
        padding: MaterialStateProperty.resolveWith(
              (states) => const EdgeInsets.all(10),
        ),
      ),
      onPressed: () {
        if (!isDisable) {
          onpress();
        }
      },
      child: isLoading
          ? const Center(
        child: SizedBox(
          height: 25,
          width: 25,
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      )
          : Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }
}
