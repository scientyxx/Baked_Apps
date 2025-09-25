import 'package:baked/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

class Register2Page extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    void registerAndSaveUserData(BuildContext context) async {
      try {
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
        print("Data successfully saved to Firestore and verification email sent.");

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Registrasi Berhasil!"),
              content: Text("Email verifikasi telah dikirim ke $email. Mohon cek inbox Anda (juga folder spam/junk) untuk memverifikasi akun Anda sebelum login."),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, "loginpage");
                  },
                ),
              ],
            );
          },
        );
        // ---------------------------------------------------------------------

      } catch (e) {
        print("Error: $e");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error Registrasi"),
              content: Text(e.toString().replaceFirst('Exception: ', '')),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
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
          icon: const Icon(Icons.arrow_back),
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
            const SizedBox(height: 20),
            const Text(
              "Register",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Baloo Chettan',
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromRGBO(195, 90, 45, 10), width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromRGBO(195, 90, 45, 10), width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 50),
            InkWell(
              onTap: () {
                registerAndSaveUserData(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 1.0,
                height: MediaQuery.of(context).size.height * 0.07,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: const Color.fromRGBO(195, 90, 45, 10),
                  border: Border.all(
                      color: const Color.fromRGBO(195, 90, 45, 10), width: 2),
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