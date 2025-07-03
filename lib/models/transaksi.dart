

class Transaksi {
  final String? idTransaksi; // ID unik untuk setiap baris transaksi di DB
  final String idOrder; // ID pesanan secara keseluruhan (jika ingin grouping)
  final DateTime tanggalOrder;
  final String idMakanan; // ID produk dari Katalog (Firestore ID)
  final String namaMakanan; // Tambahan untuk kemudahan
  final String? imagePath; // Tambahan untuk kemudahan
  final String idCustomer;
  final double hargaPerItem; // Harga satuan (sesuai diagram 'harga')
  final int jumlahItem; // Kuantitas (sesuai diagram 'total_order')
  final double totalHargaItem; // total_order: int di diagram (saya asumsikan total harga per item)

  Transaksi({
    this.idTransaksi,
    required this.idOrder,
    required this.tanggalOrder,
    required this.idMakanan,
    required this.namaMakanan,
    this.imagePath,
    required this.idCustomer,
    required this.hargaPerItem,
    required this.jumlahItem,
    required this.totalHargaItem,
  });

  // Convert to JSON for Firebase Realtime Database
  Map<String, dynamic> toJson() {
    return {
      'id_order': idOrder,
      'tanggal_order': tanggalOrder.toIso8601String(), // Simpan sebagai string ISO 8601
      'id_makanan': idMakanan,
      'nama_makanan': namaMakanan,
      'image_path': imagePath,
      'id_customer': idCustomer,
      'harga_per_item': hargaPerItem,
      'jumlah_item': jumlahItem,
      'total_harga_item': totalHargaItem,
    };
  }

  // Create from JSON (e.g., when reading from Firebase)
  factory Transaksi.fromJson(Map<String, dynamic> json, String idTransaksi) {
    return Transaksi(
      idTransaksi: idTransaksi,
      idOrder: json['id_order'] as String,
      tanggalOrder: DateTime.parse(json['tanggal_order'] as String),
      idMakanan: json['id_makanan'] as String,
      namaMakanan: json['nama_makanan'] as String,
      imagePath: json['image_path'] as String?,
      idCustomer: json['id_customer'] as String,
      hargaPerItem: (json['harga_per_item'] as num).toDouble(),
      jumlahItem: json['jumlah_item'] as int,
      totalHargaItem: (json['total_harga_item'] as num).toDouble(),
    );
  }
}