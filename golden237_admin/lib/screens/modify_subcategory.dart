import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import '../services/apis.dart';
import '../utils/constants.dart';
import '../widgets/custom_input.dart';
import '../widgets/header_text.dart';
import '../widgets/header_widget.dart';
import '../widgets/submit_button.dart';

class ModifySubCategory extends StatefulWidget {
  const ModifySubCategory({Key? key, this.snap, this.index}) : super(key: key);
  final AsyncSnapshot? snap;
  final int? index;

  @override
  State<ModifySubCategory> createState() => _ModifySubCategoryState();
}

class _ModifySubCategoryState extends State<ModifySubCategory> {

  late final TextEditingController _editingController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  File? imageFile;

  @override
  void initState() {
    _editingController = widget.snap?.data == null ? TextEditingController() :
      TextEditingController(text: widget.snap?.data[widget.index]['name']);
    super.initState();
  }


  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.snap?.data == null ? const Text('Add Category') : const Text('Edit Category'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.snap?.data == null ?
              const HeaderWidget(
                text: 'You will be able to create a new product category for Golden237 store',
                image: 'assets/icons/add.png',
              ) :
              const HeaderWidget(
                text: 'You will be able to edit an existing product category for Golden237 store',
                image: 'assets/icons/edit.png',
              ),

              const SizedBox(height: 25),

              Form(
                key: _formKey,
                child: CustomInput(
                controller: _editingController,
                hintText: 'Category Name',
                label: 'Name',
                maxCount: 25,
                validator: (val){
                  if(val == null || val.length <= 0){
                    return 'Add a category name';
                  }
                  else if(val.length < 4){
                    return 'Category name too short!';
                  }
                },
                prefixIcon: Icons.category_outlined,
                onChange: (val){

                },
              )
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Category Image'),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black
                    ),
                    onPressed: () {
                      _pickImageFromGallery();
                    },
                      child: const Text('Add Image'))
                ],
              ),


              widget.snap?.data == null ?
                imageFile == null ?
                Column(
                  children: const [
                    SizedBox(height: 25),
                    Text('No file selected'),
                  ],
                ) :
                Container(
                    height: 120,
                    width: 100,
                    margin: const EdgeInsets.only(right: 20),
                    child: Image.file(imageFile!, fit: BoxFit.cover)) :
              imageFile == null ?
              Container(
                  height: 120,
                  width: 100,
                  margin: const EdgeInsets.only(right: 20),
                  child: Image.network(widget.snap?.data[widget.index]['image'], fit: BoxFit.cover)) :
              Container(
                  height: 120,
                  width: 100,
                  margin: const EdgeInsets.only(right: 20),
                  child: Image.file(imageFile!, fit: BoxFit.cover)),

              const SizedBox(height: 175),

              widget.snap?.data == null ?
                SubmitButton(
                text: 'Create Category',
                isEnabled: true,
                onPressed: () {
                  if(_formKey.currentState!.validate()){
                    addProductCategory(context);
                  }
                  else {
                    return;
                  }

                },
                isLoading: false,
              ) :
                SubmitButton(
                  text: 'Update Category',
                  isEnabled: true,
                  isLoading: _isLoading,
                  onPressed: () {

                  },
                ) ,

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final pickedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          imageFile = File(pickedImage.path);
        });
      }
    } catch (e) {
      Get.snackbar('Oops!', 'Failed to pick image!',
          borderRadius: 0,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  void addProductCategory(BuildContext context) async{
    if(imageFile == null){
      ScaffoldMessenger.of(context).showSnackBar(snackBarFailed);
    }
    else{
     setState(() {
       _isLoading = !_isLoading;
     });

      final fileName = imageFile!.path.toString();
      await Apis.client.storage
          .from('category')
          .upload(fileName, imageFile!).then((value) async {
        final imageUrl = Apis.client.storage.from('category').getPublicUrl(fileName);

          await Apis.client.from('category').insert({
            'name': _editingController.text.trim(),
            'image': imageUrl});
            setState(() {
              _isLoading = !_isLoading;
            });
            Navigator.of(context).pop();
            return ScaffoldMessenger.of(context).showSnackBar(snackBarSucceed);
      });
    }

  }

  final snackBarFailed = SnackBar(
    content: const Text('Oops! Please select an image!', style: TextStyle(color: Colors.white)),
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
