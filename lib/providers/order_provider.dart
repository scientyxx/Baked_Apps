import 'package:baked/models/order.dart';
import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(Order order) {
    int index = _orders.indexWhere((o) => o.name == order.name);
    if (index >= 0) {
      _orders[index] = order;
    } else {
      _orders.add(order);
    }
    notifyListeners();
  }

  void removeOrder(Order order) {
    _orders.removeWhere((o) => o.name == order.name);
    notifyListeners();
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
  }
}
