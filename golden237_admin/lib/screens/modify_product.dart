
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:golden237_admin/models/category_model.dart';
import 'package:golden237_admin/screens/catproduct_screen.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controller/category_controller.dart';
import '../controller/product_controller.dart';
import '../services/apis.dart';
import '../utils/constants.dart';
import '../widgets/custom_input.dart';
import '../widgets/header_widget.dart';
import '../widgets/submit_button.dart';

class ModifyProduct extends StatefulWidget {
  ModifyProduct({Key? key, this.productSnapshot,
    this.index}) : super(key: key);
  final AsyncSnapshot? productSnapshot;
  final int? index;

  @override
  State<ModifyProduct> createState() => _ModifyProductState();
}

class _ModifyProductState extends State<ModifyProduct> {

  late TextEditingController _controllerName;
  late TextEditingController _controllerDesc;
  late TextEditingController _controllerPrice;
  late TextEditingController _controllerBrand;
  late TextEditingController _controllerSize;
  late TextEditingController _controllerDisCount;

  final _inputForm = GlobalKey<FormState>();
  final CategoryController categoryController = Get.find();
  bool _isCatNotSelected = true;
  bool _isSubNotSelected = true;
  String selectedCatImage = 'https://flugbvlkubwicelziitq.supabase.co/storage/v1/object/sign/product/moto%20g.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJwcm9kdWN0L21vdG8gZy5wbmciLCJpYXQiOjE2NzkwNjI1NDAsImV4cCI6MTcxMDU5ODU0MH0.i_AYFdk9L6-7ZycSHsg4VU0-KIjaRVH0DF3T9UkvVpw&t=2023-03-17T14%3A15%3A39.935Z';
  String selectedCatId = '';
  String selectedSubName = '';
  String selectedSubImage = 'https://flugbvlkubwicelziitq.supabase.co/storage/v1/object/sign/product/moto%20g.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJwcm9kdWN0L21vdG8gZy5wbmciLCJpYXQiOjE2NzkwNjI1NDAsImV4cCI6MTcxMDU5ODU0MH0.i_AYFdk9L6-7ZycSHsg4VU0-KIjaRVH0DF3T9UkvVpw&t=2023-03-17T14%3A15%3A39.935Z';
  String selectedSubId = '';
  String selectedCatName = '';

  late bool _isNew;
  File? imageFile;
  var imageFileName;
  static const _locale = 'en';
  bool isPicked = false;
  bool isLoading = false;
  final storage = GetStorage();

