import 'package:flutter/widgets.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/apis.dart';

class ProductController extends GetxController{

  RxInt prodCount = 0.obs;
  RxInt allProdCount = 0.obs;
  RxInt couponCount = 0.obs;
  RxInt orderCount = 0.obs;
  RxInt userCount = 0.obs;

  //To persist the cart state manager`
  @override
  void onInit() {
    super.onInit();
    fetchProductTableCount();
    fetchOrderTableCount();
    fetchCouponTableCount();
    fetchUserTableCount();
  }

  getProductAsc() async{
    return await Apis.client
        .from('product')
        .select().order('name', ascending: true);
  }

  getProductDes() async{
    return await Apis.client
        .from('product')
        .select().order('name', ascending: false);
  }

  getProductLH() async{
    return await Apis.client
        .from('product')
        .select().order('price', ascending: true);
  }

  getProductHL() async{
    return await Apis.client
        .from('product')
        .select().order('price', ascending: false);
  }

  getProductByRecent() async{
    return await Apis.client
        .from('product')
        .select().order('created_at', ascending: true);
  }

  getProductByPast() async{
    return await Apis.client
        .from('product')
        .select().order('created_at', ascending: false);
  }

  getOrders() async{
    return await Apis.client
        .from('order')
        .select().order('name', ascending: true);
  }

  getCategorisedProducts(String id) async{
    return await Apis.client
        .from('product')
        .select('*')
        .eq('category,', id);
  }

  fetchProductTableCount() async{
    final res = await Apis.client.from('product')
        .select('*', const FetchOptions(count: CountOption.exact) );
    allProdCount.value = res.count;
    prodCount.value = res.count;
  }

  fetchOrderTableCount() async{
    final res = await Apis.client.from('order')
        .select('*', const FetchOptions(count: CountOption.exact) );
    orderCount.value = res.count;
  }

  fetchCouponTableCount() async{
    final res = await Apis.client.from('coupon')
        .select('*', const FetchOptions(count: CountOption.exact) );
    couponCount.value = res.count;
  }

  fetchUserTableCount() async{
    final res = await Apis.client.from('profiles')
        .select('*', const FetchOptions(count: CountOption.exact) );
    userCount.value = res.count;
  }

  prodRefLatest() async {

  }

  prodRefOldest() async {

  }

  prodRefAscending() async {

  }

  prodRefDescending() async {

  }

  subCategoryData() async {

  }


  Future<void> getCouponCount() async {

  }

  Future<void> getOrdersCount() async {

  }

}