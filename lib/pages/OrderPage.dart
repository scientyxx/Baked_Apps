import 'package:baked/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          return ListView.builder(
            itemCount: orderProvider.orders.length,
            itemBuilder: (context, index) {
              final order = orderProvider.orders[index];
              return ListTile(
                title: Text(order.name),
                subtitle: Text('Quantity: ${order.quantity}'),
                trailing: Text('Rp ${order.price * order.quantity}'),
              );
            },
          );
        },
      ),
    );
  }
}
