import 'package:baked/controllers/auth_controller.dart';
import 'package:baked/controllers/user_controller.dart';
import 'package:baked/pages/transaction_history_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePageContent extends StatefulWidget {
  @override
  _ProfilePageContentState createState() => _ProfilePageContentState();
}

class _ProfilePageContentState extends State<ProfilePageContent> {
  final UserController _userController = UserController();

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authController = Provider.of<AuthController>(context, listen: false);
    if (authController.currentUser != null) {
      _loadUserData();
    } else {
      nameController.text = 'Please log in';
      addressController.text = 'Please log in';
    }
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
    final authController = Provider.of<AuthController>(context);

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
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () async { // UBAH MENJADI async
                        // GANTI pushReplacementNamed DENGAN push
                        await Navigator.pushNamed(context, "editprofilepage");
                        // Setelah kembali dari EditProfilePage, muat ulang data profil
                        _loadUserData();
                      },
                      child: const Text(
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
              const SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
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
              const SizedBox(height: 20),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(
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
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () {
                  if (authController.currentUser != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionHistoryPage(
                          customerId: authController.currentUser!.uid,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please log in to view your order history.')),
                    );
                  }
                },
                icon: const Icon(Icons.history, color: Colors.white),
                label: const Text(
                  "Order History",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC35A2E),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () async {
                  await authController.signOut();
                  // Ini akan navigasi ke halaman login yang mungkin di luar Home/Dashboard
                  Navigator.pushReplacementNamed(context, "loginpage");
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  "Logout",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC35A2E),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}