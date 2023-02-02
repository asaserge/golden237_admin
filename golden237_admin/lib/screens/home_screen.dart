import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../messages/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.theme}) : super(key: key);

  final ValueNotifier<ThemeMode> theme;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){

          },
          icon: const Icon(Icons.menu_outlined),
        ),

        title: const Text(appName),

        actions: [
          IconButton(
            onPressed: (){

            },
            icon: Icon(Icons.search_outlined),
          ),
          IconButton(
            onPressed: (){

            },
            icon: Icon(Icons.help_outline_outlined),
          ),
        ],
      ),

      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        spacing: 3,
        mini: false,
        openCloseDial: ValueNotifier<bool>(false),
        childPadding: const EdgeInsets.all(5),
        spaceBetweenChildren: 4,
        childrenButtonSize: const Size(46.0, 46.0),
        visible: true,
        direction: SpeedDialDirection.up,
        buttonSize: const Size(56.0, 56.0),
        switchLabelPosition: false,
        closeManually: false,
        renderOverlay: true,
        onOpen: () => debugPrint('OPENING DIAL'),
        onClose: () => debugPrint('DIAL CLOSED'),
        useRotationAnimation: true,
        tooltip: 'More',
        elevation: 8.0,
        animationCurve: Curves.elasticInOut,
        isOpenOnStart: false,
        shape: const StadiumBorder(),
        children: [

          SpeedDialChild(
            child:const Icon(Icons.shop),
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            label: 'Product',
            onTap: () {

            },
          ),

          SpeedDialChild(
              child: const Icon(Icons.category_outlined) ,
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              label: 'Category',
              onTap: () {

              }
          ),

          SpeedDialChild(
              child: const Icon(Icons.person_outline),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              label: 'User',
              onTap: () {

              }
          ),


        ],
      ),

    );
  }
}
