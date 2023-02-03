import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:golden237_admin/messages/constants.dart';

@immutable
class SubmitButton extends StatelessWidget {
  const SubmitButton({Key? key, required this.text,
  required this.onPressed, required this.isLoading}) : super(key: key);
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;


    return InkWell(
      onTap: onPressed,
      child: Card(
        elevation: 2,
        child: Container(
          height: size.height / 12,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Get.isDarkMode ? Colors.black54 : primaryColor,
              borderRadius: BorderRadius.circular(15.0)
          ),
          child: Center(
              child: !isLoading ?
              Text(text) :
              const CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.white,
              )

          ),
        )
      ),
    );
  }
}
