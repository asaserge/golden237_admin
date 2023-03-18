import 'package:flutter/material.dart';
import '../models/category_model.dart';

class CategoryDropdown extends StatefulWidget {
  CategoryDropdown({Key? key}) : super(key: key);

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {

  late List<CategoryModel> categoryData = [];
  late CategoryModel selectedCatModel;
  late CategoryModel selectedSubCatModel;

  @override
  void initState() {
    for (var element in categoryList) {
      categoryData.add(CategoryModel.fromJson(element));
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        // FormField<String>(
        //   builder: (FormFieldState<String> state) {
        //     return InputDecorator(
        //       decoration: InputDecoration(
        //         label: const Text('Select Category'),
        //         contentPadding: const EdgeInsets.all(17.0),
        //         border: OutlineInputBorder(
        //             borderRadius:
        //             BorderRadius.circular(10.0)),
        //       ),
        //       child: DropdownButtonHideUnderline(
        //         child: DropdownButton<CategoryModel>(
        //             style: const TextStyle(
        //               fontSize: 16,
        //               color: Colors.grey,
        //             ),
        //             items: categoryData
        //                 .map<DropdownMenuItem<CategoryModel>>(
        //                     (CategoryModel value) {
        //                   return DropdownMenuItem(
        //                     value: value,
        //                     child: Row(
        //                       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                       children: [
        //                         CircleAvatar(
        //                           backgroundImage: AssetImage(
        //                               value.image),
        //                         ),
        //                         // Icon(valueItem.bank_logo),
        //                         const SizedBox(
        //                           width: 15,
        //                         ),
        //                         Text(value.name),
        //                       ],
        //                     ),
        //                   );
        //                 }).toList(),
        //
        //             isExpanded: true,
        //             isDense: true,
        //             onChanged: (CategoryModel? newCategoryModel) {
        //               setState(() {
        //                 selectedCatModel = newCategoryModel!;
        //               });
        //             },
        //             value: selectedCatModel
        //
        //         ),
        //       ),
        //     );
        //   },
        // ),
        //
        // const SizedBox(height: 25),
        //
        // FormField<String>(
        //   builder: (FormFieldState<String> state) {
        //     return InputDecorator(
        //       decoration: InputDecoration(
        //         label: const Text('Select SubCategory'),
        //         contentPadding: const EdgeInsets.all(17.0),
        //         border: OutlineInputBorder(
        //             borderRadius:
        //             BorderRadius.circular(10.0)),
        //       ),
        //       child: DropdownButtonHideUnderline(
        //         child: DropdownButton<CategoryModel>(
        //             style: const TextStyle(
        //               fontSize: 16,
        //               color: Colors.grey,
        //             ),
        //             items: categoryData
        //                 .map<DropdownMenuItem<CategoryModel>>(
        //                     (CategoryModel value) {
        //                   return DropdownMenuItem(
        //                     value: value,
        //                     child: Row(
        //                       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                       children: [
        //                         CircleAvatar(
        //                           backgroundImage: AssetImage(
        //                               value.image),
        //                         ),
        //                         // Icon(valueItem.bank_logo),
        //                         const SizedBox(
        //                           width: 15,
        //                         ),
        //                         Text(value.name),
        //                       ],
        //                     ),
        //                   );
        //                 }).toList(),
        //
        //             isExpanded: true,
        //             isDense: true,
        //             onChanged: (CategoryModel? newCategoryModel) {
        //               setState(() {
        //                 selectedSubCatModel = newCategoryModel!;
        //               });
        //             },
        //             value: selectedSubCatModel
        //
        //         ),
        //       ),
        //     );
        //   },
        // ),
      ],
    );
  }
}
