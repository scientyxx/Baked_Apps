import 'package:baked/controllers/user_controller.dart'; // Import UserController
import 'package:flutter/material.dart';

class ProfilePageContent extends StatefulWidget {
  @override
  _ProfilePageContentState createState() => _ProfilePageContentState();
}

class _ProfilePageContentState extends State<ProfilePageContent> {
  final UserController _userController = UserController(); // Inisialisasi UserController

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      Map<String, dynamic>? userData = await _userController.getUserData(); // Gunakan UserController
      if (userData != null) {
        setState(() {
          nameController.text = userData['name'] ?? '';
          addressController.text = userData['address'] ?? '';
        });
      } else {
        setState(() {
          nameController.text = 'Data not found';
          addressController.text = 'Data not found';
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        nameController.text = 'Error loading data';
        addressController.text = 'Error loading data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                padding: EdgeInsets.only(
                  bottom: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, "editprofilepage");
                      },
                      child: Text(
                        "Edit",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFC35A2E),
                        ),
                      ),
                    ),
                  ],
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
                      color: Color.fromRGBO(195, 90, 45, 10),
                      width: 2.0,
                    ),
                  ),
                ),
                readOnly: true,
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
                      color: Color.fromRGBO(195, 90, 45, 10),
                      width: 2.0,
                    ),
                  ),
                ),
                readOnly: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}