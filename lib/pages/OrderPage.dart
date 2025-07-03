import 'package:baked/controllers/auth_controller.dart';
import 'package:baked/controllers/menu_controller.dart' as app_menu_controller;
import 'package:baked/controllers/order_controller.dart';
import 'package:baked/models/katalog.dart'; // Pastikan ini diimport
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
                final orderController = Provider.of<OrderController>(context, listen: false);
                final authController = Provider.of<AuthController>(context, listen: false);
                final menuController = Provider.of<app_menu_controller.MenuController>(context, listen: false);

                // Dapatkan customerId dari AuthController
                String? customerId = authController.currentUser?.uid;

                if (customerId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please log in to place an order. (Customer ID is null)')),
                  );
                  return;
                }

                String uniqueOrderId = DateTime.now().millisecondsSinceEpoch.toString();

                for (Order itemInCart in orderProvider.orders) {
                  Katalog? correspondingKatalogItem;
                  try {
                    correspondingKatalogItem = menuController.menuItems
                        .firstWhere((katalogItem) => katalogItem.namaMakanan == itemInCart.name);
                  } catch (e) {
                    print("Could not find corresponding Katalog item for ${itemInCart.name}: $e");
                  }

                  if (correspondingKatalogItem != null && correspondingKatalogItem.id != null) {
                    await orderController.addOrUpdateTransaksiFromOrder(
                      orderItem: itemInCart,
                      idCustomer: customerId,
                      idMakananKatalog: correspondingKatalogItem.id!,
                      idOrderOverall: uniqueOrderId,
                    );
                  } else {
                    print("Warning: Skipping item ${itemInCart.name}. Could not find corresponding Katalog item or item ID is null.");
                  }
                }

                orderProvider.clearCart();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        QrCodePage(orders: []),
                  ),
                );
              },
              backgroundColor: const Color.fromRGBO(195, 90, 45, 1),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.qr_code),
              label: const Text('Payment Now'),
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