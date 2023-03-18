import 'package:flutter/material.dart';

import '../screens/about_screen.dart';
import '../screens/order_screen_details.dart';

class OrderWidget extends StatelessWidget {
  const OrderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ListView.builder(
        itemCount: 10,
        //physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: (){
              print('\n\n${index + 1} pressed!');
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OrderScreenDetails()));
            },
            child: Container(
              height: size.height / 6.5,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                      width: 1.0
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
                      Text('Order #40475', style: TextStyle(fontSize: 17)),
                      Text('Status: Pending', style: TextStyle(fontSize: 14)),
                      Text('${DateTime.now()}', style: TextStyle(fontSize: 8)),

                    ],
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text('No. ', style: TextStyle(fontSize: 14)),
                          Text('${index + 1}', style: TextStyle(fontSize: 24)),
                        ],
                      ),
                      Text('XAF 7,500', style: TextStyle(fontSize: 14)),
                    ],
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('assets/images/image4.jpg', scale: 18.0, fit: BoxFit.contain,),
                      Text('Black Men Pant', style: TextStyle(fontSize: 8.0)),
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
