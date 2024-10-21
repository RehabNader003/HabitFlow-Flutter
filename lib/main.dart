// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:project_app/create_new_habit.dart';
import 'package:project_app/notification.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:project_app/page/home_page.dart';
import 'firebase_options.dart'; // Import the generated firebase_options.dart file
import 'notification_service.dart';
import 'Taskservice.dart';
import 'dart:async'; // Import Timer


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  NotificationHandler.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    myRequestPermission();
    getToken();
  }

  Future<void> myRequestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> getToken() async {
    String? myToken = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $myToken");
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home:  HomePage(),
    );
  }
}
