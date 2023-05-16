
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../utils/constants.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _pages = [
      Get.to('/home'),
      Get.to('/favorite'),
      Get.to('/account'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        iconSize: 40,
        onTap: _onItemTapped,
        elevation: 5,
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'montserrat_medium'
        ),
        selectedLabelStyle: const TextStyle(
            fontFamily: 'montserrat_medium'
        ),
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_outlined),
            label: 'Listing'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline_sharp),
              label: 'Favorite'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box_outlined),
              label: 'Account'
          ),
        ],

      ),
    );
  }
}


