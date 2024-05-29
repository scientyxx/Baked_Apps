import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var icons;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(right: 20, left: 15, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      icons.menu,
                      color: Colors.white,
                      size: 30,
                    ),
                    Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow()]))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
