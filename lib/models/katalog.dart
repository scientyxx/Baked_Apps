class Katalog {
  final String? id;
  final String namaMakanan;
  final String deskripsi;
  final String kategori;
  final double harga;
  final DateTime tanggalKadaluarsa;
  final int stock;
  final String? imagePath;

  Katalog({
    this.id,
    required this.namaMakanan,
    required this.deskripsi,
    required this.kategori,
    required this.harga,
    required this.tanggalKadaluarsa,
    required this.stock,
    this.imagePath,
  });

  Katalog copyWith({
    String? id,
    String? namaMakanan,
    String? deskripsi,
    String? kategori,
    double? harga,
    DateTime? tanggalKadaluarsa,
    int? stock,
    String? imagePath,
  }) {
    return Katalog(
      id: id ?? this.id,
      namaMakanan: namaMakanan ?? this.namaMakanan,
      deskripsi: deskripsi ?? this.deskripsi,
      kategori: kategori ?? this.kategori,
      harga: harga ?? this.harga,
      tanggalKadaluarsa: tanggalKadaluarsa ?? this.tanggalKadaluarsa,
      stock: stock ?? this.stock,
      imagePath: imagePath ?? this.imagePath, // Perbarui
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_makanan': namaMakanan,
      'deskripsi': deskripsi,
      'kategori': kategori,
      'harga': harga,
      'tanggal_kadaluarsa': tanggalKadaluarsa.toIso8601String(),
      'stock': stock,
    };
  }

  factory Katalog.fromJson(Map<String, dynamic> json, String id) {
    return Katalog(
      id: id,
      namaMakanan: json['nama_makanan'],
      deskripsi: json['deskripsi'],
      kategori: json['kategori'],
      harga: json['harga'].toDouble(),
      tanggalKadaluarsa: DateTime.parse(json['tanggal_kadaluarsa']),
      stock: json['stock'],
      imagePath: json['image_path'],
    );
  }
}