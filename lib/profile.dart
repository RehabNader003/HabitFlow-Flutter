import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // لاستخدام Firebase Storage
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // لاختيار التاريخ
import 'package:file_picker/file_picker.dart';
import 'package:tracking_habits/Register.dart'; // مكتبة لاختيار الصور

final genderController = TextEditingController();

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name;
  String? email;
  String? phone;
  String? imagePath;
  String? selectedGender; // لتخزين الجنس
  DateTime? selectedDate; // لتخزين تاريخ الميلاد
  String? selectedImagePath; // لتخزين مسار الصورة المحددة
  final FirebaseAuth _auth = FirebaseAuth.instance; // متغير FirebaseAuth
  final FirebaseStorage _storage = FirebaseStorage.instance; // متغير FirebaseStorage

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  // وظيفة لتحميل بيانات المستخدم من SharedPreferences
  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      email = prefs.getString('email');
      phone = prefs.getString('phone');
      imagePath = prefs.getString('imagePath'); // تحميل الصورة المحفوظة
    });
  }

  // وظيفة لاختيار الصورة
  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedImagePath = result.files.single.path; // تخزين مسار الصورة المحددة
      });

      // رفع الصورة إلى Firebase Storage
      await uploadImageToFirebase(selectedImagePath!);
    }
  }

  // رفع الصورة إلى Firebase Storage
  Future<void> uploadImageToFirebase(String path) async {
    File file = File(path);
    try {
      // استخدام الـ uid الخاص بالمستخدم كاسم للصورة
      String fileName = '${_auth.currentUser?.uid}.jpg';
      Reference ref = _storage.ref().child('profile_images/$fileName');
      await ref.putFile(file); // رفع الصورة
      String downloadUrl = await ref.getDownloadURL(); // الحصول على رابط الصورة

      // حفظ الرابط في SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('imagePath', downloadUrl);

      setState(() {
        imagePath = downloadUrl; // تحديث مسار الصورة
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Image uploaded successfully!'),
      ));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error uploading image: $e'),
      ));
    }
  }

  // وظيفة لاختيار التاريخ
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Personal Information",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // الخلفية: صورة تغطي الشاشة بالكامل
          Container(
            width: double.infinity,
            height: screenSize.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/profile.jpg"),
                fit: BoxFit.cover, // تغطية الشاشة بالكامل بالصورة
              ),
            ),
          ),
          // المحتوى فوق الخلفية
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 170),
                  // صورة الملف الشخصي
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: imagePath != null
                              ? NetworkImage(imagePath!) // استخدام الصورة من Firebase
                              : null,
                          child: imagePath == null
                              ? const Icon(Icons.person, size: 60, color: Colors.white)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, color: Colors.teal, size: 30),
                            onPressed: pickImage,
                            tooltip: "Edit Profile Image",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // معلومات المستخدم
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8), // خلفية نصف شفافة
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        buildInfoText("Name: ${name ?? ''}", Icons.person),
                        const SizedBox(height: 10),
                        buildInfoText("Email: ${email ?? ''}", Icons.email),
                        const SizedBox(height: 10),
                        buildInfoText("Phone: ${phone ?? ''}", Icons.phone),
                        const SizedBox(height: 20),

                        // Gender Dropdown
                        const Align(
                          alignment: Alignment.centerLeft, // محاذاة اليسار
                          child: Text(
                            "Gender",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 5),
                        DropdownButtonFormField<String>(
                          value: selectedGender,
                          hint: Text("Select your Gender"),
                          items: <String>['Male', 'Female'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            fillColor: Colors.teal[50],
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedGender = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 10),

                        // Birthdate with Calendar Icon
                        const Align(
                          alignment: Alignment.centerLeft, // محاذاة اليسار
                          child: Text(
                            "BirthDate",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: TextEditingController(
                            text: selectedDate != null
                                ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                                : '',
                          ),
                          decoration: InputDecoration(
                            labelText: "BirthDate",
                            suffixIcon: const Icon(Icons.calendar_today, color: Colors.teal),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            fillColor: Colors.teal[50],
                          ),
                          readOnly: true, // لمنع المستخدم من كتابة التاريخ يدوياً
                          onTap: () => _selectDate(context),
                        ),
                        const SizedBox(height: 30),

                        // زر تسجيل الخروج
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            // قم بتسجيل خروج المستخدم
                            await _auth.signOut();
                            Navigator.of(context).pop(); 
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const Register()));
                          },
                          child: const Text(
                            "Log Out",
                            style: TextStyle(fontSize: 18 , color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoText(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
