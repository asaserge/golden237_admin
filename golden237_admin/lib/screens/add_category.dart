import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:golden237_admin/messages/constants.dart';

import '../widgets/custom_input.dart';
import '../widgets/header_text.dart';
import '../widgets/header_widget.dart';
import '../widgets/subcat_input.dart';
import '../widgets/submit_button.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {

  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderWidget(
                text: 'You will be able to create a new product category for Golden237 store',
                image: 'assets/icons/category-icon.png',
              ),

              const SizedBox(height: 25),

              CustomInput(
                controller: _controller1,
                hintText: 'Category Name',
                label: 'Name',
                prefixIcon: Icons.category_outlined,
                onChange: (val){

                },
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 1,
                        backgroundColor: Get.isDarkMode ? Colors.black54 : primaryColor
                    ),
                    onPressed: (){

                    },
                    child: const Text('Select Image'),
                  ),

                  HeaderText(
                      text: 'No image selected', fontSize: 10.0,
                      fontWeight: FontWeight.w300
                  )
                ],
              ),

              const SizedBox(height: 35),

              SubmitButton(
                text: 'Create Category',
                onPressed: () {

                },
                isLoading: false,
              ),

              const SizedBox(height: 15),


              const Divider(thickness: 2),

              const SizedBox(height: 25),

              const HeaderWidget(
                text: 'You will be able to create a product subcategories for Golden237 store',
                image: 'assets/icons/subcategory.png',
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 1,
                        backgroundColor: Get.isDarkMode ? Colors.black54 : primaryColor
                    ),
                    onPressed: (){

                    },
                    child: const Text('Select Category'),
                  ),

                  HeaderText(
                      text: 'No category selected', fontSize: 10.0,
                      fontWeight: FontWeight.w300
                  )
                ],
              ),

              const SizedBox(height: 15),

              SubCatInput(
                controller1: _controller2,
                controller2: _controller3,
                hintText1: 'Name',
                hintText2: 'Value',
                icon: Icons.double_arrow_sharp,
                onChange2: (val){

                },
              ),

              const SizedBox(height: 15),

              SubCatInput(
                controller1: _controller2,
                controller2: _controller3,
                hintText1: 'Name',
                hintText2: 'Value',
                icon: Icons.double_arrow_sharp,
                onChange2: (val){

                },
              ),

              const SizedBox(height: 15),

              SubCatInput(
                controller1: _controller2,
                controller2: _controller3,
                hintText1: 'Name',
                hintText2: 'Value',
                icon: Icons.double_arrow_sharp,
                onChange2: (val){

                },
              ),

              const SizedBox(height: 30),

              SubmitButton(
                text: 'Create Subcategory',
                onPressed: () {

                },
                isLoading: false,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
