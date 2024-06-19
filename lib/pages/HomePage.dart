import 'package:baked/pages/MenuPage.dart';
import 'package:baked/widgets/CategoriesWidget.dart';
import 'package:baked/widgets/PopularItemsWidget.dart';
import 'package:baked/widgets/MenuHomeWidget.dart';
import 'package:baked/widgets/MenuListWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        textTheme: TextTheme(
            // Atur gaya teks sesuai dengan kebutuhan Anda
            ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // List of widgets corresponding to each tab
  final List<Widget> _tabs = [
    HomePageContent(), // Placeholder for Home page content
    MenuPageContent(), // Placeholder for Menu page content
    Container(
      color: Colors.blueGrey,
      child: Center(
        child: Text(
          'Order',
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
    ),
    Container(
      color: Colors.teal,
      child: Center(
        child: Text(
          'Profile',
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _tabs[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        unselectedItemColor: Color(0xFF50555C),
        selectedItemColor: Color(0xFFC35A2E),
        unselectedLabelStyle: TextStyle(color: Color(0xFF50555C)),
        selectedLabelStyle: TextStyle(color: Color(0xFFC35A2E)),
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
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
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "What do you want to buy?",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.symmetric(horizontal: 15),
            height: 50,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 237, 233, 233),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.search),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  width: 250,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search here...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Spacer(),
                Icon(Icons.filter_list),
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
                PopularItemsWidget(),
                MenuHomeWidget()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
