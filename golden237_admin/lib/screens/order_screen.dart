import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';

import '../controller/order_controller.dart';
import '../utils/constants.dart';
import '../widgets/header_widget.dart';
import '../widgets/order_widget.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with TickerProviderStateMixin{

  late TabController tabController;
  OrderController orderController = Get.find();

  @override
  void initState() {
     tabController  = TabController(length: 2, vsync: this,
     animationDuration: const Duration(milliseconds: 300));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),

        actions: [
          IconButton(
              onPressed: (){
                setState(() {});
              },
              icon: const Icon(Icons.refresh_outlined)
          ),
          const SizedBox(
            width: 20.0,
          )
        ],

      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: Column(
            children: [
              const HeaderWidget(
                text: 'You will be able to view, update, accept or decline orders on GOlden237 Store',
                image: 'assets/icons/icons-order.png',
              ),

              const SizedBox(height: 25),

              Container(
                height: size.height / 8,
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.only(bottom: 20.0),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0))
                ),
                child: TabBar(
                  indicatorColor: primaryColor,
                  indicatorWeight: 2.0,
                  indicatorSize: TabBarIndicatorSize.label,
                  controller: tabController,
                  tabs: [
                    Tab(icon: const Icon(Icons.bookmark_border_outlined),
                        text: 'Active Orders (${orderController.orderCount.value})'),
                    Tab(icon: const Icon(Icons.history_outlined),
                        text: 'Order History (${orderController.deliverCount.value})'),
                  ],
                ),
              ),

              SizedBox(
                height: size.height / 1.9,
                width: double.infinity,
                child: TabBarView(
                    controller: tabController,
                    children: [
                      FutureBuilder(
                          future: orderController.getAllOrders(),
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
                              return OrderWidget(orderSnap: snapshot);
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

                      FutureBuilder(
                          future: orderController.getDeliveredOrders(),
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
                              return OrderWidget(orderSnap: snapshot);
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
                    ]
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

}
