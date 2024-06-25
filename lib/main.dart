import 'package:baked/pages/ContinuePage.dart';
import 'package:baked/pages/CoverPage.dart';
import 'package:baked/pages/EditProfilePage.dart';
import 'package:baked/pages/HomePage.dart';
import 'package:baked/pages/LoginPage.dart';
import 'package:baked/pages/ProfilePage.dart';
import 'package:baked/pages/Register2Page.dart';
import 'package:baked/pages/RegisterPage.dart';
import 'package:baked/pages/StartingPage.dart';
import 'package:baked/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
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
      routes: {
        "/": (context) => CoverPage(),
        // "/": (context) => HomePage(),
        "homepage": (context) => HomePage(),
        "startingpage": (context) => StartingPage(),
        "continuepage": (context) => ContinuePage(),
        "loginpage": (context) => LoginPage(),
        "registerpage": (context) => RegisterPage(),
        "register2page": (context) => Register2Page(),
        "editprofilepage": (context) => EditProfilePageContent(),
        "profilepage": (context) => ProfilePageContent(),
      },
      debugShowMaterialGrid: false, // ini buat ngilangin debug
    );
  }
}
