import 'package:flutter/material.dart';
import 'package:news_app/configs/dimens.dart';

class ThemeClass {
  // ! colors assigning

  static const Color purpleColor = Color(0xFF170B3B);
  static const Color pinkColor = Color(0xFFfe4164);

  static final themeData = ThemeData(
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    accentColor: ThemeClass.purpleColor,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          color: ThemeClass.purpleColor,
        ),
        borderRadius: BorderRadius.circular(
          Dimens.outlineBorderRadius,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: ThemeClass.purpleColor),
        borderRadius: BorderRadius.circular(
          Dimens.outlineBorderRadius,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          Dimens.outlineBorderRadius,
        ),
        borderSide: const BorderSide(color: ThemeClass.purpleColor),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: ThemeClass.purpleColor),
        borderRadius: BorderRadius.circular(
          Dimens.outlineBorderRadius,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: ThemeClass.purpleColor),
        borderRadius: BorderRadius.circular(
          Dimens.outlineBorderRadius,
        ),
      ),
    ),
  );
}
