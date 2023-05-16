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

class ModifySubCategory extends StatefulWidget {
  ModifySubCategory({Key? key}) : super(key: key);

  @override
  State<ModifySubCategory> createState() => _ModifySubCategoryState();
}

class _ModifySubCategoryState extends State<ModifySubCategory> {

  late final TextEditingController _nameController;
  late final TextEditingController _detailController;
  final _formKeyMod = GlobalKey<FormState>();
  bool _isLoading = false;
  final dynamic argumentData = Get.arguments;
  File? imageFile;
  bool _change = false;

  @override
  void initState() {
    _nameController = argumentData['name'] == null ? TextEditingController() :
    TextEditingController(text: argumentData['name']);
    _detailController = argumentData['detail'] == null ? TextEditingController() :
    TextEditingController(text: argumentData['detail']);
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
        title: argumentData == null ? const Text('Add Subcategory') : const Text('Edit Subcategory'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              argumentData == null ?
              const HeaderWidget(
                text: 'You will be able to create a new product subcategory for Golden237 store',
                image: 'assets/icons/add.png',
              ) :
              const HeaderWidget(
                text: 'You will be able to edit an existing product subcategory for Golden237 store',
                image: 'assets/icons/edit.png',
              ),

              const SizedBox(height: 25),

              Form(
                  key: _formKeyMod,
                  child: Column(
                    children: [
                      CustomInput(
                          controller: _nameController,
                          hintText: 'Subcategory Name',
                          label: 'Name',
                          maxCount: 25,
                          validator: (val){
                            if(val == null || val.length <= 0){
                              return 'Add a subcategory name';
                            }
                            else if(val.length < 4){
                              return 'Subcategory name too short!';
                            }
                          },
                          prefixIcon: Icons.category_outlined,
                          onChange: (val){

                          }
                      ),

                      CustomInput(
                          controller: _detailController,
                          hintText: 'Subcategory Detail',
                          label: 'Detail',
                          maxCount: 60,
                          maxLines: 3,
                          validator: (val){
                            if(val == null || val.length <= 0){
                              return 'Add a subcategory detail';
                            }
                            else if(val.length < 4){
                              return 'Subcategory detail too short!';
                            }
                          },
                          prefixIcon: Icons.description,
                          padding: const EdgeInsets.only(top: 20.0),

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
                    const Text('Subcategory Image'),
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


              argumentData == null ?
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
                  child: Image.network(argumentData['image'], fit: BoxFit.contain)) :
              Container(
                  height: 120,
                  width: 100,
                  margin: const EdgeInsets.only(left: 10),
                  child: Image.file(imageFile!, fit: BoxFit.contain)),

              const SizedBox(height: 75),

              argumentData == null ?
              SubmitButton(
                  text: 'Create Subcategory',
                  isEnabled: true,
                  isLoading: _isLoading,
                  onPressed: () {
                    if(_formKeyMod.currentState!.validate()){
                      addProductCategory(context);
                    }
                    else {
                      return;
                    }

                  }
              ) :
              SubmitButton(
                text: 'Update Subcategory',
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
        await Apis.client.storage.from('subcategory').uploadBinary(
          filePath,
          bytes!,
        );
        final imageUrlResponse = await Apis.client.storage
            .from('subcategory')
            .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);
        await Apis.client.from('subcategory').upsert({
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
    if(_change){
      try{
        final bytes = await imageFile?.readAsBytes();
        final fileExt = imageFile?.path
            .split('.')
            .last;
        final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
        final filePath = fileName;
        await Apis.client.storage.from('subcategory').uploadBinary(
          filePath,
          bytes!,
        );
        final imageUrlResponse = await Apis.client.storage
            .from('subcategory')
            .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);
        await Apis.client
            .from('subcategory')
            .update({
          'name': _nameController.text,
          'detail': _detailController.text,
          'image': imageUrlResponse
        }).eq('id', argumentData['id']);
        Get.snackbar('Success!', '${argumentData['name']} updated successfully!',
            backgroundColor: Colors.green, colorText: Colors.white, borderRadius: 5);
        Navigator.of(context).pop();
        setState(() {
          _change = false;
        });
      } catch(error){
        Get.snackbar('Oops!', '${argumentData['name']} failed to update!',
            backgroundColor: Colors.green, colorText: Colors.white, borderRadius: 5);
      }
    }
    else{
      await Apis.client
          .from('subcategory')
          .update({
        'name': _nameController.text,
        'detail': _nameController.text
      }).eq('id', argumentData['id']);
      Get.snackbar('Success!', '${argumentData['name']} updated successfully!',
          backgroundColor: Colors.green, colorText: Colors.white, borderRadius: 5);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
    setState(() {
      _isLoading = !_isLoading;
    });
  }
}


///////////////////////////////////////////////////////////////////////

class ModifyMySubCategory extends StatefulWidget {
  const ModifyMySubCategory({Key? key}) : super(key: key);

  @override
  State<ModifyMySubCategory> createState() => _ModifyMySubCategoryState();
}

class _ModifyMySubCategoryState extends State<ModifyMySubCategory> {

  late final TextEditingController _nameController;
  late final TextEditingController _detailController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final dynamic argumentData = Get.arguments;
  late AsyncSnapshot? snap;
  late int? index;
  File? imageFile;
  bool _change = false;

  @override
  void initState() {
    snap = argumentData  != null ? argumentData[0]['snap'] : null;
    index = argumentData != null ? argumentData[1]['index'] : 0;
    _nameController = snap?.data[index]['name'] == null ? TextEditingController() :
    TextEditingController(text: snap?.data[index]['name']);
    _detailController = snap?.data[index]['detail'] == null ? TextEditingController() :
    TextEditingController(text: snap?.data[index]['detail']);
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
        title: snap?.data == null ? const Text('Add Subcategory') : const Text('Edit Subcategory'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              snap?.data == null ?
              const HeaderWidget(
                text: 'You will be able to create a new product subcategory for Golden237 store',
                image: 'assets/icons/add.png',
              ) :
              const HeaderWidget(
                text: 'You will be able to edit an existing product subcategory for Golden237 store',
                image: 'assets/icons/edit.png',
              ),

              const SizedBox(height: 25),

              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomInput(
                          controller: _nameController,
                          hintText: 'Subcategory Name',
                          label: 'Name',
                          maxCount: 25,
                          validator: (val){
                            if(val == null || val.length <= 0){
                              return 'Add a subcategory name';
                            }
                            else if(val.length < 4){
                              return 'Subcategory name too short!';
                            }
                          },
                          prefixIcon: Icons.category_outlined,
                          onChange: (val){

                          }
                      ),

                      CustomInput(
                        controller: _detailController,
                        hintText: 'Subcategory Detail',
                        label: 'Detail',
                        maxCount: 60,
                        maxLines: 3,
                        validator: (val){
                          if(val == null || val.length <= 0){
                            return 'Add a subcategory detail';
                          }
                          else if(val.length < 4){
                            return 'Subcategory detail too short!';
                          }
                        },
                        prefixIcon: Icons.description,
                        padding: const EdgeInsets.only(top: 20.0),

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
                    const Text('Subcategory Image'),
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


              snap?.data == null ?
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
                  child: Image.network(snap?.data[index]['image'], fit: BoxFit.contain)) :
              Container(
                  height: 120,
                  width: 100,
                  margin: const EdgeInsets.only(left: 10),
                  child: Image.file(imageFile!, fit: BoxFit.contain)),

              const SizedBox(height: 75),

              snap?.data == null ?
              SubmitButton(
                  text: 'Create Subcategory',
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
                text: 'Update Subcategory',
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
        await Apis.client.storage.from('subcategory').uploadBinary(
          filePath,
          bytes!,
        );
        final imageUrlResponse = await Apis.client.storage
            .from('subcategory')
            .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);
        await Apis.client.from('subcategory').upsert({
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
    if(_change){
      try{
        final bytes = await imageFile?.readAsBytes();
        final fileExt = imageFile?.path
            .split('.')
            .last;
        final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
        final filePath = fileName;
        await Apis.client.storage.from('subcategory').uploadBinary(
          filePath,
          bytes!,
        );
        final imageUrlResponse = await Apis.client.storage
            .from('subcategory')
            .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);
        await Apis.client
            .from('subcategory')
            .update({
          'name': _nameController.text,
          'detail': _detailController.text,
          'image': imageUrlResponse
        }).eq('id', snap?.data[index]['id']);
        Get.snackbar('Success!', '${snap?.data[index]['name']} updated successfully!',
            backgroundColor: Colors.green, colorText: Colors.white, borderRadius: 5);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        setState(() {
          _change = false;
        });
      } catch(error){
        Get.snackbar('Oops!', '${snap?.data[index]['name']} failed to update!',
            backgroundColor: Colors.green, colorText: Colors.white, borderRadius: 5);
      }
    }
    else{
      await Apis.client
          .from('subcategory')
          .update({
        'name': _nameController.text,
        'detail': _nameController.text
      }).eq('id', snap?.data[index]['id']);
      Get.snackbar('Success!', '${snap?.data[index]['name']} updated successfully!',
          backgroundColor: Colors.green, colorText: Colors.white, borderRadius: 5);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
    setState(() {
      _isLoading = !_isLoading;
    });
  }
}

