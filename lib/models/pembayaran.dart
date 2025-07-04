// lib/models/pembayaran.dart


class Pembayaran {
  final String? id; // Ubah ke String?
  final String idOrder; // Tambahkan idOrder untuk menghubungkan ke Transaksi
  final DateTime tanggalPembayaran; // Ubah nama field agar lebih spesifik
  final String metodeBayar;
  final double totalPembayaran; // Tambahkan total pembayaran

  Pembayaran({
    this.id,
    required this.idOrder,
    required this.tanggalPembayaran,
    required this.metodeBayar,
    required this.totalPembayaran,
  });

  // Metode copyWith untuk membuat instance baru dengan perubahan tertentu
  Pembayaran copyWith({
    String? id,
    String? idOrder,
    DateTime? tanggalPembayaran,
    String? metodeBayar,
    double? totalPembayaran,
  }) {
    return Pembayaran(
      id: id ?? this.id,
      idOrder: idOrder ?? this.idOrder,
      tanggalPembayaran: tanggalPembayaran ?? this.tanggalPembayaran,
      metodeBayar: metodeBayar ?? this.metodeBayar,
      totalPembayaran: totalPembayaran ?? this.totalPembayaran,
    );
  }

  // Metode toJson untuk mengonversi objek ke Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {
      'id_order': idOrder,
      'tanggal_pembayaran': tanggalPembayaran.toIso8601String(), // Simpan sebagai string ISO 8601
      'metode_bayar': metodeBayar,
      'total_pembayaran': totalPembayaran,
    };
  }

  // Factory constructor untuk membuat objek dari JSON (dari Firebase)
  factory Pembayaran.fromJson(Map<String, dynamic> json, String id) {
    return Pembayaran(
      id: id,
      idOrder: json['id_order'] as String,
      tanggalPembayaran: DateTime.parse(json['tanggal_pembayaran'] as String),
      metodeBayar: json['metode_bayar'] as String,
      totalPembayaran: (json['total_pembayaran'] as num).toDouble(), // Pastikan double
    );
  }
}