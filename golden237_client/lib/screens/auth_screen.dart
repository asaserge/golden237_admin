import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden237_client/screens/policy_screen.dart';
import 'package:golden237_client/widgets/widget_text.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../controllers/auth_controller.dart';
import '../main.dart';
import '../utils/apis.dart';
import '../utils/messages.dart';
import '../widgets/widget_input.dart';
import 'main_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {

   late TabController tabController;
   late TextEditingController usernameCtrl;
   late TextEditingController emailCtrl;
   late TextEditingController passwordCtrl;
   final formKey1 = GlobalKey<FormState>();
   final formKey2 = GlobalKey<FormState>();

   final AuthController authController = Get.find();
   bool _redirecting = false;
   late final StreamSubscription<AuthState> _authStateSubscription;

   @override
  void initState() {
    tabController = TabController(length: 2, vsync: this,
        animationDuration: const Duration(milliseconds: 250));
    usernameCtrl = TextEditingController();
    emailCtrl = TextEditingController();
    passwordCtrl = TextEditingController();
    _authStateSubscription = Apis.client.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      if (session != null) {
        authController.isUserLoggedIn.value = true;
        _redirecting = true;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
      }
      else{
        authController.isUserLoggedIn.value = false;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    usernameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      appBar: TabBar(
        controller: tabController,
        indicatorColor: Colors.black,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 3.0,
        labelStyle: const TextStyle(fontFamily: 'montserrat_bold'),
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        tabs: [
          Tab(text: 'login'.tr, icon: const Icon(Icons.login_outlined)),
          Tab(text: 'signup'.tr, icon: const Icon(Icons.account_box_outlined)),
        ],
      ),

      body: TabBarView(
        controller: tabController,
        children: [
          SingleChildScrollView(
            child:  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30.0),
              child: Column(
                children: [
                  SizedBox(
                      height: 200,
                      child: Lottie.asset('assets/anims/login1.json')
                  ),
                  WidgetText(text: 'login_head'.tr),
                  const SizedBox(height: 30.0),

                  Form(
                    key: formKey1,
                    child: Column(
                      children: [

                        WidgetInput(textEditingController: emailCtrl, prefixIcon: Icons.email_outlined,
                            labelText: 'email'.tr, hintText: 'serge123cmr@example.com', textInputType: TextInputType.emailAddress, validator: (str) {
                              if(str!.isEmpty) {
                                return 'required'.tr;
                              }
                              else if (!(regex.hasMatch(str))) {
                                return 'valid'.tr;
                              }
                              return null;
                            }),

                        const SizedBox(height: 30.0),
                        WidgetInput(textEditingController: passwordCtrl, prefixIcon: Icons.lock_outline,
                            maxLength: 25, labelText: 'pass'.tr, hintText: '*************', isObscured: true, validator: (str) {
                              if(str!.isEmpty) {
                                return 'required'.tr;
                              }
                              else if(str.length < 6){
                                return 'short'.tr;
                              }
                              return null;
                            }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50.0),
                  GestureDetector(
                    onTap: (){
                      if(formKey1.currentState!.validate()){
                        loginUser(context, emailCtrl.text, passwordCtrl.text);
                      }
                      return;
                    },
                    child: Obx(() => Container(
                        height: 40,
                        width: 200,
                        margin: const EdgeInsets.only(top: 10.0, bottom: 25.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            border:  Border.all(
                                width: 2,
                                color: Colors.black
                            )
                        ),
                        child: authController.isLoading1.value ?
                        spinkit :
                        Center(
                          child: WidgetText(text: 'login'.tr, size: 18),
                        )
                    )),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: (){

                        },
                        child: SizedBox(
                            height: 40,
                            child: Center(
                              child: WidgetText(text: 'forgotten'.tr, size: 14),
                            )
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => const MainScreen()));
                        },
                        child: SizedBox(
                            height: 40,
                            child: Center(
                              child: WidgetText(text: 'skip'.tr, size: 14),
                            )
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SingleChildScrollView(
            child:  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30.0),
              child: Column(
                children: [
                  SizedBox(
                      height: 200,
                      child: Lottie.asset('assets/anims/login2.json')
                  ),

                  Form(
                    key: formKey2,
                    child: Column(
                      children: [
                        WidgetText(text: 'signup_head'.tr, maxLines: 3),
                        const SizedBox(height: 30.0),
                        WidgetInput(textEditingController: usernameCtrl, prefixIcon: Icons.person_outline,
                            maxLength: 15, labelText: 'username'.tr, hintText: 'Serge Atangana', validator: (str) {
                              if(str!.isEmpty) {
                                return 'required'.tr;
                              }
                              else if(str.length < 4){
                                return 'short'.tr;
                              }

                              return null;
                            }),

                        const SizedBox(height: 30.0),
                        WidgetInput(textEditingController: emailCtrl, prefixIcon: Icons.email_outlined,
                            labelText: 'email'.tr, hintText: 'serge123cmr@example.com', textInputType: TextInputType.emailAddress, validator: (str) {
                              if(str!.isEmpty) {
                                return 'required'.tr;
                              }
                              else if (!(regex.hasMatch(str))) {
                                return 'valid'.tr;
                              }
                              return null;
                            }),

                        const SizedBox(height: 30.0),
                        WidgetInput(textEditingController: passwordCtrl, prefixIcon: Icons.lock_outline,
                            maxLength: 25, labelText: 'pass'.tr, hintText: '*************', isObscured: true, validator: (str) {
                              if(str!.isEmpty) {
                                return 'required'.tr;
                              }
                              else if(str.length < 6){
                                return 'short'.tr;
                              }
                              return null;
                            }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30.0),
                  RichText(
                    text: TextSpan(
                        style: TextStyle(
                            color: Get.isDarkMode
                                ? null
                                : Colors.black54),
                        children: [
                          TextSpan(
                              text:
                              'our_policy'.tr,
                              style: const TextStyle(fontSize: 9, fontFamily: 'montserrat_light')),
                          TextSpan(
                            text: 'terms'.tr,
                            style: const TextStyle(fontSize: 9, color: Colors.orange, fontFamily: 'montserrat_light'),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const PolicyScreen()));
                              },
                          ),
                          TextSpan(
                              text: 'read'.tr,
                              style: const TextStyle(fontSize: 9, fontFamily: 'montserrat_light')),
                          TextSpan(
                            text: 'privacy_policy'.tr,
                            style: const TextStyle(fontSize: 11, color: Colors.orange, fontFamily: 'montserrat_light'),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const PolicyScreen()));
                              },
                          ),
                        ]),
                  ),

                  GestureDetector(
                    onTap: (){
                      if(formKey2.currentState!.validate()){
                        signupNewUser(context, usernameCtrl.text, emailCtrl.text, passwordCtrl.text);
                      }
                      return;
                    },
                    child: Obx(() => Container(
                        height: 40,
                        width: 200,
                        margin: const EdgeInsets.only(top: 10.0, bottom: 25.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            border:  Border.all(
                                width: 2,
                                color: Colors.black
                            )
                        ),
                        child: authController.isLoading2.value ?
                        spinkit :
                        Center(
                          child: WidgetText(text: 'signup'.tr, size: 18),
                        )
                    )),
                  ),

                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => const MainScreen()));
                    },
                    child: SizedBox(
                        height: 40,
                        child: Center(
                          child: WidgetText(text: 'skip'.tr, size: 14),
                        )
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
    );
  }


   loginUser(BuildContext context, String email, String password) async {
     authController.isLoading1(true);
     try{
       await Apis.client.auth.signInWithPassword(email: email, password: password);
       if(mounted) {
         Navigator.of(context).pushReplacement(
             MaterialPageRoute(builder: (context) => const SplashScreen()));
       }
     } on AuthException catch (error){
       Get.snackbar('Oops!', error.toString(),
           borderRadius: 0, backgroundColor: Colors.red, colorText: Colors.white);
     }
     catch (error){
       Get.snackbar('Oops!', 'An unexpected error occurred!',
           borderRadius: 0, backgroundColor: Colors.red, colorText: Colors.white);
     }

   }

   signupNewUser(BuildContext context, String username, String email, String password) async {
     int num = 100 + Random().nextInt(1000 - 100);
     String code = '${username.substring(0, 3).toUpperCase()}$num';
     authController.isLoading2(true);
     try{
       await Apis.client.auth.signUp(email: email, password: password,
           data: {
             'name': username,
             'code': code,
           });
       if(mounted) {
         Navigator.of(context).pushReplacement(
             MaterialPageRoute(builder: (context) => const SplashScreen()));
       }
     } on AuthException catch (error){
       Get.snackbar('Oops!', error.message,
           borderRadius: 0, backgroundColor: Colors.red, colorText: Colors.white);
     }
     catch (error){
       Get.snackbar('Oops!', 'An unexpected error occurred!',
           borderRadius: 0, backgroundColor: Colors.red, colorText: Colors.white);
     }
   }
}



RegExp regex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

