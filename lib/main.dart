import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/auth_controller.dart';
import 'controllers/menu_controller.dart' as app_menu_controller;
import 'controllers/order_controller.dart';
import 'controllers/shift_controller.dart' as app_shift_controller;
import 'firebase_options.dart';
import 'pages/HomePage.dart' as home; // Mengimpor home.MyApp dari sini
// Tambahkan semua import halaman yang digunakan di routes yang pindah ke HomePage.dart
// Hapus import yang sudah ada di HomePage.dart karena sudah di sana
// import 'pages/AdminMenuPage.dart';
// import 'pages/ContinuePage.dart';
// import 'pages/EditProfilePage.dart';
// import 'pages/MenuManagementPage.dart';
// import 'pages/ProfilePage.dart';
// import 'pages/Register2Page.dart';
// import 'pages/RegisterPage.dart';
// import 'pages/ShiftManagementPage.dart';
// import 'pages/StartingPage.dart';
// import 'pages/CoverPage.dart'; // CoverPage tidak di HomePage.dart, jadi biarkan kalau di main.dart yang utama.

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
      child: home.MyApp(), // Menggunakan MyApp dari HomePage.dart
    ),
  );
}

// HAPUS SECARA TOTAL BLOK KELAS MyApp INI DARI main.dart
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: CoverPage(), // ini akan jadi duplikasi jika juga di home.MyApp
//       routes: {
//         "homepage": (context) => home.HomePage(),
//         "startingpage": (context) => StartingPage(),
//         "continuepage": (context) => ContinuePage(),
//         "loginpage": (context) => LoginPage(), // Ganti login.LoginPage()
//         "registerpage": (context) => RegisterPage(),
//         "register2page": (context) => Register2Page(),
//         "editprofilepage": (context) => EditProfilePageContent(),
//         "profilepage": (context) => ProfilePageContent(),
//         "admin_menu_page": (context) => AdminMenuPage(),
//         "menu_management_page": (context) => MenuManagementPage(),
//         "shift_management_page": (context) => ShiftManagementPage(),
//       },
//       debugShowMaterialGrid: false,
//     );
//   }
// }