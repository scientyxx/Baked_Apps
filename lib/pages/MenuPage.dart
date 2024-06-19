import 'package:baked/widgets/CategoriesWidget.dart';
import 'package:baked/widgets/PopularItemsWidget.dart';
import 'package:baked/widgets/MenuHomeWidget.dart';
import 'package:baked/widgets/MenuListWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(right: 20, left: 15, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    "images/logo.png",
                    height: 100,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CategoriesWidget(),
                MenuListWidget()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
