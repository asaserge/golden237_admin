import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/order_controller.dart';
import '../utils/constants.dart';

class OrderScreenDetails extends StatefulWidget {
  const OrderScreenDetails({Key? key}) : super(key: key);

  @override
  State<OrderScreenDetails> createState() => _OrderScreenDetailsState();
}

class _OrderScreenDetailsState extends State<OrderScreenDetails> with TickerProviderStateMixin{

  bool step2 = false;
  bool step3 = false;
  bool step4 = false;
  bool step5 = false;
  bool step6 = false;
  late TextEditingController _controllerLat;
  late TextEditingController _controllerLon;
  final dateFormatter = DateFormat('dd/MM/yyyy hh:mm a');
  final currencyFormatter = NumberFormat('#,###');
  OrderController orderController = Get.find();
  bool _isLoading = false;
  final dynamic orderData = Get.arguments;

  @override
  void initState() {
    _controllerLat = TextEditingController();
    _controllerLon = TextEditingController();
    if(orderData['status'] == 'Pending'){
      step2 = true;
    }
    else if(orderData['status'] == 'Picked Up'){
      step2 = true;
      step3 = true;
    }
    else if(orderData['status'] == 'In Transit'){
      step2 = true;
      step3 = true;
      step4 = true;
    }
    else if(orderData['status'] == 'Arrived'){
      step2 = true;
      step3 = true;
      step4 = true;
      step5 = true;
    }
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
        title: Text('Order #${orderData['number']}'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('Status: ', style: TextStyle(fontSize: 14)),
                      Text(orderData['status'],
                          style: const TextStyle(fontSize: 14, color: primaryColor)),
                    ],
                  ),
                  Text(dateFormatter.format(DateTime.parse(
                      orderData['created_at'])), style: const TextStyle(fontSize: 14)),
                ],
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  CachedNetworkImage(
                    imageUrl: "http://via.placeholder.com/200x150",
                    imageBuilder: (context, imageProvider) => Container(
                      height: size.height / 5.5,
                      width: size.width / 2.5,
                      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: Colors.white,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(orderData['product']['image']),
                            fit: BoxFit.cover,
                          )
                      ),
                    ),
                    placeholder: (context, url) => Image.asset('assets/images/no-image.jpg',
                        height: size.height / 5.5, width: size.width / 2.5),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),

                  const SizedBox(width: 10.0),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text('Product Information',
                              style: TextStyle(fontSize: 15.0, color: Colors.green)),
                          const SizedBox(height: 8.0),
                          Text('XAF ${currencyFormatter.format(orderData['product']['price'])}'
                              , style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4.0),
                          Text(orderData['product']['name'],
                              style: const TextStyle(fontSize: 15.0)),
                          const SizedBox(height: 4.0),

                          Text('Brand: ${orderData['product']['brand']}', style: const TextStyle(fontSize: 13.0)),
                          Text('Quantity: ${orderData['quantity']}', style: const TextStyle(fontSize: 13.0)),
                          Text('SKU: ${orderData['product']['sku']}', style: const TextStyle(fontSize: 13.0)),
                          Text('Size: ${orderData['product']['size']}', style: const TextStyle(fontSize: 13.0)),
                          const SizedBox(height: 8.0),
                          Text('Subtotal XAF ${currencyFormatter.format(orderData['product']['price'] *
                              orderData['quantity'])}', style: const TextStyle(fontSize: 15.0)),
                          const SizedBox(height: 4.0),
                        ],
                      ),
                    ],
                  )


                ],
              ),

              const SizedBox(height: 10),

              Text('Customer Note: ${orderData['note']}',
                  style: const TextStyle(fontSize: 14.0)),
              const SizedBox(height: 5.0),

              Divider(
                  thickness: 2,
                  color: Get.isDarkMode ? Colors.white38 : Colors.white
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  orderData['status'] != 'Delivered' ?
                  const Text('Update Order Status', style: TextStyle(fontSize: 17.0,
                  fontWeight: FontWeight.w500, color: primaryColor)) :
                  const Text('Order has been marked Completed!', style: TextStyle(fontSize: 17.0,
                      fontWeight: FontWeight.w500, color: Colors.red))
                ],
              ),
              const SizedBox(height: 15.0),


              Visibility(
                visible: orderData['status'] != 'Delivered',
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                value: true,
                                activeColor: primaryColor,
                                onChanged: (val){

                                }
                            ),
                            const Text('Confirmed', style: TextStyle(fontSize: 13.0)),
                          ],
                        ),

                        const Icon(Icons.arrow_forward_outlined, size: 15),

                        Row(
                          children: [
                            Checkbox(
                                value: step2,
                                activeColor: primaryColor,
                                onChanged: (val){
                                  if(step2 == false){
                                    setState(() {
                                      step2 = true;
                                    });
                                    orderController.updateOrderStatus(
                                        orderData['id'], 'Pending');
                                    ScaffoldMessenger.of(context).showSnackBar(snackBarUpdated);
                                  }
                                  else{
                                    if(step3 == true){
                                      ScaffoldMessenger.of(context).showSnackBar(snackBarLeading);
                                    }
                                    else{
                                      setState(() {
                                        step2 = false;
                                      });
                                      orderController.updateOrderStatus(
                                          orderData['id'], 'Confirmed');
                                      ScaffoldMessenger.of(context).showSnackBar(snackBarUpdated);
                                    }
                                  }
                                }
                            ),
                            const Text('Pending', style: TextStyle(fontSize: 13.0)),
                          ],
                        ),

                        const Icon(Icons.arrow_forward_outlined, size: 15),

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
                                      orderController.updateOrderStatus(
                                          orderData['id'], 'Picked Up');
                                      ScaffoldMessenger.of(context).showSnackBar(snackBarUpdated);
                                    }
                                    else{
                                      ScaffoldMessenger.of(context).showSnackBar(snackBarPreceding);
                                    }
                                  }
                                  else{
                                    if(step4 == false && step5 == false && step6 == false){
                                      setState(() {
                                        step3 = val!;
                                      });
                                      orderController.updateOrderStatus(
                                          orderData['id'], 'Pending');
                                      ScaffoldMessenger.of(context).showSnackBar(snackBarUpdated);
                                    }
                                    else{
                                      ScaffoldMessenger.of(context).showSnackBar(snackBarPreceding);
                                    }
                                  }
                                }
                            ),
                            const Text('Picked', style: TextStyle(fontSize: 13.0)),
                          ],
                        ),
                      ],
                    ),

                    const Icon(Icons.arrow_downward, size: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            const Text('Delivered', style: TextStyle(fontSize: 13.0)),
                            Checkbox(
                                value: step6,
                                activeColor: primaryColor,
                                onChanged: (val){
                                  if(step6 == false){
                                    if(step5 == true){
                                      showConfirmDeliverySheet();
                                    }
                                    else{
                                      ScaffoldMessenger.of(context).showSnackBar(snackBarLeading);
                                    }
                                  }
                                  else{
                                    setState(() {
                                      step6 = val!;
                                    });
                                    orderController.updateOrderStatus(
                                        orderData['id'], 'Arrived');
                                    ScaffoldMessenger.of(context).showSnackBar(snackBarUpdated);
                                  }
                                }
                            ),
                          ],
                        ),

                        const Icon(Icons.arrow_back_outlined, size: 15),

                        Row(
                          children: [
                            const Text('Arrived', style: TextStyle(fontSize: 15.0)),
                            Checkbox(
                                value: step5,
                                activeColor: primaryColor,
                                onChanged: (val){
                                  if(step5 == false){
                                    if(step4 == true){
                                      setState(() {
                                        step5 = val!;
                                      });
                                      orderController.updateOrderStatus(
                                          orderData['id'], 'Arrived');
                                      ScaffoldMessenger.of(context).showSnackBar(snackBarUpdated);
                                    }
                                    else{
                                      ScaffoldMessenger.of(context).showSnackBar(snackBarPreceding);
                                    }
                                  }
                                  else{
                                    if(step6 == false){
                                      setState(() {
                                        step5 = val!;
                                      });
                                      orderController.updateOrderStatus(
                                          orderData['id'], 'In Transit');
                                      ScaffoldMessenger.of(context).showSnackBar(snackBarUpdated);
                                    }
                                    else{
                                      ScaffoldMessenger.of(context).showSnackBar(snackBarLeading);
                                    }
                                  }
                                }
                            ),
                          ],
                        ),

                        const Icon(Icons.arrow_back_outlined, size: 15),

                        Row(
                          children: [
                            const Text('Transit', style: TextStyle(fontSize: 13.0)),
                            Checkbox(
                                value: step4,
                                activeColor: primaryColor,
                                onChanged: (val){
                                  if(step4 == false){
                                    if(step3 == true){
                                      setState(() {
                                        step4 = val!;
                                      });
                                      orderController.updateOrderStatus(
                                          orderData['id'], 'In Transit');
                                      ScaffoldMessenger.of(context).showSnackBar(snackBarUpdated);
                                    }
                                    else{
                                      ScaffoldMessenger.of(context).showSnackBar(snackBarPreceding);
                                    }
                                  }
                                  else{
                                    if(step5 == false && step6 == false){
                                      setState(() {
                                        step4 = val!;
                                      });
                                      orderController.updateOrderStatus(
                                          orderData['id'], 'Picked Up');
                                      ScaffoldMessenger.of(context).showSnackBar(snackBarUpdated);
                                    }
                                    else{
                                      ScaffoldMessenger.of(context).showSnackBar(snackBarLeading);
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
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  CachedNetworkImage(
                    imageUrl: "http://via.placeholder.com/200x150",
                    imageBuilder: (context, imageProvider) => Container(
                      height: size.height / 5.5,
                      width: size.width / 2.5,
                      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: Colors.white,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(orderData['profiles']['avatar_url']),
                            fit: BoxFit.cover,
                          )
                      ),
                    ),
                    placeholder: (context, url) => Image.asset('assets/images/no-image.jpg',
                        height: size.height / 5.5, width: size.width / 2.5),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),

                  const SizedBox(width: 10.0),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text('Customer Information',
                              style: TextStyle(fontSize: 15.0, color: Colors.green)),
                          const SizedBox(height: 8.0),
                          Text(orderData['profiles']['full_name'] ?? '',
                              style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4.0),
                          Text('Phone: ${orderData['profiles']['phone']}', style: const TextStyle(fontSize: 13.0)),
                          SizedBox(
                            width:  size.width / 2.5,
                            child: Text('Home Address: ${orderData['address']}', maxLines: 2, overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 13.0)),
                          ),
                          Text('Payment ${orderData['payment']}', style: const TextStyle(fontSize: 13.0)),
                          const SizedBox(height: 8.0),
                          Text('Total XAF ${currencyFormatter.format(orderData['total'])}',
                              style: const TextStyle(fontSize: 15.0)),
                          const SizedBox(height: 4.0),
                        ],
                      ),
                    ],
                  )


                ],
              ),

              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  orderData['status'] == 'Delivered' ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Delivered to', style: TextStyle(fontSize: 11.0)),
                      Text(orderData['address'], maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14.0)),
                    ],
                  ) :
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Deliver to', style: TextStyle(fontSize: 11.0)),
                      Text(orderData['address'], maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14.0)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
              Divider(
                  thickness: 2,
                  color: Get.isDarkMode ? Colors.white38 : Colors.white
              ),
              const SizedBox(height: 20),


              Visibility(
                visible: orderData['status'] != 'Delivered',
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: (){
                            _makePhoneCall(orderData['profiles']['phone']);
                          },
                          child: Container(
                            height: 45,
                            width: size.width / 4.5,
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(15.0)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const [
                                Icon(Icons.call_outlined, size: 16.0),
                                Text('Call')
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            _makeWhatsApp(orderData['profiles']['phone']);
                          },
                          child: Container(
                            height: 45,
                            width: size.width / 3.3,
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(15.0)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const [
                                Icon(Icons.whatsapp_outlined, size: 16.0),
                                Text('WhatsApp')
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 45),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: (){
                            _sendEmail(orderData['profiles']['email']);
                          },
                          child: Container(
                            height: 45,
                            width: size.width / 4.0,
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(15.0)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const [
                                Icon(Icons.email_outlined, size: 16.0),
                                Text('Email')
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              _isLoading = true;
                            });
                            showDeleteBottomSheet();
                          },
                          child: Container(
                            height: 45,
                            width: size.width / 2.5,
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15.0)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const [
                                Icon(Icons.cancel_outlined),
                                Text('Cancel Order')
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ],
                )
              )


            ],
          ),
        ),
      ),
    );
  }


  showDeleteBottomSheet(){
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30.0),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('WARNING'
                    , style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 12.0),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('You are about to cancel this order, this process can not be undone!', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,)),
              ),
              Image.asset('assets/icons/warning.png'),
              const SizedBox(height: 10.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                  ),

                  const SizedBox(width: 60.0),

                  GestureDetector(
                    onTap: (){
                      orderController.deleteOrders(orderData['id']);
                      ScaffoldMessenger.of(context).showSnackBar(snackBarSuccess);
                      setState(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: primaryColor
                      ),
                      child: !_isLoading ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                        child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2,
                        ),
                      ) :
                      const Text('Proceed', style: TextStyle(color: Colors.white)),
                    ),
                  ),

                  const SizedBox(width: 30.0),
                ],
              ),
              const SizedBox(height: 25.0),
            ],

          );
        });
  }

  showConfirmDeliverySheet(){
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30.0),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('FINAL NOTICE'
                    , style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 12.0),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('You are about to confirm you have delivered this order to the client. After doing so, the process can not be undone!'
                    , style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
              ),
              Image.asset('assets/icons/warning.png'),
              const SizedBox(height: 10.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                  ),

                  const SizedBox(width: 60.0),

                  GestureDetector(
                    onTap: (){
                      orderController.updateOrderStatus(
                          orderData['id'], 'Delivered');
                      ScaffoldMessenger.of(context).showSnackBar(snackBarUpdated);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: primaryColor
                      ),
                      child: const Text('Confirm', style: TextStyle(color: Colors.white)),
                    ),
                  ),

                  const SizedBox(width: 30.0),
                ],
              ),
              const SizedBox(height: 25.0),
            ],

          );
        });
  }

  final snackBarLeading = SnackBar(
    content: const Text('Please update the leading step first!', style: TextStyle(color: Colors.white)),
    backgroundColor: (Colors.red),
    action: SnackBarAction(
      label: 'Dismiss',
      textColor: Colors.black,
      onPressed: () {

      },
    ),
  );

  final snackBarPreceding = SnackBar(
    content: const Text('Please update the preceding step first!', style: TextStyle(color: Colors.white)),
    backgroundColor: (Colors.red),
    action: SnackBarAction(
      label: 'Dismiss',
      textColor: Colors.black,
      onPressed: () {

      },
    ),
  );

  final snackBarLaunch = SnackBar(
    content: const Text('Oops! Failed to launch!', style: TextStyle(color: Colors.white)),
    backgroundColor: (Colors.red),
    action: SnackBarAction(
      label: 'Dismiss',
      textColor: Colors.black,
      onPressed: () {

      },
    ),
  );

  final snackBarFailed = SnackBar(
    content: const Text('Failed to cancel order!', style: TextStyle(color: Colors.white)),
    backgroundColor: (Colors.red),
    action: SnackBarAction(
      label: 'Dismiss',
      textColor: Colors.black,
      onPressed: () {

      },
    ),
  );

  final snackBarSuccess = SnackBar(
    content: const Text('Order has been cancelled & deleted!', style: TextStyle(color: Colors.white)),
    backgroundColor: (Colors.green),
    action: SnackBarAction(
      label: 'Dismiss',
      textColor: Colors.black,
      onPressed: () {

      },
    ),
  );

  final snackBarUpdated = SnackBar(
    content: const Text('Order has been updated!', style: TextStyle(color: Colors.white)),
    backgroundColor: (Colors.green),
    action: SnackBarAction(
      label: 'Dismiss',
      textColor: Colors.black,
      onPressed: () {

      },
    ),
  );

  Future<void> _makePhoneCall(String phoneNumber) async {
    var callURlAndroid = "tel:$phoneNumber";
    if(await canLaunchUrl(Uri.parse(callURlAndroid))){
      await launchUrl(Uri.parse(callURlAndroid));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(snackBarLeading);
    }
  }

  Future<void> _makeWhatsApp(String phoneNumber) async {
    String msg = 'Hi there, I am writing on behave of Godlden237 E-commerce platform';
    var whatsappURlAndroid = "whatsapp://send?phone=$phoneNumber&text=$msg";
    if(await canLaunchUrl(Uri.parse(whatsappURlAndroid))){
      await launchUrl(Uri.parse(whatsappURlAndroid));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(snackBarLeading);
    }

  }

  Future<void> _sendEmail(String email) async {
    var emailURlAndroid = "mailto:$email";
    if(await canLaunchUrl(Uri.parse(emailURlAndroid))){
      await launchUrl(Uri.parse(emailURlAndroid));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(snackBarLeading);
    }
  }

}
