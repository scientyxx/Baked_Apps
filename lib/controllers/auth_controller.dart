// lib/controllers/auth_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  // Register
  Future<UserCredential?> registerUser(String email, String password, String name, String address, {String role = 'customer', String? shift}) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // --- Tambahkan baris ini untuk mengirim email verifikasi ---
        await userCredential.user!.sendEmailVerification();
        // --------------------------------------------------------

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': email,
          'name': name,
          'address': address,
          'role': role,
          'shift': shift,
        });
      }
      notifyListeners();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'Kata sandi terlalu lemah. Mohon gunakan kombinasi huruf, angka, dan simbol.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Email ini sudah terdaftar. Silakan gunakan email lain atau login.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Format email tidak valid. Mohon periksa kembali alamat email Anda.';
      } else {
        errorMessage = 'Pendaftaran gagal: ${e.message}. Silakan coba lagi.';
      }
      throw Exception(errorMessage); // Lempar Exception dengan pesan yang jelas
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak dikenal saat pendaftaran. Pesan: ${e.toString()}');
    }
  }

  // Login
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
        if (userDoc.exists) {
          notifyListeners();
          return userDoc.data() as Map<String, dynamic>;
        } else {
          await _auth.signOut();
          throw Exception('Data pengguna tidak ditemukan di database. Mohon hubungi dukungan.');
        }
      }
      return null;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'Akun tidak ditemukan untuk email ini. Mohon periksa kembali email Anda.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Kata sandi salah. Mohon periksa kembali kata sandi Anda.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Format email tidak valid. Mohon periksa kembali alamat email Anda.';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'Akun ini telah dinonaktifkan. Mohon hubungi dukungan.';
      } else {
        errorMessage = 'Login gagal: ${e.message}. Silakan coba lagi.';
      }
      throw Exception(errorMessage); // Lempar Exception dengan pesan yang jelas
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak dikenal saat login. Pesan: ${e.toString()}');
    }
  }

  // Metode untuk mendapatkan data profil kasir/pengguna
  Future<Map<String, dynamic>?> getCashierProfile(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print("Error fetching cashier profile for $uid: $e");
      return null;
    }
  }

  // Metode: Update Shift Pengguna oleh Admin
  Future<void> updateUserShift(String uid, String newShift) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'shift': newShift,
      });
      print("Shift for user $uid updated to $newShift");
      notifyListeners();
    } catch (e) {
      print("Error updating shift for user $uid: $e");
      throw Exception('Gagal mengupdate shift pengguna: ${e.toString()}');
    }
  }

  // --- Metode: Mendapatkan Semua Pengguna (untuk Admin) ---
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs.map((doc) => {
        'uid': doc.id,
        'email': doc['email'],
        'name': doc['name'],
        'role': doc['role'],
        'shift': doc['shift'],
      }).toList();
    } catch (e) {
      print("Error fetching all users: $e");
      return [];
    }
  }
  // ---------------------------------------------------

  // Tambahkan metode getNextOrderSequence() di sini
  // --- Metode Baru: Mendapatkan nomor urut order ---
  Future<int> getNextOrderSequence() async {
    final docRef = _firestore.collection('counters').doc('orderIdSequence');
    try {
      return await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        int currentSequence = 0;
        if (snapshot.exists) {
          currentSequence = (snapshot.data()?['sequence'] as int?) ?? 0;
        }
        int nextSequence = currentSequence + 1;
        transaction.set(docRef, {'sequence': nextSequence});
        return nextSequence;
      });
    } catch (e) {
      print("Error getting next order sequence: $e");
      return DateTime.now().millisecondsSinceEpoch % 10000;
    }
  }
  // ---------------------------------------------------

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  // Mendapatkan peran pengguna saat ini
  Future<String?> getCurrentUserRole() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        return userDoc['role'];
      }
    }
    return null;
  }
}