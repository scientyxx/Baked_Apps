import 'package:baked/controllers/auth_controller.dart';
import 'package:baked/pages/ShiftManagementPage.dart'; // Import halaman manajemen shift
import 'package:flutter/material.dart';

class AdminMenuPage extends StatelessWidget {
  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Menu"),
        centerTitle: true,
        backgroundColor: Color(0xFFC35A2E),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authController.signOut();
              Navigator.pushReplacementNamed(context, "loginpage");
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome, Admin/Kasir!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, "menu_management_page");
              },
              icon: Icon(Icons.edit_note),
              label: Text("Manage Menu Items"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC35A2E),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon( // Tombol baru untuk manajemen shift
              onPressed: () {
                Navigator.pushNamed(context, "shift_management_page"); // Rute baru
              },
              icon: Icon(Icons.schedule), // Icon jam
              label: Text("Manage Shifts"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC35A2E),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Go to Transaction Reports! (Not yet implemented)')),
                );
              },
              icon: Icon(Icons.analytics),
              label: Text("View Transactions"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC35A2E),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}