import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/apis.dart';

class OrderController extends GetxController{
  final storage = GetStorage();
  RxInt counter = 0.obs;
  RxInt orderCount = 0.obs;
  RxInt deliverCount = 0.obs;

  @override
  void onReady() {
    counter = storage.read('counter') ?? 0.obs;
    super.onReady();
  }

  @override
  void onInit() {
    super.onInit();
    getAllOrders();
    fetchOrderTableCount();
    fetchDeliveredOrderCount();
  }

  fetchOrderTableCount() async{
    final res = await Apis.client
        .from('order')
        .select('*', const FetchOptions(count: CountOption.exact))
        .neq('status', 'Delivered');
    orderCount.value = res.count;
  }

  fetchDeliveredOrderCount() async{
    final res = await Apis.client
        .from('order')
        .select('*', const FetchOptions(count: CountOption.exact))
        .eq('status', 'Delivered');
    deliverCount.value = res.count;
  }

  getAllOrders() async{
    final res = await Apis.client
        .from('order')
        .select('*, product(*), profiles(*)')
        .neq('status', 'Delivered')
        .order('created_at', ascending: true);
    return res;
  }

  getDeliveredOrders() async{
    final res = await Apis.client
        .from('order')
        .select('*, product(*), profiles(*)')
        .eq('status', 'Delivered')
        .order('created_at', ascending: true);
    return res;
  }

  deleteOrders(String id) async{
    final res = await Apis.client
        .from('order')
        .delete()
        .eq('id', id);
    return res;
  }

  updateOrderStatus(String id, String status) async{
    final res = await Apis.client
        .from('order')
        .update({'status': status})
        .eq('id', id);
    return res;
  }


  //////////////////////////////////////////////////////////////////////

  getCoupons() async{
    final res = await Apis.client
        .from('coupon')
        .select()
        .order('created_at', ascending: true);
    return res;
  }

  deleteCouponMethod(String id) async{
    await Apis.client
        .from('coupon')
        .delete()
        .eq('id', id);
  }

  updateCouponMethod({required String id, required String start, required String end,
    required String code, required String image, required String percent}) async{
    final res = await Apis.client
        .from('coupon')
        .update({
        'code': code,
        'start': start,
        'end': end,
        'percent': percent,
        'image': image,
         })
        .eq('id', id);
    return res;
  }

  createCouponMethod({required String id, required String start, required String end,
    required String code, required String image, required String percent}) async{
    final res = await Apis.client
        .from('coupon')
        .insert({
        'code': code,
        'start': start,
        'end': end,
        'percent': percent,
        'image': image,
        });
    return res;
  }

}