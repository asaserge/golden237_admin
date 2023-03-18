import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:golden237_admin/models/category_model.dart';

import 'constants.dart';

class Helper{

  showSimpleDialog(BuildContext context, String title, content){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(content),
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
              child: const Text("Okay", style: TextStyle(color: Colors.black54)),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> showCustomDeleteDialog(BuildContext context, var obj, int index) async {
    Get.defaultDialog(
      title: "Heads Up!",
      content: Text("Are you sure you want to delete ${obj['name']}?"),
      textConfirm: "Okay",
      textCancel: "No",
      titlePadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      onCancel: (){
        Navigator.of(context).pop();
      },
      onConfirm: () async {
        //Todo, delete product
        Get.snackbar('Deleted!', '${obj['name']} was deleted successfully!',
            backgroundColor: Colors.red, colorText: Colors.white, borderRadius: 0
        );
      }
    );
  }
}
