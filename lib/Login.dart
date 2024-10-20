import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_habits/ForgotPassword.dart';
import 'package:tracking_habits/Register.dart';
import 'package:tracking_habits/profile.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
bool rememberMe = false; // State for checkbox

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              "assets/images/login.jpg",
              height: 1000,
              width: 1000,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Welcome Back!👋",
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'RobotoMono',
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Color.fromARGB(255, 163, 70, 240),
                              offset: Offset(2, 2),
                              blurRadius: 3.0,
                            ),
                          ],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Sign in to access your personalized habit tracking experience",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'RobotoMono',
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Color.fromARGB(255, 163, 70, 240),
                              offset: Offset(2, 2),
                              blurRadius: 3.0,
                            ),
                          ],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Email Field
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'RobotoMono',
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Color.fromARGB(255, 163, 70, 240),
                                offset: Offset(2, 2),
                                blurRadius: 3.0,
                              ),
                            ],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter Your Email',
                          labelText: "Email",
                          prefixIcon: const Icon(Icons.email, color: Color.fromARGB(255, 163, 70, 240)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 17,
                          fontFamily: 'RobotoMono',
                          color: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty || !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                            return "Enter a valid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Password Field
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Password",
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'RobotoMono',
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Color.fromARGB(255, 163, 70, 240),
                                offset: Offset(2, 2),
                                blurRadius: 3.0,
                              ),
                            ],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: 'Enter Your Password',
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock, color: Color.fromARGB(255, 163, 70, 240)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        obscureText: true,
                        style: const TextStyle(
                          fontSize: 17,
                          fontFamily: 'RobotoMono',
                          color: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty || value.length < 6) {
                            return "Enter a valid password (min. 6 characters)";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // Remember Me Checkbox
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value!;
                                  });
                                },
                                activeColor: const Color.fromARGB(255, 163, 70, 240),
                              ),
                              const Text(
                                "Remember Me",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgotPassword(),
                                ),
                              );
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Color.fromARGB(255, 163, 70, 240),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Sign In Button
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );

                              // Store login state if "Remember Me" is checked
                              if (rememberMe) {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                await prefs.setString('email', emailController.text.trim());
                              }

                              // Navigate to Profile screen on successful login
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const Profile()),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 163, 70, 240),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        child: const Text(
                          "Sign In",
                          style: TextStyle(fontSize: 18, fontFamily: 'RobotoMono'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Sign Up Link
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Register()),
                          );
                        },
                        child: const Text(
                          "Don't have an account? Sign Up",
                          style: TextStyle(
                            color: Color.fromARGB(255, 163, 70, 240),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
