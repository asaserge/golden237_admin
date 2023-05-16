
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:golden237_admin/screens/modify_product.dart';
import 'package:golden237_admin/screens/product_detail_screen.dart';
import 'package:intl/intl.dart';

import '../services/apis.dart';
import '../utils/constants.dart';

class ProductWidget extends StatefulWidget {
  ProductWidget({Key? key,
    required this.productData}) : super(key: key);
  var productData;

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {

  bool isLoading = false;
  final decimalFormatter = NumberFormat('#.#');

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: (){
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
        //     ProductDetailScreen(productSnapshot: widget.productSnapshot,
        //       index: widget.index)));
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
                        image: NetworkImage(widget.productData['image']),
                        fit: BoxFit.cover,
                        // colorFilter:
                        // const ColorFilter.mode(Colors.white70, BlendMode.colorBurn)
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Image.asset('assets/images/no-image.jpg',
                      height: size.height / 4.8, width: size.width / 2.5),
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
                        child: Text(widget.productData['is_new'] ? 'New' : 'Used'
                            ,style: const TextStyle(fontSize: 12.0, color: Colors.green)
                        ),
                      ),

                    ),
                  ),
                ),

                Visibility(
                  visible: widget.productData['discount'] > 0 ? true : false,
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
                          child: Text('${decimalFormatter.format((widget.productData['price'] -
                              widget.productData['discount']) /
                              widget.productData['price'] * 100)}% OFF'
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width / 2.4,
                  child: Text(widget.productData['name'], maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15.0)),
                ),
                Text('XAF ${widget.productData['price']}', style: const TextStyle(
                    fontSize: 18.0, color: primaryColor, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8.0),
                Text('Cat: ${widget.productData['category']['name']}', maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14.0)),
                const SizedBox(height: 3.0),
                Text('Brand: ${widget.productData['brand']}', maxLines: 1,
                    overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14.0)),
                const SizedBox(height: 3.0),
                Text('Size: ${widget.productData['size']}', maxLines: 1,
                    overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14.0)),
                const SizedBox(height: 3.0),
                Text('SKU: ${widget.productData['sku']}', style: const TextStyle(fontSize: 14.0)),

              ],
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: (){
                   // showMoreOptions(widget.productSnapshot, widget.index);
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


  showDeleteBottomSheet(AsyncSnapshot snap, int index){
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
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Are you sure you want to delete ${snap.data[index]['name']}?'
                    , style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 18.0),
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

                      deleteProductMethod(snap, index);
                      Navigator.of(context).pop();
                      showBottomSnackBarMsg(context, 'Success!', '${snap.data[index]['name']}'
                          ' has been deleted successfully!', Colors.green);

                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: primaryColor
                        ),
                        child: const Text('Delete', style: TextStyle(color: Colors.white)),
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
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
              ),

              const SizedBox(height: 10.0),

              ListTile(
                leading: Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.red
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.white, size: 20.0,)
                ),
                title: const Text('Delete Product'),
                onTap: () {
                  Navigator.pop(context);
                  showDeleteBottomSheet(snap, index);
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(thickness: 1, color: Colors.grey),
              ),
              ListTile(
                leading: Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.yellow
                    ),
                    child: const Icon(Icons.more_outlined, color: Colors.black, size: 20.0,)
                ),
                title: const Text('More About'),
                onTap: () {
                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                  //     ProductDetailScreen(productSnapshot: widget.productSnapshot,
                  //         index: widget.index)));
                },
              ),
              const SizedBox(height: 15.0),
              ListTile(
                leading: Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.green
                    ),
                    child: const Icon(Icons.edit_outlined, color: Colors.white, size: 20.0,)
                ),
                title: const Text('Edit Product'),
                onTap: () {
                  // Navigator.pop(context);
                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                  //     ModifyProduct(productSnapshot: widget.productSnapshot,
                  //         index: widget.index)));
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(thickness: 1, color: Colors.grey),
              ),
            ],

          );
        });
  }

  showBottomSnackBarMsg(BuildContext context, String title, String msg, Color color){
    final snackBar = SnackBar(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10.0),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 20)),
          const SizedBox(height: 5.0),
          Text(msg, style: const TextStyle(color: Colors.white)),
        ],
      ),
      duration: const Duration(seconds: 4),
      backgroundColor: (color),
      dismissDirection: DismissDirection.down,
    );
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  deleteProductMethod(var obj, int index) async{
    final res = await Apis.client.from('product').delete().eq('id', obj.data[index]['id']);
    setState(() {
      isLoading = !isLoading;
    });
    return res;
  }
}
