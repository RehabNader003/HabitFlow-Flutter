
import 'package:flutter/material.dart';
import 'package:tracking_habits/ForgotPassword.dart';
import 'package:tracking_habits/profile.dart';
import 'package:tracking_habits/start.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home:  Start(),
    //home: ForgotPasswordPage(),
     //home: ProfilePage(),
    );
  }
}


