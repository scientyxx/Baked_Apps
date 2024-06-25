class Order {
  final String name;
  final double price;
  final int quantity;
  final String imagePath;

  Order({
    required this.name,
    required this.price,
    required this.quantity,
    required this.imagePath,
  });

  // Create a copy of the Order object with updated fields
  Order copyWith({
    String? name,
    double? price,
    int? quantity,
    String? imagePath,
  }) {
    return Order(
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  // Convert the Order object to a map that can be converted to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      // 'imagePath': imagePath,
    };
  }

  // Deserialize JSON to an Order object
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
      imagePath: json['imagePath'],
    );
  }
}
