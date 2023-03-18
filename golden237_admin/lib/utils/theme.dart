import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

// light theme
ThemeData light = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(color: Colors.white.withOpacity(0.1)),
  scaffoldBackgroundColor: Colors.white.withOpacity(0.91),
);

// dark theme
ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  iconTheme: const IconThemeData(color: Colors.white),
);

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  final storage = GetStorage();
  bool _isDark = true;

// getter
  bool get isDark => _isDark;

  ThemeNotifier() {
    _isDark = true; // default value
    _loadFromPrefs();
  }

// function to change the theme
  toggleTheme() {
    _isDark = !_isDark;
    _savedToPrefs();
    notifyListeners();
  }

// loading saved preferences
  _loadFromPrefs() {
    _isDark = storage.read(key) ?? true;
    notifyListeners();
  }

// saving to preferences
  _savedToPrefs() {
    storage.write(key, _isDark);
  }
}
