import 'package:baked/pages/CoverPage.dart';
import 'package:flutter/material.dart';
import 'package:baked/pages/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => CoverPage(),
        "homepage": (context) => HomePage(),
      },
    );
  }
}
