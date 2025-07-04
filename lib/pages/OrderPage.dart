import 'package:baked/controllers/auth_controller.dart'; // Pastikan ini diimport
import 'package:baked/models/order.dart';
import 'package:baked/pages/QrCodePage.dart';
import 'package:baked/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 20, left: 15, top: 10),
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
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Order",
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<OrderProvider>(
              builder: (context, orderProvider, child) {
                if (orderProvider.orders.isEmpty) {
                  return const Center(
                    child: Text('No items in your cart.'),
                  );
                }
                return ListView.builder(
                  itemCount: orderProvider.orders.length,
                  itemBuilder: (context, index) {
                    Order order = orderProvider.orders[index];
                    return OrderItemWidget(order: order);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.orders.isNotEmpty) {
            return FloatingActionButton.extended(
              onPressed: () async {
                // --- PERBAIKI: Dapatkan authController di sini ---
                final authController = Provider.of<AuthController>(context, listen: false);
                // --------------------------------------------------

                String? customerIdForQr = authController.currentUser?.uid; // ID pelanggan yang login
                if (customerIdForQr == null) {
                  customerIdForQr = 'guest_user'; // Atau ID guest yang lebih unik
                }

                final List<Order> ordersForQr = orderProvider.orders.map((order) {
                  return order.copyWith(customerId: customerIdForQr); // Tambahkan customerId ke setiap order
                }).toList();

                orderProvider.clearCart();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QrCodePage(orders: ordersForQr), // Teruskan order dengan customerId
                  ),
                );
              },
              backgroundColor: const Color.fromRGBO(195, 90, 45, 1),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.qr_code),
              label: const Text('Generate QR Code'),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class OrderItemWidget extends StatelessWidget {
  final Order order;

  const OrderItemWidget({Key? key, required this.order}) : super(key: key);

  void _incrementQuantity(BuildContext context) {
    Provider.of<OrderProvider>(context, listen: false)
        .updateOrderQuantity(order, order.quantity + 1);
  }

  void _decrementQuantity(BuildContext context) {
    Provider.of<OrderProvider>(context, listen: false).updateOrderQuantity(order, order.quantity - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            order.imagePath != null && order.imagePath!.isNotEmpty
                ? Image.asset(
                    'images/${order.imagePath!}',
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 50),
                  )
                : const Icon(Icons.image, size: 50),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Rp ${(order.price * order.quantity).toStringAsFixed(0)}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => _decrementQuantity(context),
                ),
                Text(order.quantity.toString()),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _incrementQuantity(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}