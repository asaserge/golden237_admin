import 'package:flutter/material.dart';
import 'package:golden237_admin/screens/home_screen.dart';

import 'messages/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  var theme = ValueNotifier(ThemeMode.dark);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: theme,
        builder: (context, value, child) => MaterialApp(
          title: appName,
          home: HomeScreen(theme: theme),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.orange,
          ),
          darkTheme: ThemeData(
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.orange,
            ),
            brightness: Brightness.dark,
            primaryColor: Colors.lightBlue[900],
          ),
          themeMode: value,
        )
    );
  }
}
