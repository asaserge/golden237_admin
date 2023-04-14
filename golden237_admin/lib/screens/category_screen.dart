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
          title: const Text('Categories', style: TextStyle(fontSize: 18)),
          actions: [
            Obx(() => Padding(
              padding: const EdgeInsets.only(top: 22.0),
              child: Text('(${categoryController.mainCategoriesList.length})'))
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

        body: Obx(() => categoryController.mainCategoriesList.isEmpty ?
            const Center(
              child: Text('No category available!')
            ) :
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              child: ListView.builder(
              itemCount: categoryController.mainCategoriesList.length,
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: (){
                    var data = categoryController.mainCategoriesList[index];
                    Get.toNamed('/subcategory', arguments: data);
                  },
                  onLongPress: (){
                    var data = categoryController.mainCategoriesList[index];
                    showMoreOptions(data, index);
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
                                    image: NetworkImage(categoryController.mainCategoriesList[index]['image']),
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
                                  Text(categoryController.mainCategoriesList[index]['name'], maxLines: 1, overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 18)),
                                  const SizedBox(height: 8.0),
                                  Text(categoryController.mainCategoriesList[index]['detail'] ?? '',
                                      style: const TextStyle(fontSize: 10)),
                                ],
                              )
                          ),
                          GestureDetector(
                            onTap: (){
                              var data = categoryController.mainCategoriesList[index];
                              showMoreOptions(data, index);
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
        )

        ),

        floatingActionButton: Container(
          height: 50.0,
          width: 120.0,
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
                  Text('Category')
                ],
              ),
              onPressed: () {
                Get.toNamed('/modify_category');
              },
            ),
          ),
        )
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
              Text('More about ${data['name']}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 12.0),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit'),
                onTap: () {
                  Get.offAndToNamed('/modify_category', arguments: data);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Delete'),
                onTap: () {
                  if(categoryController.subCategoriesList.isEmpty){
                    Get.off;
                    showDeleteDialog(data);
                  }
                  else{
                    showDialog<void>(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Heads Up!'),
                          content: const Text('Because this category has other subcategories, this action cannot be performed! '
                              'Try deleting all subcategories before trying again!'),
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
              const SizedBox(height: 30.0),
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