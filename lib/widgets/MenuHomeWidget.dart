import 'package:baked/pages/MenuPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MenuHomeWidget extends StatefulWidget {
  @override
  _MenuHomeWidgetState createState() => _MenuHomeWidgetState();
}

class _MenuHomeWidgetState extends State<MenuHomeWidget> {
  final List<FoodItem> foodItems = [
    FoodItem(
      name: "Quiche Lorraine",
      imagePath: "images/1.png",
      price: 40000,
    ),
    FoodItem(
      name: "Croissant Sandwich",
      imagePath: "images/2.png",
      price: 50000,
    ),
    FoodItem(
      name: "Danish Pastry",
      imagePath: "images/3.png",
      price: 45000,
    ),
    FoodItem(
      name: "Cinnamon Roll",
      imagePath: "images/4.png",
      price: 35000,
    ),
    FoodItem(
      name: "Chocolate Cake",
      imagePath: "images/5.png",
      price: 55000,
    ),
    FoodItem(
      name: "Blueberry Muffin",
      imagePath: "images/6.png",
      price: 30000,
    ),
    FoodItem(
      name: "Baguette",
      imagePath: "images/7.png",
      price: 15000,
    ),
    FoodItem(
      name: "Cheesecake",
      imagePath: "images/8.png",
      price: 48000,
    ),
  ];

  Map<String, int> _cartItems = {};
  int _totalCartItems = 0;

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

  void addToCart(FoodItem foodItem, int quantity) {
    if (quantity > 0) {
      setState(() {
        if (_cartItems.containsKey(foodItem.name)) {
          _cartItems[foodItem.name] = _cartItems[foodItem.name]! + quantity;
        } else {
          _cartItems[foodItem.name] = quantity;
        }
        _totalCartItems = getTotalCartItems(); // Update total cart items
      });
    }
  }

  // Metode untuk mendapatkan jumlah total item dalam keranjang
  int getTotalCartItems() {
    int total = 0;
    _cartItems.forEach((key, value) {
      total += value;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Menu List",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigasi ke halaman MenuListWidget tanpa mengganti halaman saat ini
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MenuPageContent(),
                      ),
                    );
                  },
                  child: Text(
                    "See More",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: foodItems.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                return MenuItemWidget(
                  foodItem: foodItems[index],
                  formatCurrency: formatCurrency,
                  addToCart: addToCart,
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
    widget.addToCart(widget.foodItem, 1);
  }

  void _decrementQuantity() {
    if (quantity > 0) {
      setState(() {
        quantity--;
      });
      widget.addToCart(widget.foodItem, -1);
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
