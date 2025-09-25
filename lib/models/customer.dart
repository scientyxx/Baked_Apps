class Customer {
  final String? id;
  final String email;
  final String password;

  Customer({
    this.id,
    required this.email,
    required this.password,
  });

  // ... copyWith ...
  // ... toJson ...

  factory Customer.fromJson(Map<String, dynamic> json, String id) {
    return Customer(
      id: id,
      email: json['email'],
      password: json['password'],
    );
  }
}