  final DateFormat formatDate = DateFormat('dd/MM/yyyy hh:mm a');
  final formatCurrency = NumberFormat('#,###');
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));
  //String get _currency => NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
  String imageIrl = '';

  @override
  void initState() {
    _isCatNotSelected = widget.productSnapshot == null ? true : false;
    _isSubNotSelected = widget.productSnapshot == null ? true : false;
    selectedCatId = widget.productSnapshot == null ? '' : storage.read('catId') ??
        '62c81245-61e8-4e9f-b1fa-fcdeb94fcc75';
    selectedCatName = widget.productSnapshot == null ? '' : storage.read('catName') ?? 'Smart Phones';
    selectedCatImage = widget.productSnapshot == null ? '' : storage.read('catImage') ??
        'https://flugbvlkubwicelziitq.supabase.co/storage/v1/object/sign/category/mobile-phones.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJjYXRlZ29yeS9tb2JpbGUtcGhvbmVzLnBuZyIsImlhdCI6MTY3OTA1OTk3MCwiZXhwIjoxNzEwNTk1OTcwfQ.3OVT7JtcEtov7-togLjmADncwAAHSTmAlsU-n-cFofE&t=2023-03-17T13%3A32%3A49.986Z';
    selectedSubId = widget.productSnapshot == null ? '' : storage.read('subId') ??
        'a7232891-761d-4331-b829-35e3cde5979b';
    selectedSubName = widget.productSnapshot == null ? '' : storage.read('subName') ?? 'Windows Phone';
    selectedSubImage = widget.productSnapshot == null ? '' : storage.read('subImage') ??
        'https://flugbvlkubwicelziitq.supabase.co/storage/v1/object/sign/sub-category/windows-phone.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJzdWItY2F0ZWdvcnkvd2luZG93cy1waG9uZS5wbmciLCJpYXQiOjE2NzkxNTkwNjksImV4cCI6MTcxMDY5NTA2OX0.g2QqRaTKja2MlDMRiuGjbdRctZkYCvIvdKNk3pt_r0o&t=2023-03-18T17%3A04%3A26.374Z';

    _isNew = widget.productSnapshot == null ? true : widget.productSnapshot?.data[widget.index]['is_new'];
    _controllerName = widget.productSnapshot == null ? TextEditingController() :
    TextEditingController(text: widget.productSnapshot?.data[widget.index]['name']);
    _controllerDesc = widget.productSnapshot == null ? TextEditingController() :
    TextEditingController(text: widget.productSnapshot?.data[widget.index]['description']);
    _controllerPrice = widget.productSnapshot == null ? TextEditingController() :
    TextEditingController(text: '${widget.productSnapshot?.data[widget.index]['price']}');
    _controllerBrand = widget.productSnapshot == null ? TextEditingController() :
    TextEditingController(text: widget.productSnapshot?.data[widget.index]['brand']);
    _controllerDisCount = widget.productSnapshot == null ? TextEditingController() :
    TextEditingController(text: '${widget.productSnapshot?.data[widget.index]['discount']}');
    _controllerSize = widget.productSnapshot == null ? TextEditingController() :
    TextEditingController(text: '${widget.productSnapshot?.data[widget.index]['size']}');
    super.initState();
  }

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerPrice.dispose();
    _controllerBrand.dispose();
    _controllerSize.dispose();
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
        title: widget.productSnapshot == null ? const Text('Add Product') : const Text('Edit Product'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.productSnapshot == null ?
              const HeaderWidget(
                text: 'You will be able to create new products to showcase on Golden237 store',
                image: 'assets/icons/add.png',
              ) :
              const HeaderWidget(
                text: 'You will be able to edit existing products on Golden237 store',
                image: 'assets/icons/add.png',
              ),

              const SizedBox(height: 25),

              GestureDetector(
                onTap: (){
                  if(_isSubNotSelected){
                    showCatBottomOptions(context);
                  }
                  else{
                    setState(() {
                      _isSubNotSelected = true;
                    });
                    selectedSubId = '';
                    selectedSubName = '';
                    showCatBottomOptions(context);
                  }
                },
                child: Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                        color: Colors.white38,
                        width: 1
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: _isCatNotSelected,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(left: 9.0, right: 13.0),
                                  child: Icon(Icons.category_outlined, color: primaryColor, size: 26),
                                ),
                                Text('Select Category*', style: TextStyle(fontWeight: FontWeight.w400,
                                    color: Colors.white60, fontSize: 16)),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 30.0),
                              child: Icon(Icons.arrow_drop_down_outlined, color: Colors.white60, size: 30),
                            ),
                          ],
                        ),
                      ),

                      Visibility(
                        visible: !_isCatNotSelected,
                        child: ListTile(
                          dense: true,
                          tileColor: Colors.grey.withOpacity(0.1),
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(selectedCatImage),
                          ),
                          title: Text(selectedCatName, maxLines: 1,
                              overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16.0)),
                          subtitle: const Text('Category Type', maxLines: 1,
                              overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.0)),
                          trailing: const Padding(
                            padding: EdgeInsets.only(right: 30.0),
                            child: Icon(Icons.arrow_drop_down_outlined, color: Colors.white60, size: 30),
                          ),
                        )
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              GestureDetector(
                onTap: (){
                  if(_isCatNotSelected){
                    showBottomSnackBarMsg(context, 'Warning!', 'You must select a category first!', Colors.red);
                  }
                  else{
                    showSubBottomOptions(context);
                  }

                },
                child: Container(
                  height: 66,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                        color: Colors.white38,
                        width: 1
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: _isSubNotSelected,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(left: 9.0, right: 13.0),
                                  child: Icon(Icons.sort_outlined, color: primaryColor, size: 26),
                                ),
                                Text('Select Subcategory*', style: TextStyle(fontWeight: FontWeight.w400,
                                    color: Colors.white60, fontSize: 16)),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 30.0),
                              child: Icon(Icons.arrow_drop_down_outlined, color: Colors.white60, size: 30),
                            ),
                          ],
                        ),
                      ),

                      Visibility(
                          visible: !_isSubNotSelected,
                          child: ListTile(
                            dense: true,
                            tileColor: Colors.grey.withOpacity(0.1),
                            leading: CircleAvatar(
                              radius: 23,
                              backgroundImage: NetworkImage(selectedSubImage),
                            ),
                            title: Text(selectedSubName, maxLines: 1,
                                overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16.0)),
                            subtitle: const Text('Subcategory Type', maxLines: 1,
                                overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.0)),
                            trailing: const Padding(
                              padding: EdgeInsets.only(right: 30.0),
                              child: Icon(Icons.arrow_drop_down_outlined, color: Colors.white60, size: 30),
                            ),
                          )
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

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
                          maxCount: 6,
                          label: 'Size',
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
                          maxCount: 9,
                          prefixIcon: Icons.discount_outlined,
                          label: 'Discount',
                          prefixText: 'XAF ',
                          onChange: (val) {
                            setState(() {
                              val = _formatNumber(val!.replaceAll(',', ''));
                              _controllerDisCount.value = TextEditingValue(
                                text: val!,
                                selection: TextSelection.collapsed(
                                    offset: val!.length),
                              );
                            });
                            return null;
                          },
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
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
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
                            child: widget.productSnapshot == null ?
                              Image.asset(
                                'assets/icons/no-image.png', scale: 2) : Image.network(
                                widget.productSnapshot?.data[widget.index]['image'])
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

              widget.productSnapshot == null ?
              SubmitButton(
                text: 'Create Product',
                isLoading: isLoading,
                isEnabled: true,
                onPressed: () {
                  if(selectedCatId == ''){
                    showBottomSnackBarMsg(context, 'Warning!', 'You must select a category!', Colors.red);
                  }
                  else if(selectedSubId == ''){
                    showBottomSnackBarMsg(context, 'Warning!', 'You must select a subcategory!', Colors.red);
                  }
                  else if(_inputForm.currentState!.validate()){
                    if(imageFile == null){
                      showBottomSnackBarMsg(context, 'Warning!', 'Please add an image!!!', Colors.red);
                    }
                    else{
                      setState(() {
                        isLoading = true;
                      });

                      ///Upload product method
                      uploadProduct(context);
                      ScaffoldMessenger.of(context).showSnackBar(snackBarSuccess);
                      Navigator.of(context).pop();
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
                      });

                      ///Update product method
                      updateProduct(context);
                      ScaffoldMessenger.of(context).showSnackBar(snackBarSuccess);
                      Navigator.of(context).pop();
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

  ///Function to upload product
  uploadProduct(BuildContext context) async{
    final fileName = imageFile!.path.toString().trim();
    await Apis.client.storage
        .from('product')
        .upload(fileName, imageFile!);
    final imageUrl = Apis.client.storage.from('product').getPublicUrl(fileName);
    await Apis.client.from('product').insert({
      'name': _controllerName.text,
      'price': _controllerPrice.text.replaceAll(',', ''),
      'description': _controllerDesc.text,
      'brand': _controllerBrand.text,
      'discount': _controllerDisCount.text.replaceAll(',', ''),
      'category': selectedSubId,
      'image': imageUrl,
      'is_new': _isNew,
      'sku': getRandomString() + getRandomNumber(),
      'size': _controllerSize.text,
      'sold': 0,
    });
  }

  updateProduct(BuildContext context) async{
    final fileName = imageFile!.path.toString().trim();
    await Apis.client.storage
        .from('product')
        .upload(fileName, imageFile!);
    final imageUrl = Apis.client.storage.from('product').getPublicUrl(fileName);

    await Apis.client.from('product').update({
      'name': _controllerName.text,
      'price': _controllerPrice.text.replaceAll(',', ''),
      'description': _controllerDesc.text,
      'brand': _controllerBrand.text,
      'discount': _controllerDisCount.text.replaceAll(',', ''),
      'category': selectedSubId,
      'image': imageUrl,
      'is_new': _isNew,
      'sku': getRandomString() + getRandomNumber(),
      'size': _controllerSize.text,
      'sold': 0,
    });
  }

  showBottomSnackBarMsg(BuildContext context, String title, String msg, Color color){
    final snackBar = SnackBar(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10.0),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 20)),
          const SizedBox(height: 5.0),
          Text(msg, style: const TextStyle(color: Colors.white)),
        ],
      ),
      duration: const Duration(seconds: 4),
      backgroundColor: (color),
      dismissDirection: DismissDirection.vertical,
      // action: SnackBarAction(
      //   label: 'Dismiss',
      //   textColor: Colors.black,
      //   onPressed: () {
      //     Navigator.of(context).pop();
      //   },
      // ),
    );
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  showCatBottomOptions(BuildContext context){
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) {
          return Container(
            height: 450,
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const Text('Select a category', style: TextStyle(fontSize: 18, fontWeight:  FontWeight.w700)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.black
                          ),
                          child: const Icon(Icons.cancel_outlined, color: Colors.red, size: 25)
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: FutureBuilder(
                    future: categoryController.getMainCategory(),
                    builder: (context, snapshot){
                      if(snapshot.hasError){
                        return const Center(
                            child: Text('Something went wrong!')
                        );
                      }
                      if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){
                        return lisCatWidget(snapshot);
                      }
                      return Center(
                          child: Column(
                            children: const [
                              SizedBox(height: 45.0),
                              CircularProgressIndicator(
                                strokeWidth: 3,
                                color: primaryColor,
                              ),
                              SizedBox(height: 12.0),
                              Text('Loading, please wait...', style: TextStyle(fontSize: 14, fontWeight:  FontWeight.w300))
                            ],
                          )
                      );

                    },
                  )
                ),
                const SizedBox(height: 15),
              ],
            ),
          );
        });
  }

  showSubBottomOptions(BuildContext context){
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) {
          return Container(
            height: 450,
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const Text('Select a subcategory', style: TextStyle(fontSize: 18, fontWeight:  FontWeight.w700)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Container(
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.black
                          ),
                          child: const Icon(Icons.cancel_outlined, color: Colors.red, size: 25)
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 25),
                Expanded(
                    child: FutureBuilder(
                      future: categoryController.getSpecificSubCategory(selectedCatId),
                      builder: (context, snapshot){
                        if(snapshot.hasError){
                          return const Center(
                              child: Text('Something went wrong!')
                          );
                        }
                        if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){
                          return lisSubWidget(snapshot);
                        }
                        return Center(
                            child: Column(
                              children: const [
                                SizedBox(height: 45.0),
                                CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: primaryColor,
                                ),
                                SizedBox(height: 12.0),
                                Text('Loading, please wait...', style: TextStyle(fontSize: 14, fontWeight:  FontWeight.w300))
                              ],
                            )
                        );

                      },
                    )
                ),
                const SizedBox(height: 15),
              ],
            ),
          );
        });
  }

  Widget lisCatWidget(AsyncSnapshot snap){
    return ListView.builder(
        itemCount: snap.data.length,
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: (){
              setState(() {
                _isCatNotSelected = false;
                selectedCatId = snap.data[index]['id'];
                selectedCatName = snap.data[index]['name'];
                selectedCatImage = snap.data[index]['image'];
                storage.write('catId', snap.data[index]['id']);
                storage.write('catName', snap.data[index]['name']);
                storage.write('catImage', snap.data[index]['image']);
              });

              Navigator.of(context).pop();
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                dense: true,
                tileColor: Colors.grey.withOpacity(0.1),
                visualDensity: const VisualDensity(vertical: 2),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                      snap.data[index]['image']
                  ),
                ),
                title: Text(snap.data[index]['name'], maxLines: 1,
                    overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16.0)),
              ),
            ),
          );
        }
    );
  }

  Widget lisSubWidget(AsyncSnapshot snap){
    return ListView.builder(
        itemCount: snap.data.length,
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: (){
              setState(() {
                _isSubNotSelected = false;
                selectedSubId = snap.data[index]['id'];
                selectedSubName = snap.data[index]['name'];
                selectedSubImage = snap.data[index]['image'];
                storage.write('subId', snap.data[index]['id']);
                storage.write('subName', snap.data[index]['name']);
                storage.write('subImage', snap.data[index]['image']);
              });

              Navigator.of(context).pop();
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                dense: true,
                tileColor: Colors.grey.withOpacity(0.1),
                visualDensity: const VisualDensity(vertical: 2),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                      snap.data[index]['image']
                  ),
                ),
                title: Text(snap.data[index]['name'], maxLines: 1,
                    overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16.0)),
              ),
            ),
          );
        }
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

    ///Todo upload product image

    return null;


  }

  String getRandomString() => String.fromCharCodes(Iterable.generate(
      3, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  String getRandomNumber() => String.fromCharCodes(Iterable.generate(
      3, (_) => _numbers.codeUnitAt(_rnd.nextInt(_numbers.length))));

  final snackBarSuccess = SnackBar(
    content: const Text('Product updated successfully!!', style: TextStyle(color: Colors.white)),
    backgroundColor: (Colors.green),
    action: SnackBarAction(
      label: 'Dismiss',
      textColor: Colors.black,
      onPressed: () {

      },
    ),
  );

  final _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  final _numbers = '1234567890';
  final Random _rnd = Random();
}

