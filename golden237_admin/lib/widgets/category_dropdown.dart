import 'package:flutter/material.dart';
import '../models/category_model.dart';

class CategoryDropdown extends StatefulWidget {
  CategoryDropdown({Key? key}) : super(key: key);

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {

  late CategoryModel selectedCatModel;
  late CategoryModel selectedSubCatModel;
  late List<CategoryModel> subCatModel;

  ///Dummy data for testing
  List<CategoryModel> catModel = [
    CategoryModel(id: '001', name: 'Fashion & Beauty', image: 'assets/icons/fashion.png'),
    CategoryModel(id: '002', name: 'Mobile Phone', image: 'assets/icons/phone.png'),
    CategoryModel(id: '003', name: 'Personal Computer', image: 'assets/icons/computer.png'),
    CategoryModel(id: '004', name: 'Consoles & PDA', image: 'assets/icons/console.png'),
    CategoryModel(id: '005', name: 'Electronic Accessory', image: 'assets/icons/accessory-smart-watch.png'),
  ];

  List<CategoryModel> fashionSubModel = [
    CategoryModel(id: '101', name: 'Pant', image: 'assets/icons/fashion-jeans.png'),
    CategoryModel(id: '102', name: 'Heel', image: 'assets/icons/fashion-heels.png'),
    CategoryModel(id: '103', name: 'Jacket', image: 'assets/icons/fashion-jackets.png'),
    CategoryModel(id: '104', name: 'Glass', image: 'assets/icons/fashion-glasses.png'),
    CategoryModel(id: '105', name: 'Hat', image: 'assets/icons/fashion-hat.png'),
    CategoryModel(id: '106', name: 'Sneaker', image: 'assets/icons/fashion-sneakers.png'),
    CategoryModel(id: '107', name: 'Woman', image: 'assets/icons/fashion-woman.png'),
    CategoryModel(id: '108', name: 'Kid', image: 'assets/icons/fashion-kids.png'),
    CategoryModel(id: '109', name: 'Man', image: 'assets/icons/fashion-man.png'),
  ];

  List<CategoryModel> mobileSubModel = [
    CategoryModel(id: '201', name: 'Android', image: 'assets/icons/phone-android.png'),
    CategoryModel(id: '202', name: 'iOS', image: 'assets/icons/phone-iphone.png'),
    CategoryModel(id: '203', name: 'Windows', image: 'assets/icons/phone-window.png'),
  ];

  List<CategoryModel> computerSubModel = [
    CategoryModel(id: '301', name: 'Desktop', image: 'assets/icons/computer-desktop.png'),
    CategoryModel(id: '302', name: 'Laptop', image: 'assets/icons/computer-laptop.png'),
    CategoryModel(id: '303', name: 'Microcontroller', image: 'assets/icons/computer-micro.png'),
  ];

  List<CategoryModel> consoleSubModel = [
    CategoryModel(id: '401', name: 'PlayStation', image: 'assets/icons/console-playstation.png'),
    CategoryModel(id: '402', name: 'XBox', image: 'assets/icons/console-xbox.png'),
    CategoryModel(id: '403', name: 'Nintendo', image: 'assets/icons/console-nintendo.png'),
  ];

  List<CategoryModel> accessorySubModel = [
    CategoryModel(id: '501', name: 'AirPod', image: 'assets/icons/accessory-airpod.png'),
    CategoryModel(id: '502', name: 'Charger', image: 'assets/icons/accessory-charger.png'),
    CategoryModel(id: '503', name: 'HeadPhone', image: 'assets/icons/accessory-headphone.png'),
    CategoryModel(id: '504', name: 'SmartWatch', image: 'assets/icons/accessory-smartwatch.png'),
    CategoryModel(id: '505', name: 'HeadPhone', image: 'assets/icons/accessory-headphone.png'),
  ];


  @override
  void initState() {
    selectedCatModel = catModel[0];
    selectedSubCatModel = fashionSubModel[0];
    subCatModel = fashionSubModel;
    super.initState();
  }

  void _onDropDownItemSelected(CategoryModel newCategoryModel) {
    setState(() {
      selectedCatModel = newCategoryModel;
      if(newCategoryModel.id == catModel[0].id){
        subCatModel = fashionSubModel;
        selectedSubCatModel = fashionSubModel[0];
      }
      else if(newCategoryModel.id == catModel[1].id){
        subCatModel = mobileSubModel;
        selectedSubCatModel = mobileSubModel[0];
      }
      else if(newCategoryModel.id == catModel[2].id){
        subCatModel = computerSubModel;
        selectedSubCatModel = computerSubModel[0];
      }
      else if(newCategoryModel.id == catModel[3].id){
        subCatModel = consoleSubModel;
        selectedSubCatModel = consoleSubModel[0];
      }
      else if(newCategoryModel.id == catModel[4].id){
        subCatModel = accessorySubModel;
        selectedSubCatModel = accessorySubModel[0];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                label: const Text('Select Category'),
                contentPadding: const EdgeInsets.all(17.0),
                border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(10.0)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<CategoryModel>(
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    items: catModel
                        .map<DropdownMenuItem<CategoryModel>>(
                            (CategoryModel value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage(
                                      value.image),
                                ),
                                // Icon(valueItem.bank_logo),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(value.name),
                              ],
                            ),
                          );
                        }).toList(),

                    isExpanded: true,
                    isDense: true,
                    onChanged: (CategoryModel? newCategoryModel) {
                      _onDropDownItemSelected(newCategoryModel!);
                    },
                    value: selectedCatModel

                ),
              ),
            );
          },
        ),

        const SizedBox(height: 25),

        FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                label: const Text('Select SubCategory'),
                contentPadding: const EdgeInsets.all(17.0),
                border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(10.0)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<CategoryModel>(
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    items: subCatModel
                        .map<DropdownMenuItem<CategoryModel>>(
                            (CategoryModel value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage(
                                      value.image),
                                ),
                                // Icon(valueItem.bank_logo),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(value.name),
                              ],
                            ),
                          );
                        }).toList(),

                    isExpanded: true,
                    isDense: true,
                    onChanged: (CategoryModel? newCategoryModel) {
                      setState(() {
                        selectedSubCatModel = newCategoryModel!;
                      });
                    },
                    value: selectedSubCatModel

                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
