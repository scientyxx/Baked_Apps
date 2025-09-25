// lib/models/transaksi.dart


class Transaksi {
  final String? idTransaksi;
  final String idOrder;
  final DateTime tanggalOrder;
  final String idMakanan;
  final String namaMakanan;
  final String? imagePath;
  final String idCustomer;
  final double hargaPerItem;
  final int jumlahItem;
  final double totalHargaItem;
  final String? idCashier;
  final String? namaCashier;
  final String? shift;

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
    this.idCashier,
    this.namaCashier,
    this.shift,
  });

  Transaksi copyWith({
    String? idTransaksi,
    String? idOrder,
    DateTime? tanggalOrder,
    String? idMakanan,
    String? namaMakanan,
    String? imagePath,
    String? idCustomer,
    double? hargaPerItem,
    int? jumlahItem,
    double? totalHargaItem,
    String? idCashier,
    String? namaCashier,
    String? shift,
  }) {
    return Transaksi(
      idTransaksi: idTransaksi ?? this.idTransaksi,
      idOrder: idOrder ?? this.idOrder,
      tanggalOrder: tanggalOrder ?? this.tanggalOrder,
      idMakanan: idMakanan ?? this.idMakanan,
      namaMakanan: namaMakanan ?? this.namaMakanan,
      imagePath: imagePath ?? this.imagePath,
      idCustomer: idCustomer ?? this.idCustomer,
      hargaPerItem: hargaPerItem ?? this.hargaPerItem,
      jumlahItem: jumlahItem ?? this.jumlahItem,
      totalHargaItem: totalHargaItem ?? this.totalHargaItem,
      idCashier: idCashier ?? this.idCashier,
      namaCashier: namaCashier ?? this.namaCashier,
      shift: shift ?? this.shift,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_order': idOrder,
      'tanggal_order': tanggalOrder.toIso8601String(),
      'id_makanan': idMakanan,
      'nama_makanan': namaMakanan,
      'image_path': imagePath,
      'id_customer': idCustomer,
      'harga_per_item': hargaPerItem,
      'jumlah_item': jumlahItem,
      'total_harga_item': totalHargaItem,
      'id_cashier': idCashier,
      'nama_cashier': namaCashier,
      'shift': shift,
    };
  }

  factory Transaksi.fromJson(Map<String, dynamic> json, String id) {
    return Transaksi(
      idTransaksi: id,
      idOrder: json['id_order'] as String,
      tanggalOrder: DateTime.parse(json['tanggal_order'] as String),
      idMakanan: json['id_makanan'] as String,
      namaMakanan: json['nama_makanan'] as String,
      imagePath: json['image_path'] as String?,
      idCustomer: json['id_customer'] as String,
      hargaPerItem: (json['harga_per_item'] as num).toDouble(),
      jumlahItem: (json['jumlah_item'] as num).toInt(),
      totalHargaItem: (json['total_harga_item'] as num).toDouble(),
      idCashier: json['id_cashier'] as String?,
      namaCashier: json['nama_cashier'] as String?,
      shift: json['shift'] as String?,
    );
  }
}