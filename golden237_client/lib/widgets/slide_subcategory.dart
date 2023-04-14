import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:golden237_client/widgets/widget_text.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../controllers/category_controller.dart';
import '../controllers/product_controller.dart';
import '../screens/list_products.dart';
import '../utils/messages.dart';

class SlideSubCategory extends StatelessWidget {
  SlideSubCategory({Key? key}) : super(key: key);

  final CategoryController categoryController = Get.find();
  final ProductController productController = Get.find();

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
    return SizedBox(
        height: 50,
        width: size.width,
        child: Obx(() {
          if(categoryController.isLoadingSub.value){
            return Container(
                height: 40, width: 50,
                padding: const EdgeInsets.all(5.0),
                child: spinkit
            );
          }
          else{
            return ListView.builder(
                itemCount: categoryController.subcategoryList.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index){
                  return GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                            ListProducts(value: categoryController.subcategoryList[index]['id'],
                              name: categoryController.subcategoryList[index]['name'], image:
                                categoryController.subcategoryList[index]['image'])));
                      },
                      child: Card(
                        elevation: 4,
                        color: Colors.white ,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Image.network(categoryController.subcategoryList[index]['image'], fit: BoxFit.cover),
                              const SizedBox(width: 8.0),
                              WidgetText(text: categoryController.subcategoryList[index]['name'], color: Colors.black),
                            ],
                          ),
                        ),
                      )
                  );
                }
            );
          }
        })

    );
  }
}
