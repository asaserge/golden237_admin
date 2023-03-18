import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../utils/constants.dart';

class SubCatInput extends StatelessWidget {
  SubCatInput({Key? key, required this.controller1,
    this.textInputType, required this.hintText1,
    required this.hintText2,
    required this.icon, required this.controller2,
    this.maxCount, this.onChange1, this.onChange2
  }) : super(key: key);
  final TextEditingController controller1;
  final TextEditingController controller2;
  final String hintText1;
  final String hintText2;
  final IconData icon;
  int? maxCount;
  TextInputType? textInputType;
  String? Function(String?)? onChange1;
  String? Function(String?)? onChange2;


  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Expanded(
          child: TextFormField(
              controller: controller1,
              maxLines: 1,
              maxLength: maxCount ?? 15,
              onChanged: onChange1,
              cursorColor: Get.isDarkMode ? Colors.white : Colors.black54,
              keyboardType: textInputType ?? TextInputType.text,
              decoration: InputDecoration(
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
                  hintText: hintText1
              )

          )
        ),

        const SizedBox(width: 10.0),

        Expanded(
          child: TextFormField(
              controller: controller1,
              maxLines: 1,
              maxLength: maxCount ?? 15,
              onChanged: onChange2,
              cursorColor: Get.isDarkMode ? Colors.white : Colors.black54,
              keyboardType: textInputType ?? TextInputType.text,
              decoration: InputDecoration(
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
                  hintText: hintText2
              )

          ),
        ),
      ],
    );
  }
}
