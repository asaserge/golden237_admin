import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';

class CustomInput extends StatelessWidget {
  CustomInput({Key? key, required this.controller,
    this.textInputType, required this.hintText,
    required this.prefixIcon, this.maxLines, this.maxCount, this.padding,
    this.onChange, this.prefixText, required this.label, this.validator
  }) : super(key: key);
  final TextEditingController controller;
  final String hintText;
  final String label;
  final IconData prefixIcon;
  String? prefixText;
  int? maxCount;
  int? maxLines;
  TextInputType? textInputType;
  String? Function(String?)? onChange;
  FormFieldValidator? validator;
  EdgeInsets? padding;


  @override
  Widget build(BuildContext context) {

    return TextFormField(
      controller: controller,
      maxLines: maxLines ?? 1,
      maxLength: maxCount ?? 15,
      onChanged: onChange,
      validator: validator,
      cursorColor: Get.isDarkMode ? Colors.white : Colors.black54,
      keyboardType: textInputType ?? TextInputType.text,
      decoration: InputDecoration(
        contentPadding: padding ?? EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            width: 1,
            color: Colors.white38
          )
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
                width: 1,
                color: primaryColor
            )
        ),
        prefixIcon: Icon(prefixIcon, color: primaryColor),
        prefixText: prefixText,
        hintText: hintText,
        label: Text(label)
      )

    );
  }
}
