class Kasir {
  final String? id;
  final String nama;
  final String email;
  final String password;
  final String? shiftType;

  Kasir({
    this.id,
    required this.nama,
    required this.email,
    required this.password,
    this.shiftType,
  });

  // ... copyWith ...
  // ... toJson ...

  factory Kasir.fromJson(Map<String, dynamic> json, String id) {
    return Kasir(
      id: id,
      nama: json['nama'],
      email: json['email'],
      password: json['password'],
      shiftType: json['shift_type'],
    );
  }
}
