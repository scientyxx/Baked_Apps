// lib/models/order.dart (Pastikan fromJson seperti ini)
class Order {
  final String name;
  final double price;
  final int quantity;
  final String? imagePath;

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

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      // PASTIKAN INI MENANGANI NULL DENGAN BAIK
      imagePath: json['imagePath'] as String?, // Membaca sebagai String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'imagePath': imagePath, // Ini akan mengirim null jika imagePath memang null
    };
  }
}