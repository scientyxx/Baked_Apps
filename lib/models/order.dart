// lib/models/order.dart
class Order {
  final String name;
  final double price;
  final int quantity;
  final String? imagePath;
  final String? customerId; // <--- TAMBAHKAN INI

  Order({
    required this.name,
    required this.price,
    required this.quantity,
    this.imagePath,
    this.customerId, // <--- INISIALISASI
  });

  Order copyWith({
    String? name,
    double? price,
    int? quantity,
    String? imagePath,
    String? customerId, // <--- TAMBAHKAN INI
  }) {
    return Order(
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imagePath: imagePath ?? this.imagePath,
      customerId: customerId ?? this.customerId, // <--- PERBARUI INI
    );
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      imagePath: json['imagePath'] as String?,
      customerId: json['customerId'] as String?, // <--- BACA DARI JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'imagePath': imagePath,
      'customerId': customerId, // <--- SERTAKAN DI JSON
    };
  }
}