import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:karetaker/widgets/widget_text.dart';

import '../controllers/property_controller.dart';
import '../utils/constants.dart';
import '../widgets/widget_property.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final filter = [
    'Apartment',
    'Studio',
    'Room',
    'Vehicle',
    'Hall',
    'Plot',
    'Store'
  ];

  int selectedIndex = 0;
  final PropertyController propertyController = Get.find();
  final currencyFormatter = NumberFormat('#,###');

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    GestureDetector(
                      onTap: (){
                        //Todo open menu drawer
                      },
                      child: const Icon(Icons.menu_outlined, size: 35),
                    ),

                    const WidgetText(text: 'KareTaker Services',  color: primaryColor, size: 20),

                    GestureDetector(
                      onTap: (){
                        //Todo goto profile
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/images/avatar.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25.0),

                ///Search bar
                SizedBox(
                  height: 40,
                  child: TextField(
                    style: const TextStyle(fontFamily: 'montserrat_medium'),
                    maxLines: 1,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                                width: 2.0,
                                color: Colors.grey.withOpacity(0.4)
                            )
                        ),
                        prefixIcon: GestureDetector(
                          onTap: (){
                            //Todo search property
                          },
                          child: const Icon(Icons.search_rounded),
                        ),
                        hintText: 'Search property...',
                        hintStyle: const TextStyle(
                            fontSize: 15
                        )
                    ),
                  ),
                ),

                const SizedBox(height: 20.0),

                ///Filter widget
                SizedBox(
                  width: double.infinity,
                  height: 40.0,
                  child: ListView.builder(
                      itemCount: filter.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index){
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              selectedIndex = index;
                            });
                            //Todo list property by filter
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
                            margin: const EdgeInsets.only(right: 12.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: selectedIndex == index ? primaryColor : null,
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.4)
                              )
                            ),
                            child: Center(
                                child: WidgetText(
                                  text: filter[index],
                                  color: selectedIndex == index ? Colors.white : Colors.black,
                                )
                            ),
                          ),
                        );
                      }
                  ),
                ),

                const SizedBox(height: 35.0),

                ///Rent Apartment
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const WidgetText(text: 'Apartments for rent', font: 'montserrat_bold', size: 17),

                      WidgetText( text: '(${propertyController.propertyRentApartment.length})'),

                      const Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
                Container(
                  height: size.height / 2.9,
                  width: size.width,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15.0)
                  ),
                  child: SizedBox(
                    height: size.height / 3,
                    width: size.width,
                    child: ListView.builder(
                        itemCount: propertyController.propertyRentApartment.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index){
                          return GestureDetector(
                            onTap: (){
                              var data = propertyController.propertyRentApartment[index];
                              Get.toNamed('/property', arguments: data);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: size.height / 5,
                                  width: size.width / 1.3,
                                  margin: const EdgeInsets.only(bottom: 8.0, right: 15.0),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15.0),
                                      topRight: Radius.circular(15.0),
                                    ),
                                    image: DecorationImage(
                                        image: NetworkImage(propertyController.propertyRentApartment[index]['cover']),
                                        fit: BoxFit.cover
                                    ),
                                  ),
                                ),

                                Row(
                                  children: [
                                    const Icon(Icons.account_balance_rounded, size: 18, color: primaryColor,),
                                    WidgetText(text: propertyController.propertyRentApartment[index]['type'], color: primaryColor)
                                  ],
                                ),
                                WidgetText(text: 'XAF ${currencyFormatter.format(propertyController.propertyRentApartment[index]['price'])}/Month', size: 18),
                                WidgetText(text: propertyController.propertyRentApartment[index]['location'], font: 'montserrat_light', size: 12),
                                const SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.bed_outlined, size: 18),
                                        WidgetText(text: '${propertyController.propertyRentApartment[index]['bedroom']}')
                                      ],
                                    ),
                                    const SizedBox(width: 25.0),
                                    Row(
                                      children: [
                                        const Icon(Icons.shower_outlined, size: 18),
                                        WidgetText(text: '${propertyController.propertyRentApartment[index]['bathroom']}')
                                      ],
                                    ),
                                    const SizedBox(width: 25.0),
                                    Row(
                                      children: [
                                        const Icon(Icons.area_chart, size: 18),
                                        WidgetText(text: '${propertyController.propertyRentApartment[index]['area']} msqr')
                                      ],
                                    ),
                                    const SizedBox(width: 25.0),
                                    Row(
                                      children: const [
                                        Icon(Icons.star, size: 18),
                                        WidgetText(text: '3.5')
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

