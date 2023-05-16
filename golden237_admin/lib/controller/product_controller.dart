import 'package:flutter/widgets.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/apis.dart';

class ProductController extends GetxController{

  RxBool isLoading = false.obs;
  var productList = [].obs;
  var productRecent = [].obs;
  var productListCheap = [].obs;
  RxInt allCatProdCount = 0.obs;

  RxString searchWord = ''.obs;

  //To persist the cart state manager`
  @override
  void onInit() {
    super.onInit();
    getAllProduct();
    getProductByLatest();
    getProductByPrice();

  }

  getAllProduct() async {
    try{
      isLoading(true);
      final res = await Apis
          .client
          .from('product')
          .select('*, category(*)');
      if(res != null){
        productList.value = res;
      }
    } finally {
      isLoading(false);
    }
  }

  getProductByLatest() async {
    try{
      isLoading(true);
      final res = await Apis
          .client
          .from('product')
          .select('*, category(*)')
          .order('created_at', ascending: false);
      if(res != null){
        productRecent.value = res;
      }
    } finally {
      isLoading(false);
    }
  }

  getProductByPrice() async {
    try{
      isLoading(true);
      final res = await Apis
          .client
          .from('product')
          .select('*, category(*)')
          .order('price', ascending: true);
      if(res != null){
        productListCheap.value = res;
      }
    } finally {
      isLoading(false);
    }
  }

  getProductSearch() async{
    final res = await Apis.client
        .from('product')
        .select('*, category(*)')
        ..textSearch('description', "'${searchWord.value}'");
    return res;
  }

  getOrders() async{
    return await Apis.client
        .from('order')
        .select().order('name', ascending: true);
  }

  getCategorisedProducts(String id) async{
    return await Apis.client
        .from('product')
        .select('*, category(*)')
        .eq('category,', id);
  }

}