
import 'package:flutter/material.dart';
import 'package:tracking_habits/Login.dart';
import 'package:tracking_habits/Register.dart';

class Start extends StatelessWidget {
  const Start({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Let's Get Started!",
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'RobotoMono',
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Color.fromARGB(255, 145, 30, 240),
                    offset: Offset(2, 2),
                    blurRadius: 3.0,
                  ),
                ],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4), // Space between the two texts
            Text(
              "Let's divide into your account!",
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'RobotoMono',
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Color.fromARGB(255, 145, 30, 240),
                    offset: Offset(2, 2),
                    blurRadius: 3.0,
                  ),
                ],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 7),
            Container(
              width: 400,
              height: 400,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/first.gif'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 163, 70, 240),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  Register()),
                );
              },
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 7),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 163, 70, 240),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  const Login()),
                );
              },
              child: const Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
