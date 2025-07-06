// lib/providers/order_provider.dart
import 'package:baked/controllers/menu_controller.dart' as app_menu_controller; // Import MenuController
import 'package:baked/models/katalog.dart'; // Import Katalog
import 'package:baked/models/order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  // Metode addOrder yang asli (tetap dipertahankan)
  void addOrder(Order order) {
    int existingIndex = _orders.indexWhere((item) => item.name == order.name);

    if (existingIndex != -1) {
      _orders[existingIndex] =
          _orders[existingIndex].copyWith(quantity: _orders[existingIndex].quantity + order.quantity);
    } else {
      _orders.add(order);
    }
    notifyListeners();
  }

  // Modifikasi updateOrderQuantity untuk cek stok
  // Metode ini sekarang menerima BuildContext agar bisa mengakses provider lain (MenuController)
  Future<void> updateOrderQuantity(BuildContext context, Order order, int newQuantity) async {
    // Pastikan context tidak null
    if (context == null) {
      print("Error: Context is null, cannot check stock for order quantity update.");
      return;
    }

    // Dapatkan instance MenuController dari Provider
    final app_menu_controller.MenuController menuController = Provider.of<app_menu_controller.MenuController>(context, listen: false);

    Katalog? katalogItem;
    try {
      // Cari item katalog yang sesuai dengan nama order
      katalogItem = menuController.menuItems.firstWhere((item) => item.namaMakanan == order.name);
    } catch (e) {
      // Jika item tidak ditemukan di katalog (mungkin sudah dihapus), log error dan keluar
      print("Error: Item ${order.name} not found in Katalog. Cannot update quantity.");
      // Tampilkan pesan kepada pengguna jika item tidak ada di menu
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maaf, menu ${order.name} tidak ditemukan.')),
      );
      return;
    }

    // Pastikan kuantitas baru tidak negatif
    if (newQuantity < 0) {
      newQuantity = 0;
    }

    // Cek apakah kuantitas baru melebihi stok yang tersedia
    if (newQuantity > katalogItem.stock) {
      print("Cannot add more ${order.name}. Stock limit reached: ${katalogItem.stock}");
      // Tampilkan pesan bahwa stok tidak cukup
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maaf, stok ${order.name} tidak cukup. Tersisa: ${katalogItem.stock}')),
      );
      return; // Hentikan proses jika stok tidak cukup
    }

    // Lanjutkan dengan logika update keranjang jika stok mencukupi
    int index = _orders.indexWhere((item) => item.name == order.name);

    if (index != -1) {
      // Jika item sudah ada di keranjang
      if (newQuantity == 0) {
        _orders.removeAt(index); // Hapus jika kuantitas jadi 0
      } else {
        _orders[index] = order.copyWith(quantity: newQuantity); // Update kuantitas
      }
    } else if (newQuantity > 0) {
      // Jika item belum ada di keranjang dan kuantitasnya > 0, tambahkan
      _orders.add(order.copyWith(quantity: newQuantity));
    }
    
    notifyListeners(); // Beri tahu listener bahwa data berubah
  }

  // Metode getOrderByName (tetap sama)
  Order? getOrderByName(String name) {
    try {
      return _orders.firstWhere((order) => order.name == name);
    } catch (e) {
      return null;
    }
  }

  // Metode getOrderQuantity (tetap sama)
  int getOrderQuantity(String name) {
    Order? order = getOrderByName(name);
    return order?.quantity ?? 0;
  }

  // Metode removeOrder (tetap sama)
  void removeOrder(Order order) {
    _orders.removeWhere((item) => item.name == order.name);
    notifyListeners();
  }

  // Metode clearCart (tetap sama)
  void clearCart() {
    _orders.clear();
    notifyListeners();
  }
}