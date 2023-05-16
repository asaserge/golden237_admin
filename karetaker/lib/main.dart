import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:karetaker/screens/account_screen.dart';
import 'package:karetaker/screens/favorite_screen.dart';
import 'package:karetaker/screens/home_screen.dart';
import 'package:karetaker/screens/main_screen.dart';
import 'package:karetaker/screens/property_screen.dart';
import 'package:karetaker/utils/apis.dart';
import 'package:karetaker/utils/constants.dart';
import 'package:karetaker/utils/messages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'controllers/property_controller.dart';
import 'screens/auth_screen.dart';
import 'controllers/auth_controller.dart';
import 'controllers/settings_controller.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
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
  final storage = GetStorage();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    Locale? getDeviceLocale(){
      if(storage.read('lang') == 'english'){
        return const Locale('en', 'US');
      }
      else if(storage.read('lang') == 'french'){
        return const Locale('fr', 'FR');
      }
      else {
        return Get.deviceLocale;
      }
    }

    return GetMaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      translations: Messages(),
      locale: getDeviceLocale(),
      fallbackLocale: const Locale('en', 'US'),
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen(), transition: Transition.zoom),
        GetPage(name: '/main', page: () => const MainScreen(), transition: Transition.zoom),
        GetPage(name: '/home', page: () => const HomeScreen(), transition: Transition.zoom),
        GetPage(name: '/auth', page: () => const AuthScreen(), transition: Transition.zoom),
        GetPage(name: '/favorite', page: () => const FavoriteScreen(), transition: Transition.zoom),
        GetPage(name: '/account', page: () => const AccountScreen(), transition: Transition.zoom),
        GetPage(name: '/property', page: () => const PropertyScreen(), transition: Transition.zoom),
      ],

    );
  }
}


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool _redirectCalled = false;

  @override
  void initState() {
    Get.put(AuthController());
    Get.put(SettingsController());
    Get.put(PropertyController());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(const Duration(seconds: 4));
    if (_redirectCalled || !mounted) {
      return;
    }

    _redirectCalled = true;
    final session = Apis.client.auth.currentSession;
    if (session == null) {
      Get.offAndToNamed('/home');
    } else {
      Get.offAndToNamed('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Center(
          child: Stack(
            textDirection: TextDirection.ltr,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.jpg', width: size.width / 2.8,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 40.0),

                  const Text('KareTaker', style: TextStyle(fontSize: 23, color: primaryColor,
                      fontWeight: FontWeight.bold, fontFamily: 'montserrat_bold')),

                  const SizedBox(height: 20.0),

                  const SizedBox(
                    height: 28.0,
                    width: 28.0,
                    child: CircularProgressIndicator(
                      color: primaryColor,
                      strokeWidth: 3,
                    ),

                  ),

                ],
              ),

              const Positioned(
                  bottom: 40,
                  right: 20,
                  left: 20,
                  child: Center(
                    child: Text(appSignature, style: TextStyle(fontSize: 8,
                        fontWeight: FontWeight.w700, fontFamily: 'montserrat_medium')),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
