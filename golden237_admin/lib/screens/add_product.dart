import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import '../messages/constants.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../widgets/category_dropdown.dart';
import '../widgets/custom_input.dart';
import '../widgets/header_widget.dart';
import '../widgets/submit_button.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  late TextEditingController _controllerName;
  late TextEditingController _controllerDesc;
  late TextEditingController _controllerPrice;
  late TextEditingController _controllerBrand;

  bool _isNew = true;
  File? imageFile;
  final dateFormatter = DateFormat.yMMMd();

  @override
  void initState() {
    _controllerName = TextEditingController();
    _controllerDesc = TextEditingController();
    _controllerPrice = TextEditingController();
    _controllerBrand = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerDesc.dispose();
    _controllerPrice.dispose();
    _controllerBrand.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderWidget(
                text: 'You will be able to create new products to showcase on Golden237 store',
                image: 'assets/icons/product-icon.png',
              ),

              const SizedBox(height: 25),

              CategoryDropdown(),

              const SizedBox(height: 25),

              CustomInput(
                controller: _controllerName,
                hintText: 'Product Name',
                prefixIcon: Icons.drive_file_rename_outline,
                label: 'Name',
              ),

              const SizedBox(height: 25),

              CustomInput(
                controller: _controllerPrice,
                hintText: 'Product Price',
                prefixIcon: Icons.price_change_outlined,
                textInputType: TextInputType.number,
                maxCount: 7,
                prefixText: 'XAF ',
                label: 'Price',
              ),

              const SizedBox(height: 25),

              CustomInput(
                controller: _controllerBrand,
                hintText: 'Product Brand',
                prefixIcon: Icons.branding_watermark_outlined,
                label: 'Brand',
              ),

              const SizedBox(height: 25),

              SwitchListTile(
                value: _isNew,
                activeColor: primaryColor,
                title: const Text('Product State'),
                subtitle: _isNew ? const Text('It\'s brand new product') : const Text('It\'s fairly used new product'),
                dense: true,
                visualDensity: const VisualDensity(vertical: 2),
                secondary: _isNew ? const Icon(Icons.new_releases_outlined, color: primaryColor)
                    : const Icon(Icons.real_estate_agent_outlined, color: primaryColor),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white38, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                  onChanged: (val){
                  setState(() {
                    _isNew = val;
                  });
                }
              ),

              const SizedBox(height: 25),

              CustomInput(
                controller: _controllerBrand,
                hintText: 'Product Description',
                prefixIcon: Icons.description_outlined,
                label: 'Description',
                maxLines: 4,
                maxCount: 200,
              ),

              const SizedBox(height: 25),

              Container(
                height: size.height / 5,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    width: 1,
                    color: Colors.white38
                  )
                ),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        setState(() {
                          _pickImageFromGallery();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Get.isDarkMode ? Colors.black54 : primaryColor,
                        elevation: 0
                      ),
                      child: Text('Select Image')
                    ),
                    Container(
                      height: Get.height / 5.5,
                      width: 180,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.file(imageFile!, fit: BoxFit.cover),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              SubmitButton(
                text: 'Create Product',
                onPressed: () {

                },
                isLoading: false,
              ),

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

}
