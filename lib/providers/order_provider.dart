import 'dart:convert';

import 'package:baked/models/order.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  final String firebaseUrl =
      'https://bakedapps-dfda2-default-rtdb.firebaseio.com/';
  final String firebaseToken = 'AIzaSyDW88BGk2cXVfTTUmp4X7pFuPeKz0eLA3E';

  List<Order> get orders => _orders;

  void addOrder(Order order) {
    int index = _orders.indexWhere((o) => o.name == order.name);
    if (index >= 0) {
      _orders[index] = order;
    } else {
      _orders.add(order);
    }
    notifyListeners();

    _addToFirebase(order);
  }

  void removeOrder(Order order) {
    _orders.removeWhere((o) => o.name == order.name);
    notifyListeners();

    _removeFromFirebase(order);
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
    if (index >= 0 && newQuantity > 0) {
      _orders[index] = order.copyWith(quantity: newQuantity);
    } else if (index >= 0 && newQuantity <= 0) {
      _orders.removeAt(index);
    }
    notifyListeners();

    _updateInFirebase(order.copyWith(quantity: newQuantity));
  }

  Future<void> _addToFirebase(Order order) async {
    try {
      final response = await http.post(
        Uri.parse('$firebaseUrl/orders.json?auth=$firebaseToken'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(order.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to add order');
      }
    } catch (error) {
      print('Error adding order to Firebase: $error');
    }
  }

  Future<void> _removeFromFirebase(Order order) async {
    try {
      final response = await http.delete(
        Uri.parse('$firebaseUrl/orders/${order.name}.json?auth=$firebaseToken'),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to remove order');
      }
    } catch (error) {
      print('Error removing order from Firebase: $error');
    }
  }

  Future<void> _updateInFirebase(Order order) async {
    try {
      final response = await http.put(
        Uri.parse('$firebaseUrl/orders/${order.name}.json?auth=$firebaseToken'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(order.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update order');
      }
    } catch (error) {
      print('Error updating order in Firebase: $error');
    }
  }
}
