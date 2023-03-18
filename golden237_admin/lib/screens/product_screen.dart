import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden237_admin/screens/add_product.dart';
import 'package:golden237_admin/screens/home_screen.dart';
import 'package:golden237_admin/screens/product_detail_screen.dart';
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

  // Initial Selected Value
  String dropValue = 'Latest';

  var items = [
    'Latest',
    'Oldest',
    'Ascending',
    'Descending',
    'Low to High',
    'High to Low',
  ];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
    });
    return Scaffold(
        appBar: AppBar(
          title: const Text('Products', style: TextStyle(fontSize: 16)),

          actions: [

            DropdownButton<String>(
              value: dropValue,
              icon: const Icon(Icons.keyboard_arrow_down),
              // Array list of items
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  dropValue = newValue!;
                });
              },
            ),

            const SizedBox(width: 25),

            Obx(() => Padding(
                padding: const EdgeInsets.only(top: 21.0, right: 25.0),
                child: Text('(${productController.allProdCount.value})')
            )
            ),

            const SizedBox(width: 10.0)
          ],
        ),

        body: FutureBuilder(
            future: dropValue == "Latest" ? productController.getProductByRecent() :
            dropValue == "Oldest" ? productController.getProductByPast() :
            dropValue == "Ascending" ? productController.getProductAsc() :
            dropValue == "Descending" ? productController.getProductDes() :
            dropValue == "Low to High" ? productController.getProductLH() :
            productController.getProductHL(),
            builder: (context, snapshot){
              if(snapshot.hasError) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    color: Colors.white,
                    child: Text('Something went wrong: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red)
                    ),
                  ),
                );
              }
              if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){
                return loadingProduct(snapshot);
              }
              else{
                return const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                      strokeWidth: 3,
                    )
                );
              }
            }
        ),



        floatingActionButton:  CustomFabWidget(
          route: AddProduct(option: 'add',), text: 'Product', width: 120.0,)
    );
  }

  Widget loadingProduct(AsyncSnapshot snap){
   return ListView.builder(
       itemCount: snap.data.length,
       itemBuilder: (context, index){
         return ProductWidget(productSnapshot: snap,
             index: index, subCat: snap.data[index]['name']);
       }
   );
  }
}


