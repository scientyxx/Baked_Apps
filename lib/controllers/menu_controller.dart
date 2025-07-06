// lib/controllers/menu_controller.dart
import 'package:baked/models/katalog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MenuController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Katalog> _menuItems = [];
  String _searchQuery = '';
  List<Katalog> _filteredMenuItems = [];

  List<Katalog> get menuItems => _menuItems;
  List<Katalog> get filteredMenuItems => _filteredMenuItems;
  String get searchQuery => _searchQuery; // TAMBAHKAN GETTER INI

  MenuController() {
    _listenToMenuItems();
  }

  Future<void> _listenToMenuItems() async {
    try {
      _firestore.collection('katalog').snapshots().listen((snapshot) {
        final List<Katalog> loadedMenuItems = [];
        for (var doc in snapshot.docs) {
          try {
            loadedMenuItems.add(Katalog.fromJson(doc.data() as Map<String, dynamic>, doc.id));
          } catch (e) {
            print("Error parsing menu item from Firestore: $e, data: ${doc.data()}");
          }
        }
        _menuItems = loadedMenuItems;
        _applyFilter();
        notifyListeners();
        print("Menu items updated in real-time. Current items count: ${_menuItems.length}");
      }, onError: (error) {
        print("Error listening to menu items from Firestore: $error");
      });
    } catch (e) {
      print("Error setting up real-time listener for menu items: $e");
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredMenuItems = List.from(_menuItems);
    } else {
      _filteredMenuItems = _menuItems.where((item) {
        return item.namaMakanan.toLowerCase().contains(_searchQuery) ||
               item.deskripsi.toLowerCase().contains(_searchQuery) ||
               item.kategori.toLowerCase().contains(_searchQuery);
      }).toList();
    }
  }

  Future<void> addMenuItem(Katalog item) async {
    try {
      final itemJson = item.toJson();
      itemJson['image_path'] = item.imagePath;

      await _firestore.collection('katalog').add(itemJson);
    } catch (e) {
      print("Error adding menu item: $e");
    }
  }

  Future<void> updateMenuItem(Katalog item) async {
    try {
      if (item.id != null) {
        final itemJson = item.toJson();
        itemJson['image_path'] = item.imagePath;

        await _firestore.collection('katalog').doc(item.id).update(itemJson);
      } else {
        print("Error: Cannot update menu item without an ID.");
      }
    } catch (e) {
      print("Error updating menu item: $e");
    }
  }

  Future<void> deleteMenuItem(String id) async {
    try {
      await _firestore.collection('katalog').doc(id).delete();
    } catch (e) {
      print("Error deleting menu item: $e");
    }
  }
}