import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/auth_controller.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

  AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Screen'),
        actions: [
          Obx(() => Padding(
              padding: const EdgeInsets.only(top: 22.0),
              child: Text('(${authController.userList.length})'))
          ),
          IconButton(
              onPressed: (){
                showHelpDialog();
              },
              icon: const Icon(Icons.help_outline_outlined)
          ),
          const SizedBox(width: 10.0)
        ],
      ),

      body: Obx(() => authController.userList.isEmpty ?
        Center(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              color: Colors.white,
              child: const Text('Oops! No users was found!',
                  style: TextStyle(color: Colors.green)
              ),
            ),
          )
        ) :
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: ListView.builder(
            itemCount: authController.userList.length,
            itemBuilder: (context, index){
              return ListTile(
                leading: CachedNetworkImage(
                  imageUrl: "http://via.placeholder.com/200x150",
                  imageBuilder: (context, imageProvider) => Container(
                    height: 45,
                    width: 45,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: NetworkImage(authController.userList[index]['avatar_url']),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                title: Text(authController.userList[index]['name'], style: const TextStyle(fontSize: 15)),
                subtitle: Text(authController.userList[index]['email'],
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w200)
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Joined ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200)),
                    Text(getVerboseDateTimeRepresentation(DateTime.parse(authController.userList[index]['created_at'])),
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w100)),
                  ],
                ),
                onTap: () {
                  //Todo user profile screen
                }
              );
            }
          ),
        )
      ),

      floatingActionButton: Container(
            height: 50.0,
            width: 90.0,
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Colors.white38,
                )
            ),
            child: Center(
              child: RawMaterialButton(
                shape: const CircleBorder(),
                elevation: 0.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.add_outlined,
                    ),
                    SizedBox(width: 5.0),
                    Text('User')
                  ],
                ),
                onPressed: () {
                  Get.toNamed('/add_user');
                },
              ),
            ),
          )
    );
  }

  showHelpDialog(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: const [
              Text('Long press to see more options like edit and delete, can press to see subcategories as well.'),
              SizedBox(height: 10.0),

            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("Got it", style: TextStyle(color: Colors.green)),
          ),

        ],
      ),
    );
  }

  String getVerboseDateTimeRepresentation(DateTime dateTime) {
    DateTime now = DateTime.now().toLocal();

    DateTime localDateTime = dateTime.toLocal();

    if (localDateTime.difference(now).inDays == 0) {
      var differenceInHours = localDateTime.difference(now).inHours.abs();
      var differenceInMins = localDateTime.difference(now).inMinutes.abs();

      if (differenceInHours > 0) {
        return '$differenceInHours hours ago';
      } else if (differenceInMins > 2) {
        return '$differenceInMins mins ago';
      } else {
        return 'Just now';
      }
    }

    String roughTimeString = DateFormat('jm').format(dateTime);

    if (localDateTime.day == now.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return roughTimeString;
    }

    DateTime yesterday = now.subtract(const Duration(days: 1));

    if (localDateTime.day == yesterday.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return 'Yesterday';
    }

    if (now.difference(localDateTime).inDays < 4) {
      String weekday = DateFormat(
        'EEEE',
      ).format(localDateTime);

      return '$weekday, $roughTimeString';
    }

    return '${DateFormat('yMd').format(dateTime)}, $roughTimeString';
  }
}
