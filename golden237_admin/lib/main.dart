import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:golden237_admin/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:golden237_admin/screens/login_screen.dart';
import 'package:golden237_admin/services/apis.dart';

import 'package:golden237_admin/utils/messages.dart';
import 'package:golden237_admin/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  if (kDebugMode) {
    print('\n\n\n$fcmToken');
  }
  await Supabase.initialize(
      url: serverUrl,
      anonKey: anonKey,
      authCallbackUrlHostname: 'login-callback', // optional
      debug: true // optional
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return MaterialApp(
            title: appName,
            debugShowCheckedModeBanner: false,
            theme: notifier.isDark ? dark : light,
            home:  HomeScreen()
          );
        }),
    );
  }
}
