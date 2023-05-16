import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:golden237_admin/controller/auth_controller.dart';
import 'package:golden237_admin/controller/product_controller.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controller/category_controller.dart';
import '../controller/order_controller.dart';
import '../services/apis.dart';
import '../utils/constants.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final GlobalKey<ScaffoldState> scaffoldKey  = GlobalKey();
  ProductController productController = Get.put(ProductController());
  OrderController orderController = Get.put(OrderController());
  AuthController authController = Get.put(AuthController());
  final CategoryController categoryController = Get.put(CategoryController());
  final DateFormat formatDate = DateFormat.yMMMMEEEEd();
  late bool isShowingMainData;

  @override
  void initState() {
    startRealTime();
    isShowingMainData = true;
    super.initState();
  }

  startRealTime(){
    Apis.client.channel('*').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(event: '*', schema: 'public'),
          (payload, [ref]) {
            productController.getAllProduct();
            categoryController.getMainCategory();
            categoryController.getSubCategory();
            orderController.getDeliveredOrders();
            orderController.getUndeliveredOrders();
            orderController.getAllCoupons();
        print('\n\n\nProduct Change received: ${payload.toString()}');
      },
    ).subscribe();
  }


  getMonthName(){
    List months = ['jan', 'feb', 'mar', 'apr', 'may','jun','jul','aug','sep','oct','nov','dec'];
    var now = DateTime.now();
    var currentMon = now.month;
    List<String> data = [
      months[currentMon-2],
      months[currentMon-1],
      months[currentMon],
    ];
    return data;
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
                Get.toNamed('/notifications');
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
               //Todo account screen
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.analytics,
              ),
              title: const Text('Analytics'),
              onTap: () {
                Get.back();
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.bookmark_border_outlined,
              ),
              title: const Text('Orders'),
              onTap: () {
               Get.offAndToNamed('/orders');
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.search,
              ),
              title: const Text('Search'),
              onTap: () {
                Get.offAndToNamed('/search');
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.notifications_outlined,
              ),
              title: const Text('Notifications'),
              onTap: () {
                Get.offAndToNamed('/notifications');
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.settings_outlined,
              ),
              title: const Text('Settings'),
              onTap: () {
                Get.offAndToNamed('/settings');
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.help_outline_outlined,
              ),
              title: const Text('Help'),
              onTap: () {
                Get.offAndToNamed('/help');
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.developer_mode_outlined,
              ),
              title: const Text('About'),
              onTap: () {
                Get.offAndToNamed('/about');
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.logout_outlined,
              ),
              title: const Text('Logout'),
              onTap: () {
                Get.offAll('/');
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
                Get.offAndToNamed('/developer');
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
                                    Obx(() => Text('${productController.productList.length}',
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
                              percent: productController.productList.length / 200,
                              center: Text(
                                "${((productController.productList.length / 200) * 100).round()} %",
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
                                    Obx(() => Text('${categoryController.subCategoriesList.length}',
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
                              percent: (categoryController.subCategoriesList.length).toDouble() / 50,
                              center: Text(
                                "${((categoryController.subCategoriesList.length / 50) * 100).round()} %",
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

              AspectRatio(
                aspectRatio: 1.23,
                child: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(
                          height: 37,
                        ),
                        const Text(
                          'Monthly Sales',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 37,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16, left: 6),
                            child: _LineChart(isShowingMainData: isShowingMainData),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
                      ),
                      onPressed: () {
                        setState(() {
                          isShowingMainData = !isShowingMainData;
                        });
                      },
                    )
                  ],
                ),
              ),

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

                    Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          child: ListTile(
                              title: TextButton.icon(
                                onPressed: () {
                                  Get.toNamed('/orders');
                                },
                                icon: const Icon(Icons.shopping_basket_outlined, color: Colors.green),
                                label: const Text('Orders',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                              subtitle: Obx(() => Text(
                                orderController.ordersAllList.isEmpty ? '0' :
                                '${orderController.ordersAllList.length}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 60.0,
                                ),
                              )
                            )
                          ),
                        ),
                    ),

                    Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          child: ListTile(
                              title: TextButton.icon(
                                onPressed: () {
                                  Get.toNamed('/user');
                                },
                                icon: const Icon(Icons.person_outline, color: Colors.deepOrangeAccent),
                                label: const Text('Users',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                              subtitle: Obx(() => Text(
                                authController.userList.isEmpty ? '0' :
                                '${authController.userList.length}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 60.0,
                                ),
                              )
                            )
                          ),
                        ),
                    ),

                    Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          child: ListTile(
                              title: TextButton.icon(
                                onPressed: () {
                                  Get.toNamed('/category');
                                },
                                icon: const Icon(Icons.category_outlined, color: Colors.blue),
                                label: const Text('Categories',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                              subtitle: Obx(() => Text(
                                categoryController.mainCategoriesList.isEmpty ? '0' :
                                '${categoryController.mainCategoriesList.length - 1}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 60.0,
                                ),
                              )
                            )
                          ),
                        ),
                    ),

                    Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          child: ListTile(
                              title: TextButton.icon(
                                onPressed: () {
                                  Get.toNamed('/subcategory');
                                },
                                icon: const Icon(Icons.sort_by_alpha_outlined, color: Colors.limeAccent),
                                label: const Text('SubCats',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                              subtitle: Obx(() => Text(
                                categoryController.subCategoriesList.isEmpty ? '0' :
                                '${categoryController.subCategoriesList.length}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 60.0,
                                ),
                              )
                              )
                          ),
                        ),
                    ),

                    Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          child: ListTile(
                              title: TextButton.icon(
                                onPressed: () {
                                  Get.toNamed('/product');
                                },
                                icon: const Icon(Icons.shop_2_outlined, color: Colors.yellow),
                                label: const Text('Products',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                              subtitle: Obx(() => Text(
                                productController.productList.isEmpty ? '0' :
                                '${productController.productList.length}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 60.0,
                                ),
                              )
                            )
                          ),
                        ),
                    ),

                    Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          child: ListTile(
                              title: TextButton.icon(
                                onPressed: () {
                                  Get.toNamed('/coupons');
                                },
                                icon: const Icon(Icons.card_giftcard_outlined, color: Colors.purpleAccent),
                                label: const Text('Coupons',
                                    style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold)),
                              ),
                              subtitle: Obx(() => Text(
                                orderController.couponList.isEmpty ? '0' :
                                '${orderController.couponList.length}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 60.0,
                                ),
                              )
                            )
                          ),
                        ),
                    ),

                    const SizedBox(height: 100)
                  ],
                ),
              ),

              const SizedBox(height: 35.0),

              const Text(
                  'Usage Statistics',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3),

              const SizedBox(height: 35.0),

              const LineChartSample2(),

              const SizedBox(height: 80),
              ListTile(
                title: const Text('Powered By ASAtech',
                    style: TextStyle(fontSize: 8)),
                subtitle: const Text('@Buea - 2023',
                    style: TextStyle(fontSize: 8)),
                onTap: () {
                  Get.offAndToNamed('/developer');
                },
              ),

            ],
          ),
        ),
      ),

    );
  }

  Widget overViewWidget({required String msg, required String title, required String page,
        required IconData iconData, required Color color, required, required RxInt value}){
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Tooltip(
          message: msg,
          child: Card(
            child: ListTile(
                title: TextButton.icon(
                  onPressed: () {
                    Get.to(page);
                  },
                  icon: Icon(iconData, color: color),
                  label: Text(title,
                      style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                ),
                subtitle: Text(
                  categoryController.subCategoriesList.isEmpty ? '0' : '$value',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  color: color,
                  fontSize: 60.0,
                 ),
                )
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

}

class _LineChart extends StatelessWidget {
  const _LineChart({required this.isShowingMainData});

  final bool isShowingMainData;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      isShowingMainData ? sampleData1 : sampleData2,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
    lineTouchData: lineTouchData1,
    gridData: gridData,
    titlesData: titlesData1,
    borderData: borderData,
    lineBarsData: lineBarsData1,
    minX: 0,
    maxX: 14,
    maxY: 4,
    minY: 0,
  );

  LineChartData get sampleData2 => LineChartData(
    lineTouchData: lineTouchData2,
    gridData: gridData,
    titlesData: titlesData2,
    borderData: borderData,
    lineBarsData: lineBarsData2,
    minX: 0,
    maxX: 14,
    maxY: 6,
    minY: 0,
  );

  LineTouchData get lineTouchData1 => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
    ),
  );

  FlTitlesData get titlesData1 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    rightTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  List<LineChartBarData> get lineBarsData1 => [
    lineChartBarData1_1,
    lineChartBarData1_2,
    lineChartBarData1_3,
  ];

  LineTouchData get lineTouchData2 => LineTouchData(
    enabled: false,
  );

  FlTitlesData get titlesData2 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    rightTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  List<LineChartBarData> get lineBarsData2 => [
    lineChartBarData2_1,
    lineChartBarData2_2,
    lineChartBarData2_3,
  ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1m';
        break;
      case 2:
        text = '800k';
        break;
      case 3:
        text = '600k';
        break;
      case 4:
        text = '400k';
        break;
      case 5:
        text = '200k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
    getTitlesWidget: leftTitleWidgets,
    showTitles: true,
    interval: 1,
    reservedSize: 40,
  );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 14,
    );
    Widget text;
    List<String> monthNames = getMonthName();
    switch (value.toInt()) {
      case 2:
        text = Text(monthNames[0], style: style);
        break;
      case 7:
        text = Text(monthNames[1], style: style);
        break;
      case 12:
        text = Text(monthNames[2], style: style);
        break;
      default:
        text = const Text('');
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: 1,
    getTitlesWidget: bottomTitleWidgets,
  );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: Border(
      bottom:
      BorderSide(color: primaryColor.withOpacity(0.2), width: 4),
      left: const BorderSide(color: Colors.transparent),
      right: const BorderSide(color: Colors.transparent),
      top: const BorderSide(color: Colors.transparent),
    ),
  );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
    isCurved: true,
    color: Colors.green,
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: const [
      FlSpot(1, 1),
      FlSpot(3, 1.5),
      FlSpot(5, 1.4),
      FlSpot(7, 3.4),
      FlSpot(10, 2),
      FlSpot(12, 2.2),
      FlSpot(13, 1.8),
    ],
  );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
    isCurved: true,
    color: Colors.pink,
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(
      show: false,
      color: Colors.pink.withOpacity(0),
    ),
    spots: const [
      FlSpot(1, 1),
      FlSpot(3, 2.8),
      FlSpot(7, 1.2),
      FlSpot(10, 2.8),
      FlSpot(12, 2.6),
      FlSpot(13, 3.9),
    ],
  );

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
    isCurved: true,
    color: Colors.cyan,
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: const [
      FlSpot(1, 2.8),
      FlSpot(3, 1.9),
      FlSpot(6, 3),
      FlSpot(10, 1.3),
      FlSpot(13, 2.5),
    ],
  );

  LineChartBarData get lineChartBarData2_1 => LineChartBarData(
    isCurved: true,
    curveSmoothness: 0,
    color: Colors.green.withOpacity(0.5),
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: const [
      FlSpot(1, 1),
      FlSpot(3, 4),
      FlSpot(5, 1.8),
      FlSpot(7, 5),
      FlSpot(10, 2),
      FlSpot(12, 2.2),
      FlSpot(13, 1.8),
    ],
  );

  LineChartBarData get lineChartBarData2_2 => LineChartBarData(
    isCurved: true,
    color: Colors.pink.withOpacity(0.5),
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      color: Colors.pink.withOpacity(0.2),
    ),
    spots: const [
      FlSpot(1, 1),
      FlSpot(3, 2.8),
      FlSpot(7, 1.2),
      FlSpot(10, 2.8),
      FlSpot(12, 2.6),
      FlSpot(13, 3.9),
    ],
  );

  LineChartBarData get lineChartBarData2_3 => LineChartBarData(
    isCurved: true,
    curveSmoothness: 0,
    color: Colors.cyan.withOpacity(0.5),
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: FlDotData(show: true),
    belowBarData: BarAreaData(show: false),
    spots: const [
      FlSpot(1, 3.8),
      FlSpot(3, 1.9),
      FlSpot(6, 5),
      FlSpot(10, 3.3),
      FlSpot(13, 4.5),
    ],
  );

  getMonthName(){
    List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    var now = DateTime.now();
    var currentMon = now.month;
    List<String> data = [
      months[currentMon-3],
      months[currentMon-2],
      months[currentMon-1],
    ];
    return data;
  }
}

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    Colors.cyan,
    Colors.blue,
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              showAvg ? avgData() : mainData(),
            ),
          ),
        ),
        SizedBox(
          width: 60,
          height: 34,
          child: TextButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              'avg',
              style: TextStyle(
                fontSize: 12,
                color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: primaryColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.green,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


