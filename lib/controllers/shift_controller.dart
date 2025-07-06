import 'package:baked/models/shift.dart'; // Pastikan path ini benar
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShiftController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Shift> _shifts = [];

  List<Shift> get shifts => _shifts;

  ShiftController() {
    fetchShifts(); // Memanggil versi publik dari fetchShifts
  }

  // Mengambil semua definisi shift dari Firestore (sekarang publik)
  Future<void> fetchShifts() async { // Mengubah _fetchShifts() menjadi fetchShifts()
    try {
      _shifts.clear(); // Bersihkan daftar sebelum memuat ulang
      QuerySnapshot snapshot = await _firestore.collection('shifts').get();
      _shifts = snapshot.docs.map((doc) {
        // Menggunakan factory Shift.fromJson(Map<String, dynamic> json, String id)
        return Shift.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching shifts: $e");
      // Handle error, misalnya tampilkan SnackBar
    }
  }

  // Menambah definisi shift baru
  Future<void> addShift(Shift shift) async {
    try {
      await _firestore.collection('shifts').add(shift.toJson());
      await fetchShifts(); // Refresh daftar setelah menambah
    } catch (e) {
      print("Error adding shift: $e");
    }
  }

  // Mengedit definisi shift yang sudah ada
  Future<void> updateShift(Shift shift) async {
    try {
      if (shift.id != null) {
        await _firestore.collection('shifts').doc(shift.id).update(shift.toJson());
        await fetchShifts(); // Refresh daftar setelah mengedit
      } else {
        print("Error: Cannot update shift without an ID.");
      }
    } catch (e) {
      print("Error updating shift: $e");
    }
  }

  // Menghapus definisi shift
  Future<void> deleteShift(String id) async {
    try {
      await _firestore.collection('shifts').doc(id).delete();
      await fetchShifts(); // Refresh daftar setelah menghapus
    } catch (e) {
      print("Error deleting shift: $e");
    }
  }
}