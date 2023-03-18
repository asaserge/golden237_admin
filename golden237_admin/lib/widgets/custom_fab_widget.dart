import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../utils/constants.dart';

class CustomFabWidget extends StatelessWidget {
  const CustomFabWidget({Key? key,
    required this.route, required this.text, required this.width
  }) : super(key: key);
  final route;
  final String text;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50.0,
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.black : primaryColor,
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
            children: [
              Icon(
                Icons.add_outlined,
              ),
              SizedBox(width: 5.0),
              Text(text)
            ],
          ),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => route));
          },
        ),
      ),
    );
  }
}
