// lib/models/transaksi.dart

class Transaksi {
  final String? id; // Ubah ke String?
  final DateTime tanggalOrder;
  final String idMakanan; // Ubah ke String
  final String customerId; // Ubah ke String
  final String kasaOrderId; // Ubah ke String
  final double harga;
  final int quantity;

  Transaksi({
    this.id,
    required this.tanggalOrder,
    required this.idMakanan,
    required this.customerId,
    required this.kasaOrderId,
    required this.harga,
    required this.quantity,
  });

  // ... copyWith ...

  Map<String, dynamic> toJson() { // <--- PASTIKAN METHOD INI ADA
    return {
      'tanggal_order': tanggalOrder.toIso8601String(),
      'id_makanan': idMakanan,
      'customer_id': customerId,
      'kasa_order_id': kasaOrderId,
      'harga': harga,
      'quantity': quantity,
    };
  }

  // ... fromJson ...

  double get subtotal => harga * quantity;
}