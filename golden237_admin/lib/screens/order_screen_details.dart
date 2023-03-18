import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../utils/constants.dart';
import '../widgets/custom_input.dart';
import '../widgets/header_widget.dart';
import '../widgets/order_widget.dart';
import '../widgets/subcat_input.dart';

class OrderScreenDetails extends StatefulWidget {
  const OrderScreenDetails({Key? key}) : super(key: key);

  @override
  State<OrderScreenDetails> createState() => _OrderScreenDetailsState();
}

class _OrderScreenDetailsState extends State<OrderScreenDetails> with TickerProviderStateMixin{

  bool step1 = true;
  bool step2 = false;
  bool step3 = false;
  bool step4 = false;
  bool step5 = false;
  bool step6 = false;
  late TextEditingController _controllerLat;
  late TextEditingController _controllerLon;

  @override
  void initState() {
    _controllerLat = TextEditingController();
    _controllerLon = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controllerLat.dispose();
    _controllerLon.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order #40475 Details'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Status: Pending', style: TextStyle(fontSize: 14)),
                  Text('${DateTime.now()}', style: TextStyle(fontSize: 14)),
                ],
              ),

              SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Image.asset('assets/images/image4.jpg', scale: 7.0, fit: BoxFit.contain,),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Black Men Pant', style: TextStyle(fontSize: 15.0)),
                          Text('XAF 7,500', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                          Text('Brand: Fervente', style: TextStyle(fontSize: 13.0)),
                          Text('Quanty: 2', style: TextStyle(fontSize: 13.0)),
                          Text('SKU: 14256748542', style: TextStyle(fontSize: 13.0)),
                        ],
                      ),

                      Divider(
                        thickness: 2,
                        color: Get.isDarkMode ? Colors.white38 : Colors.black54
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('City: Kumba', style: TextStyle(fontSize: 13.0)),
                          Text('Address: Hausa Quater 4', style: TextStyle(fontSize: 13.0)),
                          Text('Contact: +237 678424794', style: TextStyle(fontSize: 13.0)),
                        ],
                      ),
                    ],
                  )


                ],
              ),

              SizedBox(height: 10),
              Divider(
                  thickness: 2,
                  color: Get.isDarkMode ? Colors.white38 : Colors.black54
              ),
              const SizedBox(height: 20),

              const Text('Update Order Status', style: TextStyle(fontSize: 15.0,
              fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
              const SizedBox(height: 15.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                              value: step1,
                              activeColor: primaryColor,
                              onChanged: (val){

                              }
                          ),
                          const Text('Confirmed', style: TextStyle(fontSize: 15.0)),
                        ],
                      ),

                      const Icon(Icons.arrow_forward_outlined, size: 18),

                      Row(
                        children: [
                          Checkbox(
                              value: step2,
                              activeColor: primaryColor,
                              onChanged: (val){
                                setState(() {
                                  step2 = val!;
                                });
                              }
                          ),
                          const Text('Pending', style: TextStyle(fontSize: 15.0)),
                        ],
                      ),

                      const Icon(Icons.arrow_forward_outlined, size: 18),

                      Row(
                        children: [
                          Checkbox(
                            value: step3,
                            activeColor: primaryColor,
                            onChanged: (val){
                              if(step3 == false){
                                if(step2 == true){
                                  setState(() {
                                    step3 = val!;
                                  });
                                }
                                else{
                                  Get.snackbar('', 'Please update the previous step first!',
                                      snackPosition: SnackPosition.BOTTOM, colorText: Colors.white,
                                      backgroundColor: Colors.red, borderRadius: 0);
                                }
                              }
                              else{
                                if(step4 == false && step5 == false && step6 == false){
                                  setState(() {
                                    step3 = val!;
                                  });
                                }
                                else{
                                  Get.snackbar('', 'Please update the future steps first!',
                                      snackPosition: SnackPosition.BOTTOM, colorText: Colors.white,
                                      backgroundColor: Colors.red, borderRadius: 0);
                                }
                              }
                            }
                          ),
                          const Text('Packaging', style: TextStyle(fontSize: 15.0)),
                        ],
                      ),
                    ],
                  ),

                  const Icon(Icons.arrow_downward, size: 18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          const Text('Delivered', style: TextStyle(fontSize: 15.0)),
                          Checkbox(
                              value: step6,
                              activeColor: primaryColor,
                              onChanged: (val){
                                if(step6 == false){
                                  if(step2 == true && step3 == true && step4 == true && step5 == true){
                                    setState(() {
                                      step6 = val!;
                                    });
                                  }
                                  else{
                                    Get.snackbar('', 'Please update the previous step first!',
                                        snackPosition: SnackPosition.BOTTOM, colorText: Colors.white,
                                        backgroundColor: Colors.red, borderRadius: 0);
                                  }
                                }
                                else{
                                  setState(() {
                                    step6 = val!;
                                  });
                                }
                              }
                          ),
                        ],
                      ),

                      const Icon(Icons.arrow_back_outlined, size: 18),

                      Row(
                        children: [
                          const Text('Arrived', style: TextStyle(fontSize: 15.0)),
                          Checkbox(
                              value: step5,
                              activeColor: primaryColor,
                              onChanged: (val){
                                if(step5 == false){
                                  if(step2 == true && step3 == true && step4 == true){
                                    setState(() {
                                      step5 = val!;
                                    });
                                  }
                                  else{
                                    Get.snackbar('', 'Please update the previous step first!',
                                        snackPosition: SnackPosition.BOTTOM, colorText: Colors.white,
                                        backgroundColor: Colors.red, borderRadius: 0);
                                  }
                                }
                                else{
                                  if(step6 == false){
                                    setState(() {
                                      step5 = val!;
                                    });
                                  }
                                  else{
                                    Get.snackbar('', 'Please update the future steps first!',
                                        snackPosition: SnackPosition.BOTTOM, colorText: Colors.white,
                                        backgroundColor: Colors.red, borderRadius: 0);
                                  }
                                }
                              }
                          ),
                        ],
                      ),

                      const Icon(Icons.arrow_back_outlined, size: 18),

                      Row(
                        children: [
                          const Text('In-Transit', style: TextStyle(fontSize: 15.0)),
                          Checkbox(
                            value: step4,
                            activeColor: primaryColor,
                            onChanged: (val){
                              if(step4 == false){
                                if(step2 == true && step3 == true){
                                  setState(() {
                                    step4 = val!;
                                  });
                                }
                                else{
                                  Get.snackbar('', 'Please update the previous step first!',
                                      snackPosition: SnackPosition.BOTTOM, colorText: Colors.white,
                                      backgroundColor: Colors.red, borderRadius: 0);
                                }
                              }
                              else{
                                if(step5 == false && step6 == false){
                                  setState(() {
                                    step4 = val!;
                                  });
                                }
                                else{
                                  Get.snackbar('', 'Please update the future steps first!',
                                      snackPosition: SnackPosition.BOTTOM, colorText: Colors.white,
                                      backgroundColor: Colors.red, borderRadius: 0);
                                }
                              }
                            }
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 10),
              Divider(
                  thickness: 2,
                  color: Get.isDarkMode ? Colors.white38 : Colors.black54
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      //TODO Call client number
                    },
                    child: Container(
                      height: 45,
                      width: size.width / 5,
                      decoration: BoxDecoration(
                        color: Get.isDarkMode ? Colors.black : primaryColor,
                        borderRadius: BorderRadius.circular(8.0)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon((Icons.call_outlined)),
                          Text('Call')
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      //TODO WhatsApp client number
                    },
                    child: Container(
                      height: 45,
                      width: size.width / 3.7,
                      decoration: BoxDecoration(
                        color: Get.isDarkMode ? Colors.black : primaryColor,
                        borderRadius: BorderRadius.circular(8.0)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon((Icons.whatsapp_outlined)),
                          Text('WhatsApp')
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      //TODO Call client number
                    },
                    child: Container(
                      height: 45,
                      width: size.width / 3.7,
                      decoration: BoxDecoration(
                        color: Get.isDarkMode ? Colors.black : primaryColor,
                        borderRadius: BorderRadius.circular(8.0)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon((Icons.directions_outlined)),
                          Text('Directions')
                        ],
                      ),
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 25),

              SubCatInput(
                controller1: _controllerLat,
                controller2: _controllerLon,
                hintText1: 'Latitude',
                hintText2: 'Longitude',
                icon: Icons.double_arrow_sharp,
                onChange2: (val){

                },
              ),

              const SizedBox(height: 45),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      //TODO WhatsApp client number
                    },
                    child: Container(
                      height: 45,
                      width: size.width / 2.5,
                      decoration: BoxDecoration(
                          color: Get.isDarkMode ? Colors.black : primaryColor,
                          borderRadius: BorderRadius.circular(8.0)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon((Icons.send)),
                          Text('Send Condinates')
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      //TODO Call client number
                    },
                    child: Container(
                      height: 45,
                      width: size.width / 2.5,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8.0)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.cancel_outlined),
                          Text('Cancel Order')
                        ],
                      ),
                    ),
                  ),

                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
}
