import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:golden237_admin/screens/add_category.dart';
import 'package:golden237_admin/screens/add_coupon.dart';
import 'package:golden237_admin/screens/add_product.dart';
import 'package:golden237_admin/screens/add_user.dart';
import 'package:golden237_admin/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'messages/constants.dart';
import 'messages/utils.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  //await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {

    final bool _isFirst = storage.read('isFirst') ?? true;
    final bool _isDark = storage.read('isDark') ?? true;

    return GetMaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: _isDark ? MyTheme.myDarkTheme : MyTheme.myDarkTheme,
      home: HomeScreen(),
    );
  }
}
