import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:golden237_admin/screens/add_product.dart';
import 'package:golden237_admin/screens/searchbar_screen.dart';
import 'package:intl/intl.dart';

import '../controller/product_controller.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key, required this.productSnapshot}) : super(key: key);
  final AsyncSnapshot productSnapshot;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with TickerProviderStateMixin{

  Helper helper = Helper();
  final ProductController productController = Get.find();
  final formatter = NumberFormat('#,###');

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    var timestamp = widget.productSnapshot.data['created'];
    DateTime dateTime = timestamp.toDate();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Product Details', style: TextStyle(fontSize: 16)),

        ),

        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: size.height / 2,
                        width: double.infinity,
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(widget.productSnapshot.data['image']),
                              fit: BoxFit.fill
                          ),
                        ),
                      ),
                      Positioned(
                        top: 2,
                        left: 2,
                        child: Card(
                          elevation: 2,
                          child: RotatedBox(
                            quarterTurns: 135,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0,
                                  vertical: 5.0),
                              child: Text(widget.productSnapshot.data['isNew'] ? 'New' : 'Used'
                                  ,style: const TextStyle(fontSize: 15.0, color: Colors.green)
                              ),
                            ),

                          ),
                        ),
                      ),

                      Visibility(
                        visible: widget.productSnapshot.data['discount'] > 0 ? true : false,
                        child: Positioned(
                          top: 0,
                          right: 2,
                          child: Card(
                            color: Colors.red,
                            elevation: 2,
                            child: RotatedBox(
                              quarterTurns: 180,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0,
                                    vertical: 5.0),
                                child: Text('- ${widget.productSnapshot.data['discount']} OFF'
                                    ,style: const TextStyle(fontSize: 15.0)
                                ),
                              ),

                            ),
                          ),
                        ),
                      )

                    ],
                  ),

                  const SizedBox(height: 15.0),

                  Text(widget.productSnapshot.data['name'], style: const TextStyle(
                      fontSize: 25.0, color: primaryColor, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 25.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      
                      Text('${widget.productSnapshot.data['sold']} Sold',
                          style: const TextStyle(fontSize: 15.0)),

                      Column(
                        children: [
                          const Text('Created Date',
                              style: TextStyle(fontSize: 10.0)),
                          Text('$dateTime',
                              style: const TextStyle(fontSize: 12.0)),
                        ],
                      ),
                      Text('${widget.productSnapshot.data['quantity']} In stock',
                          style: const TextStyle(fontSize: 15.0)),
                    ],
                  ),

                  const SizedBox(height: 25.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text('XAF ${widget.productSnapshot.data['price']}',
                          style: const TextStyle(fontSize: 20.0)),
                      Text('$dateTime',
                          style: const TextStyle(fontSize: 15.0)),
                    ],
                  ),
                ],
              )
          ),
        ),

    );
  }
}
