import 'package:baked/models/order.dart';
import 'package:flutter/foundation.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(Order order) {
    int index =
        _orders.indexWhere((existingOrder) => existingOrder.name == order.name);
    if (index != -1) {
      // Update quantity if order already exists
      _orders[index].quantity += order.quantity;
    } else {
      // Add new order
      _orders.add(order);
    }
    notifyListeners();
  }

  void removeOrder(Order order) {
    _orders.remove(order);
    notifyListeners();
  }
}
