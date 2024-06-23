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
}
