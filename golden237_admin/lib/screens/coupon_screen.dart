import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/coupon_model.dart';
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

  Helper helper = Helper();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coupon'),
      ),

      // body: FutureBuilder<QuerySnapshot>(
      //   future: _productController.couponReference.get(),
      //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if (snapshot.hasError) {
      //       return const Center(
      //           child: Text('Something went wrong')
      //       );
      //     }
      //
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(
      //         child: CircularProgressIndicator(
      //           color: primaryColor,
      //           strokeWidth: 4,
      //         ),
      //       );
      //     }
      //
      //     return Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      //         child: snapshot.data?.docs.length != null ?
      //         ListView.builder(
      //             itemCount: snapshot.data?.docs.length,
      //             itemBuilder: (context, index){
      //               final Size size = MediaQuery
      //                   .of(context)
      //                   .size;
      //               final doc = snapshot.data?.docs[index];
      //               return Container(
      //                 height: size.height / 3,
      //                 width: double.infinity,
      //                 margin: const EdgeInsets.only(bottom: 25.0),
      //                 decoration: BoxDecoration(
      //                     border: Border.all(
      //                       color: primaryColor,
      //                       width: 2,
      //                     ),
      //                     borderRadius: const BorderRadius.only(
      //                         topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0))
      //                 ),
      //                 child: Column(
      //                   children: [
      //                     Container(
      //                         height: 75.0,
      //                         width: double.infinity,
      //                         //margin: const EdgeInsets.only(top: 12.0),
      //                         padding: const EdgeInsets.symmetric(horizontal: 12.0),
      //                         decoration: const BoxDecoration(
      //                             color: primaryColor,
      //                             borderRadius: BorderRadius.only(
      //                                 topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0))
      //                         ),
      //                         child: Row(
      //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                           children: [
      //                             Text(doc!['start']),
      //                             Container(
      //                               height: 65.0,
      //                               width: 70.0,
      //                               decoration: BoxDecoration(
      //                                   shape: BoxShape.circle,
      //                                   border: Border.all(
      //                                     color: Colors.white,
      //                                     width: 3,
      //                                   )
      //                               ),
      //                               child: Center(child: Text('${doc['percent']}%', style: const TextStyle(fontSize: 25))),
      //                             ),
      //                             Text(doc['start']),
      //                           ],
      //                         )
      //                     ),
      //                     Expanded(
      //                         child: Column(
      //                           children: [
      //                             const SizedBox(height: 12.0),
      //                             Text(doc['code'], style: const TextStyle(fontSize: 20)),
      //                             const SizedBox(height: 12.0),
      //                             Text(doc['desc'], maxLines: 3, overflow: TextOverflow.ellipsis),
      //                             const SizedBox(height: 12.0),
      //                             Row(
      //                               mainAxisAlignment: MainAxisAlignment.spaceAround,
      //                               children: [
      //                                 ElevatedButton(
      //                                     style: ElevatedButton.styleFrom(
      //                                         backgroundColor: Colors.green
      //                                     ),
      //                                     onPressed: (){
      //                                       Navigator.of(context).push(MaterialPageRoute(
      //                                           builder: (context) => AddCoupon(isAdd: false,
      //                                           percent: '${doc['percent']}',
      //                                           start: doc['start'],
      //                                           end: doc['end'],
      //                                           code: doc['code'],
      //                                           desc: doc['desc'],
      //                                           )));
      //                                     },
      //                                     child: Row(
      //                                       children: [
      //                                         Icon(Icons.edit_outlined, color: Colors.white,),
      //                                         SizedBox(width: 8.0),
      //                                         Text('Edit', style: TextStyle(color: Colors.white))
      //                                       ],
      //                                     )
      //                                 ),
      //                                 ElevatedButton(
      //                                     style: ElevatedButton.styleFrom(
      //                                         backgroundColor: Colors.red
      //                                     ),
      //                                     onPressed: (){
      //                                       showSimpleDialog(context, doc);
      //                                       Navigator.of(context).pop();
      //                                     },
      //                                     child: Row(
      //                                       children: const [
      //                                         Icon(Icons.delete_outline, color: Colors.white,),
      //                                         SizedBox(width: 8.0),
      //                                         Text('Delete', style: TextStyle(color: Colors.white))
      //                                       ],
      //                                     )
      //                                 ),
      //                               ],
      //                             )
      //                           ],
      //                         )
      //                     )
      //                   ],
      //                 ),
      //               );
      //             }
      //         ) :
      //         const Center(
      //             child: Text('No coupon found!')
      //         )
      //     );
      //   },
      // ),

      floatingActionButton: CustomFabWidget(
        route: AddCoupon(isAdd: true,), text: 'Coupon', width: 120.0,),
    );
  }

  showSimpleDialog(BuildContext context, var ref){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text('Are you sure you want to delete ${ref['code']}'),
              SizedBox(height: 20.0),
              Visibility(
                visible: isLoading,
                child: CircularProgressIndicator()
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: primaryColor,
              ),
              child: const Text("Cancel", style: TextStyle(color: Colors.black54)),
            ),
          ),

          TextButton(
            onPressed: () {
              setState(() {
                isLoading = !isLoading;
              });
              deleteCoupon(context, ref['id']);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: primaryColor,
              ),
              child: const Text("Delete", style: TextStyle(color: Colors.black54)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deleteCoupon(BuildContext context, String ref) async{
  //   _productController.categoryReference.doc(ref).delete().then((value) {
  //     Navigator.of(context).pop();
  //     Get.snackbar('Success!', 'Coupon code deleted successfully!!.',
  //         colorText: Colors.white, backgroundColor: Colors.green,
  //         borderRadius: 0
  //     );
  //   }, onError: (e){
  //     setState(() {
  //       isLoading = !isLoading;
  //     });
  //     Get.snackbar('Error!', e.toString(),
  //         colorText: Colors.white, backgroundColor: Colors.red,
  //         borderRadius: 0
  //     );
  //   }
  //   );
   }

}
