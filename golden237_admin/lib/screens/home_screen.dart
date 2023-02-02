import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:golden237_admin/screens/product_screen.dart';
import 'package:golden237_admin/screens/shipping_screen.dart';
import 'package:golden237_admin/screens/user_screen.dart';

import '../messages/constants.dart';
import 'about_screen.dart';
import 'category_screen.dart';
import 'dev_screen.dart';
import 'notification_screen.dart';
import 'order_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.theme}) : super(key: key);

  final ValueNotifier<ThemeMode> theme;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final GlobalKey<ScaffoldState> scaffoldKey  = GlobalKey();

  @override
  Widget build(BuildContext context) {
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

            },
          ),

          SpeedDialChild(
              child: const Icon(Icons.category_outlined) ,
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              label: 'Category',
              onTap: () {

              }
          ),

          SpeedDialChild(
              child: const Icon(Icons.person_outline),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              label: 'User',
              onTap: () {

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
