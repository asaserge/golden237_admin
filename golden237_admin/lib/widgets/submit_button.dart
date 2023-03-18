import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../utils/constants.dart';

class SubmitButton extends StatefulWidget {
  SubmitButton({Key? key, required this.text, required this.isEnabled,
    required this.onPressed, required this.isLoading}) : super(key: key);
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  bool isEnabled;

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;


    return InkWell(
      onTap: widget.isEnabled ? widget.onPressed : null,
      child: Card(
          elevation: 2,
          child: widget.isEnabled ?
          Container(
            height: size.height / 12,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Get.isDarkMode ? Colors.black54 : primaryColor,
                borderRadius: BorderRadius.circular(15.0)
            ),
            child: Center(
                child: !widget.isLoading ?
                Text(widget.text, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)) :
                const CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                )

            ),
          ) :
          Container(
              height: size.height / 12,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(15.0)
              ),
              child: Center(
                  child: Text(widget.text)
              )
          )
      ),
    );
  }
}
