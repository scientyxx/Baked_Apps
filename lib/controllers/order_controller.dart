import 'package:baked/models/order.dart' as app_order_model;
import 'package:baked/models/transaksi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class OrderController with ChangeNotifier {
  final DatabaseReference _transaksiRef = FirebaseDatabase.instance.ref().child('transaksi');

  List<Transaksi> _transaksiItems = [];

  List<Transaksi> get transaksiItems => _transaksiItems;

  OrderController() {
    _listenToTransaksi();
  }

  void _listenToTransaksi() {
    _transaksiRef.onValue.listen((event) {
      final data = event.snapshot.value;
      _transaksiItems.clear();
      if (data != null && data is Map) {
        data.forEach((key, value) {
          try {
            _transaksiItems.add(Transaksi.fromJson(Map<String, dynamic>.from(value), key));
          } catch (e) {
            print("Error parsing transaksi from Firebase: $e, data: $value");
          }
        });
      }
      notifyListeners();
    }, onError: (error) {
      print("Error listening to transaksi from Firebase: $error");
    });
  }

  Future<void> addOrUpdateTransaksiFromOrder({
    required app_order_model.Order orderItem,
    required String idCustomer,
    required String idMakananKatalog,
    String? idOrderOverall,
  }) async {
    String transaksiId = _transaksiRef.push().key!;

    double totalHargaItem = orderItem.price * orderItem.quantity;

    Transaksi newTransaksi = Transaksi(
      idTransaksi: transaksiId,
      idOrder: idOrderOverall ?? transaksiId,
      tanggalOrder: DateTime.now(),
      idMakanan: idMakananKatalog,
      namaMakanan: orderItem.name,
      imagePath: orderItem.imagePath,
      idCustomer: idCustomer,
      hargaPerItem: orderItem.price,
      jumlahItem: orderItem.quantity,
      totalHargaItem: totalHargaItem,
    );

    // DEBUGGING: Tambahkan print sebelum mencoba menulis ke DB
    print("Attempting to save Transaksi: ${newTransaksi.toJson()} with ID: $transaksiId");

    await _transaksiRef.child(newTransaksi.idTransaksi!).set(newTransaksi.toJson()).then((_) {
      print("Transaksi added/updated successfully for ${newTransaksi.namaMakanan}");
    }).catchError((error) {
      print("Error adding/updating transaksi to Firebase: $error");
      // DEBUGGING: Print error secara lebih detail
      if (error is FirebaseException) {
        print("Firebase Error Code: ${error.code}");
        print("Firebase Error Message: ${error.message}");
      }
    });
  }

  Future<void> removeTransaksi(String idTransaksi) async {
    await _transaksiRef.child(idTransaksi).remove().then((_) {
      print("Transaksi $idTransaksi removed successfully.");
    }).catchError((error) {
      print("Error removing transaksi from Firebase: $error");
    });
  }

  Future<void> clearAllTransaksi() async {
    _transaksiItems.clear();
    await _transaksiRef.remove();
    notifyListeners();
  }
}