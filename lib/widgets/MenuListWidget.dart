import 'package:baked/models/order.dart';
import 'package:baked/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MenuListWidget extends StatefulWidget {
  final int limit;

  MenuListWidget({this.limit = 10});

  @override
  _MenuListWidgetState createState() => _MenuListWidgetState();
}

class _MenuListWidgetState extends State<MenuListWidget> {
  final List<FoodItem> foodItems = [
    FoodItem(
      name: "Apple Pie",
      imagePath: "images/1.png",
      price: 40000,
    ),
    FoodItem(
      name: "Fruit Tart",
      imagePath: "images/2.png",
      price: 45000,
    ),
    FoodItem(
      name: "Danish Pastry",
      imagePath: "images/3.png",
      price: 30000,
    ),
    FoodItem(
      name: "Cheese Puff Pastry",
      imagePath: "images/4.png",
      price: 35000,
    ),
    FoodItem(
      name: "Cinnamon Roll",
      imagePath: "images/5.png",
      price: 45000,
    ),
    FoodItem(
      name: "Blueberry Danish",
      imagePath: "images/6.png",
      price: 35000,
    ),
    FoodItem(
      name: "Chicken Puff Isolated",
      imagePath: "images/7.png",
      price: 35000,
    ),
    FoodItem(
      name: "Croissant Sandwich",
      imagePath: "images/8.png",
      price: 50000,
    ),
    FoodItem(
      name: "Quiche Lorraine",
      imagePath: "images/9.png",
      price: 40000,
    ),
    FoodItem(
      name: "Classic Cheesecake",
      imagePath: "images/10.png",
      price: 45000,
    ),
  ];

  String formatCurrency(double amount) {
    try {
      final formatCurrency =
          NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
      return formatCurrency.format(amount);
    } catch (e) {
      print('Error formatting currency: $e');
      return 'Rp 0';
    }
  }

  void updateCart(FoodItem foodItem, int quantity) {
    if (quantity != 0) {
      Order order = Order(
        name: foodItem.name,
        price: foodItem.price.toDouble(),
        quantity: quantity,
        imagePath: foodItem.imagePath,
      );
      if (quantity > 0) {
        Provider.of<OrderProvider>(context, listen: false).addOrder(order);
      } else {
        Provider.of<OrderProvider>(context, listen: false).removeOrder(order);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int displayLimit = widget.limit;
    List<FoodItem> limitedFoodItems = foodItems.take(displayLimit).toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: limitedFoodItems.length, //
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                return MenuItemWidget(
                  foodItem: limitedFoodItems[index],
                  formatCurrency: formatCurrency,
                  updateCart: updateCart,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItemWidget extends StatefulWidget {
  final FoodItem foodItem;
  final String Function(double) formatCurrency;
  final void Function(FoodItem, int) updateCart;

  MenuItemWidget({
    required this.foodItem,
    required this.formatCurrency,
    required this.updateCart,
  });

  @override
  _MenuItemWidgetState createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<MenuItemWidget> {
  int quantity = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    quantity = Provider.of<OrderProvider>(context, listen: false)
        .getOrderQuantity(widget.foodItem.name);
  }

  void _incrementQuantity() {
    setState(() {
      quantity++;
      widget.updateCart(widget.foodItem, quantity);
    });
  }

  void _decrementQuantity() {
    if (quantity > 0) {
      setState(() {
        quantity--;
        widget.updateCart(widget.foodItem, quantity);
      });
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Add to Cart'),
          content:
              Text('Add ${widget.foodItem.name} (Qty: $quantity) to cart?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Add to Cart'),
              onPressed: () {
                widget.updateCart(widget.foodItem, quantity);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
            padding: EdgeInsets.all(2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.foodItem.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 0),
                Text(
                  widget.formatCurrency(
                      widget.foodItem.price * (quantity > 0 ? quantity : 1)),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: _decrementQuantity,
                  color: Color(0xFFC35A2E),
                ),
                Text(
                  quantity.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _incrementQuantity,
                  color: Color(0xFFC35A2E),
                ),
              ],
            ),
          ),
          // Center(
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: ElevatedButton(
          //       onPressed: _showConfirmationDialog,
          //       child: Text('Add to Cart'),
          //     ),
          //   ),
          // ),
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
