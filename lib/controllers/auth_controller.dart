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
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': email,
          'name': name,
          'address': address,
          'role': role, // Menggunakan parameter role
          'shift': shift, // Menambahkan field shift
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

  // --- Metode Baru: Update Shift Pengguna oleh Admin ---
  Future<void> updateUserShift(String uid, String newShift) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'shift': newShift,
      });
      print("Shift for user $uid updated to $newShift");
      notifyListeners(); // Beri tahu listener jika ada yang memantau perubahan user
    } catch (e) {
      print("Error updating shift for user $uid: $e");
      throw Exception('Failed to update user shift: $e');
    }
  }

  // --- Metode Baru: Mendapatkan Semua Pengguna (untuk Admin) ---
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs.map((doc) => {
        'uid': doc.id,
        'email': doc['email'],
        'name': doc['name'],
        'role': doc['role'],
        'shift': doc['shift'], // Pastikan field shift ada
      }).toList();
    } catch (e) {
      print("Error fetching all users: $e");
      return [];
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