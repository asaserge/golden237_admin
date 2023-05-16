import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden237_admin/screens/modify_product.dart';
import 'package:golden237_admin/screens/home_screen.dart';
import 'package:golden237_admin/screens/product_detail_screen.dart';
import 'package:golden237_admin/screens/searchbar_screen.dart';
import 'package:intl/intl.dart';

import '../controller/product_controller.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/color_widget.dart';
import '../widgets/custom_fab_widget.dart';
import '../widgets/product_widget.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  Helper helper = Helper();
  int productCounter = 0;
  final ProductController productController = Get.find();
  final formatter = NumberFormat('#,###');
  bool isLoading = false;
  String dropdownValue = 'Default';

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
    });
    return Scaffold(
        appBar: AppBar(
          title: const Text('Products', style: TextStyle(fontSize: 16)),

          actions: [

            Obx(() => Padding(
                padding: const EdgeInsets.only(top: 21.0, right: 25.0),
                child: Text('(${productController.productList.length})'))
            ),

            DropdownButton<String>(
              value: dropdownValue,
              underline: const SizedBox(),
              elevation: 3,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: sort.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
            ),

            const SizedBox(width: 10.0)
          ],
        ),

        body: Obx(() => productController.productList.isEmpty ?
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icons/icons-not-found.png'),
                const SizedBox(height: 15.0),
                const Text('No delivered item yet!')
              ],
            ),
          ) :
          // ListView.builder(
          //     itemCount: productController.productList.length,
          //     itemBuilder: (context, index){
          //       return ProductWidget(productData:
          //
          //       );
          //     }
          // )
          SizedBox()
        ),



        floatingActionButton: Container(
          height: 50.0,
          width: 110.0,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.white38,
              )
          ),
          child: Center(
            child: RawMaterialButton(
              shape: const CircleBorder(),
              elevation: 0.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.add_outlined,
                  ),
                  SizedBox(width: 5.0),
                  Text('Product')
                ],
              ),
              onPressed: () {
                Get.toNamed('/modify_product');
              },
            ),
          ),
        )
    );
  }

}


