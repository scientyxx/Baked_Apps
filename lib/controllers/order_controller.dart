// lib/controllers/order_controller.dart
import 'package:baked/models/order.dart';
import 'package:firebase_database/firebase_database.dart'; // Import ini
import 'package:flutter/material.dart';

class OrderController with ChangeNotifier {
  // HAPUS BARIS firebaseUrl dan firebaseToken
  // final String firebaseUrl = 'https://bakedapps-dfda2-default-rtdb.firebaseio.com/';
  // final String firebaseToken = 'AIzaSyDW88BGk2cXVfTTUmp4X7pFuPeKz0eLA3E';

  // Inisialisasi DatabaseReference TANPA URL di sini.
  // URL akan diambil otomatis dari Firebase.initializeApp() di main.dart.
  final DatabaseReference _ordersRef = FirebaseDatabase.instance.ref().child('orders');
  // final FirebaseAuth _auth = FirebaseAuth.instance; // Ini opsional, hanya jika Anda perlu mengakses user auth langsung di sini

  List<Order> _orders = [];

  List<Order> get orders => _orders;

  OrderController() {
    _listenToOrders();
  }

  void _listenToOrders() {
    _ordersRef.onValue.listen((event) {
      final data = event.snapshot.value;
      _orders.clear();
      if (data != null && data is Map) {
        data.forEach((key, value) {
          try {
            // Pastikan Order.fromJson dapat menangani Map<String, dynamic>
            _orders.add(Order.fromJson(Map<String, dynamic>.from(value)));
          } catch (e) {
            print("Error parsing order from Firebase: $e, data: $value");
          }
        });
      }
      notifyListeners();
    }, onError: (error) {
      print("Error listening to orders from Firebase: $error");
    });
  }

  int getOrderQuantity(String itemName) {
    try {
      final existingOrder = _orders.firstWhere((order) => order.name == itemName);
      return existingOrder.quantity;
    } catch (e) {
      return 0;
    }
  }

  void updateOrderQuantity(Order newOrder, int newQuantity) {
    final String safeItemName = newOrder.name.replaceAll(RegExp(r'[.#$\[\]/]'), '_');

    if (newQuantity <= 0) {
      _ordersRef.child(safeItemName).remove().then((_) {
        // Beri tahu UI secara langsung untuk update cepat, meskipun listener akan sync
        // notifyListeners(); // Opsional, karena listener _ordersRef.onValue akan sync
      }).catchError((error) {
        print("Error removing order from Firebase: $error");
      });
    } else {
      final Order orderToPersist = newOrder.copyWith(quantity: newQuantity);
      _ordersRef.child(safeItemName).set(orderToPersist.toJson()).then((_) {
        // Beri tahu UI secara langsung untuk update cepat, meskipun listener akan sync
        // notifyListeners(); // Opsional, karena listener _ordersRef.onValue akan sync
      }).catchError((error) {
        print("Error updating/adding order to Firebase: $error");
      });
    }
    // notifyListeners() tidak perlu dipanggil di sini setelah setiap operasi karena _listenToOrders yang akan melakukan refresh.
    // Namun, jika Anda ingin respons UI yang sangat cepat sebelum data dari Firebase kembali, Anda bisa memanggilnya secara opsional di .then() dari operasi Firebase.
  }

  Future<void> clearAllOrders() async {
    _orders.clear();
    await _ordersRef.remove();
    notifyListeners();
  }
}