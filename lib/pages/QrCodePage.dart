import 'dart:convert';

import 'package:baked/models/order.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

class QrCodePage extends StatelessWidget {
  final List<Order> orders;

  QrCodePage({required this.orders});

  @override
  Widget build(BuildContext context) {
    String orderData =
        jsonEncode(orders.map((order) => order.toJson()).toList());

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "images/logo.png",
          height: 60,
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Tunjukkan QR Code Ke Kasir",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Center(
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: orderData,
                  width: 300,
                  height: 300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
