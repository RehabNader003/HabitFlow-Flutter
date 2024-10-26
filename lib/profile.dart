import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project_app/pick_image-function.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:project_app/Login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _image;
  String? name;
  String? email;
  String? phone;
  String? imagePath;
  String? selectedGender = "Male";
  DateTime? selectedDate = DateTime.now();
  String? userId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
      name = prefs.getString('name');
      email = prefs.getString('email');
      phone = prefs.getString('phone');
      imagePath = prefs.getString('imagePath'); // Load the image path
      selectedGender = prefs.getString('gender');
      String? dateString = prefs.getString('birthdate');
      if (dateString != null) {
        selectedDate = DateTime.parse(dateString);
      }
      _image = imagePath != null && imagePath!.isNotEmpty
          ? Uri.parse(imagePath!).hasScheme
              ? imagePath
              : null
          : null;
// Initialize _image with the loaded imagePath
    });
  }

  Future<void> saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name ?? '');
    prefs.setString('email', email ?? '');
    prefs.setString('phone', phone ?? '');
    prefs.setString('imagePath', imagePath ?? '');
    prefs.setString('gender', selectedGender ?? '');
    prefs.setString('birthdate',
        selectedDate != null ? selectedDate!.toIso8601String() : '');

    print("Image path saved: $imagePath");
  }

  Future<void> uploadImage(String path) async {
    final file = File(path);
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child(
        'profile_images/${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg');

    await imageRef.putFile(file);
    final downloadUrl = await imageRef.getDownloadURL();

    setState(() {
      imagePath = downloadUrl; // Update imagePath with the download URL
      _image = downloadUrl; // Update _image to reflect the uploaded image
      saveUserData();
    });

    print("Image uploaded successfully, URL: $downloadUrl");
  }

  void selectImage() async {
    String imagePath = await pickImage(ImageSource.gallery);
    setState(() {
      this.imagePath = imagePath; // Update local variable
      uploadImage(imagePath); // Upload the selected image
    });
  }

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
        saveUserData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[700],
        title: const Text(
          "Personal Information",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 64,
                          backgroundColor: Colors.purple[100],
                          backgroundImage:
                              _image != null ? NetworkImage(_image!) : null,
                        ),
                        Positioned(
                          bottom: -10,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt,
                                color: Colors.black, size: 30),
                            onPressed: selectImage,
                            tooltip: "Edit Profile Image",
                            color: Colors.purple[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.purple[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        _buildInfoCard(
                          icon: Icons.person,
                          label: "Name",
                          value: name ?? '',
                        ),
                        _buildInfoCard(
                          icon: Icons.email,
                          label: "Email",
                          value: email ?? '',
                        ),
                        _buildInfoCard(
                          icon: Icons.phone,
                          label: "Phone",
                          value: phone ?? '',
                        ),
                        const SizedBox(height: 20),
                        _buildDropdown(
                          label: "Gender",
                          value: selectedGender,
                          items: ['Male', 'Female'],
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedGender = newValue;
                              saveUserData();
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        _buildDateField(
                          label: "BirthDate",
                          value: selectedDate != null
                              ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                              : 'Select your Birthdate',
                          onTap: () => _selectDate(context),
                        ),
                        const SizedBox(height: 20),
                        _buildSignOutButton(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() => _isLoading = true);
                      await saveUserData();
                      setState(() => _isLoading = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Changes saved successfully')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.purple[700],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: const Text("Save Changes"),
                  ),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.purple[700]),
        title: Text(
          label,
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.purple[700]),
        ),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text("Select your $label"),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.purple[100],
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        TextFormField(
          readOnly: true,
          onTap: onTap,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.purple[100],
            hintText: value,
          ),
        ),
      ],
    );
  }

  Widget _buildSignOutButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          const Icon(Icons.exit_to_app),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Login(),
                ),
              );
            },
            child: Text("Sign Out",
                style: TextStyle(color: Colors.purple[700], fontSize: 19)),
          ),
        ],
      ),
    );
  }
}
