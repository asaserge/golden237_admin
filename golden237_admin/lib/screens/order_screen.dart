import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/order_controller.dart';
import '../utils/constants.dart';
import '../widgets/header_widget.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with TickerProviderStateMixin{

  late TabController tabController;
  OrderController orderController = Get.find();
  final dateFormatter = DateFormat('dd/MM/yyyy hh:mm a');
  final currencyFormatter = NumberFormat('#,###');

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
          Obx(() => Padding(
              padding: const EdgeInsets.only(top: 22.0, right: 15),
              child: Text('(${orderController.ordersAllList.length})'))
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

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: Column(
            children: [
              const HeaderWidget(
                text: 'You will be able to view, update, accept or decline orders on GOlden237 Store',
                image: 'assets/icons/icons-order.png',
              ),

              const SizedBox(height: 35),
              //const SizedBox(height: 200),

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
                    Obx(() => Tab(icon: const Icon(Icons.bookmark_border_outlined),
                        text: 'Active Orders (${orderController.ordersUndeliveredList.length})')
                    ),
                    Obx(() => Tab(icon: const Icon(Icons.history_outlined),
                        text: 'Order History (${orderController.ordersDeliveredList.length})')
                    )
                  ],
                ),
              ),

              SizedBox(
                height: size.height / 1.9,
                width: double.infinity,
                child: TabBarView(
                    controller: tabController,
                    children: [
                      Obx(() =>
                        orderController.ordersUndeliveredList.isEmpty ?
                        Center(
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                color: Colors.white,
                                child: const Text('Calm down and relax! No active orders yet!',
                                    style: TextStyle(color: Colors.green)
                                ),
                              ),
                            )
                        ) :
                        ListView.builder(
                            itemCount: orderController.ordersUndeliveredList.length,
                            itemBuilder: (context, index){
                              return GestureDetector(
                                onTap: (){
                                  Get.toNamed('/order_details', arguments: orderController.ordersUndeliveredList[index]);
                                },
                                child: Container(
                                  height: size.height / 6.5,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                          width: 1.0,
                                          color: Colors.white
                                      )
                                  ),
                                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Order #${orderController.ordersUndeliveredList[index]['number']}', style: const TextStyle(fontSize: 17)),
                                          Row(
                                            children: [
                                              const Text('Status: ', style: TextStyle(fontSize: 14)),
                                              Text(orderController.ordersUndeliveredList[index]['status'],
                                                  style: const TextStyle(fontSize: 14, color: primaryColor)),
                                            ],
                                          ),
                                          Text(dateFormatter.format(DateTime.parse(orderController.ordersUndeliveredList[index]['created_at'])), style: const TextStyle(fontSize: 8)),

                                        ],
                                      ),

                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              const Text('No. ', style: TextStyle(fontSize: 14)),
                                              Text('${index + 1}', style: const TextStyle(fontSize: 24)),
                                            ],
                                          ),
                                          Text('XAF ${currencyFormatter.format(orderController.ordersUndeliveredList[index]['total'])}', style: const TextStyle(fontSize: 14)),
                                        ],
                                      ),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: "http://via.placeholder.com/200x150",
                                            imageBuilder: (context, imageProvider) => Container(
                                              height: 70,
                                              width: 70,
                                              margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5.0),
                                                  border: Border.all(
                                                    color: Colors.white,
                                                  ),
                                                  image: DecorationImage(
                                                    image: NetworkImage(orderController.ordersUndeliveredList[index]['product']['image']),
                                                    fit: BoxFit.cover,
                                                  )
                                              ),
                                            ),
                                            placeholder: (context, url) => Image.asset('assets/images/no-image.jpg',
                                                height: 69, width: 69),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                          ),
                                          Expanded(
                                            child: Text('${orderController.ordersUndeliveredList[index]['product']['name']}', style: const TextStyle(fontSize: 10.0)),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                        )

                      ),

                      Obx(() =>
                        orderController.ordersDeliveredList.isEmpty ?
                        Center(
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                color: Colors.white,
                                child: const Text('Calm down and relax! No delivered orders yet!',
                                    style: TextStyle(color: Colors.green)
                                ),
                              ),
                            )
                        ) :
                        ListView.builder(
                            itemCount: orderController.ordersDeliveredList.length,
                            itemBuilder: (context, index){
                              return GestureDetector(
                                onTap: (){
                                  Get.toNamed('/order_details', arguments: orderController.ordersDeliveredList[index]);
                                },
                                child: Container(
                                  height: size.height / 6.5,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                          width: 1.0,
                                          color: Colors.white
                                      )
                                  ),
                                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Order #${orderController.ordersDeliveredList[index]['number']}', style: const TextStyle(fontSize: 17)),
                                          Row(
                                            children: [
                                              const Text('Status: ', style: TextStyle(fontSize: 14)),
                                              Text(orderController.ordersDeliveredList[index]['status'],
                                                  style: const TextStyle(fontSize: 14, color: primaryColor)),
                                            ],
                                          ),
                                          Text(dateFormatter.format(DateTime.parse(orderController.ordersDeliveredList[index]['created_at'])), style: const TextStyle(fontSize: 8)),

                                        ],
                                      ),

                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              const Text('No. ', style: TextStyle(fontSize: 14)),
                                              Text('${index + 1}', style: const TextStyle(fontSize: 24)),
                                            ],
                                          ),
                                          Text('XAF ${currencyFormatter.format(orderController.ordersDeliveredList[index]['total'])}', style: const TextStyle(fontSize: 14)),
                                        ],
                                      ),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: "http://via.placeholder.com/200x150",
                                            imageBuilder: (context, imageProvider) => Container(
                                              height: 70,
                                              width: 70,
                                              margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5.0),
                                                  border: Border.all(
                                                    color: Colors.white,
                                                  ),
                                                  image: DecorationImage(
                                                    image: NetworkImage(orderController.ordersDeliveredList[index]['product']['image']),
                                                    fit: BoxFit.cover,
                                                  )
                                              ),
                                            ),
                                            placeholder: (context, url) => Image.asset('assets/images/no-image.jpg',
                                                height: 69, width: 69),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                          ),
                                          Expanded(
                                            child: Text('${orderController.ordersDeliveredList[index]['product']['name']}', style: const TextStyle(fontSize: 10.0)),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                        )

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
