import 'package:flutter/material.dart';

class CoverPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(254, 210, 119, 5),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/logo.png",
            height: 300,
          ),
          // Container(
          //   margin: EdgeInsets.only(top: 50),
          //   child: Text(
          //     "Buy Baked",
          //     style: TextStyle(
          //       color: Colors.black,
          //       fontSize: 35,
          //       fontWeight: FontWeight.w300,
          //     ),
          //   ),
          // ),
          Container(
            margin: EdgeInsets.only(top: 50),
            child: SizedBox(
              height: 50,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, "HomePage");
            },
            child: Ink(
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color.fromRGBO(195, 90, 45, 10),
              ),
              child: Text(
                "Get Startted",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      )),
    );
  }
}
