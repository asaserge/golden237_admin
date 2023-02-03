import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:golden237_admin/screens/product_screen.dart';
import 'package:golden237_admin/screens/searchbar_screen.dart';
import 'package:golden237_admin/screens/settings_screen.dart';
import 'package:golden237_admin/screens/shipping_screen.dart';
import 'package:golden237_admin/screens/user_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pie_chart/pie_chart.dart';

import '../controller/procduct_controller.dart';
import '../messages/constants.dart';
import 'about_screen.dart';
import 'add_category.dart';
import 'add_coupon.dart';
import 'add_product.dart';
import 'add_user.dart';
import 'category_screen.dart';
import 'dev_screen.dart';
import 'notification_screen.dart';
import 'order_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final GlobalKey<ScaffoldState> scaffoldKey  = GlobalKey();

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
          icon: const Icon(Icons.menu_outlined),
        ),

        title: const Text(appName),

        actions: [
          IconButton(
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SearchbarScreen()));
            },
            icon: const Icon(Icons.search_outlined),
          ),

          Badge(
            position: BadgePosition.topEnd(top: -10, end: -12),
            showBadge: true,
            ignorePointer: false,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NotificationScreen()));
            },
            badgeContent: Text('2', style: TextStyle(fontSize: 8),),
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
              showSimpleDialog(
                'Quick Help',
                'The dialog is a type of widget which comes on the window or the screen which contains any critical information or can ask for any decision. When a dialog box is popped up all the other functions get disabled until you close the dialog box or provide an answer. We use a dialog box for a different type of condition such as an alert notification, or simple notification in which different options are shown, or we can also make a dialog box that can be used as a tab for showing the dialog box. '
                    'Alert dialog tells the user about any condition that requires any recognition. The alert dialog contains an optional title and an optional list of actions.  We have different no of actions as our requirements. Sometimes the content is too large compared to the screen size so for resolving this problem we may have to use the expanded class.'
              );
            },
            icon: const Icon(Icons.help_outline_outlined),
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
             UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: primaryColor),
              accountName: const Text(
                "Welcome Super Admin",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: const Text(
                "Tamanjong James"
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/my_avatar.jpg')
              ),
              arrowColor: Colors.black54,
               onDetailsPressed: (){

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
                Icons.local_shipping_outlined,
              ),
              title: const Text('Shipping'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ShippingScreen()));
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
                    builder: (context) => DevScreen()));
              },
            ),



          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                                Text('234',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24)),
                                Text('All Products',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 13))
                              ],
                            ),
                            CircularPercentIndicator(
                              radius: 27.0,
                              lineWidth: 5.0,
                              animation: true,
                              percent: 0.7,
                              center: Text(
                                "73%",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: Colors.deepOrangeAccent,
                            ),
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
                                Text('06',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24)),
                                Text('All Categories',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 13))
                              ],
                            ),
                            CircularPercentIndicator(
                              radius: 27.0,
                              lineWidth: 5.0,
                              animation: true,
                              percent: 0.2,
                              center: Text(
                                "27%",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: Colors.yellowAccent,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('XAF 102,7800',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24)),
                      Text('Today\'s Sale',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 15)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('XAF 520,500',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24)),
                      Text('Week\'s Sale',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 15)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25.0),

              PieChart(
                dataMap: dataMap,
                animationDuration: const Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                chartRadius: MediaQuery.of(context).size.width / 3.2,
                colorList: colorList,
                initialAngleInDegree: 0,
                chartType: ChartType.ring,
                ringStrokeWidth: 27,
                centerText: "Golden237",
                legendOptions: const LegendOptions(
                  showLegendsInRow: false,
                  legendPosition: LegendPosition.right,
                  showLegends: true,
                  legendTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValueBackground: true,
                  showChartValues: true,
                  showChartValuesInPercentage: false,
                  showChartValuesOutside: false,
                  decimalPlaces: 0,
                ),
                // gradientList: ---To add gradient colors---
                // emptyColorGradient: ---Empty Color gradient---
              ),

              const SizedBox(height: 15.0),

              const Text(
                  'Welcome Admin, you have the ability to create, view, update and/or '
                      'delete categories, products, users, coupons, from this panel!',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3),
              const SizedBox(height: 15.0),
              const Text('Today', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 24)),
              Container(
                width: double.infinity,
                height: size.height / 9,
                padding: const EdgeInsets.only(top: 10),
                child: GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16),
                  children: [
                    Container(
                      width: size.width / 1.5,
                      height: size.height / 10,
                      margin: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('36',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24)),
                              Text('Interactions',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13))
                            ],
                          ),
                          LinearPercentIndicator(
                            animation: true,
                            lineHeight: 15.0,
                            animationDuration: 2500,
                            percent: 0.8,
                            center: Text("80.0%",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13,
                                    color: Colors.black54)),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: Colors.green,
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: size.width / 1.5,
                      height: size.height / 10,
                      margin: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('7',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24)),
                              Text('Orders',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13))
                            ],
                          ),
                          LinearPercentIndicator(
                            animation: true,
                            lineHeight: 15.0,
                            animationDuration: 2500,
                            percent: 0.35,
                            center: Text("35.0%",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13,
                                    color: Colors.black54)),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: Colors.blue,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: size.height / 9,
                padding: const EdgeInsets.only(top: 10),
                child: GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16),
                  children: [
                    Container(
                      width: size.width / 1.5,
                      height: size.height / 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('3',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24)),
                              Text('Request',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13))
                            ],
                          ),
                          LinearPercentIndicator(
                            animation: true,
                            lineHeight: 15.0,
                            animationDuration: 2500,
                            percent: 0.15,
                            center: Text("15.0%",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13,
                                    color: Colors.black54)),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: Colors.orange,
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: size.width / 1.5,
                      height: size.height / 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('9',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24)),
                              Text('Contacts',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13))
                            ],
                          ),
                          LinearPercentIndicator(
                            animation: true,
                            lineHeight: 15.0,
                            animationDuration: 2500,
                            percent: 0.45,
                            center: Text("45.0%",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13,
                                    color: Colors.black54)),
                            progressColor: Colors.purple,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25.0),
              const Text('This Week', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 24)),
              Container(
                width: double.infinity,
                height: size.height / 9,
                padding: const EdgeInsets.only(top: 10),
                child: GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16),
                  children: [
                    Container(
                      width: size.width / 1.5,
                      height: size.height / 10,
                      margin: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('36',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24)),
                              Text('Interactions',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13))
                            ],
                          ),
                          LinearPercentIndicator(
                            animation: true,
                            lineHeight: 15.0,
                            animationDuration: 2500,
                            percent: 0.63,
                            center: Text("63.0%",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13,
                                    color: Colors.black54)),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: Colors.green,
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: size.width / 1.5,
                      height: size.height / 10,
                      margin: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('38',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24)),
                              Text('Orders',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13))
                            ],
                          ),
                          LinearPercentIndicator(
                            animation: true,
                            lineHeight: 15.0,
                            animationDuration: 2500,
                            percent: 0.41,
                            center: Text("41.0%",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13,
                                    color: Colors.black54)),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: Colors.blue,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: size.height / 9,
                padding: const EdgeInsets.only(top: 10),
                child: GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16),
                  children: [
                    Container(
                      width: size.width / 1.5,
                      height: size.height / 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('19',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24)),
                              Text('Request',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13))
                            ],
                          ),
                          LinearPercentIndicator(
                            animation: true,
                            lineHeight: 15.0,
                            animationDuration: 2500,
                            percent: 0.19,
                            center: Text("19.0%",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13,
                                    color: Colors.black54)),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: Colors.orange,
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: size.width / 1.5,
                      height: size.height / 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('39',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24)),
                              Text('Contacts',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13))
                            ],
                          ),
                          LinearPercentIndicator(
                            animation: true,
                            lineHeight: 15.0,
                            animationDuration: 2500,
                            percent: 0.63,
                            center: Text("63.0%",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 13,
                                    color: Colors.black54)),
                            progressColor: Colors.purple,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        spacing: 3,
        mini: false,
        openCloseDial: ValueNotifier<bool>(false),
        childPadding: const EdgeInsets.all(5),
        spaceBetweenChildren: 4,
        childrenButtonSize: const Size(46.0, 46.0),
        visible: true,
        direction: SpeedDialDirection.up,
        buttonSize: const Size(56.0, 56.0),
        switchLabelPosition: false,
        closeManually: false,
        renderOverlay: true,
        onOpen: () => debugPrint('OPENING DIAL'),
        onClose: () => debugPrint('DIAL CLOSED'),
        useRotationAnimation: true,
        tooltip: 'More',
        elevation: 8.0,
        animationCurve: Curves.elasticInOut,
        isOpenOnStart: false,
        shape: const StadiumBorder(),
        children: [

          SpeedDialChild(
            child:const Icon(Icons.shop),
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            label: 'Product',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddProduct()));
            },
          ),

          SpeedDialChild(
              child: const Icon(Icons.category_outlined) ,
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              label: 'Category',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddCategory()));
              }
          ),

          SpeedDialChild(
              child: const Icon(Icons.discount_outlined),
              backgroundColor: Colors.pink,
              foregroundColor: Colors.white,
              label: 'Coupon',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddCoupon()));
              }
          ),

          SpeedDialChild(
              child: const Icon(Icons.person_outline),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              label: 'User',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddUser()));
              }
          ),


        ],
      ),

    );
  }

  ///\/////////////////////METHODS/////////////////////
  showSimpleDialog(String title, content){
    showDialog(
      context: context,
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
}
