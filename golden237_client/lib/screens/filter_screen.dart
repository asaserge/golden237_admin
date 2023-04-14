import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/category_controller.dart';
import '../models/color_model.dart';
import '../utils/messages.dart';
import '../widgets/widget_text.dart';

class FilterScreen extends StatelessWidget {
  FilterScreen({Key? key}) : super(key: key);

  int selectedColor = 0;
  String starRating = 'rating';
  final CategoryController categoryController = Get.find();
  final currencyFormatter = NumberFormat('#,###');

  List<ColorModel> colorModel = [
    ColorModel(name: 'Green', color: Colors.green),
    ColorModel(name: 'Red', color: Colors.red),
    ColorModel(name: 'Pink', color: Colors.pink),
    ColorModel(name: 'Brown', color: Colors.brown),
    ColorModel(name: 'Yellow', color: Colors.yellow),
    ColorModel(name: 'Black', color: Colors.black),
    ColorModel(name: 'Purple', color: Colors.purple),
    ColorModel(name: 'White', color: Colors.white),
    ColorModel(name: 'Blue', color: Colors.blue),
    ColorModel(name: 'Orange', color: Colors.orange),
    ColorModel(name: 'Teal', color: Colors.tealAccent),
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(

        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 30.0),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    WidgetText(text: 'Advance Filter', font: 'montserrat_bold', size: 20),
                  ],
                ),
                const SizedBox(height: 70.0),
                GestureDetector(
                  onTap: (){
                    showProductCategory(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const WidgetText(text: 'Category'),
                          const SizedBox(width: 8.0),
                          Obx(() => WidgetText(text: categoryController.selectedCatName.value, size: 14)),
                        ],
                      ),
                      Row(
                        children: const [
                          WidgetText(text: 'Pick', size: 13),
                          SizedBox(width: 10.0),
                          Icon(Icons.arrow_forward_ios_outlined, size: 15),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40.0),
                GestureDetector(
                  onTap: (){
                    showProductSubCategory(context, categoryController.selectedCatId.value);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const WidgetText(text: 'Subcategory'),
                          const SizedBox(width: 8.0),
                          Obx(() => WidgetText(text: categoryController.selectedSubCatName.value, size: 14)),
                        ],
                      ),
                      Row(
                        children: const [
                          WidgetText(text: 'Pick', size: 13),
                          SizedBox(width: 10.0),
                          Icon(Icons.arrow_forward_ios_outlined, size: 15),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const WidgetText(text: 'Colors'),
                    Row(
                      children: [
                        Obx(() => WidgetText(text: categoryController.selectedColor.value, size: 14)),
                        const SizedBox(width: 5.0),
                        const Icon(Icons.expand_less_outlined, size: 27),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ListView.builder(
                      itemCount: colorModel.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index){
                        return GestureDetector(
                          onTap: (){
                            categoryController.clickedColor.value = index;
                            categoryController.selectedColor.value = colorModel[index].name;
                          },
                          child: Obx(() =>
                              Card(
                                elevation: 2,
                                color: categoryController.clickedColor.value == index ?
                                Colors.black : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 10,
                                        backgroundColor: colorModel[index].color,
                                      ),
                                      const SizedBox(width: 8.0),
                                      WidgetText(text: colorModel[index].name, size: 14,
                                        color: categoryController.clickedColor.value == index ?
                                        Colors.white : Colors.black,)
                                    ],
                                  ),
                                ),
                              )
                          ),
                        );
                      }
                  ),
                ),

                const SizedBox(height: 40.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const WidgetText(text: 'Price Range'),
                    Row(
                      children: [
                        Obx(() => WidgetText(text: 'XAF ${currencyFormatter.format(categoryController.currentRangeValues.value.start)} '
                            '- ${currencyFormatter.format(categoryController.currentRangeValues.value.end)}', size: 14)),
                        const SizedBox(width: 5.0),
                        const Icon(Icons.expand_less_outlined, size: 27),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20.0),
                Obx(() =>
                  RangeSlider(
                    values: categoryController.currentRangeValues.value,
                    min: 0,
                    max: 300000,
                    divisions: 10,
                    activeColor: Get.isDarkMode ? Colors.white : Colors.black,

                    inactiveColor: Colors.grey,
                    labels: RangeLabels(
                      categoryController.currentRangeValues.value.start.round().toString(),
                      categoryController.currentRangeValues.value.end.round().toString(),
                    ),
                    onChanged: (val){
                      categoryController.currentRangeValues.value = val;
                    }
                  )
                ),

                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const WidgetText(text: 'Customer Reviews'),
                    Row(
                      children: [
                        WidgetText(text: 'Rating', size: 14),
                        const SizedBox(width: 5.0),
                        const Icon(Icons.expand_less_outlined, size: 27),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star_sharp, color: Get.isDarkMode ? Colors.white : Colors.black),
                            Icon(Icons.star_sharp, color: Get.isDarkMode ? Colors.white : Colors.black),
                            Icon(Icons.star_sharp, color: Get.isDarkMode ? Colors.white : Colors.black),
                            Icon(Icons.star_sharp, color: Get.isDarkMode ? Colors.white : Colors.black),
                            Icon(Icons.star_outline, color: Get.isDarkMode ? Colors.white : Colors.black),
                          ],
                        ),
                        const SizedBox(width: 10.0),
                        const WidgetText(text: '& Up', size: 14,),
                      ],
                    ),

                    Radio(
                      value: '4 Stars and up',
                      activeColor: Get.isDarkMode ? Colors.white : Colors.black,
                      groupValue: starRating,
                      toggleable: true,
                      onChanged: (val){
                        categoryController.isStarCheck.value = val.toString();
                      }
                    )

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star_sharp, color: Get.isDarkMode ? Colors.white : Colors.black),
                            Icon(Icons.star_sharp, color: Get.isDarkMode ? Colors.white : Colors.black),
                            Icon(Icons.star_sharp, color: Get.isDarkMode ? Colors.white : Colors.black),
                            Icon(Icons.star_outline, color: Get.isDarkMode ? Colors.white : Colors.black),
                            Icon(Icons.star_outline, color: Get.isDarkMode ? Colors.white : Colors.black),
                          ],
                        ),
                        const SizedBox(width: 10.0),
                        const WidgetText(text: '& Up', size: 14,),
                      ],
                    ),

                     Radio(
                        value: '3 Stars and up',
                        activeColor: Colors.black,
                        groupValue: starRating,
                        onChanged: (val){
                          categoryController.isStarCheck.value = val.toString();
                        }
                    )

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star_sharp, color: Get.isDarkMode ? Colors.white : Colors.black),
                            Icon(Icons.star_sharp, color: Get.isDarkMode ? Colors.white : Colors.black),
                            Icon(Icons.star_outline, color: Get.isDarkMode ? Colors.white : Colors.black),
                            Icon(Icons.star_outline, color: Get.isDarkMode ? Colors.white : Colors.black),
                            Icon(Icons.star_outline, color: Get.isDarkMode ? Colors.white : Colors.black),
                          ],
                        ),
                        const SizedBox(width: 10.0),
                        const WidgetText(text: '& Up', size: 14,),
                      ],
                    ),

                     Radio(
                        value: '2 Stars and up',
                        activeColor: Colors.black,
                        groupValue: starRating,
                        onChanged: (val){
                          categoryController.isStarCheck.value = val.toString();
                        }
                    )

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star_sharp, color: Get.isDarkMode ? Colors.white : Colors.black),
                            Icon(Icons.star_outline, color: Get.isDarkMode ? Colors.white : Colors.black),
                            Icon(Icons.star_outline, color: Get.isDarkMode ? Colors.white : Colors.black),
                            Icon(Icons.star_outline, color: Get.isDarkMode ? Colors.white : Colors.black),
                            Icon(Icons.star_outline, color: Get.isDarkMode ? Colors.white : Colors.black),
                          ],
                        ),
                        const SizedBox(width: 10.0),
                        const WidgetText(text: '& Up', size: 14,),
                      ],
                    ),

                     Radio(
                        value: '1 Star and up',
                        activeColor: Colors.black,
                        groupValue: starRating,
                        onChanged: (val){
                          categoryController.isStarCheck.value = val.toString();
                        }
                    )

                  ],
                ),

                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 40,
                      width: size.width / 2,
                      margin: const EdgeInsets.only(top: 30.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border:  Border.all(
                              width: 2,
                              color: Get.isDarkMode ? Colors.white : Colors.black
                          )
                      ),
                      child:  const Center(child: WidgetText(text: 'Apply Filter', font: 'montserrat_bold', size: 18)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),


              ],
            ),
          ),
        ),
      ),
    );
  }

  showProductCategory(BuildContext context){
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (context) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                )
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const WidgetText(text: 'Select Category', size: 18),
                const SizedBox(height: 30.0),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: categoryController.categoryList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index){
                      return ListTile(
                        leading: CircleAvatar(
                          child: Image.network(categoryController.categoryList[index]['image']),
                        ),
                        title: WidgetText(text: categoryController.categoryList[index]['name'], size: 14),
                        onTap: (){
                          categoryController.selectedCatName.value = categoryController.categoryList[index]['name'];
                          categoryController.selectedCatId.value = categoryController.categoryList[index]['id'];
                          categoryController.isCatSelected.value = true;
                          Navigator.of(context).pop();
                        },
                      );
                    }
                  ),
                )

              ],
            ),
          );
        });
  }

  showProductSubCategory(BuildContext context, String id){
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (context) {
          return FutureBuilder(
              future: categoryController.fetchGroupSubCategories(id),
              builder: (context, snapshot){
                if(snapshot.hasError){
                  return WidgetText(text: snapshot.error.toString());
                }
                else if(snapshot.hasData && snapshot.connectionState == ConnectionState.waiting){
                  return spinkit;
                }
                return loadWidget(snapshot);
              }
          );;
        });
  }

  loadWidget(AsyncSnapshot snap){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
          )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const WidgetText(text: 'Select Subcategory', size: 18),
          const SizedBox(height: 30.0),
          SizedBox(
            height: 300,
            child: ListView.builder(
                itemCount: snap.data?.length ?? 0,
                shrinkWrap: true,
                itemBuilder: (context, index){
                  return ListTile(
                    leading: CircleAvatar(
                      child: Image.network(snap.data[index]['image']),
                    ),
                    title: WidgetText(text: snap.data[index]['name'], size: 14),
                    onTap: (){
                      categoryController.selectedSubCatName.value = snap.data[index]['name'];
                      categoryController.selectedSubCatId.value = snap.data[index]['id'];
                      Navigator.of(context).pop();
                    },
                  );
                }
            ),
          )

        ],
      ),
    );
  }


}


