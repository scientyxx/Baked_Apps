class Pembayaran {
  final String? id; // Ubah ke String?
  final DateTime tanggalOrder;
  final String metodeBayar;

  Pembayaran({
    this.id,
    required this.tanggalOrder,
    required this.metodeBayar,
  });

  // ... copyWith ...
  // ... toJson ...

  factory Pembayaran.fromJson(Map<String, dynamic> json, String id) { // <-- TAMBAHKAN 'String id' DI SINI
    return Pembayaran(
      id: id, // <-- GUNAKAN PARAMETER 'id' DARI LUAR
      tanggalOrder: DateTime.parse(json['tanggal_order']),
      metodeBayar: json['metode_bayar'],
    );
  }
}