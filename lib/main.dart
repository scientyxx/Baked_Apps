import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/auth_controller.dart';
import 'controllers/menu_controller.dart' as app_menu_controller;
import 'controllers/order_controller.dart';
import 'controllers/shift_controller.dart' as app_shift_controller;
import 'firebase_options.dart';
import 'pages/HomePage.dart' as home;
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
      child: home.MyApp(), // Pastikan menggunakan home.MyApp()
    ),
  );
}

// HAPUS BLOK KELAS MyApp INI DARI SINI JIKA ADA DUPLIKASI DENGAN HomePage.dart
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: CoverPage(),
//       routes: {
//         "homepage": (context) => home.HomePage(),
//         "startingpage": (context) => StartingPage(),
//         "continuepage": (context) => ContinuePage(),
//         "loginpage": (context) => login.LoginPage(),
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