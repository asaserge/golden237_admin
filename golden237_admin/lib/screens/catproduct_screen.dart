import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/category_controller.dart';
import '../controller/product_controller.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/product_widget.dart';

class CatProductScreen extends StatefulWidget {
  const CatProductScreen({Key? key}) : super(key: key);

  @override
  State<CatProductScreen> createState() => _CatProductScreenState();
}

class _CatProductScreenState extends State<CatProductScreen> {

  Helper helper = Helper();
  final ProductController productController = Get.find();
  final CategoryController categoryController = Get.find();
  final formatter = NumberFormat('#,###');
  bool isLoading = false;
  final data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
    });
    return Scaffold(
        appBar: AppBar(
          title: Text('dfgfdgdfgfd Products',
              style: const TextStyle(fontSize: 18)),

          actions: [
            Obx(() => Padding(
                padding: const EdgeInsets.only(top: 22.0, right: 20.0),
                child: Text('(${categoryController.mainCategoriesList.length})'))
            ),

            const SizedBox(width: 10.0)
          ],
        ),

        body: FutureBuilder(
            future: productController.getCategorisedProducts(data['id']),
            builder: (context, snapshotProd){
              if(snapshotProd.hasError) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    color: Colors.white,
                    child: Text('Something went wrong: ${snapshotProd.error}',
                        style: const TextStyle(color: Colors.red)
                    ),
                  ),
                );
              }
              if(snapshotProd.hasData && snapshotProd.connectionState == ConnectionState.done){
                return allocatedWidget(snapshotProd);
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

        // floatingActionButton:  CustomFabWidget(
        //   route: AddProduct(option: 'add',), text: 'Product', width: 120.0,)
    );
  }

  Widget allocatedWidget(AsyncSnapshot snap){
    if(categoryController.subCategoriesList.isEmpty){
      return Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          color: Colors.white,
          child: Text('Oops! No product found for dsfvdsfds category!',
              style: const TextStyle(color: Colors.green)
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: snap.data.length ?? 0,
      itemBuilder: (context, index){
        return ProductWidget(productSnapshot: snap, index: index);
      },

    );
  }
}


