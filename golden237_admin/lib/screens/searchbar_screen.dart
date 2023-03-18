import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:golden237_admin/controller/product_controller.dart';


class SearchbarScreen extends StatefulWidget {
  const SearchbarScreen({Key? key}) : super(key: key);

  @override
  State<SearchbarScreen> createState() => _SearchbarScreenState();
}

class _SearchbarScreenState extends State<SearchbarScreen> {

  late TextEditingController _searchController;
  bool isSearch = false;
  int textLength = 0;
  String enteredText = '';
  late ListView _listView;
  late AsyncSnapshot snapshotData;

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
              enteredText = val;
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

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: isSearch ?
            searchedData() :
            const Center(
              child: Text('Search a product'),
            )
      ),
    );
  }

  Widget searchedData(){
    return ListView.builder(
        itemCount: snapshotData.data.length,
        itemBuilder: (context, index){
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  snapshotData.data[index]['image'].data
              ),
            ),
            title: Text(snapshotData.data[index]['name']),
            trailing: Text('${snapshotData.data[index]['price']}'),
          );
        }
    );
  }

}
