import 'package:baked/controllers/order_controller.dart'; // Import OrderController
import 'package:baked/models/order.dart';
import 'package:baked/pages/QrCodePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
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
            child: Consumer<OrderController>( // Gunakan OrderController
              builder: (context, orderController, child) {
                if (orderController.orders.isEmpty) {
                  return Center(
                    child: Text('No orders yet'),
                  );
                }
                return ListView.builder(
                  itemCount: orderController.orders.length,
                  itemBuilder: (context, index) {
                    Order order = orderController.orders[index];
                    return OrderItemWidget(order: order);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Consumer<OrderController>( // Gunakan OrderController
        builder: (context, orderController, child) {
          if (orderController.orders.isNotEmpty) {
            return FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        QrCodePage(orders: orderController.orders),
                  ),
                );
              },
              backgroundColor: Color.fromRGBO(195, 90, 45, 1),
              foregroundColor: Colors.white,
              icon: Icon(Icons.qr_code),
              label: Text('Payment Now'),
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

  OrderItemWidget({required this.order});

  void _incrementQuantity(BuildContext context) {
    Provider.of<OrderController>(context, listen: false) // Gunakan OrderController
        .updateOrderQuantity(order, order.quantity + 1);
  }

  void _decrementQuantity(BuildContext context) {
    // Memanggil updateOrderQuantity, akan menghapus jika kuantitas 0 atau kurang
    Provider.of<OrderController>(context, listen: false).updateOrderQuantity(order, order.quantity - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            order.imagePath != null && order.imagePath!.isNotEmpty
                ? Image.asset(
                    'images/${order.imagePath!}',
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image, size: 50),
                  )
                : Icon(Icons.image, size: 50),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
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
                  icon: Icon(Icons.remove),
                  onPressed: () => _decrementQuantity(context),
                ),
                Text(order.quantity.toString()),
                IconButton(
                  icon: Icon(Icons.add),
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