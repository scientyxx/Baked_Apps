// lib/controllers/order_controller.dart
import 'package:baked/models/order.dart' as app_order_model;
import 'package:baked/models/pembayaran.dart';
import 'package:baked/models/transaksi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class OrderController with ChangeNotifier {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  List<Transaksi> _transaksiItems = [];
  List<Pembayaran> _pembayaranItems = [];

  List<Transaksi> get transaksiItems => _transaksiItems;
  List<Pembayaran> get pembayaranItems => _pembayaranItems;

  OrderController() {
    _listenToTransaksiChanges();
    _listenToPembayaranChanges();
  }

  void _listenToTransaksiChanges() {
    _databaseRef.child('transaksi').onValue.listen((event) {
      final dataSnapshot = event.snapshot;
      final List<Transaksi> loadedTransaksi = [];
      if (dataSnapshot.value != null) {
        final Map<dynamic, dynamic> values = dataSnapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          try {
            loadedTransaksi.add(Transaksi.fromJson(Map<String, dynamic>.from(value), key));
          } catch (e) {
            print("Error parsing transaksi from Firebase: $e, data: $value");
          }
        });
      }
      _transaksiItems = loadedTransaksi;
      notifyListeners();
    }, onError: (error) {
      print("Error listening to transaksi from Firebase: $error");
    });
  }

  void _listenToPembayaranChanges() {
    _databaseRef.child('pembayaran').onValue.listen((event) {
      final dataSnapshot = event.snapshot;
      final List<Pembayaran> loadedPembayaran = [];
      if (dataSnapshot.value != null) {
        final Map<dynamic, dynamic> values = dataSnapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          try {
            loadedPembayaran.add(Pembayaran.fromJson(Map<String, dynamic>.from(value), key));
          } catch (e) {
            print("Error parsing pembayaran from Firebase: $e, data: $value");
          }
        });
      }
      _pembayaranItems = loadedPembayaran;
      notifyListeners();
    }, onError: (error) {
      print("Error listening to pembayaran from Firebase: $error");
    });
  }

  Future<void> addOrUpdateTransaksiFromOrder({
    required app_order_model.Order orderItem,
    required String idCustomer,
    required String idMakananKatalog,
    String? idOrderOverall,
    String? idCashier,
    String? namaCashier,
    String? shift,
  }) async {
    DatabaseReference transaksiRef = _databaseRef.child('transaksi');
    String transaksiId = transaksiRef.push().key!;

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
      idCashier: idCashier,
      namaCashier: namaCashier,
      shift: shift,
    );

    print("Attempting to save Transaksi: ${newTransaksi.toJson()} with ID: $transaksiId");

    await transaksiRef.child(newTransaksi.idTransaksi!).set(newTransaksi.toJson()).then((_) {
      print("Transaksi added/updated successfully for ${newTransaksi.namaMakanan}");
    }).catchError((error) {
      print("Error adding/updating transaksi to Firebase: $error");
      if (error is FirebaseException) {
        print("Firebase Error Code: ${error.code}");
        print("Firebase Error Message: ${error.message}");
      }
    });
  }

  Future<void> removeTransaksi(String idTransaksi) async {
    await _databaseRef.child('transaksi').child(idTransaksi).remove().then((_) {
      print("Transaksi $idTransaksi removed successfully.");
    }).catchError((error) {
      print("Error removing transaksi from Firebase: $error");
    });
  }

  Future<void> clearAllTransaksi() async {
    _transaksiItems.clear();
    await _databaseRef.child('transaksi').remove();
    notifyListeners();
  }

  Map<String, int> getMostSoldItemIds() {
    Map<String, int> soldQuantities = {};

    for (var transaksi in _transaksiItems) {
      soldQuantities.update(
        transaksi.idMakanan,
        (value) => value + transaksi.jumlahItem,
        ifAbsent: () => transaksi.jumlahItem,
      );
    }
    return soldQuantities;
  }

  Future<void> savePayment({
    required String idOrder,
    required String metodeBayar,
    required double totalPembayaran,
  }) async {
    DatabaseReference pembayaranRef = _databaseRef.child('pembayaran');
    String paymentId = pembayaranRef.push().key!;

    Pembayaran newPembayaran = Pembayaran(
      id: paymentId,
      idOrder: idOrder,
      tanggalPembayaran: DateTime.now(),
      metodeBayar: metodeBayar,
      totalPembayaran: totalPembayaran,
    );

    print("Attempting to save Pembayaran: ${newPembayaran.toJson()} with ID: $paymentId");

    await pembayaranRef.child(newPembayaran.id!).set(newPembayaran.toJson()).then((_) {
      print("Pembayaran added successfully for Order ID: $idOrder, Method: $metodeBayar");
    }).catchError((error) {
      print("Error adding pembayaran to Firebase: $error");
      if (error is FirebaseException) {
        print("Firebase Error Code: ${error.code}");
        print("Firebase Error Message: ${error.message}");
      }
    });
  }
}