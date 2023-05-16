import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../controller/order_controller.dart';
import '../models/coupon_model.dart';
import '../services/apis.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/custom_fab_widget.dart';
import 'add_coupon.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({Key? key}) : super(key: key);

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {

  bool isLoading = false;
  OrderController orderController = Get.find();
  final dateFormatter = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coupon'),

        actions: [
          Obx(() => Padding(
              padding: const EdgeInsets.only(top: 22.0, right: 15),
              child: Text('(${orderController.couponList.length})'))
          ),
          IconButton(
              onPressed: (){
                showHelpDialog();
              },
              icon: const Icon(Icons.help_outline_outlined)
          ),
          const SizedBox(width: 20.0)
        ],
      ),

      body: Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: orderController.couponList.isEmpty ?
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icons/icons-not-found.png'),
                const SizedBox(height: 15.0),
                const Text('No coupon available!')
              ],
            ),
          ) :
          ListView.builder(
              itemCount: orderController.couponList.length,
              itemBuilder: (context, index){
                final Size size = MediaQuery
                    .of(context)
                    .size;
                return Container(
                  height: size.height / 3,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 25.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0))
                  ),
                  child: Column(
                    children: [
                      Container(
                          height: 75.0,
                          width: double.infinity,
                          //margin: const EdgeInsets.only(top: 12.0),
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Start Date', style: TextStyle(fontSize: 10)),
                                  Text(orderController.couponList[index]['start']),
                                ],
                              ),
                              Container(
                                height: 65.0,
                                width: 70.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    )
                                ),
                                child: Center(child: Text('${orderController.couponList[index]['percent']}%', style: const TextStyle(fontSize: 25))),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Start End', style: TextStyle(fontSize: 10)),
                                  Text(orderController.couponList[index]['end']),
                                ],
                              ),
                            ],
                          )
                      ),
                      Expanded(
                          child: Column(
                            children: [
                              const SizedBox(height: 8.0),
                              Text('${orderController.couponList[index]['code']}', style: const TextStyle(fontSize: 20)),
                              const SizedBox(height: 8.0),
                              Stack(
                                children: [
                                  Positioned(
                                      bottom: 15,
                                      right: 0,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green
                                          ),
                                          onPressed: (){
                                            Get.toNamed('/add_coupon', arguments: [
                                              {'start': orderController.couponList[index]['start']},
                                              {'end': orderController.couponList[index]['end']},
                                              {'code': orderController.couponList[index]['code']},
                                              {'percent': orderController.couponList[index]['percent']},
                                            ]);
                                          },
                                          child: Row(
                                            children: const [
                                              Icon(Icons.edit_outlined, color: Colors.white,),
                                              SizedBox(width: 8.0),
                                              Text('Edit', style: TextStyle(color: Colors.white))
                                            ],
                                          )
                                      )
                                  ),
                                  Positioned(
                                      bottom: 15,
                                      left: 8,
                                      child:ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red
                                          ),
                                          onPressed: (){

                                            showDeleteBottomSheet(orderController.couponList[index]['code'],
                                                orderController.couponList[index]['id']);
                                            Navigator.of(context).pop();
                                          },
                                          child: Row(
                                            children: const [
                                              Icon(Icons.delete_outline, color: Colors.white,),
                                              SizedBox(width: 8.0),
                                              Text('Delete', style: TextStyle(color: Colors.white))
                                            ],
                                          )
                                      )
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12.0),
                            ],
                          )
                      )
                    ],
                  ),
                );
              }
          )

      )
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
                Text('Coupon')
              ],
            ),
            onPressed: () {
              Get.toNamed('/add_coupon', arguments: null);
            },
          ),
        ),
      )
    );
  }

  showDeleteBottomSheet(String name, String id){
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30.0),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('WARNING'
                    , style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Are you sure you want to delete $name?', textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400,)),
              ),
              Image.asset('assets/icons/warning.png'),
              const SizedBox(height: 10.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                  ),

                  const SizedBox(width: 60.0),

                  GestureDetector(
                    onTap: (){
                      orderController.deleteCouponMethod(id);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: primaryColor
                      ),
                      child: const Text('Proceed', style: TextStyle(color: Colors.white)),
                    ),
                  ),

                  const SizedBox(width: 30.0),
                ],
              ),
              const SizedBox(height: 25.0),
            ],

          );
        }
      );
  }

  showHelpDialog(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: const [
              Text('Nothing to help you on, everything is straight forward'),
              SizedBox(height: 10.0),

            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("Got it", style: TextStyle(color: Colors.green)),
          ),

        ],
      ),
    );
  }

}
