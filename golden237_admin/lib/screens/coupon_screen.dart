import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../controller/order_controller.dart';
import '../models/coupon_model.dart';
import '../services/apis.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/custom_fab_widget.dart';
import 'add_coupon.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({Key? key}) : super(key: key);

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {

  bool isLoading = false;
  OrderController orderController = Get.find();
  final dateFormatter = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coupon'),

        actions: [
          IconButton(
              onPressed: (){
                setState(() {});
              },
              icon: const Icon(Icons.refresh_outlined)
          ),
          const SizedBox(
            width: 20.0,
          )
        ],
      ),

      body: FutureBuilder(
          future: orderController.getCoupons(),
          builder: (context, snapshot){
            if(snapshot.hasError) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  color: Colors.white,
                  child: Text('Something went wrong: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red)
                  ),
                ),
              );
            }
            if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){
              return couponWidget(snapshot);
            }
            else{
              return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                    strokeWidth: 3,
                  )
              );
            }
          }
      ),

      floatingActionButton: CustomFabWidget(
        route: AddCoupon(isAdd: true,), text: 'Coupon', width: 120.0,),
    );
  }

  Widget couponWidget(AsyncSnapshot snap){
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: snap.data.length == 0 ?
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icons/icons-not-found.png'),
              const SizedBox(height: 15.0),
              const Text('No coupon available!')
            ],
          ),
        ) :
        ListView.builder(
            itemCount: snap.data.length ?? 0,
            itemBuilder: (context, index){
              final Size size = MediaQuery
                  .of(context)
                  .size;
              final doc = snap.data[index];
              return Container(
                height: size.height / 3,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 25.0),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0))
                ),
                child: Column(
                  children: [
                    Container(
                        height: 75.0,
                        width: double.infinity,
                        //margin: const EdgeInsets.only(top: 12.0),
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Start Date', style: TextStyle(fontSize: 10)),
                                Text(dateFormatter.format(DateTime.parse(snap.data[index]['start']))),
                              ],
                            ),
                            Container(
                              height: 65.0,
                              width: 70.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  )
                              ),
                              child: Center(child: Text('${snap.data[index]['percent']}%', style: const TextStyle(fontSize: 25))),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Start End', style: TextStyle(fontSize: 10)),
                                Text(dateFormatter.format(DateTime.parse(snap.data[index]['end']))),
                              ],
                            ),
                          ],
                        )
                    ),
                    Expanded(
                        child: Column(
                          children: [
                            const SizedBox(height: 8.0),
                            Text('${snap.data[index]['code']}', style: const TextStyle(fontSize: 20)),
                            const SizedBox(height: 8.0),
                           Stack(
                             children: [
                               Container(
                                 width: double.infinity,
                                 height: 100,
                                 decoration: BoxDecoration(
                                     image: DecorationImage(
                                         image: NetworkImage(snap.data[index]['image'])
                                     )
                                 ),
                               ),
                               Positioned(
                                 bottom: 15,
                                 right: 0,
                                  child: ElevatedButton(
                                     style: ElevatedButton.styleFrom(
                                         backgroundColor: Colors.green
                                     ),
                                     onPressed: (){
                                       Navigator.of(context).push(MaterialPageRoute(
                                           builder: (context) => AddCoupon(isAdd: false,
                                             percent: '${snap.data[index]['percent']}',
                                             start: snap.data[index]['start'],
                                             end: snap.data[index]['end'],
                                             code: snap.data[index]['code'],
                                             desc: snap.data[index]['desc'],
                                           )));
                                     },
                                     child: Row(
                                       children: [
                                         Icon(Icons.edit_outlined, color: Colors.white,),
                                         SizedBox(width: 8.0),
                                         Text('Edit', style: TextStyle(color: Colors.white))
                                       ],
                                     )
                                 )
                               ),
                               Positioned(
                                 bottom: 15,
                                 left: 8,
                                 child:ElevatedButton(
                                     style: ElevatedButton.styleFrom(
                                         backgroundColor: Colors.red
                                     ),
                                     onPressed: (){

                                       showDeleteBottomSheet(snap.data[index]['code'], snap.data[index]['id']);
                                       Navigator.of(context).pop();
                                     },
                                     child: Row(
                                       children: const [
                                         Icon(Icons.delete_outline, color: Colors.white,),
                                         SizedBox(width: 8.0),
                                         Text('Delete', style: TextStyle(color: Colors.white))
                                       ],
                                     )
                                 )
                               ),
                             ],
                           ),
                            const SizedBox(height: 12.0),
                          ],
                        )
                    )
                  ],
                ),
              );
            }
        )

    );

  }

  showDeleteBottomSheet(String name, String id){
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
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Are you sure you want to delete $name?', textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400,)),
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
                      orderController.deleteCouponMethod(id);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: primaryColor
                      ),
                      child: const Text('Proceed', style: TextStyle(color: Colors.white)),
                    ),
                  ),

                  const SizedBox(width: 30.0),
                ],
              ),
              const SizedBox(height: 25.0),
            ],

          );
        }
      );
  }




}
