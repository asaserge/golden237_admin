import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:golden237_admin/services/apis.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';


class CategoryController extends GetxController {

  RxBool isLoading = false.obs;
  var mainCategoriesList = [].obs;
  var subCategoriesList = [].obs;
  RxInt allCatCount = 0.obs;
  RxInt subCatCount = 0.obs;
  final category = [].obs;

  @override
  void onInit() {
    super.onInit();
    getMainCategory();
    getSubCategory();
  }


  getMainCategory() async{
    try{
      isLoading(true);
      final res = await Apis
          .client
          .from('category')
          .select()
          .order('name', ascending: false);
      if(res != null){
        mainCategoriesList.value = res;
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

  getSubCategory() async{
    try{
      isLoading(true);
      final res = await Apis
          .client
          .from('subcategory')
          .select('*, main_category(*)')
          .order('name', ascending: false);
      if(res != null){
        subCategoriesList.value = res;
      }
    } finally {
      isLoading(false);
    }
  }

  getSpecificSubCategory(String id) async{
    return await Apis.client
        .from('subcategory')
        .select('*')
        .eq('main_category,', id);
  }

  fetchSubCategoryTableCount() async{
    final res = await Apis.client.from('subcategory')
        .select('*', const FetchOptions(count: CountOption.exact) );
    allCatCount.value = res.count;
  }


}