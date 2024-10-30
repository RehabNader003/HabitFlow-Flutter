import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_app/pages/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool rememberMe = false;
  bool isPasswordVisible = false;
  bool isLoading = false; // Loading indicator state

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: screenSize.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      "Join HabitFlow Today✨",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Color.fromARGB(255, 201, 160, 220),
                            offset: Offset(2, 2),
                            blurRadius: 3.0,
                          ),
                        ],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Start your habit journey with HabitFlow. It's quick, easy, and free!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Color.fromARGB(255, 201, 160, 220),
                            offset: Offset(2, 2),
                            blurRadius: 3.0,
                          ),
                        ],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Name field
                    _buildTextField(
                      controller: nameController,
                      label: 'Name',
                      hint: 'Enter your Name',
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Email Field
                    _buildTextField(
                      controller: emailController,
                      label: 'Email',
                      hint: 'Enter Your Email',
                      icon: Icons.email,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                                .hasMatch(value)) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password Field
                    _buildPasswordField(),
                    const SizedBox(height: 20),

                    // Phone Field
                    _buildTextField(
                      controller: phoneController,
                      label: 'Phone',
                      hint: 'Enter Your Phone',
                      icon: Icons.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Remember me checkbox
                    _buildRememberMeCheckbox(),

                    const SizedBox(height: 6),

                    // Already have an account
                    _buildAlreadyHaveAccountRow(),

                    const SizedBox(height: 10),

                    // Register Button
                    _buildRegisterButton(),
                    const SizedBox(height: 20),

                    // Loading Indicator
                    if (isLoading) const CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Method to build TextFields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintStyle: const TextStyle(
          fontSize: 15,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Color.fromARGB(255, 201, 160, 220),
              offset: Offset(2, 2),
              blurRadius: 3.0,
            ),
          ],
          fontWeight: FontWeight.bold,
        ),
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 241, 194, 125)),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: const TextStyle(
        fontSize: 17,
        color: Colors.white,
        shadows: [
          Shadow(
            color: Color.fromARGB(255, 201, 160, 220),
            offset: Offset(2, 2),
            blurRadius: 3.0,
          ),
        ],
        fontWeight: FontWeight.bold,
      ),
      validator: validator,
    );
  }

  // Method to build Password Field
  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter A strong Password',
        hintStyle: const TextStyle(
          fontSize: 15,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Color.fromARGB(255, 201, 160, 220),
              offset: Offset(2, 2),
              blurRadius: 3.0,
            ),
          ],
          fontWeight: FontWeight.bold,
        ),
        prefixIcon:
            const Icon(Icons.lock, color: Color.fromARGB(255, 241, 194, 125)),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: const Color.fromARGB(255, 241, 194, 125),
          ),
          onPressed: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: const TextStyle(
        fontSize: 17,
        color: Colors.white,
        shadows: [
          Shadow(
            color: Color.fromARGB(255, 80, 76, 176),
            offset: Offset(2, 2),
            blurRadius: 3.0,
          ),
        ],
        fontWeight: FontWeight.bold,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        return null;
      },
    );
  }

  // Method to build remember me checkbox
  Widget _buildRememberMeCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: rememberMe,
          onChanged: (value) {
            setState(() {
              rememberMe = value!;
            });
          },
          activeColor: const Color.fromARGB(255, 80, 76, 176),
        ),
        const Text(
          "I agree to Habitly Terms & Conditions",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  // Method to build already have an account row
  Widget _buildAlreadyHaveAccountRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account?",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const Login(),
              ),
            );
          },
          child: const Text(
            "Sign In",
            style: TextStyle(
              color: Color.fromARGB(255, 93, 58, 109),
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  // Method to build register button
  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 216, 138, 151),
          padding: const EdgeInsets.all(15),
        ),
        onPressed:
            isLoading ? null : _registerUser, // Disable button if loading
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Text(
                "Register",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  // Method to register user
  void _registerUser() async {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        isLoading = true; // Set loading to true
      });

      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Save user ID to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Optionally, save user data to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'profile_image': Uint8List(0),
        });

        // Save user data to SharedPreferences
        await prefs.setString('name', nameController.text.trim());
        await prefs.setString('email', emailController.text.trim());
        await prefs.setString('phone', phoneController.text.trim());
        await prefs.setString('userId', userCredential.user?.uid ?? '');
        print(await prefs.setString('userId', userCredential.user?.uid ?? ''));
        print(prefs.setString('name', nameController.text.trim()));

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'weak-password') {
          message = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          message = 'The account already exists for that email.';
        } else {
          message = 'Registration failed. Please try again.';
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      } finally {
        setState(() {
          isLoading = false; // Set loading to false after the operation
        });
      }
    }
  }
}
