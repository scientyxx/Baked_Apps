import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; // Penting untuk ChangeNotifier

class AuthController with ChangeNotifier { // Pastikan ada 'with ChangeNotifier'
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Getter untuk mendapatkan User yang sedang login
  User? get currentUser => _auth.currentUser;

  // Register
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
          'role': 'customer',
        });
      }
      notifyListeners(); // Beri tahu listener bahwa status mungkin berubah
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
          notifyListeners(); // Beri tahu listener setelah login berhasil
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

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners(); // Beri tahu listener setelah logout
  }

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