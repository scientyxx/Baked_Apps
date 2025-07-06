// lib/controllers/menu_controller.dart
import 'package:baked/models/katalog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MenuController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Katalog> _menuItems = [];
  // Tambahkan StreamSubscription jika ingin mengelola listener
  // StreamSubscription? _menuSubscription;

  List<Katalog> get menuItems => _menuItems;

  MenuController() {
    _listenToMenuItems(); // Ganti _fetchMenuItems dengan _listenToMenuItems
  }

  // Metode baru untuk mendengarkan perubahan menu item secara real-time
  Future<void> _listenToMenuItems() async {
    // Jika ada subscription lama, batalkan dulu
    // _menuSubscription?.cancel();

    try {
      // Menggunakan snapshots() untuk real-time updates
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
        notifyListeners(); // Memberi tahu UI untuk rebuild
        print("Menu items updated in real-time. Current items count: ${_menuItems.length}");
      }, onError: (error) {
        print("Error listening to menu items from Firestore: $error");
        // Handle error, misalnya tampilkan SnackBar
      });
    } catch (e) {
      print("Error setting up real-time listener for menu items: $e");
    }
  }

  // Menambah item menu baru
  Future<void> addMenuItem(Katalog item) async {
    try {
      final itemJson = item.toJson();
      itemJson['image_path'] = item.imagePath;

      await _firestore.collection('katalog').add(itemJson);
      // _listenToMenuItems() akan otomatis memperbarui _menuItems karena ini adalah listener
      // await _fetchMenuItems(); // Tidak perlu panggil lagi
    } catch (e) {
      print("Error adding menu item: $e");
    }
  }

  // Mengedit item menu yang sudah ada
  Future<void> updateMenuItem(Katalog item) async {
    try {
      if (item.id != null) {
        final itemJson = item.toJson();
        itemJson['image_path'] = item.imagePath;

        await _firestore.collection('katalog').doc(item.id).update(itemJson);
        // _listenToMenuItems() akan otomatis memperbarui _menuItems
        // await _fetchMenuItems(); // Tidak perlu panggil lagi
      } else {
        print("Error: Cannot update menu item without an ID.");
      }
    } catch (e) {
      print("Error updating menu item: $e");
    }
  }

  // Menghapus item menu
  Future<void> deleteMenuItem(String id) async {
    try {
      await _firestore.collection('katalog').doc(id).delete();
      // _listenToMenuItems() akan otomatis memperbarui _menuItems
      // await _fetchMenuItems(); // Tidak perlu panggil lagi
    } catch (e) {
      print("Error deleting menu item: $e");
    }
  }

  // Opsional: Batalkan subscription saat controller dibuang
  // @override
  // void dispose() {
  //   _menuSubscription?.cancel();
  //   super.dispose();
  // }
}