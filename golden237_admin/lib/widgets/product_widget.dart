
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden237_admin/screens/product_detail_screen.dart';
import 'package:intl/intl.dart';

import '../services/apis.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import 'color_widget.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({Key? key, required this.productSnapshot,
  required this.index, required this.subCat}) : super(key: key);
  final AsyncSnapshot productSnapshot;
  final int index;
  final String subCat;

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {

  Helper helper = Helper();
  bool isLoading = false;
  final decimalFormatter = NumberFormat('#.#');

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onLongPress: (){
        //helper.showOptionDialog(context, 1);
      },
      child: Container(
        height: size.height / 4.8,
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
                width: 2.0,
                color: Colors.white38
            )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: "http://via.placeholder.com/200x150",
                  imageBuilder: (context, imageProvider) => Container(
                    height: size.height / 4.8,
                    width: size.width / 2.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: NetworkImage(widget.productSnapshot.data[widget.index]['image']),
                        fit: BoxFit.contain,
                        // colorFilter:
                        // const ColorFilter.mode(Colors.white70, BlendMode.colorBurn)
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Positioned(
                  top: 2,
                  left: 2,
                  child: Card(
                    elevation: 2,
                    child: RotatedBox(
                      quarterTurns: 135,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0,
                            vertical: 2.0),
                        child: Text(widget.productSnapshot.data[widget.index]['is_new'] ? 'New' : 'Used'
                            ,style: const TextStyle(fontSize: 12.0, color: Colors.green)
                        ),
                      ),

                    ),
                  ),
                ),

                Visibility(
                  visible: widget.productSnapshot.data[widget.index]['discount'] > 0 ? true : false,
                  child: Positioned(
                    top: 0,
                    right: 2,
                    child: Card(
                      color: Colors.red,
                      elevation: 2,
                      child: RotatedBox(
                        quarterTurns: 180,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0,
                              vertical: 3.0),
                          child: Text('${decimalFormatter.format((widget.productSnapshot.data[widget.index]['price'] -
                              widget.productSnapshot.data[widget.index]['discount']) /
                              widget.productSnapshot.data[widget.index]['price'] * 100)}% OFF'
                              ,style: const TextStyle(fontSize: 11.0)
                          ),
                        ),

                      ),
                    ),
                  ),
                )

              ],
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.productSnapshot.data[widget.index]['name'], maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16.0)),
                  Text('XAF ${widget.productSnapshot.data[widget.index]['price']}', style: const TextStyle(
                      fontSize: 18.0, color: primaryColor, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8.0),
                  //widget.productData[index].map(_buildCat).toList(),
                  Text(widget.subCat, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14.0)),
                  const SizedBox(height: 3.0),
                  Text('Brand: ${widget.productSnapshot.data[widget.index]['brand']}', maxLines: 1,
                      overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14.0)),
                  const SizedBox(height: 3.0),
                  Text('Size: ${widget.productSnapshot.data[widget.index]['size']}', maxLines: 1,
                      overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14.0)),
                  const SizedBox(height: 3.0),
                  Text('SKU: ${widget.productSnapshot.data[widget.index]['sku']}', style: const TextStyle(fontSize: 14.0)),

                ],
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: (){
                    showMoreOptions(widget.productSnapshot, widget.index);
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                      margin: const EdgeInsets.only(top: 10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.grey.withOpacity(0.3)
                      ),
                      child: const Icon(Icons.more_vert_outlined, color: primaryColor, size: 20.0)
                  ),
                ),
                Icon(Icons.arrow_forward_outlined, size: 22, color: Colors.grey.withOpacity(0.3))
              ],
            ),
            const SizedBox(width: 5.0),
          ],
        ),

      ),
    );
  }

  showDeleteDialog(AsyncSnapshot obj, int index){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text('Are you sure you want to delete ${obj.data[index]['name']}'),
              const SizedBox(height: 20.0),
              Visibility(
                  visible: isLoading,
                  child: const CircularProgressIndicator(strokeWidth: 3, color: primaryColor)
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(ctx).pop();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5)
              ),
              child: const Text("Cancel", style: TextStyle(color: Colors.black54)),
            ),
          ),

          TextButton(
            onPressed: () async{
              setState(() {
                isLoading = !isLoading;
              });
              await Apis.client.from('category').delete().eq('id', obj.data[index]['id'])
                  .then((value) {
                Navigator.of(ctx).pop();
                setState(() {

                });
                return snackBarFailed;
              });
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

  showMoreOptions(AsyncSnapshot snap, int index){
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
            children: [
              const SizedBox(height: 30.0),
              Text('About ${snap.data[index]['name']}', style: const TextStyle(fontSize: 18,
                  fontWeight: FontWeight.w700)),
              const SizedBox(height: 18.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(snap.data[index]['description'], maxLines: 6, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w300)),
              ),
              const SizedBox(height: 12.0),
              ListTile(
                leading: Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.green
                    ),
                    child: const Icon(Icons.edit_outlined, color: Colors.white, size: 20.0,)
                ),
                title: const Text('Edit product'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12.0),
              ListTile(
                leading: Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.red
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.white, size: 20.0,)
                ),
                title: const Text('Delete product'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12.0),
              ListTile(
                leading: Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.yellow
                    ),
                    child: const Icon(Icons.more_outlined, color: Colors.white, size: 20.0,)
                ),
                title: const Text('More about'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12.0),
            ],

          );
        });
  }

  final snackBarFailed = SnackBar(
    content: const Text('Oops! Something went wrong!', style: TextStyle(color: Colors.white)),
    backgroundColor: (Colors.red),
    action: SnackBarAction(
      label: 'Dismiss',
      textColor: Colors.black,
      onPressed: () {
      },
    ),
  );

  final snackBarSucceed = SnackBar(
    content: const Text('Success! Transaction successful!', style: TextStyle(color: Colors.white)),
    backgroundColor: (Colors.green),
    action: SnackBarAction(
      label: 'Dismiss',
      textColor: Colors.black,
      onPressed: () {
      },
    ),
  );

}
