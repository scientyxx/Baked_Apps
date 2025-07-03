import 'package:baked/pages/HomePage%20copy.dart';
import 'package:baked/pages/RegisterPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Register2Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    bool _obscureText = true;

    void registerAndSaveUserData(BuildContext context) async {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          print("User ID: ${user.uid}");
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'name': nameController.text,
            'address': addressController.text,
            // Tambahkan data lainnya sesuai kebutuhan
          });
          print("Data successfully saved to Firestore");
          // Jika berhasil, lanjutkan navigasi ke halaman beranda atau lakukan tindakan sesuai kebutuhan aplikasi Anda.
          Navigator.pushReplacementNamed(context, "homepage");
        } else {
          // Handle error jika user null (meskipun seharusnya tidak terjadi dalam konteks ini)
          print("User is null");
        }
      } catch (e) {
        // Handle error registration here.
        print("Error: $e");
        // Tampilkan pesan kesalahan kepada pengguna jika diperlukan.
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Failed to register. Please try again later."),
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Register2Page(),
    routes: {
      "homepage": (context) => HomePage(),
      "registerpage": (context) => RegisterPage(),
    },
  ));
}
