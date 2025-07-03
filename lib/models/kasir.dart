class Kasir {
  final String? id; // Ubah ke String?
  final String nama;
  final String email;
  final String password;
  final String? shiftType; // Sudah ada

  Kasir({
    this.id,
    required this.nama,
    required this.email,
    required this.password,
    this.shiftType,
  });

  // ... copyWith ...
  // ... toJson ...

  factory Kasir.fromJson(Map<String, dynamic> json, String id) { // <-- TAMBAHKAN 'String id' DI SINI
    return Kasir(
      id: id, // <-- GUNAKAN PARAMETER 'id' DARI LUAR
      nama: json['nama'],
      email: json['email'],
      password: json['password'],
      shiftType: json['shift_type'],
    );
  }
}