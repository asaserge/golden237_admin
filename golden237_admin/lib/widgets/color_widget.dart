import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorWidget extends StatelessWidget {
  const ColorWidget({Key? key, required this.myColors
  }) : super(key: key);
  final String myColors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      width: 80,
      child: Container(
        height: 13,
        width: 13,
        margin: const EdgeInsets.only(right: 4.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _showColorBox(myColors),
            border: Border.all(
                color: Colors.white
            )
        ),
      )
    );
  }

  Color _showColorBox(String color){
    switch(color){
      case "Black":
        return Colors.black;
      case "Yellow":
        return Colors.yellow;
      case "Green":
        return Colors.green;
      case "Pink":
        return Colors.black;
      case "Grey":
        return Colors.grey;
      case "Red":
        return Colors.red;
      case "Brown":
        return Colors.brown;
      case "White":
        return Colors.white;
      case "Blue":
        return Colors.blue;
      case "Purple":
        return Colors.purple;
    }
    return Colors.white;
  }
}
