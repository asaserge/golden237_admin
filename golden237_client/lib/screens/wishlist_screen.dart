import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:golden237_client/screens/product_detail.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../controllers/auth_controller.dart';
import '../controllers/wishlist_controller.dart';
import '../controllers/product_controller.dart';
import '../widgets/widget_text.dart';
import 'auth_screen.dart';

class WishlistScreen extends StatelessWidget {
  WishlistScreen({Key? key}) : super(key: key);

  final storage = GetStorage();
  AuthController authController = Get.find();
  WishlistController wishlistController = Get.find();
  final ProductController productController = Get.find();
  final currencyFormatter = NumberFormat('#,###');
  final dateFormatter = DateFormat('dd/MM/yyyy hh:mm a');

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const WidgetText(text: 'Your Wishlist', font: 'montserrat_bold', size: 20),
          centerTitle: true),

        body: Obx(() => !authController.isUserLoggedIn.value ?
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/anims/user.json'),
                  const SizedBox(height: 30.0),
                  const Text('No user was found on this device!',
                    textAlign: TextAlign.center, style: TextStyle(fontFamily: 'montserrat_medium',
                        fontSize: 16),
                  ),
                  const SizedBox(height: 20.0),
                  const Text('You need to login or created an account to view wishlist items',
                    textAlign: TextAlign.center, style: TextStyle(fontFamily: 'monsterrat_regular',
                        fontSize: 11),
                  ),
                  const SizedBox(height: 50.0),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const AuthScreen()));
                    },
                    child: Container(
                        height: 40,
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            border:  Border.all(
                                width: 2,
                                color: Colors.black
                            )
                        ),
                        child: const Center(
                          child: WidgetText(text: 'Authenticate', size: 18),
                        )
                    ),
                  ),
                ],
              ),
            ) :
            wishlistController.wishlistProduct.isEmpty ?
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/icons/icons-crying.png'),
                  const SizedBox(height: 50.0),
                  const Text('You don\'t have any item in your wishlist!',
                    textAlign: TextAlign.center, style: TextStyle(fontFamily: 'montserrat_medium',
                        fontSize: 16),
                  )
                ],
              ),
            ) :
            Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 15.0),
                child: ListView.builder(
                  itemCount: wishlistController.wishlistProduct.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final duration = DateTime.parse(wishlistController.wishlistProduct[index]['created_at']);
                    return GestureDetector(
                      onTap: (){
                        var data = wishlistController.wishlistProduct;
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => ProductDetail(
                              productData: data, index: index)));
                      },
                      child: Container(
                        height: size.height / 6.2,
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9.0),
                            color: Colors.grey.withOpacity(0.2)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: size.height / 6,
                                  width: size.width / 4,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(wishlistController.wishlistProduct[index]['product']['image']),
                                          fit: BoxFit.cover)),
                                ),
                                const SizedBox(width: 12.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    WidgetText(text: wishlistController.wishlistProduct[index]['product']['name'], size: 15),
                                    WidgetText(
                                        text: 'XAF ${currencyFormatter.format(wishlistController.wishlistProduct[index]['product']['price'])}'),
                                    //const SizedBox(height: 7),
                                    Row(
                                      children: [
                                        WidgetText(text: wishlistController.wishlistProduct[index]['product']['sku'], size: 12),
                                        const SizedBox(width: 5),
                                        WidgetText(text:wishlistController.wishlistProduct[index]['product']['brand'], size: 12),
                                      ],
                                    ),

                                    WidgetText(text: 'Added ${getVerboseDateTimeRepresentation(duration)}',
                                        size: 10, font: 'montserrat_light'),
                                  ],
                                ),
                              ],
                            ),
                            GestureDetector(
                                onTap: (){
                                  wishlistController.removeWishlistProduct(wishlistController.wishlistProduct[index]['product']['id']);
                                  wishlistController.isFav.value = false;
                                },
                                child: const Icon(Icons.cancel_outlined)
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ))
        )

      )
    );
  }

  String getVerboseDateTimeRepresentation(DateTime dateTime) {
    DateTime now = DateTime.now().toLocal();

    DateTime localDateTime = dateTime.toLocal();

    if (localDateTime.difference(now).inDays == 0) {
      var differenceInHours = localDateTime.difference(now).inHours.abs();
      var differenceInMins = localDateTime.difference(now).inMinutes.abs();

      if (differenceInHours > 0) {
        return '$differenceInHours hours ago';
      } else if (differenceInMins > 2) {
        return '$differenceInMins mins ago';
      } else {
        return 'Just now';
      }
    }

    String roughTimeString = DateFormat('jm').format(dateTime);

    if (localDateTime.day == now.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return roughTimeString;
    }

    DateTime yesterday = now.subtract(const Duration(days: 1));

    if (localDateTime.day == yesterday.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return 'Yesterday';
    }

    if (now.difference(localDateTime).inDays < 4) {
      String weekday = DateFormat(
        'EEEE',
      ).format(localDateTime);

      return '$weekday, $roughTimeString';
    }

    return '${DateFormat('yMd').format(dateTime)}, $roughTimeString';
  }
}
