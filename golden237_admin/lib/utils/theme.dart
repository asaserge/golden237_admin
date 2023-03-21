import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

// light theme
ThemeData lightTheme  = ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.white,
  brightness: Brightness.light,
  backgroundColor: const Color(0xFFE5E5E5),
  dividerColor: Colors.white54,
);

// dark theme
ThemeData darkTheme  = ThemeData(
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  backgroundColor: const Color(0xFF212121),
  dividerColor: Colors.black12,
);
