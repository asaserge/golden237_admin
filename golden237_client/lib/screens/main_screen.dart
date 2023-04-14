import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden237_client/screens/filter_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


import '../controllers/category_controller.dart';
import '../utils/apis.dart';
import 'account_screen.dart';
import 'category_screen.dart';
import 'wishlist_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final CategoryController categoryController = Get.find();
  int index = 2;

  final pageList = [
    FilterScreen(),
    const CategoryScreen(),
    HomeScreen(),
    WishlistScreen(),
    AccountScreen(),
  ];

  final iconList = [
    const Icon(Icons.filter_alt_outlined),
    const Icon(Icons.category_outlined),
    Icon(MdiIcons.fromString('storefront')),
    Icon(MdiIcons.fromString('heart')),
    Icon(MdiIcons.fromString('account_circle')),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        extendBody: true,
        body: pageList[index],

        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
          ),
          child: CurvedNavigationBar(
            //buttonBackgroundColor: Colors.black54,
            key: categoryController.navigationKey,
            backgroundColor: Colors.grey.withOpacity(0.3),
            color: Colors.black,
            height: 60,
            animationDuration: const Duration(milliseconds: 250),
            animationCurve: Curves.easeIn,
            items: iconList,
            index: index,
            onTap: (index) {
              setState(() {
                this.index = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
