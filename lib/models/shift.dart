class Shift {
  final String? id;
  final String namaShift; // Contoh: "Shift Pagi", "Shift Sore"
  final String waktuMulai;
  final String waktuSelesai;
  final String shiftType; // <--- TAMBAH FIELD INI

  Shift({
    this.id,
    required this.namaShift,
    required this.waktuMulai,
    required this.waktuSelesai,
    required this.shiftType, // <--- TAMBAH DI CONSTRUCTOR
  });

  Shift copyWith({
    String? id,
    String? namaShift,
    String? waktuMulai,
    String? waktuSelesai,
    String? shiftType, // <--- TAMBAH DI copyWith
  }) {
    return Shift(
      id: id ?? this.id,
      namaShift: namaShift ?? this.namaShift,
      waktuMulai: waktuMulai ?? this.waktuMulai,
      waktuSelesai: waktuSelesai ?? this.waktuSelesai,
      shiftType: shiftType ?? this.shiftType, // <--- TAMBAH DI copyWith
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_shift': namaShift,
      'waktu_mulai': waktuMulai,
      'waktu_selesai': waktuSelesai,
      'shift_type': shiftType, // <--- TAMBAH DI toJson
    };
  }

  factory Shift.fromJson(Map<String, dynamic> json, String id) {
    return Shift(
      id: id,
      namaShift: json['nama_shift'],
      waktuMulai: json['waktu_mulai'],
      waktuSelesai: json['waktu_selesai'],
      shiftType: json['shift_type'], // <--- TAMBAH DI fromJson
    );
  }
}