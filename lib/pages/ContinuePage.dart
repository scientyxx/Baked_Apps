import 'package:flutter/material.dart';

class ContinuePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(right: 20, left: 15, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/logo.png",
                    height: 100,
                  ),
                ],
              ),
            ),
            Image.asset(
              "images/27.png",
              height: MediaQuery.of(context).size.width * 0.75,
            ),
            Text(
              "Smooth Payments, \nSweet Treats!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Baloo Chettan',
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Indulge Yourself in Luxurious Treats \nwith Effortless Payment.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: MediaQuery.of(context).size.width * 0.03,
                color: Color.fromRGBO(172, 179, 191, 1),
              ),
            ),
            SizedBox(height: 50),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, "registerpage");
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Center(
                  child: Text(
                    "REGISTER",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, "loginpage");
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color.fromRGBO(195, 90, 45, 1),
                  border: Border.all(
                    color: Color.fromRGBO(195, 90, 45, 1),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    "SIGN IN",
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

void main() {
  runApp(MaterialApp(
    home: ContinuePage(),
  ));
}
