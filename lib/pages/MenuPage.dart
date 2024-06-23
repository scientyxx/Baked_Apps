import 'package:baked/models/order.dart';
import 'package:baked/providers/order_provider.dart';
import 'package:baked/widgets/MenuListWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: MenuPageContent(),
    );
  }
}

class MenuPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
            padding: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MenuListWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItemWidget extends StatefulWidget {
  final FoodItem foodItem;
  final String Function(double) formatCurrency;
  final void Function(FoodItem, int) addToCart;

  MenuItemWidget({
    required this.foodItem,
    required this.formatCurrency,
    required this.addToCart,
  });

  @override
  _MenuItemWidgetState createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<MenuItemWidget> {
  int quantity = 0;

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    if (quantity > 0) {
      setState(() {
        quantity--;
      });
    }
  }

  void _addToOrder(BuildContext context) {
    if (quantity > 0) {
      Order order = Order(
        name: widget.foodItem.name,
        price: widget.foodItem.price,
        imagePath: widget.foodItem.imagePath,
        quantity: quantity,
      );
      Provider.of<OrderProvider>(context, listen: false).addOrder(order);
      setState(() {
        quantity = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                widget.foodItem.imagePath,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.foodItem.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  widget.formatCurrency(widget.foodItem.price),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: _decrementQuantity,
                  color: Theme.of(context).primaryColor,
                ),
                Text(
                  quantity.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _incrementQuantity,
                  color: Theme.of(context).primaryColor,
                ),
                ElevatedButton(
                  onPressed: () => _addToOrder(context),
                  child: Text('Add to Order'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FoodItem {
  final String name;
  final String imagePath;
  final double price;

  FoodItem({
    required this.name,
    required this.imagePath,
    required this.price,
  });
}
