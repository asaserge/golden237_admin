import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden237_client/controllers/auth_controller.dart';
import 'package:golden237_client/controllers/product_controller.dart';
import 'package:golden237_client/controllers/wishlist_controller.dart';
import 'package:golden237_client/screens/profile_screen.dart';
import 'package:golden237_client/widgets/widget_text.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:badges/badges.dart' as badges;


import '../controllers/cart_controller.dart';
import '../controllers/category_controller.dart';
import '../utils/apis.dart';
import '../widgets/product_gridslider.dart';
import '../widgets/product_list.dart';
import '../widgets/slide_subcategory.dart';
import 'auth_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final CategoryController categoryController = Get.find();
  final ProductController productController = Get.find();
  final CartController cartController = Get.find();
  final AuthController authController = Get.find();
  final WishlistController wishlistController = Get.find();

  final List<Widget> snapImages = [
    Image.asset('assets/images/snap4.jpg'),
    Image.asset('assets/images/snap5.jpg'),
    Image.asset('assets/images/snap6.jpg'),
    Image.asset('assets/images/snap1.jpg'),
    Image.asset('assets/images/snap3.jpg'),
    Image.asset('assets/images/snap2.jpg'),
  ];

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      if(Apis.client.auth.currentUser != null){
                        categoryController.navigationKey.currentState!.setPage(4);
                      }
                      else{
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const AuthScreen()));
                      }
                    },
                    child: Card(
                      elevation: 5,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: authController.userAvatar.value == '' ?
                        Image.asset('assets/images/avatar.png', height: 25,
                          width: 25, fit: BoxFit.fill,) :
                        Container(
                          height: 25.0,
                          width: 25.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(authController.userAvatar.value),
                        )
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: (){
                      showSearch(context: context, delegate: MySearchDelegate());
                    },
                    child: Container(
                      height: 40,
                      width: size.width / 1.8,
                      padding: const EdgeInsets.only(left: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          const Icon(MdiIcons.magnify),
                          const SizedBox(width: 10.0),
                          Expanded(child: WidgetText(text: 'search'.tr, size: 13,
                              font: 'montserrat_light', maxLines: 1)
                          )
                        ],
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CartScreen()));
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Stack(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                            child: Icon(MdiIcons.basket, size: 25),
                          ),
                          Positioned(
                            top: -5,
                            right: -3,
                            child: badges.Badge(
                              position: badges.BadgePosition.topEnd(top: -15, end: -12),
                              showBadge: true,
                              ignorePointer: false,
                              onTap: () {},
                              badgeAnimation: const badges.BadgeAnimation.rotation(
                                animationDuration: Duration(seconds: 1),
                                colorChangeAnimationDuration: Duration(seconds: 1),
                                loopAnimation: false,
                                curve: Curves.fastOutSlowIn,
                                colorChangeAnimationCurve: Curves.easeInCubic,
                              ),
                              badgeStyle: const badges.BadgeStyle(
                                shape: badges.BadgeShape.circle,
                                badgeColor: Colors.black,
                                padding: EdgeInsets.all(5.0),
                                borderSide: BorderSide(color: Colors.white, width: 2),
                                elevation: 2,
                              ),
                              badgeContent: Obx(() =>
                                  Text('${cartController.products.length}',
                                      style: const TextStyle(color: Colors.white))),

                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Apis.client.auth.currentUser == null ?
                  WidgetText(text: 'hi_there'.tr, maxLines: 1,
                      size: 24, font: 'montserrat_bold') :
                  Obx(() => WidgetText(text: '${'hi'.tr} ${authController.userName.value},', maxLines: 1,
                      size: 24, font: 'montserrat_bold')),
                  WidgetText(text: 'we_delighted'.tr, size: 14,
                      font: 'monsterrat_regular', color: Colors.black54, maxLines: 1),
                ],
              ),
              const SizedBox(height: 20.0),

              CarouselSlider(
                  items: snapImages,
                  options: CarouselOptions(
                    height: size.height / 4,
                    aspectRatio: 16/9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    scrollDirection: Axis.horizontal,
                  )
              ),

              const SizedBox(height: 30.0),

              SlideSubCategory(),
              const SizedBox(height: 40.0),

              Obx(() => Visibility(
                  visible: authController.isUserLoggedIn.value,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const WidgetText(text: 'Only Ya Own!', size: 18, font: 'montserrat_bold'),
                              WidgetText(text: 'showing_recommended'.tr, size: 13,
                                  font: 'monsterrat_regular', color: Colors.black54),
                              const SizedBox(height: 15.0),
                            ],
                          ),
                          const Icon(Icons.arrow_forward_outlined, size: 20)
                        ],
                      ),
                      ProductGridSlider(attribute: productController.productListRecommended),
                      const SizedBox(height: 40.0),
                    ],
                  )
              )),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      const WidgetText(text: 'Shop Anyhow', size: 18, font: 'montserrat_bold'),
                      WidgetText(text: 'showing_random'.tr, size: 13,
                          font: 'monsterrat_regular', color: Colors.black54),
                      const SizedBox(height: 15.0),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_outlined, size: 20)
                ],
              ),
              ProductGridSlider(attribute: productController.productListAuthentic),
              const SizedBox(height: 40.0),

              Container(
                height: size.height / 6,
                width: size.width,
                margin: const EdgeInsets.only(bottom: 30.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12.0)
                ),
                child: Image.asset('assets/icons/discount15.jpg', fit: BoxFit.cover)
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const WidgetText(text: 'Betta Things Dem', size: 18, font: 'montserrat_bold'),
                      WidgetText(text: 'showing_trending'.tr, size: 13,
                          font: 'monsterrat_regular', color: Colors.black54),
                      const SizedBox(height: 15.0),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_outlined, size: 20)
                ],
              ),
              ProductGridSlider(attribute: productController.productListAuthentic),
              const SizedBox(height: 40.0),

              Container(
                  height: size.height / 6,
                  width: size.width,
                  margin: const EdgeInsets.only(bottom: 30.0),
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12.0)
                  ),
                  child: Image.asset('assets/icons/refer-earn.jpg',
                      width: size.width / 1.5, height: size.height / 7, fit: BoxFit.cover)
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const WidgetText(text: 'Na Sa Sa Ye', size: 18, font: 'montserrat_bold'),
                      WidgetText(text: 'showing_promotion'.tr, size: 13,
                          font: 'monsterrat_regular', color: Colors.black54),
                      const SizedBox(height: 15.0),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_outlined, size: 20)
                ],
              ),
              ProductGridSlider(attribute: productController.productListPromo),
              const SizedBox(height: 40.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const WidgetText(text: 'For Small Money', size: 18, font: 'montserrat_bold'),
                      WidgetText(text: 'showing_discount'.tr, size: 13,
                          font: 'monsterrat_regular', color: Colors.black54),
                      const SizedBox(height: 15.0),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_outlined, size: 20)
                ],
              ),
              ProductGridSlider(attribute: productController.productListCheap),
              const SizedBox(height: 40.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const WidgetText(text: 'Na De Eye', size: 18, font: 'montserrat_bold'),
                      WidgetText(text: 'showing_quality'.tr, size: 13,
                          font: 'monsterrat_regular', color: Colors.black54),
                      const SizedBox(height: 15.0),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_outlined, size: 20)
                ],
              ),
              ProductGridSlider(attribute: productController.productListCheap),
              const SizedBox(height: 40.0),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WidgetText(text: 'try_filter'.tr,
                      alignment: TextAlign.center),
                  const SizedBox(height: 30.0),
                  GestureDetector(
                    onTap: (){
                      //categoryController.navigationKey.currentState?.setPage(0);
                    },
                    child: Container(
                        height: 40,
                        width: 130,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            border:  Border.all(
                                width: 2,
                                color: Colors.black
                            )
                        ),
                        child: Center(
                          child: WidgetText(text: 'proceed'.tr, size: 18),
                        )
                    ),
                  )
                ],
              ),

              const SizedBox(height: 50.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const WidgetText(text: 'See All Thing', size: 18, font: 'montserrat_bold'),
                      WidgetText(text: 'showing_all'.tr, size: 13,
                          font: 'monsterrat_regular', color: Colors.black54),
                      const SizedBox(height: 15.0),
                    ],
                  ),
                  const Icon(Icons.arrow_downward_outlined, size: 20)
                ],
              ),
              ProductList(attribute: productController.productListCheap),
              const SizedBox(height: 40.0),

              const SizedBox(height: 90.0),


            ],
          ),
        )
    );
  }
}

