import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:golden237_client/screens/policy_screen.dart';
import 'package:golden237_client/screens/profile_screen.dart';
import 'package:golden237_client/widgets/widget_text.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/auth_controller.dart';
import '../controllers/settings_controller.dart';
import '../utils/theme.dart';
import 'auth_screen.dart';
import 'chat_screen.dart';
import 'faq_screen.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({Key? key}) : super(key: key);

  final SettingsController settingsController = Get.find();
  final AuthController authController = Get.find();
  final TextEditingController promoCtx = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Obx(() => authController.isUserLoggedIn.value ?
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 90,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 20.0),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            authController.userAvatar.value == '' ?
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  image: const DecorationImage(
                                      image: AssetImage('assets/images/avatar.png')
                                  ),
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.black
                                  )
                              ),
                            ) :
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(authController.userAvatar.value),
                                  ),
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.black
                                  )
                              ),
                            ),
                            const SizedBox(width: 15.0),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => const ProfileScreen()));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  WidgetText(text: authController.userName.value, font: 'montserrat_bold', size: 18),
                                  const SizedBox(height: 3.0),
                                  WidgetText(text: 'profile'.tr, size: 15),
                                ],
                              ),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const ProfileScreen()));
                          },
                          child: Row(
                            children: const [
                              Icon(Icons.manage_accounts_outlined),
                              SizedBox(width: 15.0),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  ListTile(
                    leading: const Icon(Icons.list_alt_outlined, size: 30),
                    title: WidgetText(text: 'orders'.tr),
                    onTap: (){

                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.notifications_outlined, size: 30),
                    title: WidgetText(text: 'noti'.tr),
                    trailing: const Icon(Icons.circle, size: 10, color: Colors.red),
                    onTap: (){

                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: WidgetText(text: 'settings'.tr, size: 18, font: 'montserrat_bold'),
                  ),

                  Obx(() =>
                      SwitchListTile(
                          value: settingsController.isDarkMode.value,
                          activeColor: Colors.black,
                          secondary: settingsController.isDarkMode.value ?
                          const Icon(Icons.dark_mode_outlined, size: 30) :
                          const Icon(Icons.light_mode_outlined, size: 30),
                          title: WidgetText(text:'dark'.tr),
                          onChanged: (val){
                            settingsController.isDarkMode.value = val;
                            if(val){
                              Get.changeTheme(darkTheme);
                              storage.write('isDarkMode', settingsController.isDarkMode.value);
                            }
                            else{
                              Get.changeTheme(lightTheme);
                              storage.write('isDarkMode', settingsController.isDarkMode.value);
                            }
                          }
                      ),
                  ),

                  ListTile(
                    leading: const Icon(Icons.translate_outlined, size: 30),
                    title: WidgetText(text: 'language'.tr),
                    onTap: (){
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return customDialog(context);
                        },
                      );
                    },
                  ),

                  Obx(() =>
                      SwitchListTile(
                          value: settingsController.isLocation.value,
                          activeColor: Colors.black,
                          secondary: settingsController.isLocation.value ?
                          const Icon(Icons.location_on_outlined, size: 30) :
                          const Icon(Icons.location_off_outlined, size: 30),
                          title: WidgetText(text:'location'.tr),
                          onChanged: (val){
                            settingsController.isLocation.value = val;
                            if(val){
                              storage.write('isLocation', settingsController.isLocation.value);
                            }
                            else{
                              storage.write('isLocation', settingsController.isLocation.value);
                            }
                          }
                      ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: WidgetText(text: 'reward'.tr, size: 18, font: 'montserrat_bold',),
                  ),

                  ListTile(
                    leading: const Icon(Icons.campaign_outlined, size: 30),
                    title: WidgetText(text: 'promo'.tr),
                    onTap: (){
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context){
                            return AnimatedPadding(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeOut,
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 30.0),
                                  const WidgetText(text: 'Apply Promo Code'),
                                  const SizedBox(height: 30.0),
                                  Form(
                                      key: formKey,
                                      child: Container(
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                        child: TextFormField(
                                          controller: promoCtx,
                                          validator: (val){
                                            if(val!.isEmpty){
                                              return 'Field required';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              hintText: 'Enter promo code',
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12.0),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.withOpacity(0.3),
                                                  )
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.black,
                                                  )
                                              )
                                          ),
                                        ),
                                      )
                                  ),
                                  const SizedBox(height: 60.0),
                                  Container(
                                      height: 40,
                                      width: 130,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15.0),
                                          border:  Border.all(
                                              width: 2,
                                              color: Colors.black
                                          )
                                      ),
                                      child: const Center(
                                        child: WidgetText(text: 'Apply', size: 18),
                                      )
                                  )
                                ],
                              ),
                            );
                          }
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.workspace_premium_outlined, size: 30),
                    title: WidgetText(text: 'reward'.tr),
                    trailing: WidgetText(text: '0 Pts', font: 'montserrat_light', size: 13),
                    onTap: (){

                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_month_outlined, size: 30),
                    title: WidgetText(text: 'daily'.tr),
                    trailing: WidgetText(text: '0 Pts', font: 'montserrat_light', size: 13),
                    onTap: (){

                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: WidgetText(text: 'support'.tr, size: 18, font: 'montserrat_bold',),
                  ),

                  ListTile(
                    leading: const Icon(Icons.announcement_outlined, size: 30),
                    title: WidgetText(text: 'customer'.tr),
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const LiveChat()));
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.help_outline_outlined, size: 30),
                    title: WidgetText(text: 'faq'.tr),
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const FaqScreen()));
                    },
                  ),


                  ListTile(
                    leading: const Icon(Icons.policy_outlined, size: 30),
                    title: WidgetText(text: 'policies'.tr),
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const PolicyScreen()));
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.share_outlined, size: 30),
                    title: WidgetText(text: 'share'.tr),
                    onTap: (){
                      showShareOption(context);
                    },
                  ),

                  const SizedBox(height: 30.0)


                ],
              ),
            ) :
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 90,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 20.0),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  image: const DecorationImage(
                                      image: AssetImage('assets/images/avatar.png')
                                  ),
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.black
                                  )
                              ),
                            ),
                            const SizedBox(width: 15.0),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => const AuthScreen()));
                              },
                              child: WidgetText(text: 'auth'.tr, font: 'montserrat_bold', size: 18),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const AuthScreen()));
                          },
                          child: Row(
                            children: const [
                              Icon(Icons.login_outlined),
                              SizedBox(width: 15.0),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20.0),

                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetText(text: 'auth_text'.tr, font: 'monsterrat_regular', size: 15),
                        const SizedBox(height: 40.0),
                        WidgetText(text: 'settings'.tr, size: 18, font: 'montserrat_bold')
                      ],
                    ),
                  ),

                  Obx(() =>
                      SwitchListTile(
                          value: settingsController.isDarkMode.value,
                          activeColor: Colors.black,
                          secondary: settingsController.isDarkMode.value ?
                          const Icon(Icons.dark_mode_outlined, size: 30) :
                          const Icon(Icons.light_mode_outlined, size: 30),
                          title: WidgetText(text:'dark'.tr),
                          onChanged: (val){
                            settingsController.isDarkMode.value = val;
                            if(val){
                              Get.changeTheme(darkTheme);
                              storage.write('isDarkMode', settingsController.isDarkMode.value);
                            }
                            else{
                              Get.changeTheme(lightTheme);
                              storage.write('isDarkMode', settingsController.isDarkMode.value);
                            }
                          }
                      ),
                  ),

                  ListTile(
                    leading: const Icon(Icons.translate_outlined, size: 30),
                    title: WidgetText(text: 'language'.tr),
                    onTap: (){
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return customDialog(context);
                        },
                      );
                    },
                  ),

                  Obx(() =>
                      SwitchListTile(
                          value: settingsController.isLocation.value,
                          activeColor: Colors.black,
                          secondary: settingsController.isLocation.value ?
                          const Icon(Icons.location_on_outlined, size: 30) :
                          const Icon(Icons.location_off_outlined, size: 30),
                          title: WidgetText(text:'location'.tr),
                          onChanged: (val){
                            settingsController.isLocation.value = val;
                            if(val){
                              storage.write('isLocation', settingsController.isLocation.value);
                            }
                            else{
                              storage.write('isLocation', settingsController.isLocation.value);
                            }
                          }
                      ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: WidgetText(text: 'support'.tr, size: 18, font: 'montserrat_bold',),
                  ),

                  ListTile(
                    leading: const Icon(Icons.announcement_outlined, size: 30),
                    title: WidgetText(text: 'customer'.tr),
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const LiveChat()));
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.help_outline_outlined, size: 30),
                    title: WidgetText(text: 'faq'.tr),
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const FaqScreen()));
                    },
                  ),


                  ListTile(
                    leading: const Icon(Icons.policy_outlined, size: 30),
                    title: WidgetText(text: 'policies'.tr),
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const PolicyScreen()));
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.share_outlined, size: 30),
                    title: WidgetText(text: 'share'.tr),
                    onTap: (){
                      showShareOption(context);
                    },
                  ),

                  const SizedBox(height: 30.0)


                ],
              ),
            )
          )
      ),
    );
  }

  Widget customDialog(BuildContext context){

    return AlertDialog(
      title: WidgetText(text: 'language'.tr, font: 'montserrat_bold'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          ListTile(
            title: WidgetText(text: 'english'.tr),
            onTap: (){
              var locale = const Locale('en', 'US');
              Get.updateLocale(locale);
              storage.write('lang', 'english');
              Navigator.pop(context);
            },
          ),

          ListTile(
            title: WidgetText(text: 'french'.tr),
            onTap: (){
              var locale = const Locale('fr', 'FR');
              Get.updateLocale(locale);
              storage.write('lang', 'french');
              Navigator.pop(context);
            },
          ),

          ListTile(
            title: WidgetText(text: 'spanish'.tr),
            onTap: (){
              var locale = const Locale('es', 'ES');
              Get.updateLocale(locale);
              storage.write('lang', 'spanish');
              Navigator.pop(context);
            },
          ),



        ],
      ),
    );
  }

  showBottomSheetNow(BuildContext context, IconData iconData, String name){
  showModalBottomSheet(
      context: context,
      isScrollControlled:true,
      isDismissible: true,
      builder: (_) {
        return LayoutBuilder(
            builder: (context, _) { //<----- very important use this context
              return AnimatedPadding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                    constraints: const BoxConstraints(
                        maxHeight: 500,
                        minHeight: 150
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        WidgetText(text: 'Edit $name'),
                        const SizedBox(height: 30.0),
                        Form(
                            key: formKey,
                            child: TextFormField(
                              validator: (val){
                                if(val == '' || val!.isEmpty){
                                  return 'Enter $name';
                                }
                                else if(val.length < 3){
                                  return '$name too short';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter $name',
                                prefixIcon: Icon(iconData, color: Colors.grey),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.black
                                    )
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                            )
                        ),
                        const SizedBox(height: 60.0),
                        GestureDetector(
                          onTap: (){
                            if(formKey.currentState!.validate()) {

                            }
                            return;
                          },
                          child: Container(
                              height: 35,
                              width: 120,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border:  Border.all(
                                      width: 2,
                                      color: Colors.black
                                  )
                              ),
                              child: const Center(
                                child: WidgetText(text: 'Update', size: 16),
                              )
                          ),
                        )
                      ],
                    ),
                  )
              );
            }
        );
      }
    );
  }

  showShareOption(BuildContext context) async{
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(
      'Hello',
      subject: 'I found Golden237Ecommerce app handy for my shopping, get it on playstore on htpps://www.golden237.io',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

}

