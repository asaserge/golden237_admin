import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:golden237_admin/screens/modify_product.dart';
import 'package:golden237_admin/screens/searchbar_screen.dart';
import 'package:intl/intl.dart';

import '../controller/product_controller.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key, required
  this.productSnapshot, required this.index}) : super(key: key);
  final AsyncSnapshot productSnapshot;
  final int index;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with TickerProviderStateMixin{

  Helper helper = Helper();
  final ProductController productController = Get.find();
  final currencyFormatter = NumberFormat('#,###');
  final decimalFormatter = NumberFormat('#.#');
  final dateFormatter = DateFormat('dd/MM/yyyy hh:mm a');

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Product Details', style: TextStyle(fontSize: 16)),

        ),

        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: size.height / 2,
                          width: double.infinity,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                            image: DecorationImage(
                                image: NetworkImage(widget.productSnapshot.data[widget.index]['image']),
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
                                child: Text(widget.productSnapshot.data[widget.index]['is_new'] ? 'New' : 'Used'
                                    ,style: const TextStyle(fontSize: 15.0, color: Colors.green)
                                ),
                              ),

                            ),
                          ),
                        ),

                        Visibility(
                          visible: widget.productSnapshot.data[widget.index]['discount'] > 0 ? true : false,
                          child: Positioned(
                            top: 0,
                            right: 2,
                            child: Card(
                              color: Colors.red,
                              elevation: 2,
                              child: RotatedBox(
                                quarterTurns: 180,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0,
                                      vertical: 7.0),
                                  child: Text('${decimalFormatter.format((widget.productSnapshot.data[widget.index]['price'] -
                                      widget.productSnapshot.data[widget.index]['discount']) /
                                      widget.productSnapshot.data[widget.index]['price'] * 100)}% OFF'
                                      ,style: const TextStyle(fontSize: 13.0)
                                  ),
                                ),

                              ),
                            ),
                          ),
                        )

                      ],
                    ),

                    const SizedBox(height: 15.0),

                    Row(
                      children: [
                        Text(widget.productSnapshot.data[widget.index]['name'], style: const TextStyle(
                            fontSize: 25.0, color: primaryColor, fontWeight: FontWeight.bold)),
                      ],
                    ),

                    const SizedBox(height: 25.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Text('XAF ${currencyFormatter.format(widget.productSnapshot.data[widget.index]['price'])}',
                            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500)),

                        Column(
                          children: [
                            const Text('Created on',
                                style: TextStyle(fontSize: 10.0)),
                            Text(dateFormatter.format(DateTime.parse(
                                widget.productSnapshot.data[widget.index]['created_at'])),
                                style: const TextStyle(fontSize: 10.0)),
                          ],
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11.0),
                              color: Colors.black
                          ),
                          child: Text(widget.productSnapshot.data[widget.index]['sku'],
                              style: const TextStyle(fontSize: 15.0)),
                        )
                      ],
                    ),

                    const SizedBox(height: 15.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Text('(${widget.productSnapshot.data[widget.index]['sold']} Sold)',
                            style: const TextStyle(fontSize: 13.0)),

                        Text('Size: ${widget.productSnapshot.data[widget.index]['size']}',
                            style: const TextStyle(fontSize: 13.0)),

                        Row(
                          children: [
                            CircleAvatar(
                              radius: 17,
                              child: Image.network(widget.productSnapshot.data[widget.index]['category']['image']),

                            ),
                            const SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.productSnapshot.data[widget.index]['category']['name'],
                                    style: const TextStyle(fontSize: 13.0)),
                                Text(widget.productSnapshot.data[widget.index]['brand'],
                                    style: const TextStyle(fontSize: 15.0)),
                              ],
                            ),
                          ],
                        ),

                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Text(widget.productSnapshot.data[widget.index]['category']['detail'], maxLines: 2,
                        overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 17.0)),

                    const SizedBox(height: 16.0),
                    Text(widget.productSnapshot.data[widget.index]['description'],
                        style: const TextStyle(fontSize: 14.0, letterSpacing: 1.5)),
                    const SizedBox(height: 25.0),
                  ],
                )
            ),
          )
        ),

    );
  }
}
