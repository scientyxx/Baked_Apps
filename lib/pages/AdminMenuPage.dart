// lib/pages/AdminMenuPage.dart
import 'package:baked/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Menu"),
        centerTitle: true,
        backgroundColor: const Color(0xFFC35A2E),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authController.signOut();
              Navigator.pushReplacementNamed(context, "loginpage");
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome, Admin/Kasir!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, "menu_management_page");
              },
              icon: const Icon(Icons.edit_note),
              label: const Text("Manage Menu Items"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC35A2E),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, "shift_management_page");
              },
              icon: const Icon(Icons.schedule),
              label: const Text("Manage Shifts"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC35A2E),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            // Tombol Baru untuk Kasir Scan
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, "cashier_scan_page"); // <--- NAVIGASI KE HALAMAN KASIR
              },
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text("Process Orders (Cashier)"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC35A2E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Go to Transaction Reports! (Not yet implemented)')),
                );
              },
              icon: const Icon(Icons.analytics),
              label: const Text("View Transactions"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC35A2E),
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