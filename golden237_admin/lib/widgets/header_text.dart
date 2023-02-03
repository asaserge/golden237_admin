import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  HeaderText({Key? key, required this.text, this.fontSize,
  this.fontWeight}) : super(key: key);
  final String text;
  double? fontSize;
  FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(
      fontSize: fontSize ?? 14.0,
      fontWeight: fontWeight ?? FontWeight.w500,
    ));
  }
}
