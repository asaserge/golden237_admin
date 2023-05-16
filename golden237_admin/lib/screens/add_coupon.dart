import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:golden237_admin/controller/order_controller.dart';

import '../models/coupon_model.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/custom_input.dart';
import '../widgets/date_widget.dart';
import '../widgets/header_widget.dart';
import '../widgets/submit_button.dart';

class AddCoupon extends StatefulWidget {
  AddCoupon({Key? key}) : super(key: key);

  @override
  State<AddCoupon> createState() => _AddCouponState();
}

class _AddCouponState extends State<AddCoupon> {

  late TextEditingController _controllerCode;
  late TextEditingController _controllerPercent;
  late TextEditingController _controllerStart;
  late TextEditingController _controllerEnd;
  final OrderController orderController = Get.find();
  final dynamic couponData = Get.arguments;
  late String start;
  late String end;
  late String code;
  late String percent;

  Helper helper = Helper();
  bool isLoading = false;
  final _formKeyCoupon = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    start = couponData != null ? couponData[0]['start'] : '';
    end = couponData != null ? couponData[1]['end'] : '';
    code = couponData != null ? couponData[2]['code'] : '';
    percent = couponData != null ? couponData[2]['percent'] : '';
    _controllerStart = start == '' ? TextEditingController() : TextEditingController(text: start);
    _controllerEnd = end == '' ? TextEditingController() : TextEditingController(text: end);
    _controllerCode = code == '' ? TextEditingController() : TextEditingController(text: code);
    _controllerPercent = code == '' ? TextEditingController() : TextEditingController(text: percent);
  }

  @override
  void dispose() {
    _controllerStart.dispose();
    _controllerEnd.dispose();
    _controllerCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: start == '' ? const Text('Add Coupon') : const Text('Edit Coupon'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderWidget(
                text: 'You will be able to create a product coupon for Golden237 store',
                image: 'assets/icons/icons-coupon.png',
              ),

              const SizedBox(height: 25),

              Form(
                  key: _formKeyCoupon,
                  child: Column(
                    children: [
                      TextFormField(
                          controller: _controllerCode,
                          maxLength: 6,
                          cursorColor: Get.isDarkMode ? Colors.white : Colors
                              .black54,
                          textCapitalization: TextCapitalization.characters,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Code is required!';
                            }
                            else if (val.length != 6) {
                              return 'Code is invalid!';
                            }
                          },
                          inputFormatters: [
                            UpperCaseTextFormatter(),
                          ],
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
                              prefixIcon: const Icon(
                                  Icons.code_outlined, color: primaryColor),
                              hintText: 'Coupon Code',
                              label: const Text('Code*'),
                              contentPadding: const EdgeInsets.only(
                                  top: 10, right: 20),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    _controllerCode.text =
                                        generateRandomString();
                                  });
                                },
                                child: const Icon(Icons
                                    .generating_tokens_outlined),
                              )
                          )

                      ),

                      const SizedBox(height: 15),

                      CustomInput(
                        controller: _controllerPercent,
                        hintText: 'Percentage Discount',
                        prefixIcon: Icons.percent_outlined,
                        maxCount: 3,
                        label: 'Percent*',
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Percent is required!';
                          }
                          else if (_controllerPercent.text == '0') {
                            return 'Percent can not be zero!';
                          }
                        },
                        textInputType: TextInputType.number,
                        onChange: (val) {

                        },
                      ),

                      const SizedBox(height: 15),

                      DateWidget(startDate: _controllerStart,
                          endDate: _controllerEnd),

                      const SizedBox(height: 35),

                      start == '' ?
                      SubmitButton(
                        text: 'Create Coupon',
                        isLoading: isLoading,
                        isEnabled: true,
                        onPressed: () {
                          if(_formKeyCoupon.currentState!.validate()){
                            setState(() {
                              isLoading = true;
                            });
                            CouponModel couponData = CouponModel(
                              code: _controllerCode.text,
                              start: _controllerStart.text,
                              end: _controllerEnd.text,
                              percent: _controllerPercent.text,
                            );
                            orderController.createCouponMethod(coupon: couponData);
                          }
                          return;
                        },
                      ) :

                      SubmitButton(
                        text: 'Edit Coupon',
                        isLoading: isLoading,
                        isEnabled: true,
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });

                          if(_formKeyCoupon.currentState!.validate()){

                          }
                        },
                      )
                    ],
                  )
              ),

              const SizedBox(height: 15),

            ],
          ),
        ),
      ),
    );
  }

  String generateRandomString() {
    var r = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    return List.generate(6, (index) => chars[r.nextInt(chars.length)]).join();
  }

}


class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}