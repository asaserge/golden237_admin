import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:golden237_admin/screens/subcategory_screen.dart';

import '../controller/category_controller.dart';
import '../services/apis.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/custom_fab_widget.dart';
import 'modify_category.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  Helper helper = Helper();
  bool isLoading = false;
  final CategoryController categoryController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Category', style: TextStyle(fontSize: 18)),
          actions: [
            Obx(() => Padding(
              padding: const EdgeInsets.only(top: 22.0),
              child: Text('(${categoryController.catCount.value})'))
            ),
            IconButton(
              onPressed: (){
                showHelpDialog();
              },
              icon: const Icon(Icons.help_outline_outlined)
            ),
            const SizedBox(width: 10.0)
          ],
        ),

        body: FutureBuilder(
            future: categoryController.getMainCategory(),
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
                return categoryWidget(snapshot);
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

        floatingActionButton: const CustomFabWidget(
          route: ModifyCategory(),
          text: 'Category', width: 120.0,
        )
    );
  }

  Widget categoryWidget(AsyncSnapshot snapshotCat){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      child: ListView.builder(
        itemCount: snapshotCat.data.length ?? 0,
        itemBuilder: (context, index){
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            categoryController.catCount.value = snapshotCat.data.length;
          });
          return GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SubCategoryScreen(catSnap: snapshotCat, index: index))
              );
            },
            onLongPress: (){
              showMoreOptions(snapshotCat, index);
            },
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: CachedNetworkImage(
                        imageUrl: "http://via.placeholder.com/200x150",
                        imageBuilder: (context, imageProvider) => Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                                image: NetworkImage(snapshotCat.data[index]['image']),
                                fit: BoxFit.contain,
                                // colorFilter:
                                // const ColorFilter.mode(Colors.white70, BlendMode.colorBurn)
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(snapshotCat.data[index]['name'], maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 18)),
                            const SizedBox(height: 8.0),
                            Text(snapshotCat.data[index]['detail'],
                                style: const TextStyle(fontSize: 10)),
                          ],
                        )
                    ),
                    GestureDetector(
                      onTap: (){
                        showMoreOptions(snapshotCat, index);
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.grey.withOpacity(0.3)
                          ),
                          child: const Icon(Icons.more_vert_outlined, color: primaryColor, size: 20.0,)
                      ),
                    ),
                    const SizedBox(width: 18.0),
                    const Icon(Icons.arrow_forward_ios_outlined, size: 14)

                  ],
                ),
                const SizedBox(height: 8.0),
                const Divider(thickness: 2),
                const SizedBox(height: 10.0),
              ],
            ),
          );
        }
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

  showHelpDialog(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: const [
              Text('Long press to see more options like edit and delete, can press to see subcategories as well.'),
              SizedBox(height: 10.0),

            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("Got it", style: TextStyle(color: Colors.green)),
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
              Text('More about ${snap.data[index]['name']}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 12.0),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ModifyCategory(snap: snap, index: index))
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  showDeleteDialog(snap, index);

                },
              ),
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