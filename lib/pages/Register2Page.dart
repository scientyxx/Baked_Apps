import 'package:baked/controllers/auth_controller.dart'; // Import AuthController
import 'package:baked/pages/HomePage copy.dart'; // Ini mungkin harusnya HomePage.dart
import 'package:baked/pages/RegisterPage.dart';
import 'package:flutter/material.dart';

class Register2Page extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final AuthController _authController = AuthController(); // Inisialisasi AuthController

  @override
  Widget build(BuildContext context) {
    // _obscureText seharusnya di StatefullWidget jika ingin di-toggle

    void registerAndSaveUserData(BuildContext context) async {
      try {
        // Ambil email dan password dari RegisterPage (asumsi disimpan atau diteruskan)
        // Untuk contoh ini, saya asumsikan email dan password didapatkan dari suatu tempat
        // Misalnya, dari route arguments jika diteruskan dari RegisterPage
        final Map<String, String>? args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
        final String? email = args?['email'];
        final String? password = args?['password'];

        if (email == null || password == null) {
          throw Exception('Email or password is missing from previous registration step.');
        }

        await _authController.registerUser(
          email,
          password,
          nameController.text,
          addressController.text,
        );
        print("Data successfully saved to Firestore");
        Navigator.pushReplacementNamed(context, "homepage");
      } catch (e) {
        print("Error: $e");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(e.toString()), // Menampilkan pesan kesalahan dari controller
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, "registerpage");
          },
        ),
        centerTitle: true,
        title: Image.asset(
          "images/logo.png",
          height: 70,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              "Register",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Baloo Chettan',
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromRGBO(195, 90, 45, 10), width: 2.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromRGBO(195, 90, 45, 10), width: 2.0),
                ),
              ),
            ),
            SizedBox(height: 50),
            InkWell(
              onTap: () {
                registerAndSaveUserData(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 1.0,
                height: MediaQuery.of(context).size.height * 0.07,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color.fromRGBO(195, 90, 45, 10),
                  border: Border.all(
                      color: Color.fromRGBO(195, 90, 45, 10), width: 2),
                ),
                child: Center(
                  child: Text(
                    "NEXT",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Main di Register2Page dihapus karena sudah ada di main.dart