import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:golden237_admin/screens/category_screen.dart';
import 'package:golden237_admin/screens/catproduct_screen.dart';
import 'package:golden237_admin/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:golden237_admin/screens/login_screen.dart';
import 'package:golden237_admin/screens/modify_category.dart';
import 'package:golden237_admin/screens/modify_subcategory.dart';
import 'package:golden237_admin/screens/product_screen.dart';
import 'package:golden237_admin/screens/subcategory_screen.dart';
import 'package:golden237_admin/services/apis.dart';
import 'package:golden237_admin/utils/constants.dart';

import 'package:golden237_admin/utils/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'controller/auth_controller.dart';
import 'controller/category_controller.dart';
import 'controller/product_controller.dart';

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
  runApp(const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: darkTheme,
        initialRoute: '/',
        getPages: [
          GetPage(transition: Transition.zoom, name: '/', page: () => const HomeScreen()),
          GetPage(transition: Transition.zoom, name: '/category', page: () => const CategoryScreen()),
          GetPage(transition: Transition.zoom, name: '/modify_category', page: () => ModifyCategory()),
          GetPage(transition: Transition.zoom, name: '/subcategory', page: () => const SubCategoryScreen()),
          GetPage(transition: Transition.zoom, name: '/modify_subcategory', page: () => const ModifySubCategory()),
          GetPage(transition: Transition.zoom, name: '/product', page: () => const ProductScreen()),
          GetPage(transition: Transition.zoom, name: '/auth', page: () => const LoginScreen()),
          GetPage(transition: Transition.zoom, name: '/cat_product', page: () => const CatProductScreen()),
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
    ProductController productCtx = Get.put(ProductController());
    CategoryController categoryCtx = Get.put(CategoryController());
    AuthController cartController = Get.put(AuthController());
    AuthController authController = Get.put(AuthController());
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
      Get.offAndToNamed('/');
    } else {
      Get.offAndToNamed('/login');
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

                  const Text('Golden 237 Ecommerce Admin Panel', style: TextStyle(fontSize: 20,
                      fontWeight: FontWeight.w700, fontFamily: 'montserrat_medium')),

                ],
              ),

              const Positioned(
                  bottom: 40,
                  right: 20,
                  left: 20,
                  child: Center(
                    child: Text('ASAtech built it!', style: TextStyle(fontSize: 8,
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
