import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:golden237_admin/controller/product_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class SearchbarScreen extends StatefulWidget {
  const SearchbarScreen({Key? key}) : super(key: key);

  @override
  State<SearchbarScreen> createState() => _SearchbarScreenState();
}

class _SearchbarScreenState extends State<SearchbarScreen> {

  late TextEditingController _searchController;
  bool isSearch = false;
  int textLength = 0;
  final currencyFormatter = NumberFormat('#,###');
  ProductController productController = Get.put(ProductController());

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          maxLines: 1,
          maxLength: 15,
          controller: _searchController,
          cursorColor: Colors.white,
          onChanged: (val){
            setState(() {
              textLength = val.length;
              productController.searchWord.value = val.toLowerCase();
            });
          },
          decoration: InputDecoration(
            counterText: '',
            hintText: 'Search products...',
            prefixIcon: GetBuilder<ProductController>(
              init: ProductController(),
              builder: (value){
                return InkWell(
                  onTap: (){

                  },
                  child: const Icon(Icons.search_outlined, color: Colors.white),
                );
              },
            ),
            suffixIcon: textLength > 0 ?
              InkWell(
                onTap: (){
                  setState(() {
                    _searchController.clear();
                    textLength = 0;
                  });
                },
                child: const Icon(Icons.cancel_outlined, color: Colors.white)) : null,
            border: const OutlineInputBorder(
              borderSide: BorderSide.none
            )
          ),

        ),
      ),

      body: FutureBuilder(
        future: productController.getProductByLatest(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return const Center(
                child: Text('Something went wrong!')
            );
          }
          return searchedWidget(snapshot);
        },
      )
    );
  }

  Widget searchedWidget(AsyncSnapshot snap){
    return ListView.builder(
        itemCount: snap.data.length,
        itemBuilder: (context, index){
          return Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              dense: true,
              tileColor: Colors.grey.withOpacity(0.1),
              visualDensity: const VisualDensity(vertical: 4),
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                    snap.data[index]['image']
                ),
              ),
              title: Text(snap.data[index]['name'], maxLines: 1,
                  overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15.0)),
              subtitle: Text('${snap.data[index]['sku']} - ${snap.data[index]['brand']}', style: const TextStyle(fontSize: 11.0)),
              trailing: Text('XAF ${currencyFormatter.format(snap.data[index]['price'])}'),
            ),
          );
        }
    );
  }

}
