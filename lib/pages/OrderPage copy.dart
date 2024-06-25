import 'package:baked/models/order.dart';
import 'package:baked/pages/QrCodePage.dart';
import 'package:baked/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
        actions: [
          Consumer<OrderProvider>(
            builder: (context, orderProvider, child) {
              if (orderProvider.orders.isNotEmpty) {
                return IconButton(
                  icon: Icon(Icons.qr_code),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QrCodePage(orders: orderProvider.orders),
                      ),
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.orders.isEmpty) {
            return Center(
              child: Text('No orders yet'),
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
    );
  }
}

class OrderItemWidget extends StatelessWidget {
  final Order order;

  OrderItemWidget({required this.order});

  void _incrementQuantity(BuildContext context) {
    Provider.of<OrderProvider>(context, listen: false)
        .updateOrderQuantity(order, order.quantity + 1);
  }

  void _decrementQuantity(BuildContext context) {
    if (order.quantity > 1) {
      Provider.of<OrderProvider>(context, listen: false)
          .updateOrderQuantity(order, order.quantity - 1);
    } else {
      Provider.of<OrderProvider>(context, listen: false).removeOrder(order);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            // Uncomment this line if you have images in your assets
            // Image.asset(
            //   order.imagePath,
            //   height: 50,
            //   width: 50,
            //   fit: BoxFit.cover,
            // ),
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
