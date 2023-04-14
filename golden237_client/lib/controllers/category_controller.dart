
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/apis.dart';

class CategoryController extends GetxController{

  RxInt clickedCat = 0.obs;
  RxInt clickedSubCat = 0.obs;
  RxInt clickedColor = 0.obs;
  var currentRangeValues = const RangeValues(0, 100000).obs;
  RxString selectedColor = 'Green'.obs;
  RxString selectedCatId = ''.obs;
  RxString selectedSubCatId = ''.obs;
  RxString selectedCatName = ''.obs;
  RxString selectedSubCatName = ''.obs;
  RxBool isCatSelected = false.obs;
  RxBool isLoadingCat = true.obs;
  RxBool isLoadingSub = true.obs;
  var isStarCheck = ''.obs;

  var categoryList = [].obs;
  var subcategoryList = [].obs;
  var subcategorySubGroupList = [].obs;

  @override
  void onInit() {
    //print('\n\n\nonInit State');
    super.onInit();
    fetchAllCategories();
    fetchAllSubCategories();

  }

  final navigationKey = GlobalKey<CurvedNavigationBarState>();

  fetchAllCategories() async {
    try{
      isLoadingCat(true);
      final response = await Apis
          .client
          .from('category')
          .select()
          .order('name', ascending: true);
      if(response != null){
        categoryList.value = response;
      }
    } finally {
      isLoadingCat(false);
    }
  }

  fetchAllSubCategories() async {
    try{
      isLoadingSub(true);
      final response = await Apis
          .client
          .from('subcategory')
          .select()
          .order('name', ascending: true);
      if(response != null){
        subcategoryList.value = response;
      }
      else{
        Get.snackbar('Oops', '${response.error}',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            borderRadius: 0
        );
      }
    } finally {
      isLoadingSub(false);
    }
  }

  fetchGroupSubCategories(String id) async {
    final response = await Apis
        .client
        .from('subcategory')
        .select()
        .eq('main_category', id)
        .order('name', ascending: true);
    return response;
  }
}