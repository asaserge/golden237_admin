import 'package:flutter/material.dart';

class MyTheme{

  static final ThemeData myLightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.orange,
    primarySwatch: Colors.orange,
  );

  static final ThemeData myDarkTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.orange,
    ),
    brightness: Brightness.dark,
  );
}