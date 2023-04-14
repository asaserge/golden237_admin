import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:golden237_client/controllers/cart_controller.dart';
import 'package:golden237_client/screens/auth_screen.dart';
import 'package:golden237_client/screens/main_screen.dart';
import 'package:golden237_client/utils/apis.dart';
import 'package:golden237_client/utils/messages.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'controllers/auth_controller.dart';
import 'controllers/category_controller.dart';
import 'controllers/wishlist_controller.dart';
import 'controllers/product_controller.dart';
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
      else if(storage.read('lang') == 'spanish'){
        return const Locale('es', 'ES');
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
        primarySwatch: Colors.yellow,
      ),
      home: const SplashScreen(),
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
    ProductController productCtx = Get.put(ProductController());
    CategoryController categoryCtx = Get.put(CategoryController());
    WishlistController wishlistController = Get.put(WishlistController());
    CartController cartController = Get.put(CartController());
    AuthController authController = Get.put(AuthController());
    SettingsController  settingsController = Get.put(SettingsController());
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
    if (session != null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const MainScreen()));
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const AuthScreen()));
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
                    'assets/images/logo.png', width: size.width / 2.8,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 40.0),

                  const Text('Golden 237 Ecommerce', style: TextStyle(fontSize: 20,
                      fontWeight: FontWeight.w700, fontFamily: 'montserrat_medium')),

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


