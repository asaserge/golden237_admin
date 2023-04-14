import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:golden237_client/widgets/widget_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../controllers/auth_controller.dart';
import '../main.dart';
import '../utils/apis.dart';
import '../utils/messages.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  final AuthController authController = Get.find();
  final dateFormatter = DateFormat('dd-MM-yyyy');
  late TextEditingController _usernameController = TextEditingController();
  late TextEditingController _phoneController = TextEditingController();
  late TextEditingController _addressController = TextEditingController();
  late TextEditingController _emailController = TextEditingController();
  final formKeyProfile = GlobalKey<FormState>();
  bool _isClicked = false;
  File? imageFile;

  @override
  void initState() {
    _usernameController = TextEditingController(text: authController.userName.value);
    _phoneController = TextEditingController(text: authController.userPhone.value);
    _addressController = TextEditingController(text: authController.userAddress.value);
    _emailController = TextEditingController(text: authController.userEmail.value);
    //_avatarUrl = authController.userAvatar.value;
    authController.getProfile();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey.withOpacity(0.2),
          title: WidgetText(text: 'my_profile'.tr),
          actions: [
            GestureDetector(
              onTap: (){
                signOut();
              },
              child: Row(
                children: const [
                  Icon(Icons.logout_outlined)
                ],
              ),
            ),
            const SizedBox(width: 45.0)
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: size.height / 3.5,
                  width: size.width,
                  padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(50.0),
                        bottomRight : Radius.circular(50.0),
                      )
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          _pickImageFromGallery();
                        },
                        child: imageFile == null ?
                        CachedNetworkImage(
                          imageUrl: authController.userAvatar.value == '' ?
                          'https://www.pngegg.com/en/png-zxkcc' : authController.userAvatar.value,
                          imageBuilder: (context, imageProvider) => Container(
                            height: Get.height / 5.7,
                            width: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.contain),
                            ),
                          ),
                          placeholder: (context, url) => spinkit,
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ) :
                        Container(
                          height: Get.height / 5.5,
                          width: 180,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.file(imageFile!, fit: BoxFit.cover),
                        ),
                      ),

                      const SizedBox(height: 8.0),
                      WidgetText(text: authController.userName.value, font: 'montserrat_bold', size: 22),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          WidgetText(text: '${'join_on'.tr} ${dateFormatter.format(DateTime.parse(
                              '${Apis.client.auth.currentUser?.createdAt}'))}', font: 'montserrat_light', size: 10),
                          Visibility(
                              visible: authController.userUpdate.value != '',
                              child: WidgetText(text: '${'updated_on'.tr} ${dateFormatter.format(DateTime.parse(
                                  '${Apis.client.auth.currentUser?.createdAt}'))}', font: 'montserrat_light', size: 10))
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 60.0),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Form(
                    key: formKeyProfile,
                    child: Column(
                      children: [
                        Obx(() => authController.userName.value == '' ?
                          const SizedBox.shrink() :
                          TextFormField(
                            cursorColor: Colors.black,
                            controller: _usernameController,
                            maxLength: 25,
                            style: const TextStyle(fontFamily: 'montserrat_medium'),
                            onChanged: (str){
                              authController.userName.value = str;
                            },
                            validator: (val){
                              if(val!.isEmpty){
                                return 'required'.tr;
                              }
                              else if(val.length < 4){
                                return 'short'.tr;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                counterText: '',
                                prefixIcon: Icon(Icons.person_outline,
                                    color: Get.isDarkMode ? Colors.white : Colors.black54),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none
                                )
                            ),
                          )
                        ),

                        TextFormField(
                          cursorColor: Colors.black,
                          controller: _emailController,
                          enabled: false,
                          style: const TextStyle(fontFamily: 'montserrat_medium'),
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email_outlined,
                                  color: Get.isDarkMode ? Colors.white : Colors.black54),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none
                              )
                          ),
                        ),

                        Obx(() => authController.userPhone.value == '' ?
                          TextFormField(
                            cursorColor: Colors.black,
                            controller: _phoneController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontFamily: 'montserrat_medium'),
                            maxLength: 9,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone,
                                    color: Get.isDarkMode ? Colors.white : Colors.black54),
                                prefixText: '+237 ',
                                counterText: '',
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none
                                )
                            ),
                          ) :
                          TextFormField(
                            cursorColor: Colors.black,
                            controller: _phoneController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontFamily: 'montserrat_medium'),
                            maxLength: 9,
                            onChanged: (str){
                              authController.userPhone.value = str;
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone,
                                    color: Get.isDarkMode ? Colors.white : Colors.black54),
                                prefixText: '+237 ',
                                counterText: '',
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none
                                )
                            ),
                          )
                        ),

                        Obx(() => authController.userAddress.value == '' ?
                          TextFormField(
                            cursorColor: Colors.black,
                            controller: _addressController,
                            maxLength: 30,
                            style: const TextStyle(fontFamily: 'montserrat_medium'),
                            onChanged: (str){
                              authController.userAddress.value = str;
                            },
                            decoration: InputDecoration(
                                counterText: '',
                                prefixIcon: Icon(Icons.location_on_outlined,
                                    color: Get.isDarkMode ? Colors.white : Colors.black54),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none
                                )
                            ),
                          ) :
                          TextFormField(
                            cursorColor: Colors.black,
                            controller: _addressController,
                            maxLength: 30,
                            style: const TextStyle(fontFamily: 'montserrat_medium'),
                            decoration: InputDecoration(
                                counterText: '',
                                prefixIcon: Icon(Icons.location_on_outlined,
                                    color: Get.isDarkMode ? Colors.white : Colors.black54),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none
                                )
                            ),
                          )
                        ),

                        Obx(() => ListTile(
                          leading: const Icon(Icons.male_outlined),
                          minLeadingWidth: -5.0,
                          title: WidgetText(text: authController.userSex.value),
                          onTap: (){
                            showSelectSex(context);
                          },
                        )),

                        Obx(() => ListTile(
                          leading: const Icon(Icons.cake_outlined),
                          minLeadingWidth: -5.0,
                          title: WidgetText(text: authController.userBirth.value),
                          onTap: (){
                            pickDateDialog();
                          },
                        ))
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 50.0),

                GestureDetector(
                  onTap: (){
                    if(formKeyProfile.currentState!.validate()){
                      updateProfile();
                    }
                    return;
                  },
                  child: Obx(() => Container(
                      height: 40,
                      width: 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border:  Border.all(
                              width: 2,
                              color: Get.isDarkMode ? Colors.white : Colors.black
                          )
                      ),
                      child: authController.isLoading.value ?
                        spinkit :
                        Center(
                          child: WidgetText(text: 'update'.tr, size: 18),
                        )
                  )),
                ),

                const SizedBox(height: 200)

              ],
            )
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final pickedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          imageFile = File(pickedImage.path);
        });
      }
    } catch (error) {
      if (mounted) {
        Get.snackbar('Oops!', error.toString(),
            borderRadius: 0, backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  Future<void> updateProfile() async {
    authController.isLoading(true);
    if(imageFile != null){
      try {
        final userId = Apis.client.auth.currentUser!.id;
        await Apis.client.from('profiles').upsert({
          'id': userId,
          'avatar_url': imageFile,
        });
      } on PostgrestException catch (error) {
        Get.snackbar('Oops!', error.message,
            borderRadius: 0, backgroundColor: Colors.red, colorText: Colors.white);
      } catch (error) {
        Get.snackbar('Oops!', 'Unexpected error has occurred',
            borderRadius: 0, backgroundColor: Colors.red, colorText: Colors.white);
      }
    }

    final username = _usernameController.text;
    final address = _addressController.text;
    final phone = _phoneController.text;
    final sex = authController.userSex.value;
    final birth = authController.userBirth.value;
    final userId = Apis.client.auth.currentUser!.id;
    final data = {
      'id': userId,
      'name': username,
      'phone': phone,
      'address': address,
      'sex': sex,
      'updated_at':  dateFormatter.format(DateTime.now()),
      'anniversary': birth
    };
    try {
      await Apis.client.from('profiles').upsert(data);
      if (mounted) {
        Get.snackbar('Success!', 'Successfully updated profile!',
            borderRadius: 0, backgroundColor: Colors.black, colorText: Colors.white);
      }
    } on PostgrestException catch (error) {
      Get.snackbar('Oops!', error.message,
          borderRadius: 0, backgroundColor: Colors.red, colorText: Colors.white);
    } catch (error) {
      Get.snackbar('Oops!', 'Unexpected exception occurred',
          borderRadius: 0, backgroundColor: Colors.red, colorText: Colors.white);
    }
    authController.isLoading(false);
  }

  Future<void> signOut() async {
    try {
      await Apis.client.auth.signOut();
    } on AuthException catch (error) {
      Get.snackbar('Oops!', error.message,
          borderRadius: 0, backgroundColor: Colors.red, colorText: Colors.white);
    } catch (error) {
      Get.snackbar('Oops!', 'Unexpected exception occurred',
          borderRadius: 0, backgroundColor: Colors.red, colorText: Colors.white);
    }
    if (mounted) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const SplashScreen()));
    }
  }

  showSelectSex(BuildContext context){
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
                          WidgetText(text: 'choose_sex'.tr, font: 'montserrat_bold'),
                          const SizedBox(height: 20.0),
                          TextButton(
                            onPressed: (){
                              authController.userSex.value = 'male'.tr;
                              Navigator.of(context).pop();
                            },
                            child: WidgetText(text: 'male'.tr, color: Get.isDarkMode ? Colors.white : Colors.black),
                          ),
                          TextButton(
                            onPressed: (){
                              authController.userSex.value = 'female'.tr;
                              Navigator.of(context).pop();
                            },
                            child: WidgetText(text: 'female'.tr, color: Get.isDarkMode ? Colors.white : Colors.black),
                          ),
                          TextButton(
                            onPressed: (){
                              authController.userSex.value = 'no_say'.tr;
                              Navigator.of(context).pop();
                            },
                            child: WidgetText(text: 'I\'d rather not say', color: Get.isDarkMode ? Colors.white : Colors.black),
                          ),
                          const SizedBox(height: 20.0),
                        ],
                      ),
                    )
                );
              }
          );
        });
  }

  void pickDateDialog() {
    showDatePicker(
        context: context,
        initialDate: DateTime(1998),
        firstDate: DateTime(1950),
        lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      authController.userBirth.value = dateFormatter.format(pickedDate);
    });
  }

}