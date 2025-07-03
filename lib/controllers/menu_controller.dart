// import 'package:firebase_storage/firebase_storage.dart'; // Hapus import ini
// import 'dart:io'; // Hapus import ini
import 'package:baked/models/katalog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MenuController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseStorage _storage = FirebaseStorage.instance; // Hapus inisialisasi ini
  List<Katalog> _menuItems = [];

  List<Katalog> get menuItems => _menuItems;

  MenuController() {
    _fetchMenuItems();
  }

  // Mengambil semua item menu dari Firestore
  Future<void> _fetchMenuItems() async {
    try {
      _menuItems.clear(); // Bersihkan daftar sebelum memuat ulang
      QuerySnapshot snapshot = await _firestore.collection('katalog').get();
      _menuItems = snapshot.docs.map((doc) {
        return Katalog.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching menu items: $e");
      // Handle error, misalnya tampilkan SnackBar
    }
  }

  // Fungsi uploadImage dihapus
  // Future<String?> uploadImage(File imageFile, String itemName) async { ... }

  // Menambah item menu baru
  // Parameter imageFile dihapus dari sini
  Future<void> addMenuItem(Katalog item) async {
    try {
      // imageUrl tidak lagi diunggah, cukup ambil dari item.imagePath
      final itemJson = item.toJson();
      itemJson['image_path'] = item.imagePath; // Pastikan imagePath disertakan ke JSON

      await _firestore.collection('katalog').add(itemJson);
      await _fetchMenuItems(); // Refresh daftar setelah menambah
    } catch (e) {
      print("Error adding menu item: $e");
    }
  }

  // Mengedit item menu yang sudah ada
  // Parameter imageFile dihapus dari sini
  Future<void> updateMenuItem(Katalog item) async {
    try {
      if (item.id != null) {
        // imageUrl tidak lagi diunggah
        final itemJson = item.toJson();
        itemJson['image_path'] = item.imagePath; // Pastikan imagePath diperbarui di JSON

        await _firestore.collection('katalog').doc(item.id).update(itemJson);
        await _fetchMenuItems(); // Refresh daftar setelah mengedit
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
      // Logika penghapusan gambar dari storage dihapus
      await _firestore.collection('katalog').doc(id).delete();
      await _fetchMenuItems(); // Refresh daftar setelah menghapus
    } catch (e) {
      print("Error deleting menu item: $e");
    }
  }
}