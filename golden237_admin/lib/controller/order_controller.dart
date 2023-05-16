import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/coupon_model.dart';
import '../services/apis.dart';

class OrderController extends GetxController{
  final storage = GetStorage();
  var ordersAllList = [].obs;
  var ordersDeliveredList = [].obs;
  var ordersUndeliveredList = [].obs;
  var couponList = [].obs;
  RxBool isLoading = false.obs;

  RxInt counter = 0.obs;
  RxInt orderCount = 0.obs;
  RxInt deliverCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getAllOrders();
    getDeliveredOrders();
    getUndeliveredOrders();
    getAllCoupons();
  }

  getAllOrders() async{
    try{
      isLoading(true);
      final res = await Apis.client
          .from('order')
          .select('*, product(*), profiles(*)')
          .order('created_at', ascending: true);
      if(res != null){
        ordersAllList.value = res;
      }
    } finally {
      isLoading(false);
    }
  }

  getUndeliveredOrders() async{
    try{
      isLoading(true);
      final res = await Apis.client
          .from('order')
          .select('*, product(*), profiles(*)')
          .neq('status', 'Delivered')
          .order('created_at', ascending: true);
      if(res != null){
        ordersUndeliveredList.value = res;
      }
    } finally {
      isLoading(false);
    }
  }

  getDeliveredOrders() async{
    try{
      isLoading(true);
      final res = await Apis.client
          .from('order')
          .select('*, product(*), profiles(*)')
          .eq('status', 'Delivered')
          .order('created_at', ascending: true);
      if(res != null){
        ordersDeliveredList.value = res;
      }
    } finally {
      isLoading(false);
    }
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

  getAllCoupons() async{
    try{
      isLoading(true);
      final res = await Apis.client
          .from('coupon')
          .select()
          .order('created_at', ascending: true);
      if(res != null){
        couponList.value = res;
      }
    } finally {
      isLoading(false);
    }
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

  createCouponMethod({required CouponModel coupon}) async{
    try{
      isLoading(true);
      await Apis.client
          .from('coupon')
          .insert({
        'code': coupon.code,
        'start': coupon.start.toISOString(),
        'end': coupon.end.toISOString(),
        'percent': coupon.percent,
      });
      isLoading(false);
      Get.back();

    } catch(error){
      isLoading(false);
      Get.snackbar('Error!', error.toString(),
          backgroundColor: Colors.red, colorText: Colors.white, borderRadius: 5);
    }
  }

}