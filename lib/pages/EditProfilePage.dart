import 'package:baked/controllers/user_controller.dart';
import 'package:flutter/material.dart';

class EditProfilePageContent extends StatefulWidget {
  @override
  _EditProfilePageContentState createState() => _EditProfilePageContentState();
}

class _EditProfilePageContentState extends State<EditProfilePageContent> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  final UserController _userController = UserController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      Map<String, dynamic>? userData = await _userController.getUserData();
      if (userData != null) {
        setState(() {
          nameController.text = userData['name'] ?? '';
          addressController.text = userData['address'] ?? '';
        });
      } else {
        setState(() {
          nameController.text = '';
          addressController.text = '';
        });
      }
    } catch (e) {
      print('Error loading user data for edit: $e');
    }
  }

  Future<void> _saveUserData() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _userController.updateUserData(
          nameController.text,
          addressController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
        // GANTI pushReplacementNamed DENGAN pop
        Navigator.of(context).pop(); // Ini akan kembali ke halaman sebelumnya (ProfilePage)
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // TAMBAHKAN APPBAR AGAR ADA TOMBOL BACK
        title: const Text("Edit Profile"),
        backgroundColor: const Color(0xFFC35A2E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "images/logo.png",
                    height: 100,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Profile", // Ini seharusnya "Edit Profile" atau dihapus karena sudah ada di AppBar
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(195, 90, 45, 1),
                        width: 2.0,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(195, 90, 45, 1),
                        width: 2.0,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveUserData,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(
                      MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height * 0.07,
                    ),
                    backgroundColor: Color(0xFFC35A2E),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}