import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:golden237_client/widgets/widget_text.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';

import '../controllers/auth_controller.dart';
import '../controllers/cart_controller.dart';
import '../models/cart_model.dart';
import '../utils/apis.dart';
import '../utils/constants.dart';
import '../utils/messages.dart';

enum Payment {
  momo,
  points,
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {

  JavascriptRuntime runtime = getJavascriptRuntime();
  dynamic path = rootBundle.loadString("assets/files/payment.js");

  Payment? _payment = Payment.momo;
  late bool isDelivery;
  late bool isMomoPay;
  late bool isPointsPay;
  bool _spacialNeed = false;
  late TextEditingController _couponController;
  late TextEditingController _infoController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _specialController;
  late TextEditingController _addressController;
  bool _isLoadingOrder = false;
  bool _isApply = false;
  bool _isDone = false;
  bool _isLoading = false;
  final _formKeyCoupon = GlobalKey<FormState>();
  final _formKeyLocation = GlobalKey<FormState>();
  final _phoneForm = GlobalKey<FormState>();
  double price = 0;
  double temp = 0;
  double rate = 150;
  double totalAmount = 0.0;
  double costAmount = 0.0;
  bool isForSomeone = false;
  final user = Apis.client.auth.currentUser;
  int couponValue = 0;
  late CartModel product;

  final CartController _cartController = Get.find();
  final AuthController authController = Get.find();
  final divider = NumberFormat('#.#');
  final formatter = NumberFormat('#,###');
  final formatterStraight = NumberFormat('');
  final storage = GetStorage();

  @override
  void initState() {
    isDelivery = true;
    isMomoPay = true;
    isPointsPay = false;
    _couponController = TextEditingController();
    _infoController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _specialController = TextEditingController();
    _addressController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _couponController.dispose();
    _infoController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _specialController.dispose();
    _addressController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_outlined),
          ),
          centerTitle: true,
          title:
              const WidgetText(text: 'Checkout'),
        ),

        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.shopping_cart_outlined, size: 25),
                                SizedBox(width: 10),
                                WidgetText(text: 'Cart Details', size: 15, font: 'montserrat_bold'),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ListView.builder(
                              itemCount: _cartController.products.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index){
                                product = _cartController.products.keys.toList()[index];
                                int quantity = _cartController.products.values.toList()[index];
                                return Container(
                                  height: size.height / 7,
                                  width: double.infinity,
                                  //margin: const EdgeInsets.only(top: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9.0),
                                    //color: Colors.grey.withOpacity(0.2)
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: product.productImage,
                                            imageBuilder: (context, imageProvider) => Container(
                                              height: 80,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.contain),
                                              ),
                                            ),
                                            placeholder: (context, url) => const CircularProgressIndicator(color: Colors.black),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                          ),

                                          const SizedBox(width: 20),

                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              WidgetText(text: product.productName, size: 15),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  WidgetText(text: '$quantity x XAF ${formatter.format(product.productPrice)}', size: 10),
                                                  const WidgetText(text: '   =   ', size: 10),
                                                  WidgetText(text: 'XAF ${formatter.format(quantity * product.productPrice)}', size: 13),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Icons.branding_watermark_outlined, size: 12, color: Get.isDarkMode ? Colors.grey : Colors.black54),
                                                  const SizedBox(width: 5),
                                                  WidgetText(text: product.productBrand, size: 12),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const Divider(thickness: 1)
                                    ],
                                  ),
                                );
                              },
                            ),
                            Row(
                              children: [
                                Transform.scale(
                                  scale: 0.9,
                                  child: Checkbox(
                                      value: _spacialNeed,
                                      activeColor: Colors.black,
                                      onChanged: (val) {
                                        setState(() {
                                          _spacialNeed = val!;
                                        });
                                      }),
                                ),
                                const WidgetText(text: 'Additional Comment?', font: 'monsterrat_regular', size: 15)
                              ],
                            ),
                            Visibility(
                              visible: _spacialNeed,
                              child: TextFormField(
                                maxLength: 120,
                                autofocus: false,
                                maxLines: 4,
                                controller: _specialController,
                                onTap: () {
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  counterText: '',
                                  hintText:
                                      'Add additional information here...',
                                  hintStyle: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'monsterrat_regular',
                                  ),
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.black)),
                                  contentPadding: const EdgeInsets.all(10),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          width: 1, color: Colors.black)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: size.width / 2.5,
                                  child: Form(
                                    key: _formKeyCoupon,
                                    child: TextFormField(
                                      maxLength: 8,
                                      textCapitalization: TextCapitalization.characters,
                                      enabled: !_isDone,
                                      controller: _couponController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Coupon is required!';
                                        }
                                        if (value.length != 8) {
                                          return "Invalid coupon code!";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                  width: 1, color: Colors.black
                                              )
                                          ),
                                          focusedBorder:  OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                  width: 1, color: Colors.black
                                              )
                                          ),
                                          hintText: 'Coupon',
                                          prefixIcon:const Icon(Icons.card_giftcard_outlined, size: 25, color: Colors.black),
                                          hintStyle: TextStyle(
                                              color: Colors.grey[400],
                                              fontFamily: 'caro_regular'
                                          ),
                                          contentPadding: const EdgeInsets.all(0),
                                          counterText: ''

                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: _isDone ? null : (){
                                    if(_formKeyCoupon.currentState!.validate()){
                                      setState(() {
                                        _isApply = true;
                                      });
                                      _calculateCoupon();
                                    }
                                    return;
                                  },
                                  child: Container(
                                    width: 110,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        shape: BoxShape.rectangle,
                                        color: _isDone ? Colors.grey : Colors.black

                                    ),
                                    child: _isApply ?
                                    const Center(child: WidgetText(text: 'Applying...', size: 12, color: Colors.white)) :
                                    const Center(child: WidgetText(text: 'Apply Coupon', size: 12, color: Colors.white)
                                    ),
                                  ),
                                )
                              ],
                            ),

                            Visibility(
                              visible: _isDone,
                              child: Column(
                                children: [
                                    const SizedBox(height: 10),
                                  WidgetText(
                                        text:
                                            'XAF ${formatter.format(temp)} ($couponValue%) deducted from XAF ${formatter.format(_cartController.getProductTotal)}',
                                        size: 12, font: 'monsterrat_regular',
                                        color: Colors.green),
                                  ],
                              )
                            ),

                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WidgetText(text: 'Subtotal XAF ${formatter.format(_cartController.getProductTotal - temp)}', size: 15),
                                TextButton(
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                 },
                                  child: const WidgetText(text: 'Change Order',
                                  size: 14, color: primaryColor)
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ),

                    const SizedBox(height: 10),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.delivery_dining, size: 25),
                                SizedBox(width: 10),
                                WidgetText(text: 'Delivery Information', size: 15, font: 'montserrat_bold'),
                              ],
                            ),
                            const SizedBox(height: 20),

                            Obx(() => ListTile(
                              minVerticalPadding: 0,
                              leading: const Icon(Icons.location_on_outlined),
                              title: const WidgetText(text: 'Delivery Address', size: 14),
                              trailing: WidgetText(text: authController.userAddress.value == '' ? 'Not Set' : 'Change',
                                  size: 14, color: primaryColor),
                              onTap: (){
                                showLocationSheet(context, _addressController,  Icons.location_on_outlined, 'Address');
                              }
                            )),

                            Obx(() => ListTile(
                              title: WidgetText(text: _addressController.text == '' ?
                              authController.userAddress.value : _addressController.text, size: 13,
                              font: 'monsterrat_regular'),
                            )),

                            const SizedBox(height: 10),
                            const WidgetText(text: 'Delivery Fee XAF 2,000', size: 15),
                            const SizedBox(height: 10),
                          ],
                        ),
                      )
                    ),

                    const SizedBox(height: 10),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.payment_outlined, size: 25),
                                SizedBox(width: 10),
                                WidgetText(text: 'Payment Information', size: 15, font: 'montserrat_bold'),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Radio<Payment>(
                                        value: Payment.momo,
                                        groupValue: _payment,
                                        activeColor: primaryColor,
                                        onChanged: (Payment? val) {
                                          setState(() {
                                            _payment = val;
                                            isMomoPay = true;
                                            isPointsPay = false;
                                          });
                                        }),
                                    const WidgetText(
                                        text: 'Mobile Money',
                                        size: 13),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio<Payment>(
                                        value: Payment.points,
                                        groupValue: _payment,
                                        activeColor: primaryColor,
                                        onChanged: (Payment? val) {
                                          setState(() {
                                            _payment = val;
                                            isMomoPay = false;
                                            isPointsPay = true;
                                          });
                                        }),
                                    const WidgetText(
                                        text: 'Loyalty Points',
                                        size: 13),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            Visibility(
                                visible: isMomoPay,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const WidgetText(
                                        text: 'Payment Methods',
                                        size: 13),
                                    const SizedBox(height: 10),
                                    Image.asset(
                                        'assets/images/mobile-money.jpg',
                                        scale: 5),
                                    const SizedBox(height: 20),

                                    WidgetText(text: 'You will be charged XAF ${formatter.format((_cartController.getProductTotal - temp)
                                        + 2000 )}', size: 15),

                                    Container(
                                      height: 50,
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(top: 40.0, bottom: 10.0),
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                          BorderRadius.circular(12)),
                                      child: InkWell(
                                        onTap: () async {

                                          final res = await makePaymentFunction(runtime, (_cartController.getProductTotal - temp),
                                                      authController.userEmail, authController.userPhone, authController.userName,
                                                     _getRandomId()
                                          );
                                          setState(() {
                                            _isLoading = res;
                                          });

                                        },
                                        child: _isLoading
                                            ? const Center(
                                            child: spinkit
                                            )
                                            : const Center(
                                              child: WidgetText(
                                                text: 'PLACE ORDER',
                                                color: Colors.white,
                                            ),
                                        ),
                                      ),
                                    )
                                  ],
                                )),

                            Visibility(
                                visible: isPointsPay,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const WidgetText(
                                        text: 'Payment Method',
                                        size: 13),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset('assets/images/logo.png',
                                            scale: 16),
                                        Column(
                                          children: const [
                                            WidgetText(text: 'Balance Points', size: 10, font: 'monsterrat_regular'),
                                            WidgetText(text: '45 Pts'),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 20),

                                    WidgetText(
                                        text: 'You will be charged ${divider.format(((_cartController.getProductTotal - temp) + 2000) / rate)}  Pts',
                                        size: 15),
                                    Container(
                                      height: 50,
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(top: 40.0, bottom: 10.0),
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                          BorderRadius.circular(12)),
                                      child: InkWell(
                                        onTap: () {

                                        },
                                        child: _isLoading
                                            ? const Center(
                                            child: spinkit
                                        )
                                            : const Center(
                                          child: WidgetText(
                                            text: 'PLACE ORDER',
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ],
                        ),
                      )
                    ),

                    const SizedBox(height: 50),
                  ],
                )
            )
        )
    );
  }

  Future<bool> makePaymentFunction(JavascriptRuntime runtime, int amount, var email, var phone,
      var name, var code) async {
    final jsFile = await path;

    JsEvalResult jsEvalResult =
    runtime.evaluate("""${jsFile}makePayment($amount, $email, $phone $name, $product, $code)""");

    return false;
  }

  _getRandomId() {
    //initialize the Date of the day
    var now = DateTime.now();
    var rand = Random();
    //specify the format of the date
    var formatter = DateFormat('yyyyMMddHms');
    String formattedDate = "GES${formatter.format(now)}${rand.nextInt(1000)}";
    return formattedDate;
  }

  _buildPoints(AsyncSnapshot snap) {
    totalAmount = (snap.data['r_points'] + snap.data['d_points']) * rate;
    costAmount = (_cartController.getProductTotal - temp) + 400;
    storage.write('points', '${snap.data['r_points'] + snap.data['d_points']}');
    return Column(
      children: [
        const WidgetText(text: 'Total Loyalty Points', size: 12),
        WidgetText(
            text: '${snap.data['r_points'] + snap.data['d_points']} Pts'),
      ],
    );
  }

  _calculateCoupon() async {
    String couponCode = '';
    String couponPrevious = '';
    try{
      final res = await Apis.client
          .from('coupon')
          .select();
      final response = await Apis.client
          .from('profiles')
          .select('coupon')
          .eq('id', Apis.client.auth.currentUser!.id)
          .single();
      couponPrevious = response['coupon'] ?? '';
      for(int i = 0; i < res.length; i++){
        if(_couponController.text == res[i]['code']){
          couponValue = res[i]['percent'];
          couponCode = res[i]['code'];
        }
      }

      print('\n\n\nCODE: $couponCode');
      print('\n\n\nCODE PREVIOUS: $couponPrevious');
      if(couponCode != '' && couponPrevious == ''){
        try {
          await Apis.client
              .from('profiles')
              .insert({'coupon', couponCode})
              .eq('id', Apis.client.auth.currentUser!.id);
          temp = (couponValue / 100) * (_cartController.getProductTotal);
          Get.snackbar('Hurray!', 'Coupon code applied successfully!',
              borderRadius: 0,
              backgroundColor: Colors.black,
              colorText: Colors.white);
          setState(() {
            _isApply = false;
            _isDone = true;
          });
        } catch(error){
          _showErrorMsg(error.toString());
          setState(() {
            _isApply = false;
          });
        }
      }
      else if(couponCode != '' && couponPrevious != ''){
        Get.snackbar('Oops!', 'Coupon already used!',
            borderRadius: 0,
            backgroundColor: Colors.black,
            colorText: Colors.white);
        setState(() {
          _isApply = false;
        });
      }
      else{
        _showErrorMsg('Incorrect coupon code!');
        setState(() {
          _isApply = false;
        });
      }

    } catch(error){
      _showErrorMsg('Error! Something went wrong, try again!');
      setState(() {
        _isApply = false;
      });
    }
  }

  _showErrorMsg(String msg) {
    Get.snackbar('Oops!', msg,
        borderRadius: 0, backgroundColor: Colors.red, colorText: Colors.white);
  }

  Future<void> _showSuccessDialog(BuildContext context, String orderNum) async {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/good.png', height: 80),
                    const SizedBox(height: 10),
                    const WidgetText(
                        text: 'Payment Successful!',
                        color: Colors.green,
                        size: 22),
                    const SizedBox(height: 15),
                    WidgetText(
                        text:
                            'Your payment has been successful with order number $orderNum, you will receive '
                            'notifications in your box on your order status.',
                        size: 16),
                  ],
                );
              },
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Okay'))
            ],
          );
        });
  }

  _placeOrder({
    required String orderNumber,
    required String foodId,
    required String clientId,
    required int totalAmount,
    required String city,
    required String location,
    String? paymentMethod,
    String? specialRequest,
    String? isForSomeone,
    String? phone,
    String? email,
  }) async {
    final response = await Apis.client
        .from('orders')
        .insert({
      'order_number': orderNumber,
      'food_id': foodId,
      'client_id': clientId,
      'amount': totalAmount,
      'city': city,
      'location': location,
      'payment_method': paymentMethod,
      'special_request': specialRequest,
      'is4_someone': isForSomeone,
      'phone': phone,
      'email': email
    });

    final res = await Apis.client
        .from('clients')
        .update({
      'has_order': true
    })
        .eq('id', user!.id);

    _showSuccessDialog(context, orderNumber);
  }

  showLocationSheet(BuildContext context, TextEditingController controller,
      IconData iconData, String name){
    showModalBottomSheet(
        context: context,
        isScrollControlled:true,
        isDismissible: true,
        builder: (_) {
          return LayoutBuilder(
              builder: (context, _) { //<----- very important use this context
                return AnimatedPadding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOut,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                      constraints: const BoxConstraints(
                          maxHeight: 500,
                          minHeight: 150
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              WidgetText(text: 'Edit $name'),
                              GestureDetector(
                                onTap: (){
                                  Navigator.of(context).pop();
                                },
                                child: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30.0),
                          Form(
                              key: _formKeyLocation,
                              child: TextFormField(
                                controller: controller,
                                validator: (val){
                                  if(val == '' || val!.isEmpty){
                                    return 'Enter $name';
                                  }
                                  else if(val.length < 3){
                                    return '$name too short';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter $name',
                                  prefixIcon: Icon(iconData, color: Colors.grey),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: const BorderSide(
                                          color: Colors.black
                                      )
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                              )
                          ),
                          const SizedBox(height: 40.0),
                          GestureDetector(
                            onTap: (){
                              if(_formKeyLocation.currentState!.validate()) {
                                Navigator.of(context).pop();
                              }
                              return;
                            },
                            child: Container(
                                height: 35,
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border:  Border.all(
                                        width: 2,
                                        color: Colors.black
                                    )
                                ),
                                child: const Center(
                                  child: WidgetText(text: 'Update', size: 16),
                                )
                            ),
                          ),

                          const SizedBox(height: 50.0),
                        ],
                      ),
                    )
                );
              }
          );
        }
    );
  }

}
