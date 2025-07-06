import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import semua controllers
import 'controllers/auth_controller.dart';
import 'controllers/menu_controller.dart' as app_menu_controller;
import 'controllers/order_controller.dart';
import 'controllers/shift_controller.dart' as app_shift_controller;
import 'firebase_options.dart'; // Pastikan ini ada dan benar
// Import semua halaman yang digunakan di routes
import 'pages/AdminMenuPage.dart';
import 'pages/ContinuePage.dart';
import 'pages/CoverPage.dart';
import 'pages/EditProfilePage.dart';
import 'pages/HomePage.dart'; // Import HomePage (yang merupakan kontainer bottom nav bar)
import 'pages/LoginPage.dart';
import 'pages/MenuManagementPage.dart';
import 'pages/ProfilePage.dart'; // Untuk ProfilePageContent
import 'pages/Register2Page.dart';
import 'pages/RegisterPage.dart';
import 'pages/ShiftManagementPage.dart';
import 'pages/StartingPage.dart';
import 'pages/cashier_scan_page.dart';
import 'pages/transaction_history_page.dart';
// Import semua providers
import 'providers/order_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => OrderController()),
        ChangeNotifierProvider(create: (_) => app_menu_controller.MenuController()),
        ChangeNotifierProvider(create: (_) => app_shift_controller.ShiftController()),
        ChangeNotifierProvider(create: (_) => AuthController()),
      ],
      child: const MyApp(), // MyApp sekarang didefinisikan di sini
    ),
  );
}

// DEFINISI KELAS MyApp SEKARANG ADA DI main.dart
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Tambahkan const constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Baked App', // Ganti dengan nama aplikasi Anda
      theme: ThemeData(
        primarySwatch: Colors.orange,
        textTheme: const TextTheme(),
      ),
      home: CoverPage(), // Halaman awal aplikasi
      routes: {
        "homepage": (context) => HomePage(), // HomePage adalah halaman dengan BottomNavigationBar
        "startingpage": (context) => StartingPage(),
        "continuepage": (context) => ContinuePage(),
        "loginpage": (context) => LoginPage(),
        "registerpage": (context) => RegisterPage(),
        "register2page": (context) => Register2Page(),
        "editprofilepage": (context) => EditProfilePageContent(),
        "profilepage": (context) => ProfilePageContent(),
        "admin_menu_page": (context) => AdminMenuPage(),
        "menu_management_page": (context) => MenuManagementPage(),
        "shift_management_page": (context) => ShiftManagementPage(),
        "cashier_scan_page": (context) => const CashierScanPage(),
        "transaction_history_page": (context) => const TransactionHistoryPage(),
      },
      debugShowMaterialGrid: false,
    );
  }
}