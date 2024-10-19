import 'package:flutter/material.dart';
import 'package:habitflow_depi/splashScreen/splash-screen.dart';


void main() {
  runApp(HabitlyApp());
}

class HabitlyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HabitFlow',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: SplashScreen(),  // Start with the splash screen
    );
  }
}
