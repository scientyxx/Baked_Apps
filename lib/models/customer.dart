class Customer {
  final String? id; // Ubah ke String?
  final String email;
  final String password;

  Customer({
    this.id,
    required this.email,
    required this.password,
  });

  // ... copyWith ...
  // ... toJson ...

  factory Customer.fromJson(Map<String, dynamic> json, String id) { // <-- TAMBAHKAN 'String id' DI SINI
    return Customer(
      id: id, // <-- GUNAKAN PARAMETER 'id' DARI LUAR
      email: json['email'],
      password: json['password'],
    );
  }
}