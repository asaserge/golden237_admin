import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../controller/category_controller.dart';
import '../services/apis.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({Key? key}) : super(key: key);

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {

  Helper helper = Helper();
  bool isLoading = false;
  late AsyncSnapshot snap;
  late int index;
  final CategoryController categoryController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Subcategory', style: TextStyle(fontSize: 18)),
          actions: [
            Obx(() => Padding(
                padding: const EdgeInsets.only(top: 22.0),
                child: Text('(${categoryController.subCategoriesList.length})'))
            ),
            IconButton(
                onPressed: (){
                  showHelpDialog(context);
                },
                icon: const Icon(Icons.help_outline_outlined)
            ),
            const SizedBox(width: 10.0)
          ],
        ),

        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            child: categoryController.subCategoriesList.isEmpty ?
            Center(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.white,
                  child: const Text('Oops! No subcategory was found!',
                      style: TextStyle(color: Colors.green)
                  ),
                ),
              )
            ) :
            ListView.builder(
                itemCount: categoryController.subCategoriesList.length,
                itemBuilder: (context, index){
                  return GestureDetector(
                    onTap: (){
                      Get.toNamed('/cat_product', arguments: categoryController.subCategoriesList[index]);
                    },
                    onLongPress: (){
                      showMoreOptions(categoryController.subCategoriesList, index);
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
                                      image: NetworkImage(categoryController.subCategoriesList[index]['image']),
                                      fit: BoxFit.contain,
                                      // colorFilter:
                                      // const ColorFilter.mode(Colors.white70, BlendMode.colorBurn)
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(categoryController.subCategoriesList[index]['name'],
                                        style: const TextStyle(fontSize: 18)),
                                    const SizedBox(height: 8.0),
                                    Text(categoryController.subCategoriesList[index]['detail'],
                                        style: const TextStyle(fontSize: 10)),
                                  ],
                                )
                            ),
                            GestureDetector(
                              onTap: (){
                                showMoreOptions(categoryController.subCategoriesList, index);
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
                        const SizedBox(height: 10.0)
                      ],
                    ),
                  );
                }
            )
        ),

        floatingActionButton: Container(
          height: 50.0,
          width: 140.0,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.white38,
              )
          ),
          child: Center(
            child: RawMaterialButton(
              shape: const CircleBorder(),
              elevation: 0.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.add_outlined,
                  ),
                  SizedBox(width: 5.0),
                  Text('Subcategory')
                ],
              ),
              onPressed: () {
                Get.toNamed('/modify_subcategory', arguments: null);
              },
            ),
          ),
        )

    );
  }

  showHelpDialog(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: const [
              Text('Long press to see more options like edit and delete, can press to see categorised products as well.'),
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

  showMoreOptions(var data, int index){
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
              Text('More about ${data[index]['name']}', maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 12.0),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit'),
                onTap: () {
                  Get.offAndToNamed('/modify_subcategory', arguments: data[index]);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Delete'),
                onTap: () {
                  if(categoryController.subCategoriesList.isEmpty){
                    Get.off;
                    showDeleteDialog(data[index]);
                  }
                  else{
                    showDialog<void>(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Heads Up!'),
                          content: const Text('Because this subcategory has products, this action cannot be performed! '
                              'Try deleting all products before trying again!'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Understood', style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                Get.back();// Dismiss alert dialog
                                Get.back();// Dismiss alert dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 40.0),
            ],
          );
        });
  }

  showDeleteDialog(var obj){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text('Are you sure you want to delete ${obj['name']}'),
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
              try{
                await Apis.client
                    .from('category')
                    .delete()
                    .eq('id', obj['id']);
                Get.snackbar('Success!', '${obj['name']} deleted successfully!',
                    backgroundColor: Colors.green, colorText: Colors.white, borderRadius: 5);
              } catch(error){
                Get.snackbar('Oops!', '${obj['name']} failed to delete!',
                    backgroundColor: Colors.green, colorText: Colors.white, borderRadius: 5);
              }
              setState(() {
                isLoading = !isLoading;
              });
              Get.back();
              Get.back();
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
}


///////////////////////////////////////////////////////////////////////


class MySubCategoryScreen extends StatefulWidget {
  const MySubCategoryScreen({Key? key}) : super(key: key);

  @override
  State<MySubCategoryScreen> createState() => _MySubCategoryScreenState();
}

class _MySubCategoryScreenState extends State<MySubCategoryScreen> {

  Helper helper = Helper();
  bool isLoading = false;
  final CategoryController categoryController = Get.find();
  final data = Get.arguments;
  late AsyncSnapshot snap;
  late int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(data['name'], style: const TextStyle(fontSize: 18)),
          actions: [
            Obx(() => Padding(
                padding: const EdgeInsets.only(top: 22.0),
                child: Text('(${categoryController.subCatCount.value})'))
            ),
            IconButton(
                onPressed: (){
                  showHelpDialog(context);
                },
                icon: const Icon(Icons.help_outline_outlined)
            ),
            const SizedBox(width: 10.0)
          ],
        ),

        body: FutureBuilder(
            future: categoryController.getSpecificSubCategory(data['id']),
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

        floatingActionButton: Container(
          height: 50.0,
          width: 150.0,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.white38,
              )
          ),
          child: Center(
            child: RawMaterialButton(
              shape: const CircleBorder(),
              elevation: 0.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.add_outlined,
                  ),
                  SizedBox(width: 5.0),
                  Text('Subcategory')
                ],
              ),
              onPressed: () {
                Get.toNamed('/modify_subcategory');
              },
            ),
          ),
        )

    );
  }

  Widget categoryWidget(AsyncSnapshot snapshotSubCat){

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        child: snapshotSubCat.data.length == 0 ?
        Center(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                color: Colors.white,
                child: Text('No subcategory was found for ${data['name']}',
                    style: const TextStyle(color: Colors.green)
                ),
              ),
            )
        )
        :
        ListView.builder(
            itemCount: snapshotSubCat.data.length ?? 0,
            itemBuilder: (context, index){
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                categoryController.subCatCount.value = snapshotSubCat.data.length;
                this.index = index;
                snap = snapshotSubCat;
              });
              return GestureDetector(
                onTap: (){
                  Get.toNamed('/my_cat_product', arguments: [
                    {'snap': snapshotSubCat},
                    {'index': index},
                  ]);
                },
                onLongPress: (){
                  showMoreOptions(snapshotSubCat, index);
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
                                  image: NetworkImage(snapshotSubCat.data[index]['image']),
                                  fit: BoxFit.contain,
                                  // colorFilter:
                                  // const ColorFilter.mode(Colors.white70, BlendMode.colorBurn)
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(snapshotSubCat.data[index]['name'],
                                    style: const TextStyle(fontSize: 18)),
                                const SizedBox(height: 8.0),
                                Text(snapshotSubCat.data[index]['detail'],
                                    style: const TextStyle(fontSize: 10)),
                              ],
                            )
                        ),
                        GestureDetector(
                          onTap: (){
                            showMoreOptions(snapshotSubCat, index);
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
                    const SizedBox(height: 10.0)
                  ],
                ),
              );
            }
        )
    );
  }

  showHelpDialog(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: const [
              Text('Long press to see more options like edit and delete, can press to see categorised products as well.'),
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
              Text('More about ${snap.data[index]['name']}', maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 12.0),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit'),
                onTap: () {
                  Get.offAndToNamed('/modify_subcategory', arguments: [
                    {'snap': snap},
                    {'index': index}
                  ]);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Delete'),
                onTap: () {
                  if(categoryController.subCategoriesList.isEmpty){
                    Get.off;
                    showDeleteDialog(snap.data[index]);
                  }
                  else{
                    showDialog<void>(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Heads Up!'),
                          content: const Text('Because this subcategory has products, this action cannot be performed! '
                              'Try deleting all products before trying again!'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Understood', style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                Get.back();// Dismiss alert dialog
                                Get.back();// Dismiss alert dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 40.0),
            ],
          );
        });
  }

  showDeleteDialog(var obj){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text('Are you sure you want to delete ${obj['name']}'),
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
              try{
                await Apis.client
                    .from('category')
                    .delete()
                    .eq('id', obj['id']);
                Get.snackbar('Success!', '${obj['name']} deleted successfully!',
                    backgroundColor: Colors.green, colorText: Colors.white, borderRadius: 5);
              } catch(error){
                Get.snackbar('Oops!', '${obj['name']} failed to delete!',
                    backgroundColor: Colors.green, colorText: Colors.white, borderRadius: 5);
              }
              setState(() {
                isLoading = !isLoading;
              });
              Get.back();
              Get.back();
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
}