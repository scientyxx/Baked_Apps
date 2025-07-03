// Tambahkan import yang dibutuhkan untuk semua halaman di routes
import 'package:baked/pages/AdminMenuPage.dart'; // Tambahkan
import 'package:baked/pages/ContinuePage.dart'; // Tambahkan
import 'package:baked/pages/CoverPage.dart'; // Tambahkan
import 'package:baked/pages/EditProfilePage.dart'; // Tambahkan
import 'package:baked/pages/LoginPage.dart'; // Tambahkan
import 'package:baked/pages/MenuManagementPage.dart'; // Tambahkan
import 'package:baked/pages/MenuPage.dart';
import 'package:baked/pages/OrderPage.dart';
import 'package:baked/pages/ProfilePage.dart';
import 'package:baked/pages/Register2Page.dart'; // Tambahkan
import 'package:baked/pages/RegisterPage.dart'; // Tambahkan
import 'package:baked/pages/ShiftManagementPage.dart'; // Tambahkan
import 'package:baked/pages/StartingPage.dart'; // Tambahkan
import 'package:baked/providers/order_provider.dart';
import 'package:baked/widgets/MenuListWidget.dart';
import 'package:baked/widgets/PopularItemsWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  // main() ini ada di HomePage.dart, tapi harusnya dihapus atau dipindah ke main.dart utama
  // Jika ini masih ada di HomePage.dart, ini adalah duplikasi.
  // MyApp() ini akan digunakan di main.dart utama.
  runApp(
    ChangeNotifierProvider(
      create: (context) => OrderProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Tambahkan ini
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        textTheme: const TextTheme(), // Tambahkan const
      ),
      home: CoverPage(), // <--- Tetapkan CoverPage sebagai home awal
      routes: { // <--- PINDAHKAN BLOK ROUTES KE SINI
        "homepage": (context) => HomePage(), // Ini HomePage yang didefinisikan di bawah
        "startingpage": (context) => StartingPage(),
        "continuepage": (context) => ContinuePage(),
        "loginpage": (context) => LoginPage(), // Ganti login.LoginPage()
        "registerpage": (context) => RegisterPage(),
        "register2page": (context) => Register2Page(),
        "editprofilepage": (context) => EditProfilePageContent(),
        "profilepage": (context) => ProfilePageContent(),
        "admin_menu_page": (context) => AdminMenuPage(),
        "menu_management_page": (context) => MenuManagementPage(),
        "shift_management_page": (context) => ShiftManagementPage(),
      },
      debugShowMaterialGrid: false, // Tambahkan ini
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    HomePageContent(),
    MenuPageContent(),
    OrderPage(),
    ProfilePageContent(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: _tabs,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: const [
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
        unselectedItemColor: const Color(0xFF50555C),
        selectedItemColor: const Color(0xFFC35A2E),
        unselectedLabelStyle: const TextStyle(color: Color(0xFF50555C)),
        selectedLabelStyle: const TextStyle(color: Color(0xFFC35A2E)),
      ),
    );
  }
}

// ... (sisa HomePageContent tetap sama)
class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 20, left: 15, top: 10),
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
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: const Column(
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
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 50,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 237, 233, 233),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.search),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search here...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Icon(Icons.filter_list),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PopularItemsWidget(),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 10, bottom: 10, top: 50, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Another Menu",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          final homePageState = context.findAncestorStateOfType<State<HomePage>>();
                          homePageState?.setState(() {
                            (homePageState as _HomePageState).onTabTapped(1);
                          });
                        },
                        child: const Text(
                          "See More",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFC35A2E),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                MenuListWidget(limit: 4)
              ],
            ),
          ),
        ],
      ),
    );
  }
}