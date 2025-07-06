// lib/pages/HomePage.dart
// Hapus semua import yang sudah tidak relevan di sini jika MyApp sudah dipindah
// Hanya sisakan import yang memang dibutuhkan oleh HomePage dan HomePageContent
import 'package:baked/controllers/menu_controller.dart' as app_menu_controller; // Pastikan import ini ada
import 'package:baked/pages/MenuPage.dart'; // Untuk MenuPageContent
import 'package:baked/pages/OrderPage.dart'; // Untuk OrderPage
import 'package:baked/pages/ProfilePage.dart'; // Untuk ProfilePageContent
import 'package:baked/widgets/MenuListWidget.dart';
import 'package:baked/widgets/PopularItemsWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// HAPUS SECARA TOTAL void main() dan class MyApp DARI SINI
// void main() { ... }
// class MyApp extends StatelessWidget { ... }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key); // Tambahkan const constructor

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    HomePageContent(), // Ini adalah StatefulWidget, OK
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

// UBAH DARI StatelessWidget MENJADI StatefulWidget
class HomePageContent extends StatefulWidget {
  const HomePageContent({Key? key}) : super(key: key); // Tambahkan const constructor

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inisialisasi search query di MenuController saat HomePageContent pertama kali dimuat
    // Memastikan daftar item filter terisi semua di awal
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Pastikan MenuController sudah tersedia di tree
      Provider.of<app_menu_controller.MenuController>(context, listen: false).setSearchQuery('');
    });

    // Tambahkan listener untuk input pencarian
    _searchController.addListener(() {
      // Pastikan MenuController sudah tersedia di tree
      Provider.of<app_menu_controller.MenuController>(context, listen: false).setSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dapatkan instance MenuController untuk memanggil setSearchQuery
    // Tidak perlu listen: false jika Anda hanya memanggil metode
    final menuController = Provider.of<app_menu_controller.MenuController>(context, listen: false);

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
            child: Row(
              children: [
                const Icon(Icons.search),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: "Search here...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                // const Icon(Icons.filter_list),
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
                PopularItemsWidget(), // Ini akan menggunakan filteredMenuItems
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
                            (homePageState as _HomePageState).onTabTapped(1); // Navigasi ke tab Menu
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
                MenuListWidget(limit: 4) // Ini akan menggunakan filteredMenuItems
              ],
            ),
          ),
        ],
      ),
    );
  }
}