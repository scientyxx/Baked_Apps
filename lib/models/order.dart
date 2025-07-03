class Order {
  final String name;
  final double price;
  final int quantity;
  final String? imagePath; // Nullable if not always present

  Order({
    required this.name,
    required this.price,
    required this.quantity,
    this.imagePath,
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

  // Tambahkan factory fromJson dan toJson jika Order juga disimpan di Firebase Realtime Database
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      imagePath: json['imagePath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'imagePath': imagePath,
    };
  }
}