
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:badges/badges.dart' as badges;

import '../controllers/auth_controller.dart';
import '../controllers/cart_controller.dart';
import '../models/cart_model.dart';
import '../utils/apis.dart';
import '../widgets/widget_text.dart';
import 'account_screen.dart';
import 'auth_screen.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  CartScreen({Key? key}) : super(key: key);

  final CartController _cartController = Get.find();
  final AuthController authController = Get.find();
  final user = Apis.client.auth.currentUser;
  final formatter = NumberFormat('#,###');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Obx(() => _cartController.products.length == 0
            ? Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  badges.Badge(
                      position: badges.BadgePosition.topEnd(top: -15, end: -12),
                      showBadge: true,
                      ignorePointer: false,
                      onTap: () {},
                      badgeAnimation: const badges.BadgeAnimation.rotation(
                        animationDuration: Duration(seconds: 1),
                        colorChangeAnimationDuration: Duration(seconds: 1),
                        loopAnimation: false,
                        curve: Curves.fastOutSlowIn,
                        colorChangeAnimationCurve: Curves.easeInCubic,
                      ),
                      badgeStyle: const badges.BadgeStyle(
                        shape: badges.BadgeShape.circle,
                        badgeColor: Colors.black,
                        padding: EdgeInsets.all(5.0),
                        borderSide: BorderSide(color: Colors.white, width: 2),
                        elevation: 2,
                      ),
                      badgeContent: Obx(() =>
                          Text('${_cartController.products.length}',
                              style: const TextStyle(color: Colors.white))),
                      child: const WidgetText(text: 'My Cart', font: 'montserrat_bold', size: 22)
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.clear, size: 25),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: size.height / 3,
              width: double.infinity,
              margin: EdgeInsets.only(top: size.height / 11, bottom: 30),
              child: Lottie.asset('assets/anims/empty-cart.json',
                  fit: BoxFit.contain
              ),
            ),

            const WidgetText(text: 'NO ITEM IN CART', font: 'montserrat_bold', size: 15)
          ],
        )
            : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 10.0, left: 15.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        badges.Badge(
                            position: badges.BadgePosition.topEnd(top: -15, end: -12),
                            showBadge: true,
                            ignorePointer: false,
                            onTap: () {},
                            badgeAnimation: const badges.BadgeAnimation.rotation(
                              animationDuration: Duration(seconds: 1),
                              colorChangeAnimationDuration: Duration(seconds: 1),
                              loopAnimation: false,
                              curve: Curves.fastOutSlowIn,
                              colorChangeAnimationCurve: Curves.easeInCubic,
                            ),
                            badgeStyle: const badges.BadgeStyle(
                              shape: badges.BadgeShape.circle,
                              badgeColor: Colors.black,
                              padding: EdgeInsets.all(5.0),
                              borderSide: BorderSide(color: Colors.white, width: 2),
                              elevation: 2,
                            ),
                            badgeContent: Obx(() =>
                                Text('${_cartController.products.length}',
                                    style: const TextStyle(color: Colors.white))),
                            child: const WidgetText(text: 'My Cart', font: 'montserrat_bold', size: 22)
                        ),

                        GestureDetector(
                          onTap: (){
                            _cartController.clearAllItems();
                          },
                          child: const Icon(Icons.delete_outline),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.clear, size: 25),
                          ),
                        )
                      ],
                    ),

                    SizedBox(
                      height: size.height / 1.5,
                      child: ListView.builder(
                        itemCount: _cartController.products.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          CartModel product = _cartController.products.keys.toList()[index];
                          return Container(
                            height: size.height / 6.2,
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9.0),
                                color: Colors.grey.withOpacity(0.2)),
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: product.productImage,
                                  imageBuilder: (context, imageProvider) => Container(
                                    height: size.height / 8,
                                    width: size.width / 4,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.contain),
                                    ),
                                  ),
                                  placeholder: (context, url) => const CircularProgressIndicator(color: Colors.black),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),

                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(child: WidgetText(text: product.productName, size: 15, maxLines: 1)),
                                    WidgetText(
                                        text: 'XAF ${formatter.format(product.productPrice)}',
                                        size: 16),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 30,
                                          width: 140,
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                onTap: (){
                                                  _cartController.removeFoodFromCart(product);
                                                },
                                                child: Container(
                                                  height: 30,
                                                  width: 35,
                                                  decoration: const BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius: BorderRadius.only(
                                                      bottomLeft: Radius.circular(10.0),
                                                      topLeft: Radius.circular(10.0),
                                                    ),
                                                  ),
                                                  child: _cartController.products.values.toList()[index] == 1 ?
                                                  const Icon(Icons.delete_outline, color: Colors.white, size: 22) :
                                                  const Icon(Icons.remove, color: Colors.white, size: 22),
                                                ),
                                              ),

                                              SizedBox(
                                                height: 40,
                                                width: 45,
                                                child: Center(child: WidgetText(text: '${_cartController.products.values.toList()[index]}', font: 'montserrat_medium', size: 25)),
                                              ),

                                              GestureDetector(
                                                onTap: (){
                                                  _cartController.addProductToCart(product);
                                                },
                                                child: Container(
                                                  height: 30,
                                                  width: 35,
                                                  decoration: const BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius: BorderRadius.only(
                                                      bottomRight: Radius.circular(10.0),
                                                      topRight: Radius.circular(10.0),
                                                    ),
                                                  ),
                                                  child: const Icon(Icons.add, color: Colors.white, size: 22),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        WidgetText(
                                          text:
                                          'XAF ${formatter.format(_cartController.products.values.toList()[index] *
                                              product.productPrice)}', size: 12,),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            )),

        bottomSheet: Obx(() => _cartController.products.length == 0
            ? const SizedBox()
            : Container(
              height: 130,
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 30.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15)
                ),
                color: Colors.black
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                WidgetText(text: 'Subtotal XAF ${formatter.format(_cartController.getProductTotal)}',
                  color: Colors.white, size: 14),
                InkWell(
                  onTap: () {
                      if (!authController.isUserLoggedIn.value) {
                        showBottomSheetNow(context);
                      }
                      else{
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const CheckoutScreen()));
                      }
                   },
                  child: Container(
                    height: 40,
                    width: 130,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border:  Border.all(
                            width: 2,
                            color: Colors.white
                        )
                    ),
                    child: const Center(
                      child: WidgetText(text: 'Checkout', font: 'montserrat_bold', size: 18, color: Colors.white,),
                    )
                ))
              ],
            ),
          )
        ));
  }

  showBottomSheetNow(BuildContext context){
    showModalBottomSheet(
        context: context,
        isScrollControlled:true,
        isDismissible: true,
        builder: (_) {
          return LayoutBuilder(
              builder: (context, _) { //<----- very important use this context
                return AnimatedPadding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOut,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                      constraints: const BoxConstraints(
                          maxHeight: 500,
                          minHeight: 150
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const WidgetText(text: 'HEADS UP!', font: 'montserrat_bold'),
                          const SizedBox(height: 20.0),
                          const WidgetText(text: 'You MUST login or create an acount before proceeding!'),
                          const SizedBox(height: 30.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                    height: 40,
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15.0),
                                        border:  Border.all(
                                            width: 2,
                                            color: Colors.black
                                        )
                                    ),
                                    child: const Center(
                                      child: WidgetText(text: 'Cancel', size: 15),
                                    )
                                ),
                              ),

                              GestureDetector(
                                onTap: (){
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const AuthScreen()));
                                },
                                child: Container(
                                    height: 40,
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(15.0),
                                      border:  Border.all(
                                          width: 2,
                                          color: Colors.white
                                      )
                                    ),
                                    child: const Center(
                                      child: WidgetText(text: 'Proceed', size: 15, color: Colors.white),
                                    )
                                ),
                              ),

                            ],
                          ),
                          const SizedBox(height: 40.0),
                        ],
                      ),
                    )
                );
              }
          );
        }
    );
  }
}
