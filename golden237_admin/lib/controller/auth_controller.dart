import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../services/apis.dart';

class AuthController extends GetxController{

  var userList = [].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAllUsers();
  }
  getAllUsers() async{
    try{
      isLoading(true);
      final res = await Apis
          .client
          .from('profiles')
          .select()
          .order('created_at', ascending: false);
      if(res != null){
        userList.value = res;
      }
    } catch(error){
      Get.snackbar('Oops!', error.toString(),
          borderRadius: 5, backgroundColor: Colors.red,
          colorText: Colors.white);
    }
    finally {
      isLoading(false);
    }
  }


}