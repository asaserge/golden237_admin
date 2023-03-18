import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

import '../services/apis.dart';
import '../utils/constants.dart';
import '../widgets/custom_input.dart';
import '../widgets/submit_button.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPass = TextEditingController();
  final _authFormKey = GlobalKey<FormState>();
  bool isObscured = true;
  bool isLoading = false;
  bool isEnable = true;
  final storage = GetStorage();
  final bool isLoggedIn = false;
  String storedEmail = '';
  String storedPass = '';
  bool isUser = false;

  @override
  void initState()  {
    isUser = storage.read('isUser') ?? false;
    storedEmail = storage.read('email') ?? '';
    storedPass = storage.read('pass') ?? '';
    _keepUserLoggedIn();
    super.initState();
  }

  _keepUserLoggedIn() async{
    if(Apis.client.auth.currentUser != null){
      if(isUser){
        loginMethod(storedEmail, storedPass);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Auth'),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('Welcome', style: TextStyle(fontSize: 12)),
          ) ,
          SizedBox(width: 22)
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/icons/admin.png'),
              const SizedBox(height: 10),
              const Text('How are you today Admin?', style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600)),
              const Text('SignIn to see how business is doing today', style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic)),
              const SizedBox(height: 35),
              Form(
                key: _authFormKey,
                child: Column(
                  children: [
                    CustomInput(
                      controller: _controllerEmail,
                      hintText: 'Admin\'s Email',
                      maxCount: 35,
                      label: 'Email',
                      prefixIcon: Icons.email_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required!';
                        }
                        if (!(regex.hasMatch(value))) {
                          return "Enter a valid email address!";
                        }
                        return null;
                      },
                      textInputType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 25),

                    TextFormField(
                      controller: _controllerPass,
                      maxLength: 35,
                      obscureText: isObscured,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required!';
                        }
                        if (value.length < 8) {
                          return "Password is too short!";
                        }
                        return null;
                      },
                      cursorColor: Get.isDarkMode ? Colors.white : Colors.black54,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.white38
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  width: 1,
                                  color: primaryColor
                              )
                          ),
                          prefixIcon: const Icon(Icons.lock_outline, color: primaryColor),
                          hintText: 'Admin\'s Password',
                          label: const Text('Password'),
                          suffixIcon: GestureDetector(
                            onTap: (){
                              setState(() {
                                isObscured = !isObscured;
                              });
                            },
                            child: isObscured ? const Icon(Icons.remove_red_eye_outlined) : const Icon(Icons.remove_red_eye),
                          )
                      ),


                    )

                  ],
                ),
              ),

              const SizedBox(height: 35),

              SubmitButton(
                text: 'LOGIN',
                isLoading: isLoading,
                isEnabled: isEnable,
                onPressed: () {
                  if (_authFormKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    loginMethod(_controllerEmail.text, _controllerPass.text);
                  }
                  else {
                    return;
                  }
                }
              ),

              const SizedBox(height: 25),

              const Text('If you have forgotten your password, contact the developer for owner '
                  'verification and confirmation', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10)),

              const SizedBox(height: 35),
              InkWell(
                onTap: (){
                  launchWhatsApp();
                },
                child: const Text('Powered By ASAtech @Buea - 2023',
                    style: TextStyle(fontSize: 8, color: primaryColor)),
              ),

              const SizedBox(height: 1000),
            ],
          ),
        ),
      ),
    );
  }

  void launchWhatsApp() async{
    String url(){
      if (Platform.isAndroid) {
        return "https://wa.me/+237651565843/?text=${Uri.parse('Password rest for Golden237')}"; // new line
      } else {
        return "https://api.whatsapp.com/send?phone=+237651565843=${Uri.parse('Password rest for Golden237')}"; // new line
      }
    }
    Uri uri = Uri.parse(url());
    if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
    } else {
      Get.snackbar('Oops!', 'Something went wrong!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red, colorText: Colors.white,
      borderRadius: 0);
    throw 'Could not launch ${url()}';

    }
  }

  Future<void> loginMethod(String email, String password) async {
    final AuthResponse response = await Apis.client.auth.signInWithPassword(email: email, password: password);
    _goForward();
    // if (response.user == null) {
    //   if (response.error!.message.contains('Failed host lookup')) {
    //     Get.snackbar('Oops!', 'No Internet Connection!',
    //         borderRadius: 0,
    //         backgroundColor: Colors.red,
    //         colorText: Colors.white,
    //         duration: const Duration(seconds: 4));
    //   } else {
    //     Get.snackbar('Oops!', 'No Internet Connection!',
    //         borderRadius: 0,
    //         backgroundColor: Colors.red,
    //         colorText: Colors.white,
    //         duration: const Duration(seconds: 4));
    //   }
    //   setState(() {
    //     isLoading = false;
    //   });
    // }
  }

  void _goForward(){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

}



RegExp regex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

