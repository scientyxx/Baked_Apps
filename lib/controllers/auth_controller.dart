// lib/controllers/auth_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  // Register (sudah ada)
  Future<UserCredential?> registerUser(String email, String password, String name, String address) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': email,
          'name': name,
          'address': address,
          'role': 'customer', // Default role
          // Jika kasir akan didaftarkan di sini, tambahkan field shift jika diperlukan.
          // Contoh: 'shift': 'Pagi'
        });
      }
      notifyListeners();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else {
        errorMessage = 'Registration failed: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unknown error occurred during registration: $e');
    }
  }

  // Login (sudah ada)
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Setelah login, pastikan user data di Firestore diambil.
        // Ini akan secara implisit memperbarui currentUser.
        // Data ini sudah dikembalikan oleh method loginUser.
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
        if (userDoc.exists) {
          notifyListeners(); // Beri tahu listener setelah login berhasil
          return userDoc.data() as Map<String, dynamic>; // Mengembalikan semua data user, termasuk role dan nama
        } else {
          await _auth.signOut();
          throw Exception('User data not found in database. Please contact support.');
        }
      }
      return null;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else {
        errorMessage = 'Login failed: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unknown error occurred during login: $e');
    }
  }

  // <--- TAMBAHKAN METODE BARU INI UNTUK MENDAPATKAN DATA PROFIL KASIR ---
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
  // ---------------------------------------------------------------------

  // Logout (sudah ada)
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  // Mendapatkan peran pengguna saat ini (sudah ada)
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