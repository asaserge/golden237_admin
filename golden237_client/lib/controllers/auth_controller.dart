import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


import '../utils/apis.dart';

class AuthController extends GetxController {

  RxBool isUserLoggedIn = false.obs;
  RxBool isLoading = false.obs;
  RxBool isLoading1 = false.obs;
  RxBool isLoading2 = false.obs;
  RxBool isLoadingAvatar = false.obs;
  RxBool isEdited = false.obs;
  RxString userName = ''.obs;
  RxString userEmail = ''.obs;
  RxString userAvatar = ''.obs;
  RxString userPhone = ''.obs;
  RxString userAddress = ''.obs;
  RxString userSex = ''.obs;
  RxString userBirth = ''.obs;
  RxString userUpdate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkUserAuthState();
    getProfile();
  }

  logoutUser() async{
    await Apis.client.auth.signOut();
  }

  Future<void> getProfile() async {
    isLoading(true);
    try {
      final userId = Apis.client.auth.currentUser!.id;
      final data = await Apis.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single() as Map;
      userName.value = data['name'] ?? 'not_set'.tr;
      userEmail.value = data['email'];
      userAvatar.value = data['avatar_url'] ?? '';
      userPhone.value = data['phone'] ?? 'not_set'.tr;
      userAddress.value = data['address'] ?? 'not_set'.tr;
      userSex.value = data['sex'] ?? 'not_set'.tr;
      userBirth.value = data['anniversary'] ?? 'not_set'.tr;
      userUpdate.value = data['updated_at'] ?? '';
    } on PostgrestException catch (error) {
      Get.snackbar('Oops!', error.message,
          borderRadius: 0, backgroundColor: Colors.red, colorText: Colors.white);
    } catch (error) {
      Get.snackbar('Oops!', 'Unexpected exception occurred',
          borderRadius: 0, backgroundColor: Colors.red, colorText: Colors.white);
    }
    isLoading(false);
  }

  checkUserAuthState() {
    isUserLoggedIn.value = Apis.client.auth.currentUser == null ? false : true;
  }

}