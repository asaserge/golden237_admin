import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/apis.dart';
import '../utils/constants.dart';
import '../widgets/custom_input.dart';
import '../widgets/header_text.dart';
import '../widgets/header_widget.dart';
import '../widgets/submit_button.dart';

class ModifyCategory extends StatefulWidget {
  ModifyCategory({Key? key}) : super(key: key);

  @override
  State<ModifyCategory> createState() => _ModifyCategoryState();
}

class _ModifyCategoryState extends State<ModifyCategory> {

  late final TextEditingController _nameController;
  late final TextEditingController _detailController;
  final _formKey = GlobalKey<FormState>();
  final data = Get.arguments;
  bool _isLoading = false;
  bool _change = false;
  File? imageFile;

  @override
  void initState() {
    _nameController = data == null ? TextEditingController() :
      TextEditingController(text: data['name']);
    _detailController = data == null ? TextEditingController() :
    TextEditingController(text: data['detail']);
    super.initState();
  }


  @override
  void dispose() {
    _nameController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: data == null ? const Text('Add Category') : const Text('Edit Category'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              data == null ?
              const HeaderWidget(
                text: 'You will be able to create a new product category for $appName store',
                image: 'assets/icons/add.png',
              ) :
              const HeaderWidget(
                text: 'You will be able to edit an existing product category for $appName store',
                image: 'assets/icons/edit.png',
              ),

              const SizedBox(height: 25),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomInput(
                    controller: _nameController,
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

                    }
                    ),

                    CustomInput(
                    controller: _detailController,
                    hintText: 'Category Detail',
                    label: 'Detail',
                    maxCount: 60,
                    maxLines: 3,
                    validator: (val){
                      if(val == null || val.length <= 0){
                        return 'Add a category detail';
                      }
                      else if(val.length < 4){
                        return 'Category detail too short!';
                      }
                    },
                    prefixIcon: Icons.description,
                    padding: const EdgeInsets.only(top: 20.0),
                    onChange: (val){

                    }
                    ),
                  ],
                )
              ),

              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Category Image'),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black
                      ),
                      onPressed: () {
                        _pickImageFromGallery();
                        setState(() {
                          _change = true;
                        });
                      },
                        child: const Text('Add Image'))
                  ],
                ),
              ),


              data == null ?
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
                    margin: const EdgeInsets.only(left: 20),
                    child: Image.file(imageFile!, fit: BoxFit.cover)) :
              imageFile == null ?
              Container(
                  height: 120,
                  width: 100,
                  margin: const EdgeInsets.only(left: 10),
                  child: Image.network(data['image'], fit: BoxFit.contain)) :
              Container(
                  height: 120,
                  width: 100,
                  margin: const EdgeInsets.only(left: 10),
                  child: Image.file(imageFile!, fit: BoxFit.contain)),

              const SizedBox(height: 75),

              data == null ?
                SubmitButton(
                text: 'Create Category',
                isEnabled: true,
                isLoading: _isLoading,
                onPressed: () {
                  if(_formKey.currentState!.validate()){
                    addProductCategory(context);
                  }
                  else {
                    return;
                  }

                }
              ) :
                SubmitButton(
                  text: 'Update Category',
                  isEnabled: true,
                  isLoading: _isLoading,
                  onPressed: () {
                    updateProductCategory();
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
      Get.snackbar('Oops!', 'No was image selected!',
          borderRadius: 0,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
    else {
      setState(() {
        _isLoading = true;
      });

      final fileName = imageFile!.path.toString();
      print('\n\n\n$fileName');
      try {
        final bytes = await imageFile?.readAsBytes();
        final fileExt = imageFile?.path
            .split('.')
            .last;
        final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
        final filePath = fileName;
        await Apis.client.storage.from('category').uploadBinary(
          filePath,
          bytes!,
        );
        final imageUrlResponse = await Apis.client.storage
            .from('category')
            .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);
        await Apis.client.from('category').upsert({
          'name': _nameController.text,
          'detail': _detailController.text,
          'image': imageUrlResponse,
        });
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          Get.back();
        }
      } on PostgrestException catch (error) {
        Get.snackbar('Oops!', error.message,
            borderRadius: 0,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      } catch (error) {
        Get.snackbar('Oops!', 'Unexpected error has occurred',
            borderRadius: 0,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    }

  }

  updateProductCategory() async {
    setState(() {
      _isLoading = !_isLoading;
    });
    try{
      if(_change){
        final bytes = await imageFile?.readAsBytes();
        final fileExt = imageFile?.path
            .split('.')
            .last;
        final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
        final filePath = fileName;
        await Apis.client.storage.from('category').uploadBinary(
          filePath,
          bytes!,
        );
        final imageUrlResponse = await Apis.client.storage
            .from('category')
            .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);
        await Apis.client
            .from('category')
            .update({
          'name': _nameController.text,
          'detail': _nameController.text,
          'image': imageUrlResponse
        });

      }
      else{
        await Apis.client
            .from('category')
            .update({
          'name': _nameController.text,
          'detail': _nameController.text,
        });
      }
      Get.snackbar('Success!', '${data['name']} updated successfully!',
          backgroundColor: Colors.green, colorText: Colors.white, borderRadius: 5);
      Get.back();
    } catch(error){
      Get.snackbar('Oops!', '${data['name']} failed to update!',
          backgroundColor: Colors.green, colorText: Colors.white, borderRadius: 5);
    }
    setState(() {
      _isLoading = !_isLoading;
    });
    Get.back();
  }

}
