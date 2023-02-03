import 'package:flutter/material.dart';

import '../widgets/custom_input.dart';
import '../widgets/date_widget.dart';
import '../widgets/header_widget.dart';
import '../widgets/submit_button.dart';

class AddCoupon extends StatefulWidget {
  const AddCoupon({Key? key}) : super(key: key);

  @override
  State<AddCoupon> createState() => _AddCouponState();
}

class _AddCouponState extends State<AddCoupon> {

  late TextEditingController _controllerDisc;
  late TextEditingController _controllerCode;
  late TextEditingController _controllerPercent;

  @override
  void initState() {
    _controllerDisc = TextEditingController();
    _controllerCode = TextEditingController();
    _controllerPercent = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controllerDisc.dispose();
    _controllerCode.dispose();
    _controllerPercent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Coupon'),
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

              CustomInput(
                controller: _controllerCode,
                hintText: 'Coupon Code',
                maxCount: 6,
                prefixIcon: Icons.code_outlined,
                label: 'Code',
                onChange: (val){

                },
              ),

              const SizedBox(height: 15),

              CustomInput(
                controller: _controllerPercent,
                hintText: 'Percentage Discount',
                prefixIcon: Icons.percent_outlined,
                maxCount: 3,
                label: 'Percent',
                textInputType: TextInputType.number,
                onChange: (val){

                },
              ),

              const SizedBox(height: 15),

              CustomInput(
                controller: _controllerDisc,
                hintText: 'Coupon Description',
                prefixIcon: Icons.description_outlined,
                maxLines: 4,
                label: 'Description',
                maxCount: 200,
                onChange: (val){

                },
              ),

              const SizedBox(height: 30),

              const DateWidget(),

              const SizedBox(height: 35),

              SubmitButton(
                text: 'Create Coupon',
                onPressed: () {

                },
                isLoading: false,
              ),

              const SizedBox(height: 15),

            ],
          ),
        ),
      ),
    );
  }
}
