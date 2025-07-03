// import 'dart:convert'; // Tidak lagi diperlukan
import 'package:baked/models/order.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http; // Tidak lagi diperlukan

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  // Hapus properti firebaseUrl dan firebaseToken
  // final String firebaseUrl = 'https://bakedapps-dfda2-default-rtdb.firebaseio.com/';
  // final String firebaseToken = 'AIzaSyDW88BGk2cXVfTTUmp4X7pFuPeKz0eLA3E';

  List<Order> get orders => _orders;

  void addOrder(Order order) {
    int index = _orders.indexWhere((o) => o.name == order.name);
    if (index >= 0) {
      _orders[index] = order;
    } else {
      _orders.add(order);
    }
    notifyListeners();
    // Hapus pemanggilan ke metode Firebase
  }

  void removeOrder(Order order) {
    _orders.removeWhere((o) => o.name == order.name);
    notifyListeners();
    // Hapus pemanggilan ke metode Firebase
  }

  int getOrderQuantity(String name) {
    int index = _orders.indexWhere((o) => o.name == name);
    if (index >= 0) {
      return _orders[index].quantity;
    }
    return 0;
  }

  void updateOrderQuantity(Order order, int newQuantity) {
    int index = _orders.indexWhere((o) => o.name == order.name);
    if (index >= 0) {
      if (newQuantity > 0) {
        _orders[index] = order.copyWith(quantity: newQuantity);
      } else {
        _orders.removeAt(index);
      }
      notifyListeners();
    } else if (newQuantity > 0) {
      _orders.add(order.copyWith(quantity: newQuantity));
      notifyListeners();
    }
    // Hapus pemanggilan ke metode Firebase
  }

  void clearCart() {
    _orders.clear();
    notifyListeners();
  }

  // Hapus semua metode _addToFirebase, _removeFromFirebase, _updateInFirebase
}