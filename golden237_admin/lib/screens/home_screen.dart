import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:golden237_admin/controller/product_controller.dart';
import 'package:get/get.dart';

import 'package:golden237_admin/screens/catproduct_screen.dart';
import 'package:golden237_admin/screens/product_screen.dart';
import 'package:golden237_admin/screens/searchbar_screen.dart';
import 'package:golden237_admin/screens/settings_screen.dart';
import 'package:golden237_admin/screens/coupon_screen.dart';
import 'package:golden237_admin/screens/subcategory_screen.dart';
import 'package:golden237_admin/screens/user_screen.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../controller/category_controller.dart';
import '../controller/order_controller.dart';
import '../services/apis.dart';
import '../utils/constants.dart';
import '../utils/messages.dart';
import 'about_screen.dart';

import 'category_screen.dart';
import 'dev_screen.dart';
import 'help.dart';
import 'login_screen.dart';
import 'notification_screen.dart';
import 'order_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final GlobalKey<ScaffoldState> scaffoldKey  = GlobalKey();
  ProductController productController = Get.put(ProductController());
  OrderController orderController = Get.put(OrderController());
  final CategoryController categoryController = Get.put(CategoryController());
  final DateFormat formatDate = DateFormat.yMMMMEEEEd();
  String name = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            scaffoldKey.currentState!.openDrawer();
          },
          icon: const Icon(Icons.menu_outlined, size: 35),
        ),

        title: const Text(appName, style: TextStyle(fontSize: 16)),

        actions: [

          Badge(
              position: BadgePosition.topEnd(top: -10, end: -12),
              showBadge: true,
              ignorePointer: false,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const NotificationScreen()));
              },
              badgeContent: const Text('2', style: TextStyle(fontSize: 8),),
              badgeAnimation: const BadgeAnimation.rotation(
                animationDuration: Duration(seconds: 2),
                colorChangeAnimationDuration: Duration(seconds: 1),
                loopAnimation: false,
                curve: Curves.fastOutSlowIn,
                colorChangeAnimationCurve: Curves.easeInCubic,
              ),
              badgeStyle: const BadgeStyle(
                shape: BadgeShape.circle,
                badgeColor: Colors.red,
                padding: EdgeInsets.all(5),
                elevation: 2,
              ),
              child: const Icon(Icons.notifications_outlined)
          ),

          IconButton(
              onPressed: (){
                Phoenix.rebirth(context);
              },
              icon: const Icon(Icons.refresh_outlined)
          ),

          IconButton(
            onPressed: (){
              showSimpleDialog(
                  'Quick Help',
                  'Access different options by going to the main menu on the top left. You can create, delete, update or view'
                      ' products, coupons, users as you wish, each section have additional help section. As for categories and '
                      ' subcategories, you can only view them. In case of any other assistance, don\'t hesitate to contact us '
                      'via email at awujiaa2018@gmail.com.'
              );
            },
            icon: const Icon(Icons.help_outline_outlined),
          ),

          const SizedBox(width: 8.0),

        ],
      ),

      drawer: Drawer(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: primaryColor),
              accountName: const Text('Welcome Nyap Awi Betrand'),
              accountEmail: const Text(
                  "nyapawibertrand@gmail.com"
              ),
              currentAccountPicture: ClipOval(
                child: Image.asset(
                    'assets/images/admin-image.jpeg',
                    width: 130,
                    height: 130,
                    fit: BoxFit.fitWidth
                ),
              ),
              arrowColor: Colors.black54,
              onDetailsPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LoginScreen()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.analytics,
              ),
              title: const Text('Analytics'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.bookmark_border_outlined,
              ),
              title: const Text('Orders'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OrderScreen()));
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.shop_outlined,
              ),
              title: const Text('Products'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProductScreen()));
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.category_outlined,
              ),
              title: const Text('Categories'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CategoryScreen()));
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.person_pin,
              ),
              title: const Text('Users'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UserScreen()));
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.notifications_outlined,
              ),
              title: const Text('Notifications'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NotificationScreen()));
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.countertops_outlined,
              ),
              title: const Text('Coupons'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CouponScreen()));
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.settings_outlined,
              ),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SettingsScreen()));
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.help_outline_outlined,
              ),
              title: const Text('Help'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HelpScreen()));
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.developer_mode_outlined,
              ),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AboutScreen()));
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.logout_outlined,
              ),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),

            const SizedBox(height: 20),
            ListTile(
              title: const Text('Powered By ASAtech',
                  style: TextStyle(fontSize: 8)),
              subtitle: const Text('@Buea - 2023',
                  style: TextStyle(fontSize: 8)),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DevScreen()));
              },
            ),



          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 2,
                color: Colors.transparent,
                child: Container(
                  width: double.infinity,
                  height: size.height / 9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.white38),
                  child: GridView(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16),
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Container(
                        width: size.width / 1.2,
                        height: size.height / 10,
                        margin: const EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Obx(() => Text('${productController.allProdCount.value}',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24))
                                    ),
                                    Column(
                                      children: const [
                                        SizedBox(height: 8.0),
                                        Text('/200', style: TextStyle(fontSize: 10)),
                                      ],
                                    )
                                  ],
                                ),
                                const Text('Product\nOverview',
                                    overflow: TextOverflow.ellipsis, maxLines: 2,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 13))
                              ],
                            ),
                            Obx(() => CircularPercentIndicator(
                              radius: 27.0,
                              lineWidth: 5.0,
                              animation: true,
                              percent: productController.allProdCount.value / 200,
                              center: Text(
                                "${((productController.allProdCount.value / 200) * 100).round()} %",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: Colors.black,
                            )),
                          ],
                        ),
                      ),

                      Container(
                        width: size.width / 1.2,
                        height: size.height / 10,
                        margin: const EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Obx(() => Text('${categoryController.allCatCount.value}',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24))
                                    ),
                                    Column(
                                      children: const [
                                        SizedBox(height: 8.0),
                                        Text('/50', style: TextStyle(fontSize: 10)),
                                      ],
                                    )
                                  ],
                                ),
                                const Text('Category\nOverview',
                                    overflow: TextOverflow.ellipsis, maxLines: 2,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 13))
                              ],
                            ),
                            Obx(() => CircularPercentIndicator(
                              radius: 27.0,
                              lineWidth: 5.0,
                              animation: true,
                              percent: categoryController.allCatCount.value / 50,
                              center: Text(
                                "${((categoryController.allCatCount.value / 50) * 100).round()} %",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: Colors.black,
                            )),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25.0),

              const Text(
                  'Welcome Admin, you have the ability to create, view, update and/or '
                      'delete categories, products, users, coupons, from this panel!',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3),

              const SizedBox(height: 35.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset('assets/icons/icons-analytic.png'),
                  Image.asset('assets/icons/icons-admin.png'),
                ],
              ),

              Column(
                children: [
                  const Text('Today is', style: TextStyle(fontSize: 12.0)),
                  Text(formatDate.format(DateTime.now()), maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 18.0, color: Colors.red)),
                ],
              ),

              const SizedBox(height: 35.0),

              SizedBox(
                height: MediaQuery.of(context).size.height / 1.5,
                width: double.infinity,
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 1.0
                  ),
                  physics: const NeverScrollableScrollPhysics(),

                  children: [

                    overViewWidget(msg: 'All Categories', title: 'Categories',
                      iconData: Icons.category_outlined, color: Colors.blue,
                      value: categoryController.catCount, page: const CategoryScreen()),

                    overViewWidget(msg: 'All SubCats', title: 'SubCats',
                        iconData: Icons.sort_by_alpha_outlined, color: Colors.limeAccent,
                        value: categoryController.allCatCount, page: const SubCategoryScreen()),

                    overViewWidget(msg: 'All Products', title: 'Products',
                        iconData: Icons.shop_2_outlined, color: Colors.white38,
                        value: productController.allProdCount, page: const ProductScreen()),

                    overViewWidget(msg: 'All Orders', title: 'Orders',
                        iconData: Icons.shopping_basket_outlined, color: Colors.green,
                        value: orderController.orderCount, page: const OrderScreen()),

                    overViewWidget(msg: 'All Coupons', title: 'Coupons',
                        iconData: Icons.card_giftcard_outlined, color: Colors.deepOrange,
                        value: productController.couponCount, page: const CouponScreen()),

                    overViewWidget(msg: 'All Users', title: 'Users',
                        iconData: Icons.person_outline, color: Colors.tealAccent,
                        value: productController.userCount, page: const HomeScreen()),

                    const SizedBox(height: 35.0),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),

    );
  }

  Widget overViewWidget({required String msg, required String title, required var page,
        required IconData iconData, required Color color, required RxInt value}){
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Tooltip(
          message: msg,
          child: Card(
            child: ListTile(
                title: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => page));
                  },
                  icon: Icon(iconData, color: color),
                  label: Text(title,
                      style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                ),
                subtitle: Obx(() => Text(
                  '${value.value}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color,
                    fontSize: 60.0,
                  ),
                ))
            ),
          ),
        )
    );
  }


  ///\/////////////////////METHODS/////////////////////
  showSimpleDialog(String title, content){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(content),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: primaryColor,
              ),
              child: const Text("Okay", style: TextStyle(color: Colors.black54)),
            ),
          ),
        ],
      ),
    );
  }

  final snackBarFailed = SnackBar(
    content: const Text('Oops! Something went wrong!', style: TextStyle(color: Colors.white)),
    backgroundColor: (Colors.red),
    action: SnackBarAction(
      label: 'Dismiss',
      textColor: Colors.black,
      onPressed: () {
      },
    ),
  );

  final snackBarNetworkError = SnackBar(
    content: const Text('Oops! Internet Connection Error!', style: TextStyle(color: Colors.white)),
    backgroundColor: (Colors.red),
    action: SnackBarAction(
      label: 'Dismiss',
      textColor: Colors.black,
      onPressed: () {
      },
    ),
  );

  subscribeToRealTime(){

  }
}


