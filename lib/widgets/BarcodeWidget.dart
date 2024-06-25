import 'dart:convert';

import 'package:baked/models/order.dart'; // Adjust the import based on your project structure
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

class QrCodePage extends StatelessWidget {
  final List<Order> orders;

  QrCodePage({required this.orders});

  @override
  Widget build(BuildContext context) {
    // Convert the orders list to JSON
    String orderData =
        jsonEncode(orders.map((order) => order.toJson()).toList());

    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code'),
      ),
      body: Center(
        child: BarcodeWidget(
          barcode: Barcode.qrCode(),
          data: orderData,
          width: 300,
          height: 300,
        ),
      ),
    );
  }
}
