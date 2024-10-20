import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // استيراد Firebase Auth
import 'package:tracking_habits/Login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool rememberMe = false; // حالة لعلامة الاختيار
  bool isPasswordVisible = false; // حالة لرؤية كلمة المرور

  final FirebaseAuth _auth = FirebaseAuth.instance; // متغير FirebaseAuth

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: screenSize.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/register.jpg"),
                fit: BoxFit.cover, // تأكد من تغطية الصورة للشاشة بالكامل
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start, // المحاذاة للبداية
                  crossAxisAlignment: CrossAxisAlignment.center, // المركز أفقيًا
                  children: [
                    const SizedBox(height: 30), // زيادة المسافة العلوية
                    const Text(
                      "Join Habitly Today✨",
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
                      "Start your habit journey with Habitly. It's quick, easy, and free!",
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
                    const SizedBox(height: 30), // تعديل الفراغ هنا إذا لزم الأمر

                    // Name field
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(
                          fontSize: 15,
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
                        labelText: 'Name',
                        hintText: 'Enter your Name',
                        prefixIcon: const Icon(Icons.person, color: Color.fromARGB(255, 163, 70, 240)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 17,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Email Field
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(
                          fontSize: 15,
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
                        labelText: 'Email',
                        hintText: 'Enter Your Email',
                        prefixIcon: const Icon(Icons.email, color: Color.fromARGB(255, 163, 70, 240)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 17,
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

                    // Password Field
                    TextFormField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible, // تبديل الرؤية
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter A strong Password',
                        hintStyle: const TextStyle(
                          fontSize: 15,
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
                        prefixIcon: const Icon(Icons.lock, color: Color.fromARGB(255, 163, 70, 240)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: const Color.fromARGB(255, 163, 70, 240),
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 17,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Phone Field
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(
                          fontSize: 15,
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
                        labelText: 'Phone',
                        hintText: 'Enter Your Phone',
                        prefixIcon: const Icon(Icons.phone, color: Color.fromARGB(255, 163, 70, 240)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 17,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                          "I agree to Habitly Terms & Conditions",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
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
                              color: Color.fromARGB(255, 163, 70, 240),
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Register Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: const Color.fromARGB(255, 163, 70, 240),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              // تسجيل المستخدم باستخدام Firebase Auth
                              UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                              );

                              // إذا كان لديك حقول إضافية مثل الاسم أو رقم الهاتف، يمكنك تخزينها في قاعدة بيانات Firebase أخرى مثل Firestore هنا
                              
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            } catch (e) {
                              // معالجة الأخطاء مثل إذا كان البريد الإلكتروني موجودًا بالفعل
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          }
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // الحساب موجود بالفعل
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
