import 'package:flutter/material.dart';

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

  @override
  void initState() {
     tabController  = TabController(length: 2, vsync: this,
     animationDuration: const Duration(milliseconds: 500));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: Column(
            children: [
              const HeaderWidget(
                text: 'You will be able to view, update, accept or decline orders on GOlden237 Sctore',
                image: 'assets/icons/category-icon.png',
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
                  tabs: const [
                    Tab(icon: Icon(Icons.bookmark_border_outlined), text: 'Active Orders (4)'),
                    Tab(icon: Icon(Icons.history_outlined), text: 'Order History (405)'),
                  ],
                ),
              ),

              SizedBox(
                height: size.height / 1.9,
                width: double.infinity,
                child: TabBarView(
                    controller: tabController,
                    children: [
                      OrderWidget(),
                      OrderWidget(),
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
