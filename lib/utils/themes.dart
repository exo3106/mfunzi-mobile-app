import 'package:flutter/material.dart';

class MyThemes {
  static final primary = Colors.blue;
  static final primaryColor = Colors.blue.shade300;

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: CustomColors.firebaseNavy,
    primaryColorDark: CustomColors.firebaseNavyLight,
    colorScheme: ColorScheme.dark(primary: primary),
    dividerColor: Colors.white,
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: CustomColors.firebaseBackground,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(primary: primary),
    dividerColor: Colors.white,
  );
}
class CustomColors {
  static final Color firebaseNavy = Color(0xFF2C384A);
  static final Color firebaseNavyLight = Color(0xFF334057);
  static final Color firebaseNavyLightInput = Color(0xFFA1AABA);
  static final Color firebaseOrange = Color(0xFFF57C00);
  static final Color firebaseAmber = Color(0xFFFFA000);
  static final Color firebaseYellow = Color(0xFFFFCA28);
  static final Color firebaseGrey = Color(0xFFECEFF1);
  static final Color firebaseBackground = Color(0xFFFFFFFF);
  static final Color complementBackground = Color(0xFF4285F4);

}