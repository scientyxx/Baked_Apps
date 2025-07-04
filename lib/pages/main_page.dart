// Contoh di main_page.dart (atau halaman utama setelah login)
import 'package:baked/controllers/auth_controller.dart';
import 'package:baked/pages/admin_shift_management_page.dart';
import 'package:baked/pages/cashier_scan_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Import halaman lain seperti manage_menu_items_page.dart, view_transactions_page.dart

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    String? role = await Provider.of<AuthController>(context, listen: false).getCurrentUserRole();
    setState(() {
      _userRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_userRole == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()), // Menunggu peran dimuat
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Aplikasi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthController>(context, listen: false).signOut();
              // Arahkan ke halaman login
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Selamat datang, ${_userRole!.toUpperCase()}!', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),

            // Menu untuk Admin
            if (_userRole == 'admin') ...[
              ElevatedButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => ManageMenuItemsPage()));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Navigasi ke Manage Menu Items (Admin)')));
                },
                child: const Text('Kelola Item Menu'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminShiftManagementPage()));
                },
                child: const Text('Kelola Shift Kasir'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => ViewTransactionsPage()));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Navigasi ke Lihat Transaksi (Admin)')));
                },
                child: const Text('Lihat Transaksi'),
              ),
            ],

            // Menu untuk Kasir
            if (_userRole == 'kasir') ...[
              ElevatedButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => ManageMenuItemsPage()));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Navigasi ke Manage Menu Items (Kasir)')));
                },
                child: const Text('Kelola Item Menu'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CashierScanPage()));
                },
                child: const Text('Proses Pesanan (Scan QR)'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => ViewTransactionsPage()));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Navigasi ke Lihat Transaksi (Kasir)')));
                },
                child: const Text('Lihat Transaksi'),
              ),
            ],

            // Menu untuk Customer (jika ada)
            if (_userRole == 'customer') ...[
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Navigasi ke Halaman Pesanan (Customer)')));
                },
                child: const Text('Buat Pesanan Baru'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}