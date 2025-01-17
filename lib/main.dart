// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'pages/ContinuePage.dart';
import 'pages/CoverPage.dart';
import 'pages/EditProfilePage.dart';
import 'pages/HomePage.dart' as home;
import 'pages/LoginPage.dart' as login;
import 'pages/ProfilePage.dart';
import 'pages/Register2Page.dart';
import 'pages/RegisterPage.dart';
import 'pages/StartingPage.dart';
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
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CoverPage(),
      routes: {
        "homepage": (context) => home.HomePage(),
        "startingpage": (context) => StartingPage(),
        "continuepage": (context) => ContinuePage(),
        "loginpage": (context) => login.LoginPage(),
        "registerpage": (context) => RegisterPage(),
        "register2page": (context) => Register2Page(),
        "editprofilepage": (context) => EditProfilePageContent(),
        "profilepage": (context) => ProfilePageContent(),
      },
      debugShowMaterialGrid: false,
    );
  }
}
