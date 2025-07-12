// lib/pages/AdminMenuPage.dart
import 'package:baked/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminMenuPage extends StatefulWidget {
  const AdminMenuPage({Key? key}) : super(key: key);

  @override
  _AdminMenuPageState createState() => _AdminMenuPageState();
}

class _AdminMenuPageState extends State<AdminMenuPage> {
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    String? role = await authController.getCurrentUserRole();
    setState(() {
      _userRole = role;
    });
  }

 @override
Widget build(BuildContext context) {
  final authController = Provider.of<AuthController>(context, listen: false);

  // Tampilkan loading indicator jika peran masih null
  if (_userRole == null) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Loading Menu..."),
        centerTitle: true,
        backgroundColor: const Color(0xFFC35A2E),
        foregroundColor: Colors.white,
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  return Scaffold(
    appBar: AppBar(
      // Hapus properti 'title' untuk menghilangkan judul
      // title: const Text("Admin/Kasir Menu"), // <-- Hapus baris ini
      centerTitle: true,
      backgroundColor: const Color(0xFFC35A2E),
      foregroundColor: Colors.white,
      automaticallyImplyLeading: false, // <-- Tambahkan ini untuk menghilangkan tombol kembali
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
          Text(
            "Welcome, ${_userRole!.toUpperCase()}!",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // --- Menu untuk Admin ---
          if (_userRole == 'admin') ...[
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, "menu_management_page");
              },
              icon: const Icon(Icons.edit_note),
              label: const Text("Manage Menu Items"),
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
                Navigator.pushNamed(context, "shift_management_page");
              },
              icon: const Icon(Icons.schedule),
              label: const Text("Manage Shifts"),
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
                Navigator.pushNamed(context, "transaction_history_page");
              },
              icon: const Icon(Icons.analytics),
              label: const Text("View Transactions"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC35A2E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],

          // --- Menu untuk Kasir ---
          if (_userRole == 'kasir') ...[
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, "menu_management_page");
              },
              icon: const Icon(Icons.edit_note),
              label: const Text("Manage Menu Items"),
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
                Navigator.pushNamed(context, "cashier_scan_page");
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
                Navigator.pushNamed(context, "transaction_history_page");
              },
              icon: const Icon(Icons.analytics),
              label: const Text("View Transactions"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC35A2E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],

          // --- Pesan jika peran tidak dikenali atau tidak memiliki menu khusus ---
          if (_userRole != 'admin' && _userRole != 'kasir') ...[
            const Text(
              "Your role does not have access to admin/cashier features.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ],
        ],
      ),
    ),
  );
}
}