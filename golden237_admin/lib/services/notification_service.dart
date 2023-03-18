import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';

class NotificationService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initialise() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (kDebugMode) {
      print('User granted permission: ${settings.authorizationStatus}');
    }

  }
}