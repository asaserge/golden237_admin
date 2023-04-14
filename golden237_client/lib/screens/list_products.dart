import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:golden237_client/screens/product_detail.dart';
import 'package:golden237_client/widgets/widget_text.dart';
import 'package:intl/intl.dart';

import '../controllers/product_controller.dart';
import '../utils/messages.dart';

class ListProducts extends StatelessWidget {
  ListProducts({Key? key, required this.value,
    required this.name, required this.image}) : super(key: key);
  String value; String name; String image;

  final ProductController productController = Get.find();
  final currencyFormatter = NumberFormat('#,###');
  final dateFormatter = DateFormat('dd/MM/yyyy hh:mm a');

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
          child: SingleChildScrollView(
            child: FutureBuilder(
              future: productController.fetchCategorisedProducts(value),
              builder: (context, snapshot){
                if(snapshot.hasError){
                  return WidgetText(text: 'An error happened\n${snapshot.error.toString()}', maxLines: 50,);
                }
                else if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){
                  return showQueryResult(snapshot, context);
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 330),
                    spinkit
                  ],
                );
              },
            )
          )
      ),
    );
  }

  Widget showQueryResult(AsyncSnapshot snap, BuildContext context){
    final Size size = MediaQuery.of(context).size;
    return snap.data.length == 0 ?
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 200),
            const Text('No products were found for this category', textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'montserrat_medium', fontSize: 18)),
            const SizedBox(height: 40),
            Image.asset('assets/icons/icons-crying.png'),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                  height: 35,
                  width: size.width / 2.5,
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border:  Border.all(
                          width: 2,
                          color: Colors.black
                      )
                  ),
                  child: const Center(
                    child: WidgetText(text: 'Head Back', size: 18),
                  )
              ),
            ),
          ],
        ),
      ) :
      ListView.builder(
        shrinkWrap: true,
        itemCount: snap.data.length ?? 0,
        itemBuilder: (context, myIndex){
          return GestureDetector(
            onTap: (){
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
              //     ProductDetail(productData: snap.data, index: myIndex)));
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Container(
                    height: size.height / 7,
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    margin: const EdgeInsets.only(bottom: 20.0),
                    decoration: BoxDecoration(
                      // color: Colors.grey.withOpacity(0.1),
                      // borderRadius: BorderRadius.circular(12.0)
                    ),
                    child: Column(
                      children: [
                        WidgetText(text: 'Showing result for $name Category'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              child: Image.network(image, fit: BoxFit.cover, scale: 2),
                            ),
                            const SizedBox(width: 15.0),
                            WidgetText(text: '${snap.data.length}', size: 30),
                          ],
                        )
                      ],
                    ),
                  ),

                  Container(
                    height: size.height / 6,
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.0)
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: size.height / 7,
                          width: size.width / 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.grey.withOpacity(0.2),
                            image: DecorationImage(
                                image: NetworkImage(snap.data[myIndex]['image'])
                            )
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            WidgetText(text: snap.data[myIndex]['name'], maxLines: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WidgetText(text: snap.data[myIndex]['sku'], size: 12),
                                const SizedBox(width: 10),
                                WidgetText(text: snap.data[myIndex]['brand'], size: 12),
                              ],
                            ),
                            WidgetText(text: 'XAF ${currencyFormatter.format(snap.data[myIndex]['price'])}'),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WidgetText(text: snap.data[myIndex]['size'], size: 12),
                                const SizedBox(width: 10),
                                WidgetText(text: '${snap.data[myIndex]['quantity']} available', size: 12),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
