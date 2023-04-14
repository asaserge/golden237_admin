import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:golden237_client/controllers/auth_controller.dart';

class WidgetInput extends StatelessWidget {
  WidgetInput({Key? key, required this.textEditingController, required this.prefixIcon,
    required this.labelText,  required this.hintText, this.textInputType, this.validator,
    this.maxLength, this.isObscured}) : super(key: key);
  final TextEditingController textEditingController;
  final IconData prefixIcon;
  final String labelText;
  final String hintText;
  final TextInputType? textInputType;
  final int? maxLength;
  final FormFieldValidator<String>? validator;
  bool? isObscured;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      keyboardType: textInputType ?? TextInputType.name,
      maxLength: maxLength ?? 30,
      obscureText: isObscured ?? false,
      validator: validator,
      style: const TextStyle(fontFamily: 'caro_medium'),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon, color: Colors.black),
        labelText: labelText,
        hintText: hintText,
        labelStyle: const TextStyle(color: Colors.black),
        hintStyle: const TextStyle(color: Colors.grey),
        iconColor: Colors.black,
        fillColor: Colors.grey.withOpacity(0.1),
        filled: true,
        contentPadding: const EdgeInsets.all(6.0),
        counterText: '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            width: 2,
            color: Colors.black54
          )
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
              width: 2,
              color: Colors.black
          )
        ),
      ),
    );
  }
}
