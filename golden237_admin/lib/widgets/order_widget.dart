import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screens/order_screen_details.dart';
import '../utils/constants.dart';

class OrderWidget extends StatelessWidget {
  OrderWidget({Key? key, required this.orderSnap}) : super(key: key);
  final AsyncSnapshot orderSnap;

  final dateFormatter = DateFormat('dd/MM/yyyy hh:mm a');
  final currencyFormatter = NumberFormat('#,###');

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return orderSnap.data.length == 0 ?
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/icons-not-found.png'),
            const SizedBox(height: 15.0),
            const Text('No delivered item yet!')
          ],
        ),
      ) :
      ListView.builder(
        itemCount: orderSnap.data.length ?? 0,
        itemBuilder: (context, index){
          return GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OrderScreenDetails(
                        oderDetailSnapshot: orderSnap, index: index)));
              },
              child: Container(
                height: size.height / 6.5,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                        width: 1.0,
                        color: Colors.white
                    )
                ),
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order #${orderSnap.data[index]['number']}', style: const TextStyle(fontSize: 17)),
                        Row(
                          children: [
                            const Text('Status: ', style: TextStyle(fontSize: 14)),
                            Text(orderSnap.data[index]['status'],
                                style: const TextStyle(fontSize: 14, color: primaryColor)),
                          ],
                        ),
                        Text(dateFormatter.format(DateTime.parse(orderSnap.data[index]['created_at'])), style: const TextStyle(fontSize: 8)),

                      ],
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Text('No. ', style: TextStyle(fontSize: 14)),
                            Text('${index + 1}', style: const TextStyle(fontSize: 24)),
                          ],
                        ),
                        Text('XAF ${currencyFormatter.format(orderSnap.data[index]['total'])}', style: const TextStyle(fontSize: 14)),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CachedNetworkImage(
                          imageUrl: "http://via.placeholder.com/200x150",
                          imageBuilder: (context, imageProvider) => Container(
                            height: 70,
                            width: 70,
                            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(orderSnap.data[index]['product']['image']),
                                  fit: BoxFit.cover,
                                )
                            ),
                          ),
                          placeholder: (context, url) => Image.asset('assets/images/no-image.jpg',
                              height: 69, width: 69),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                        Expanded(
                          child: Text('${orderSnap.data[index]['product']['name']}', style: const TextStyle(fontSize: 10.0)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
        }
    );
  }
}
