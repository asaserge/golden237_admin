import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden237_client/controllers/product_controller.dart';
import 'package:golden237_client/controllers/wishlist_controller.dart';
import 'package:golden237_client/widgets/widget_text.dart';
import 'package:intl/intl.dart';

import '../screens/product_detail.dart';
import '../utils/apis.dart';
import '../utils/messages.dart';

class ProductGridSlider extends StatelessWidget {
  ProductGridSlider({Key? key, required this.attribute}) : super(key: key);
  var attribute;

  final ProductController productController = Get.find();
  final WishlistController wishlistController = Get.find();
  final currencyFormatter = NumberFormat('#,###');

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
    return Obx(() {
      if(productController.isLoading.value){
        return Container(
            height: 40, width: 50,
            padding: const EdgeInsets.all(5.0),
            child: spinkit
        );
      }
      else{
        return SizedBox(
          height: size.height / 2,
          child: GridView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            //physics: const NeverScrollableScrollPhysics(),
            itemCount: attribute.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                mainAxisExtent: size.height / 3.8
            ),
            itemBuilder: (BuildContext context, int index){
              return GestureDetector(
                onTap: (){
                  //triggerRatingTotal(attribute[index]['id']);
                  checkIfProductIsFav(attribute[index]['id']);
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      ProductDetail(productData: attribute, index: index)));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.0)
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height / 6,
                        width: size.width,
                        child: Image.network(attribute[index]['image']),
                      ),
                      const SizedBox(height: 5.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          WidgetText(text: attribute[index]['name'],
                              font: 'monsterrat_regular', size: 13),
                          const SizedBox(height: 5.0),
                          WidgetText(text: 'XAF ${currencyFormatter.format(attribute[index]['price'])}', size: 17),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
        }
      }

    );
  }

  triggerRatingTotal(String prod) async{
    final dataCount = await Apis.client
        .rpc('get_user_ratings', params: { 'prod_id': prod})
        .single();
    productController.userCount.value = dataCount ?? 0;
    final dataRating = await Apis.client
        .rpc('get_product_ratings', params: { 'prod_id': prod})
        .single();
    productController.starSum.value = dataRating ?? 0.0;
  }

  checkIfProductIsFav(String prodId){
    for(int i = 0; i < wishlistController.wishlistProduct.length; i++){
      if(prodId == wishlistController.wishlistProduct[i]['product']['id']){
        wishlistController.isFav.value = true;
      }
      else{
        wishlistController.isFav.value = false;
      }
    }
  }
}
