import 'package:flutter/material.dart';

class ContinuePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            centerTitle: true,
            title: Image.asset(
              "images/logo.png",
              height: 70,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                "images/27.png",
                height: 320,
              ),
              Text(
                "Smooth Payments,\nSweet Treats!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Baloo Chettan',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Indulge Yourself in Luxurious Treats \nwith Effortless Payment.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 13,
                  color: Color.fromRGBO(172, 179, 191, 1),
                ),
              ),
              SizedBox(height: 50),
              InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(context, "startingpage");
                },
                child: Container(
                  width: 300,
                  height: 50,
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(context, "startingpage");
                },
                child: Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color.fromRGBO(195, 90, 45, 10),
                    border: Border.all(
                        color: Color.fromRGBO(195, 90, 45, 10), width: 2),
                  ),
                  child: Center(
                    child: Text(
                      "SIGN IN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(ContinuePage());
}
