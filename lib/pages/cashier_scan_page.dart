// lib/pages/cashier_scan_page.dart
import 'dart:convert';

import 'package:baked/controllers/auth_controller.dart';
import 'package:baked/controllers/menu_controller.dart' as app_menu_controller;
import 'package:baked/controllers/order_controller.dart';
import 'package:baked/models/katalog.dart';
import 'package:baked/models/order.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class CashierScanPage extends StatefulWidget {
  const CashierScanPage({Key? key}) : super(key: key);

  @override
  _CashierScanPageState createState() => _CashierScanPageState();
}

class _CashierScanPageState extends State<CashierScanPage> {
  MobileScannerController cameraController = MobileScannerController();
  List<Order> scannedOrders = [];
  bool scanCompleted = false;

  final ValueNotifier<TorchState> _torchState = ValueNotifier(TorchState.off);
  final ValueNotifier<CameraFacing> _cameraFacingState = ValueNotifier(CameraFacing.back);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    cameraController.dispose();
    _torchState.dispose();
    _cameraFacingState.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (scanCompleted) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      String? rawData = barcodes.first.rawValue;
      print('Barcode found! Data: $rawData');

      try {
        List<dynamic> decodedList = jsonDecode(rawData!);
        print('Decoded List: $decodedList');
        if (decodedList.isEmpty) {
          print('Decoded list is empty!');
        } else {
          print('First decoded item: ${decodedList.first}');
        }

        List<Order> tempOrders = decodedList.map((item) => Order.fromJson(item as Map<String, dynamic>)).toList();
        print('Parsed Orders: ${tempOrders.map((o) => o.name).join(', ')}');

        setState(() {
          scannedOrders = tempOrders;
          scanCompleted = true;
        });
        cameraController.stop();
      } catch (e) {
        print('Error decoding QR data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid QR Code data: ${e.toString()}')),
        );
      }
    }
  }

  String _determineShift() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 6 && hour < 14) {
      return 'Pagi';
    } else if (hour >= 14 && hour < 22) {
      return 'Sore';
    } else {
      return 'Malam';
    }
  }

  Future<void> _processPaymentInitiation() async {
    if (scannedOrders.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No orders to process.')),
      );
      return;
    }

    double totalOrderPrice = scannedOrders.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

    String? selectedPaymentMethod = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Select Payment Method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext, 'Cash');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC35A2E),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Cash'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext, 'QRIS');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC35A2E),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('QRIS'),
              ),
            ],
          ),
        );
      },
    );

    if (selectedPaymentMethod != null) {
      final orderController = Provider.of<OrderController>(context, listen: false);
      final authController = Provider.of<AuthController>(context, listen: false);
      final menuController = Provider.of<app_menu_controller.MenuController>(context, listen: false);

      String? cashierId = authController.currentUser?.uid;
      String? cashierName; // <--- Variabel untuk nama kasir

      if (cashierId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cashier not logged in. Please log in.')),
        );
        return;
      }

      // Ambil nama kasir dari Firestore menggunakan AuthController
      Map<String, dynamic>? cashierProfile = await authController.getCashierProfile(cashierId);
      if (cashierProfile != null) {
        cashierName = cashierProfile['name'] as String?; // Asumsi field 'name' ada di profil users
      }
      if (cashierName == null) {
        print("Warning: Cashier name not found for UID: $cashierId. Using UID as name.");
        cashierName = cashierId; // Fallback ke UID jika nama tidak ditemukan
      }

      String currentShift = _determineShift();

      String customerIdFromOrder = scannedOrders.first.customerId ?? 'guest_via_qr';

      String uniqueOrderId = scannedOrders.first.name.replaceAll(RegExp(r'[.#$\[\]/]'), '_') +
                             DateTime.now().millisecondsSinceEpoch.toString();

      try {
        for (Order itemInOrder in scannedOrders) {
          Katalog? correspondingKatalogItem;
          try {
            correspondingKatalogItem = menuController.menuItems
                .firstWhere((katalogItem) => katalogItem.namaMakanan == itemInOrder.name);
          } catch (e) {
            print("Warning: Could not find corresponding Katalog item for ${itemInOrder.name}: $e");
          }

          if (correspondingKatalogItem != null && correspondingKatalogItem.id != null) {
            await orderController.addOrUpdateTransaksiFromOrder(
              orderItem: itemInOrder,
              idCustomer: customerIdFromOrder,
              idMakananKatalog: correspondingKatalogItem.id!,
              idOrderOverall: uniqueOrderId,
              idCashier: cashierId,
              namaCashier: cashierName, // <--- KIRIM NAMA KASIR
              shift: currentShift,
            );
          } else {
            print("Warning: Skipping item ${itemInOrder.name}. Katalog item or ID not found.");
          }
        }

        await orderController.savePayment(
          idOrder: uniqueOrderId,
          metodeBayar: selectedPaymentMethod,
          totalPembayaran: totalOrderPrice,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order ${uniqueOrderId} processed successfully by ${cashierName} (${currentShift} shift) with ${selectedPaymentMethod}!')),
        );

        setState(() {
          scannedOrders = [];
          scanCompleted = false;
        });
        cameraController.start();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to process order: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment method selection cancelled.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code for Payment'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder<TorchState>(
              valueListenable: _torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                  case TorchState.auto:
                    return const Icon(Icons.flash_auto, color: Colors.blue);
                  case TorchState.unavailable:
                    return const Icon(Icons.flash_off, color: Colors.black);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () {
              cameraController.toggleTorch();
              if (_torchState.value == TorchState.on) {
                _torchState.value = TorchState.off;
              } else if (_torchState.value == TorchState.off) {
                _torchState.value = TorchState.on;
              } else if (_torchState.value == TorchState.auto) {
                _torchState.value = TorchState.off;
              }
            },
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder<CameraFacing>(
              valueListenable: _cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () {
              cameraController.switchCamera();
              _cameraFacingState.value = _cameraFacingState.value == CameraFacing.back ? CameraFacing.front : CameraFacing.back;
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: scanCompleted
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_outline, color: Colors.green, size: 100),
                        const SizedBox(height: 16),
                        const Text(
                          'QR Code Scanned!',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total Items: ${scannedOrders.length}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  )
                : MobileScanner(
                    controller: cameraController,
                    onDetect: _onDetect,
                  ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Order Details:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: scannedOrders.isEmpty
                        ? const Center(child: Text('Scan a QR Code to see order details.'))
                        : ListView.builder(
                            itemCount: scannedOrders.length,
                            itemBuilder: (context, index) {
                              final order = scannedOrders[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  leading: order.imagePath != null && order.imagePath!.isNotEmpty
                                      ? Image.asset('images/${order.imagePath!}', width: 40, height: 40, fit: BoxFit.cover)
                                      : const Icon(Icons.image, size: 40),
                                  title: Text(order.name),
                                  subtitle: Text('Qty: ${order.quantity} x Rp ${order.price.toStringAsFixed(0)}'),
                                  trailing: Text('Rp ${(order.price * order.quantity).toStringAsFixed(0)}'),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: scanCompleted ? _processPaymentInitiation : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    child: const Text('Process Payment', style: TextStyle(color: Colors.white)),
                  ),
                  if (scanCompleted)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            scannedOrders = [];
                            scanCompleted = false;
                          });
                          cameraController.start();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child: const Text('Scan New QR', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}