import 'package:flutter/foundation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:golden237_admin/services/apis.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryController extends GetxController {

  RxInt catCount = 0.obs;
  RxInt allCatCount = 0.obs;
  RxInt subCatCount = 0.obs;
  final category = [].obs;

  @override
  void onInit() {
    super.onInit();
    getMainCategory();
    getSubCategory();
    fetchCategoryTableCount();
    fetchSubCategoryTableCount();
  }

  getMainCategory() async{
    final res = await Apis.client.from('category')
        .select().order('name', ascending: false);
    category.value = res;
    return res;
  }

  getSubCategory() async{
    return await Apis.client
        .from('subcategory')
        .select().order('name', ascending: true);
  }

  getSpecificSubCategory(String id) async{
    return await Apis.client
        .from('subcategory')
        .select('*')
        .eq('main_category,', id);
  }

  fetchCategoryTableCount() async{
    final res = await Apis.client.from('category')
        .select('*', const FetchOptions(count: CountOption.exact) );
    catCount.value = res.count;
  }

  fetchSubCategoryTableCount() async{
    final res = await Apis.client.from('subcategory')
        .select('*', const FetchOptions(count: CountOption.exact) );
    allCatCount.value = res.count;
  }


}