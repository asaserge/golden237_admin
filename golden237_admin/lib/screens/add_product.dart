
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden237_admin/models/category_model.dart';
import 'package:golden237_admin/screens/catproduct_screen.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/constants.dart';
import '../widgets/custom_input.dart';
import '../widgets/header_widget.dart';
import '../widgets/submit_button.dart';

class AddProduct extends StatefulWidget {
  AddProduct({Key? key, required this.option, this.obj}) : super(key: key);
  final String option;
  var obj;

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  late TextEditingController _controllerName;
  late TextEditingController _controllerDesc;
  late TextEditingController _controllerPrice;
  late TextEditingController _controllerBrand;
  late TextEditingController _controllerSize;
  late TextEditingController _controllerColor;
  late TextEditingController _controllerQuantity;
  late TextEditingController _controllerDisCount;

  final _inputForm = GlobalKey<FormState>();

  late bool _isNew;
  File? imageFile;
  var imageFileName;
  static const _locale = 'en';
  bool isPicked = false;
  bool isLoading = false;
  final DateFormat formatDate = DateFormat.yMMMd();
  final formatCurrency = NumberFormat('#,###');
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));
  //String get _currency => NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
  String imageIrl = '';

  @override
  void initState() {
    _isNew = widget.obj == null ? true : widget.obj['isNew'];
    _controllerName = widget.obj == null ? TextEditingController() : TextEditingController(text: widget.obj['name']);
    _controllerDesc = widget.obj == null ? TextEditingController() : TextEditingController(text: widget.obj['description']);
    _controllerPrice = widget.obj == null ? TextEditingController() : TextEditingController(text: '${widget.obj['price']}');
    _controllerBrand = widget.obj == null ? TextEditingController() : TextEditingController(text: widget.obj['brand']);
    _controllerSize = TextEditingController();
    _controllerColor = TextEditingController();
    _controllerQuantity = widget.obj == null ? TextEditingController() : TextEditingController(text: '${widget.obj['quantity']}');
    _controllerDisCount = widget.obj == null ? TextEditingController() : TextEditingController(text: '${widget.obj['discount']}');
    super.initState();
  }

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerPrice.dispose();
    _controllerBrand.dispose();
    _controllerSize.dispose();
    _controllerColor.dispose();
    _controllerQuantity.dispose();
    _controllerDisCount.dispose();
    _controllerDesc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        title: widget.option == "add" ? const Text('Add Product') : const Text('Edit Product'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.option == "add" ?
              const HeaderWidget(
                text: 'You will be able to create new products to showcase on Golden237 store',
                image: 'assets/icons/user-icon.png',
              ) :
              const HeaderWidget(
                text: 'You will be able to edit existing products on Golden237 store',
                image: 'assets/icons/user-icon.png',
              ),

              const SizedBox(height: 25),

              // CategoryDropdown(),

              Form(
                key: _inputForm,
                child: Column(
                  children: [
                    CustomInput(
                      controller: _controllerName,
                      hintText: 'Product Name',
                      prefixIcon: Icons.drive_file_rename_outline,
                      label: 'Name*',
                      maxCount: 22,
                      validator: (val) {
                        if (val! == '' || val == null) {
                          return 'Name is required!';
                        }
                        else if (val.length < 5) {
                          return 'Name too short!';
                        }
                      },
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(child: CustomInput(
                          controller: _controllerPrice,
                          hintText: 'Price',
                          prefixIcon: Icons.price_change_outlined,
                          textInputType: TextInputType.number,
                          maxCount: 9,
                          validator: (val) {
                            if (val! == '' || val == null) {
                              return 'Price is required!';
                            }
                            else if (val.length < 4) {
                              return 'Price too short!';
                            }
                          },
                          prefixText: 'XAF ',
                          label: 'Price*',
                          onChange: (val) {
                            setState(() {
                              val = _formatNumber(val!.replaceAll(',', ''));
                              _controllerPrice.value = TextEditingValue(
                                text: val!,
                                selection: TextSelection.collapsed(
                                    offset: val!.length),
                              );
                            });
                            return null;
                          },
                        )),
                        const SizedBox(width: 12.0),
                        Expanded(child: CustomInput(
                          controller: _controllerBrand,
                          hintText: 'Product Brand',
                          maxCount: 10,
                          prefixIcon: Icons.branding_watermark_outlined,
                          label: 'Brand*',
                          validator: (val) {
                            if (val! == '' || val == null) {
                              return 'Brand is required!';
                            }
                          },
                        )),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(child: CustomInput(
                          controller: _controllerSize,
                          hintText: 'Size',
                          prefixIcon: Icons.format_size_outlined,
                          maxCount: 4,
                          label: 'Size',
                          onChange: (val) {
                            setState(() {

                            });
                            return null;
                          },
                        )),
                        const SizedBox(width: 12.0),
                        Expanded(child: CustomInput(
                          controller: _controllerColor,
                          hintText: 'Product Color',
                          prefixIcon: Icons.color_lens_outlined,
                          label: 'Color',
                        )),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(child: CustomInput(
                          controller: _controllerQuantity,
                          hintText: 'Quantity',
                          textInputType: TextInputType.number,
                          prefixIcon: Icons.production_quantity_limits_outlined,
                          maxCount: 4,
                          validator: (val) {
                            if (val! == '' || val == null) {
                              return 'Quantity is required!';
                            }
                          },
                          label: 'Quantity*',
                          onChange: (val) {
                            setState(() {

                            });
                            return null;
                          },
                        )),
                        const SizedBox(width: 12.0),
                        Expanded(child: CustomInput(
                          controller: _controllerDisCount,
                          hintText: 'Discount',
                          textInputType: TextInputType.number,
                          maxCount: 3,
                          prefixIcon: Icons.discount_outlined,
                          label: 'Discount',
                        )),
                      ],
                    ),

                    const SizedBox(height: 15),

                    SwitchListTile(
                        value: _isNew,
                        activeColor: primaryColor,
                        title: const Text('Product State'),
                        subtitle: _isNew
                            ? const Text('It\'s brand new product')
                            : const Text('It\'s fairly used new product'),
                        dense: true,
                        visualDensity: const VisualDensity(vertical: 0),
                        secondary: _isNew ? const Icon(
                            Icons.new_releases_outlined, color: primaryColor)
                            : const Icon(Icons.real_estate_agent_outlined,
                            color: primaryColor),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Get.isDarkMode ? Colors.white38 : Colors
                                  .black54,
                              width: 1
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _isNew = val;
                          });
                        }
                    ),

                    const SizedBox(height: 25),

                    CustomInput(
                      controller: _controllerDesc,
                      hintText: 'Product Description',
                      prefixIcon: Icons.description_outlined,
                      label: 'Description',
                      maxLines: 8,
                      maxCount: 500,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _pickImageFromGallery();
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Get.isDarkMode ? Colors
                                          .black54 : primaryColor,
                                      elevation: 0
                                  ),
                                  child: const Text('Select Image',
                                      style: TextStyle(color: Colors.white))
                              ),


                              Visibility(
                                  visible: isPicked,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        imageFile = null;
                                        isPicked = false;
                                      });
                                    },
                                    child: const Icon(Icons.cancel_outlined,
                                        color: Colors.red),
                                  )
                              )
                            ],
                          ),

                          imageFile == null ?
                           Container(
                            height: Get.height / 7,
                            width: 120,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: widget.obj == null ?
                              Image.asset(
                                'assets/icons/no-image.png', scale: 2) : Image.network(widget.obj['image'])
                          ) :
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

                  ],
                ),
              ),

              widget.option == 'add' ?
              SubmitButton(
                text: 'Create Product',
                isLoading: isLoading,
                isEnabled: true,
                onPressed: () {
                  if(_inputForm.currentState!.validate()){
                    if(imageFile == null){
                      Get.snackbar('oops!', 'Please select a product image',
                          colorText: Colors.white, backgroundColor: Colors.red,
                          borderRadius: 0
                      );
                    }
                    else{
                      setState(() {
                        isLoading = true;
                       // imageIrl = uploadAndGetFileUrl() as String;
                      });

                      createProduct(
                        productName: _controllerName.text.trim(),
                        productBrand: _controllerBrand.text.trim(),
                        productPrice: int.parse(_controllerPrice.text.replaceAll(',', '')),
                        productQuantity: int.parse(_controllerQuantity.text),
                        productDiscount: 0,
                        productDesc: _controllerDesc.text.trim(),
                        productIsNew: _isNew,
                        productImage: imageIrl,
                        id: '',
                        context: context
                      );
                    }

                  }
                  else{
                    return;
                  }

                },
              ) :
              SubmitButton(
                text: 'Update Product',
                isLoading: isLoading,
                isEnabled: true,
                onPressed: () {
                  if(_inputForm.currentState!.validate()){
                    if(imageFile == null){
                      Get.snackbar('oops!', 'Please select a product image',
                          colorText: Colors.white, backgroundColor: Colors.red,
                          borderRadius: 0
                      );
                    }
                    else{
                      setState(() {
                        isLoading = true;
                       // imageIrl = uploadAndGetFileUrl() as String;
                      });

                      updateProduct(
                        productName: _controllerName.text.trim(),
                        productBrand: _controllerBrand.text.trim(),
                        productPrice: int.parse(_controllerPrice.text.replaceAll(',', '')),
                        productQuantity: int.parse(_controllerQuantity.text),
                        productDiscount: 0,
                        productDesc: _controllerDesc.text.trim(),
                        productIsNew: _isNew,
                        productImage: imageIrl,
                        id: '',
                        context: context,
                      );
                    }

                  }
                  else{
                    return;
                  }

                },
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
          imageFileName = pickedImage.name;
          isPicked = true;
        });
      }
    } catch (e) {
      Get.snackbar('Oops!', 'Failed to pick image!',
          borderRadius: 0,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<String?> uploadAndGetFileUrl() async {
    final fileName = basename(imageFile!.path);
    final destination = 'files/$fileName';

    //Todo upload product image
    // try {
    //   final ref = storage.ref(destination).child('file/');
    //   await ref.putFile(imageFile!);
    //   var imageUrl = await ref.getDownloadURL();
    //   return imageUrl;
    // } catch (e) {
    //   Get.snackbar('Oops!', e.toString(),
    //       colorText: Colors.white, backgroundColor: Colors.red,
    //       borderRadius: 0
    //   );
    // }
    return null;
    // }

  }

  Future<void> createProduct({
    required String productImage, required BuildContext context, required String id,
    required String productName, required int productPrice, required String productBrand,
    String? productSize, String? productColor, required int productQuantity,
    int? productDiscount, required bool productIsNew, required String? productDesc,
    List<String>? color, List<CategoryModel>? category, List<String>? size,
  }) async {
    ProductModel productModel = ProductModel(
      id: id,
      name: productName,
      price: productPrice,
      brand: productBrand,
      image: productImage,
      created: formatDate.format(DateTime.now()),
      quantity: productQuantity,
      isNew: productIsNew,
      discount: productDiscount ?? 0,
      sku: generateRandomString(),
    );

    //Todo add product
  }

  Future<void> updateProduct({
    required String productImage, required BuildContext context, required String id,
    required String productName, required int productPrice, required String productBrand,
    String? productSize, String? productColor, required int productQuantity,
    int? productDiscount, required bool productIsNew, required String? productDesc,
    List<String>? color, List<CategoryModel>? category, List<String>? size,
  }) async {

    ProductModel productModel = ProductModel(
      id: id,
      name: productName,
      price: productPrice,
      brand: productBrand,
      image: productImage,
      created: formatDate.format(DateTime.now()),
      quantity: productQuantity,
      isNew: productIsNew,
      //color: productColor.map<Map>((e)=> e.toMap()).toList(),
      discount: productDiscount ?? 0,
      sku: generateRandomString(),
    );
    //Todo update product
  }

  String generateRandomString() {
    var r = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    return List.generate(8, (index) => chars[r.nextInt(chars.length)]).join();
  }

}

