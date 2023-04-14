import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';

import '../models/cart_model.dart';

class CartController extends GetxController{

  static CartController cartController = Get.find();
  final _products = {}.obs;
  var finalTotal = ''.obs;
  var prodCount = 0.obs;
  var prodId = ''.obs;

  final storage = GetStorage();

  //To persist the cart state manager`
  @override
  void onInit() {
    super.onInit();
    _products.value = storage.read('cart') ?? {}.obs;
    ever(
      _products,
          (value) {
        storage.write('cart', value);
      },
    );
  }

  addProductToCart(CartModel cart) {
    if(_products.containsKey(cart)){
      _products[cart] += 1;
    }
    else {
      _products[cart] = 1;
      Get.snackbar('Hurray!', '${cart.productName} has been added to cart!',
          backgroundColor: Colors.black,
          colorText: Colors.white,
          borderRadius: 0
      );
    }

  }

  removeFoodFromCart(CartModel cart){
    if(_products.containsKey(cart) && _products[cart] == 1){
      _products.removeWhere((key, value) => key == cart);
      Get.snackbar('Hurray!', '${cart.productName} has been removed from cart!',
          backgroundColor: Colors.black,
          colorText: Colors.white,
          borderRadius: 0
      );
    }
    else{
      _products[cart] -= 1;
    }
  }

  clearAllItems(){
    _products.clear();
  }

  get getProductQuantity => _products
      .entries.map((product) => product
      .value)
      .toList().reduce((value, element) => value + element);

  get getProductTotal => _products
      .entries.map((product) => product
      .key.productPrice * product
      .value)
      .toList().reduce((value, element) => value + element);

  get getDistinctProducts => _products
      .entries.map((product) => product
      .value)
      .toList().toSet().reduce((value, element) => value + element);

  get products => _products;

}