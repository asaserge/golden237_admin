import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/coupon_model.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/custom_input.dart';
import '../widgets/date_widget.dart';
import '../widgets/header_widget.dart';
import '../widgets/submit_button.dart';

class AddCoupon extends StatefulWidget {
  AddCoupon({Key? key, required this.isAdd, this.start, this.end,
    this.percent, this.desc, this.code}) : super(key: key);
  final bool isAdd;
  String? start; String? end; String? percent; String? desc; String? code;

  @override
  State<AddCoupon> createState() => _AddCouponState();
}

class _AddCouponState extends State<AddCoupon> {

  late TextEditingController _controllerDesc;
  late TextEditingController _controllerCode;
  late TextEditingController _controllerPercent;
  late TextEditingController _controllerStart;
  late TextEditingController _controllerEnd;

  Helper helper = Helper();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controllerDesc =
    widget.isAdd ? TextEditingController() : TextEditingController(
        text: '${widget.desc}');
    _controllerCode =
    widget.isAdd ? TextEditingController() : TextEditingController(
        text: '${widget.code}');
    _controllerPercent =
    widget.isAdd ? TextEditingController() : TextEditingController(
        text: '${widget.percent}');
    _controllerStart =
    widget.isAdd ? TextEditingController() : TextEditingController(
        text: '${widget.start}');
    _controllerEnd =
    widget.isAdd ? TextEditingController() : TextEditingController(
        text: '${widget.percent}');

    super.initState();
  }

  @override
  void dispose() {
    _controllerDesc.dispose();
    _controllerCode.dispose();
    _controllerPercent.dispose();
    _controllerStart.dispose();
    _controllerEnd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isAdd ? const Text('Add Coupon') : const Text(
            'Edit Coupon'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderWidget(
                text: 'You will be able to create a product coupon for Golden237 store',
                image: 'assets/icons/coupon-icon.png',
              ),

              const SizedBox(height: 25),

              Form(
                  key: _formKey,
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

                      CustomInput(
                        controller: _controllerDesc,
                        hintText: 'Coupon Description',
                        prefixIcon: Icons.description_outlined,
                        maxLines: 4,
                        label: 'Description',
                        maxCount: 200,
                        onChange: (val) {

                        },
                      ),

                      const SizedBox(height: 30),

                      DateWidget(startDate: _controllerStart,
                          endDate: _controllerEnd),

                      const SizedBox(height: 35),

                      SubmitButton(
                        text: widget.isAdd ? 'Create Coupon' : 'Edit Country',
                        isLoading: isLoading,
                        isEnabled: true,
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });

                          widget.isAdd ?
                          createProductCoupon(
                            couponPercent: int.parse(_controllerPercent.text),
                            couponCode: _controllerCode.text,
                            couponStart: _controllerStart.text,
                            couponEnd: _controllerEnd.text,
                            couponDesc: _controllerDesc.text,
                            id: ''
                          ) :

                          updateProductCoupon(
                              couponPercent: int.parse(_controllerPercent.text),
                              couponCode: _controllerCode.text,
                              couponStart: _controllerStart.text,
                              couponEnd: _controllerEnd.text,
                              couponDesc: _controllerDesc.text
                          );
                          ;
                        },
                      ),
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

  Future<void> createProductCoupon({
    required int couponPercent, required String couponCode, required String id,
    required String couponStart, required String couponEnd, required String couponDesc,
  }) async {
    CouponModel couponData = CouponModel(
      id: id,
      code: couponCode,
      start: couponStart,
      end: couponEnd,
      desc: couponDesc,
      percent: couponPercent,
    );

    Get.snackbar('Success!', 'Product created successfully!!.',
        colorText: Colors.white, backgroundColor: Colors.green,
        borderRadius: 0
    );
  }


  Future<void> updateProductCoupon({
    required int couponPercent, required String couponCode,
    required String couponStart, required String couponEnd, required String couponDesc,
  }) async {
    //Todo add product coupon
    Get.snackbar('Success!', 'Product updated successfully!!.',
        colorText: Colors.white, backgroundColor: Colors.green,
        borderRadius: 0
    );
    Navigator.of(context).pop();
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