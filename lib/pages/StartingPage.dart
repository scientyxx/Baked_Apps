import 'package:flutter/material.dart';

class StartingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Image.asset(
                "images/logo.png",
                height: 74,
              ),
            ),
          ),
        ),
        body: Container(
            child: Image.asset(
          "images/25.png",
          height: 400,
        )),
      ),
    );
  }
}
