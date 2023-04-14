import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:golden237_client/screens/cart_screen.dart';
import 'package:golden237_client/widgets/widget_text.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:badges/badges.dart' as badges;
import 'package:share_plus/share_plus.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/auth_controller.dart';
import '../controllers/cart_controller.dart';
import '../utils/apis.dart';
import '../utils/messages.dart';
import 'chat_screen.dart';
import 'review_screen.dart';
import '../controllers/wishlist_controller.dart';
import '../controllers/product_controller.dart';
import '../models/cart_model.dart';

class ProductDetail extends StatelessWidget {
  ProductDetail({Key? key, required this.productData,
   required this.index}) : super(key: key);
  var productData;
  final int index;

  final ProductController productController = Get.find();
  final WishlistController wishlistController = Get.find();
  final CartController cartController = Get.find();
  final AuthController authController = Get.find();
  final currencyFormatter = NumberFormat('#,###');
  final decimalFormatter = NumberFormat('#.#');
  final dateFormatter = DateFormat('dd/MM/yyyy hh:mm a');
  final storage = GetStorage();
  bool hasHadReview = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: size.height / 2, width: size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(productData[index]['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Positioned(
                  top: 35,
                  left: 15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(MdiIcons.arrowLeft, size: 25),
                          )
                        ),
                      ),

                    ],
                  ),
                ),

                Positioned(
                  top: 35,
                  right: 15,
                  child: GestureDetector(
                    onTap: (){
                      if(wishlistController.isFav.value){
                        wishlistController.removeWishlistProduct(productData[index]['id']);
                        wishlistController.isFav.value = false;
                      }
                      else{
                        wishlistController.addWishlistProduct(productData[index]['id']);
                        wishlistController.isFav.value = true;
                      }
                    },
                    child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Obx(() => Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: wishlistController.isFav.value ? const Icon(Icons.favorite_outlined) :
                            const Icon(Icons.favorite_border_outlined)
                        ))
                  )),
                ),

                Visibility(
                    visible: productData[index]['discount'] > 0 ? true : false,
                    child: Positioned(
                      bottom: 20,
                      left: 15,
                      child: Card(
                        color: Colors.red,
                        elevation: 2,
                        child: RotatedBox(
                          quarterTurns: 180,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0,
                                vertical: 8.0),
                            child: Text('${decimalFormatter.format(( productData[index]['price'] -
                                productData[index]['discount']) / productData[index]['price'] * 100)}% OFF'
                                ,style: const TextStyle(fontSize: 12.0, color: Colors.white)
                            ),
                          ),

                        ),
                      ),
                    ),
                  ),

                Positioned(
                  bottom: 20,
                  right: 10,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CartScreen()));
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Stack(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                            child: Icon(MdiIcons.basket, size: 25),
                          ),
                          Positioned(
                            bottom: -5,
                            right: -3,
                            child: badges.Badge(
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
                                  Text('${cartController.products.length}',
                                      style: const TextStyle(color: Colors.white))),

                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WidgetText(text: 'XAF ${currencyFormatter.format(
                          productData[index]['price'])}', size: 25, font: 'montserrat_bold'),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          productData[index]['is_new'] ?
                          WidgetText(text: 'new'.tr, size: 12, font: 'montserrat_light') :
                          WidgetText(text: 'used'.tr, size: 12, font: 'montserrat_light'),
                          WidgetText(text: '${productData[index]['quantity']} Piece', size: 15, font: 'montserrat_light'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WidgetText(text: 'SKU: ${productData[index]['sku']}', size: 15, font: 'monsterrat_regular'),
                      const SizedBox(width: 20.0),
                      Expanded(child: WidgetText(text: productData[index]['name'], font: 'montserrat_bold', size: 20, maxLines: 3)),
                    ],
                  ),
                  const SizedBox(height: 20.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            child: Image.network(productData[index]['category']['main_category']['image']),
                          ),
                          const SizedBox(width: 5.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WidgetText(text: 'main_category'.tr, size: 13, font: 'montserrat_medium'),
                              WidgetText(text: productData[index]['category']['main_category']['name'],
                                  size: 12, font: 'monsterrat_regular'),
                            ],
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            child: Image.network(productData[index]['category']['image']),
                          ),
                          const SizedBox(width: 5.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WidgetText(text: 'subcategory'.tr, size: 13, font: 'montserrat_medium'),
                              WidgetText(text: productData[index]['category']['name'],
                                  size: 12, font: 'monsterrat_regular'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  GestureDetector(
                    onTap: (){
                      hasHadReview = assignReviewStatus(productData[index]['id']);
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          ReviewScreen(
                            productId: productData[index]['id'],
                            productName: productData[index]['name'],
                            hasReview: hasHadReview,

                          ))
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Obx(() => SmoothStarRating(
                              onRatingChanged: (v) {
                              },
                              starCount: 5,
                              rating: productController.starSum.value,
                              size: 22.0,
                              color: Colors.black,
                              borderColor: Colors.black,
                              spacing: 0.0
                            )),
                            const SizedBox(width: 10.0),
                            Obx(() => WidgetText(text: '${productController.starSum.value} / 5', size: 14))
                          ],
                        ),
                        Obx(() => WidgetText(text: '${productController.userCount.value} ${'users'.tr}', size: 14))
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [

                     GestureDetector(
                       onTap: (){
                         ScaffoldMessenger.of(context).clearSnackBars();
                         CartModel product = CartModel(
                             productId: productData[index]['id'],
                             productName: productData[index]['name'],
                             productPrice: productData[index]['price'],
                             productBrand: productData[index]['brand'],
                             productImage: productData[index]['image']
                         );
                         cartController.addProductToCart(product);
                       },
                       child: Container(
                           height: 40,
                           width: size.width / 1.5,
                           margin: const EdgeInsets.only(top: 20.0),
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(15.0),
                               border:  Border.all(
                                   width: 2,
                                   color: Colors.black
                               )
                           ),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: const [
                               Icon(Icons.shopping_cart),
                               SizedBox(width: 15.0),
                               WidgetText(text: 'Add To Card', font: 'montserrat_bold', size: 18),
                             ],
                           ),
                       ),
                     )
                   ],
                 ),
                  const SizedBox(height: 35),

                  WidgetText(text: productData[index]['description'], maxLines: 100),
                  const SizedBox(height: 40.0),
                  const Divider(thickness: 2),
                  WidgetText(text: productData[index]['category']['name'], size: 18),
                  WidgetText(text: productData[index]['category']['detail'], size: 14),

                  const SizedBox(height: 8.0),
                  const Divider(thickness: 2),
                  WidgetText(text: productData[index]['category']['main_category']['name'], size: 18),
                  WidgetText(text: productData[index]['category']['main_category']['detail'], size: 14),

                  const SizedBox(height: 8.0),
                  const Divider(thickness: 2),
                  const SizedBox(height: 8.0),
                  WidgetText(text: 'Product Size/Weight: ${productData[index]['size']}', size: 14),

                  const SizedBox(height: 55),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const LiveChat()));
                        },
                        child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 13.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                border:  Border.all(
                                    width: 2,
                                    color: Colors.black
                                )
                            ),
                            child: const Center(
                              child: WidgetText(text: 'Contact Support', size: 15),
                            )
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          shareProductOption(context);
                        },
                        child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 13.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                border:  Border.all(
                                    width: 2,
                                    color: Colors.black
                                )
                            ),
                            child: const Center(
                              child: WidgetText(text: 'Share Product', size: 15),
                            )
                        ),
                      ),

                    ],
                  ),

                  const SizedBox(height: 55),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  assignReviewStatus(String prod) async{
    final res = await Apis.client
        .rpc('get_user_ratings', params: { 'prod_id': prod})
        .single();
    return res ?? false;

  }

  shareProductOption(BuildContext context) async{
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(
      'I found ${productData[index]['name']} Golden237Ecommerce app, get it on playstore on htpps://www.golden237.io',
      subject: 'Hey there!',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  Future<void> launchPhoneDialer(String contactNumber) async {
    final Uri phoneUri = Uri(
        scheme: "tel",
        path: contactNumber
    );
    try {
      if (await canLaunchUrl(phoneUri)){
        await launchUrl(phoneUri);
      }
    } catch (error) {
      throw("Cannot dial");
    }
  }

}
