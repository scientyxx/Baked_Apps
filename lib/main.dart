import 'package:baked/pages/ContinuePage.dart';
import 'package:baked/pages/CoverPage.dart';
import 'package:baked/pages/LoginPage.dart';
import 'package:baked/pages/Register2Page.dart';
import 'package:baked/pages/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:baked/pages/HomePage.dart';
import 'package:baked/pages/StartingPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        // "/": (context) => CoverPage(),
        "/": (context) => HomePage(),
        "startingpage": (context) => StartingPage(),
        "continuepage": (context) => ContinuePage(),
        "loginpage": (context) => LoginPage(),
        "registerpage": (context) => RegisterPage(),
        "register2page": (context) => Register2Page(),
      },
      debugShowMaterialGrid: false, // ini buat ngilangin debug
    );
  }
}
