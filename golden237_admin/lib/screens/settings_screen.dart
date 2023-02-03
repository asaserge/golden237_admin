import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:golden237_admin/messages/constants.dart';

import '../messages/utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  late bool _darkModeOn;
  late bool _emailNoti;
  late bool _isSecured;
  late String pass;
  final storage = GetStorage();

  @override
  void initState() {
    _darkModeOn = storage.read('isDark') ?? true;
    _emailNoti = storage.read('isNoti') ?? true;
    _isSecured = storage.read('isSecured') ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
          child: Column(
            children: [
              SwitchListTile(
                value: _darkModeOn,
                activeColor: primaryColor,
                dense: true,
                title: const Text('Toggle App Theme'),
                subtitle: _darkModeOn ? const Text('Dark theme is enabled') : const Text('Light theme is enabled'),
                secondary: _darkModeOn ? const Icon(Icons.dark_mode_outlined) : const Icon(Icons.light_mode_outlined),
                onChanged: (value){
                  setState(() {
                    _darkModeOn = value;
                  });
                  if(value){
                    Get.changeTheme(MyTheme.myDarkTheme);
                    storage.write('isDark', value);
                  }
                  else{
                    Get.changeTheme(MyTheme.myLightTheme);
                    storage.write('isDark', value);
                  }
                }
              ),
              const Divider(thickness: 2),

              SwitchListTile(
                  value: _emailNoti,
                  activeColor: primaryColor,
                  dense: true,
                  title: const Text('Toggle Email Notification'),
                  subtitle: _emailNoti ? const Text('Email notification is turned on') : const Text('Email notification is turned off'),
                  secondary: _emailNoti ? const Icon(Icons.notifications_outlined) : const Icon(Icons.notifications_off_outlined),
                  onChanged: (value){
                    setState(() {
                      _emailNoti = value;
                    });
                    storage.write('isNoti', value);
                  }
              ),
              const Divider(thickness: 2),


            ],
          ),
        ),
      ),
    );
  }
}
