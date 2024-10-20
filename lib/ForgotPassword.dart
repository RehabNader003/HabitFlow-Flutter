import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance; // إنشاء مثيل لـ FirebaseAuth

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Forgot Password",
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'RobotoMono',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 163, 70, 240),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // خلفية الصورة
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/cute.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // محتوى النصوص والحقول
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 90),
                const Text(
                  "Enter your email to reset your password",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'RobotoMono',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Color.fromARGB(255, 163, 70, 240),
                        offset: Offset(2, 2),
                        blurRadius: 3.0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Color.fromARGB(255, 163, 70, 240),
                          offset: Offset(2, 2),
                          blurRadius: 3.0,
                        ),
                      ],
                    ),
                    prefixIcon: const Icon(Icons.email, color: Color.fromARGB(255, 163, 70, 240)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 163, 70, 240),
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                MaterialButton(
                  onPressed: () async {
                    final email = emailController.text;
                    if (email.isNotEmpty) {
                      try {
                        await _auth.sendPasswordResetEmail(email: email); // إرسال رابط إعادة تعيين كلمة المرور
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("A password reset link has been sent to $email"),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Error sending email. Please try again."),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter a valid email address"),
                        ),
                      );
                    }
                  },
                  color: const Color.fromARGB(255, 163, 70, 240),
                  textColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Send Reset Link",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'RobotoMono',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