class MySearchDelegate extends SearchDelegate{

  final ProductController productController = Get.find();
  List<String> searchResults = [
    'Black Long Gown',
    'Black Long Gown',
    'Black Long Gown',
    'Black Long Gown',
    'Black Long Gown',
    'Black Long Gown',
  ];
  @override
  String get searchFieldLabel => 'search'.tr;

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context).copyWith(
      textTheme: const TextTheme(
        titleSmall: TextStyle(
        fontFamily: 'monsterrat_regular',
        fontSize: 22.0,
        ),
      ),
    );
    return theme;
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
      IconButton(
        onPressed: (){
          if(query.isEmpty){
            close(context, null);
          }
          else{
            query = '';
          }
        },
        icon: const Icon(Icons.clear_outlined)
        )
      ];

  @override
  Widget? buildLeading(BuildContext context) =>
      IconButton(
        onPressed: (){
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back_outlined)
      );

  @override
  Widget buildResults(BuildContext context) => Center(
    child: WidgetText(text: query),
  );

  @override
  Widget buildSuggestions(BuildContext context) {
    appBarTheme(context);

    List<String> suggestions = searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index){
        final suggestion = suggestions[index];
        return ListTile(
          title: WidgetText(text: suggestion),
          onTap: (){
            query = suggestion;
            showResults(context);
          },
        );
      }
    );
  }

}
