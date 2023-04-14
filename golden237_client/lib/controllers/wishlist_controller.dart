import 'dart:ui';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/wishlist_model.dart';
import '../utils/apis.dart';

class WishlistController extends GetxController{

  final storage = GetStorage();
  RxBool isFav = false.obs;
  RxBool isLoading = false.obs;
  var wishlistProduct = [].obs;

  @override
  void onInit() {
    startRealTime();
    if(Apis.client.auth.currentUser != null){
      getAllWishProducts();
    }
    super.onInit();
  }

  startRealTime(){
    Apis.client.channel('*').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(event: '*', schema: 'public'),
          (payload, [ref]) {
        getAllWishProducts();
        print('\n\n\nWishlist Change received: ${payload.toString()}');
      },
    ).subscribe();
  }


  getAllWishProducts() async {
    try{
      isLoading(true);
      final response = await Apis
          .client
          .from('wishlist')
          .select('*, product(*)')
          .eq('profiles', Apis.client.auth.currentUser!.id)
          .order('created_at', ascending: false);
      if(response != null){
        wishlistProduct.value = response;
        update();
        return response;
      }
    } finally {
      isLoading(false);
    }
  }

  removeWishlistProduct(String prodId) async{
    try{
      isLoading(true);
      await Apis
        .client
        .from('wishlist')
        .delete()
        .eq('product', prodId);
      Get.snackbar('Success!', 'Removed from wishlist successfully!',
          borderRadius: 0, backgroundColor: Colors.black, colorText: Colors.white);
    } catch (error){
      Get.snackbar('Oops!', error.toString(),
          borderRadius: 0, backgroundColor: Colors.red, colorText: Colors.white);
    }
    finally {
      isLoading(false);
    }
  }

  addWishlistProduct(String prodId) async{
    try{
      isLoading(true);
      await Apis
        .client
        .from('wishlist')
        .insert({
          'product': prodId,
          'profiles': Apis.client.auth.currentUser!.id,
        });
      Get.snackbar('Success!', 'Added to wishlist successfully!',
          borderRadius: 0, backgroundColor: Colors.black, colorText: Colors.white);
      } catch (error){
        Get.snackbar('Oops!', error.toString(),
            borderRadius: 0, backgroundColor: Colors.red, colorText: Colors.white);
        }
      finally {
        isLoading(false);
      }
  }

}