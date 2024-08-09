import 'package:flutter/material.dart';

class FontSizes {
  static const extraSmall = 14.0;
  static const small = 16.0;
  static const standard = 18.0;
  static const large = 20.0;
  static const extraLarge = 24.0;
  static const doubleExtraLarge = 26.0;
}

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    shadowColor: Colors.white,
  ),
  colorScheme: const ColorScheme.light(
      background: Color(0xffffffff),
      primary: Color(0xff77DD77),
      secondary: Color(0xffEEEEEE)),
  inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Color(0xff77DD77))),
  textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Color(0xff000000),
      ),
      titleSmall: TextStyle(
        color: Color(0xff000000),
      ),
      bodyMedium:
          TextStyle(color: Color(0xffEEEEEE), fontSize: FontSizes.small),
      bodySmall:
          TextStyle(color: Color(0xff000000), fontSize: FontSizes.small)),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    shadowColor: Color(0xff625b5b),
  ),
  colorScheme: const ColorScheme.dark(
    background: Color(0xff000000),
    primary: Colors.blueAccent,
    secondary: Colors.orangeAccent,
    tertiary: Color(0xFF161616),
  ),
  textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Color(0xffFFFFFF),
      ),
      titleSmall: TextStyle(
        color: Color(0xff000000),
      ),
      bodyMedium:
          TextStyle(color: Color(0xffFFFFFF), fontSize: FontSizes.small),
      bodySmall:
          TextStyle(color: Color(0xffFFFFFF), fontSize: FontSizes.small)),
);
