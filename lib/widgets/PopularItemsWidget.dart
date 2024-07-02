import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PopularItemsWidget extends StatelessWidget {
  final List<FoodItem> foodItems = [
    FoodItem(
      name: "Quiche Lorraine",
      description:
          "Quiche Lorraine is a French tart with a filling made of cream, eggs, and bacon or ham, in an open pastry case.",
      imagePath: "images/best_seller/1.png",
      price: 40000,
    ),
    FoodItem(
      name: "Croissant Sandwich",
      description: "Croissant sandwich with ham, cheese, lettuce, and tomato.",
      imagePath: "images/best_seller/2.png",
      price: 50000,
    ),
    FoodItem(
      name: "Cinnamon Roll",
      description: "Delicious cinnamon roll with icing.",
      imagePath: "images/best_seller/3.png",
      price: 45000,
    ),
    FoodItem(
      name: "Danish Pastry",
      description:
          "Danish pastry with custard filling and a dusting of powdered sugar.",
      imagePath: "images/best_seller/4.png",
      price: 30000,
    ),
  ];

  String formatCurrency(double amount) {
    final formatCurrency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return formatCurrency.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 10, bottom: 10, top: 10, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Our Best Seller",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: foodItems.map((foodItem) {
              return Container(
                margin: EdgeInsets.only(top: 80, right: 15, left: 25),
                width: 320,
                height: 250,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(251, 187, 88, 1),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -height * 0.17,
                      left: width * 0.01,
                      child: Image(
                        height: 280,
                        width: 300,
                        fit: BoxFit.fill,
                        image: AssetImage(
                          foodItem.imagePath,
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 60),
                          Text(
                            formatCurrency(foodItem.price),
                            style: TextStyle(
                              color: Color.fromRGBO(195, 90, 45, 1),
                              fontFamily: 'Baloo Chettan',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            foodItem.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              foodItem.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromRGBO(195, 90, 45, 1),
                                fontFamily: 'Baloo Chettan',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class FoodItem {
  final String name;
  final String description;
  final String imagePath;
  final double price;

  FoodItem({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
  });
}
