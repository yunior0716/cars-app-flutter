class Client {
  final String id;
  final String name;
  final String email;
  final num phone;
  final String address;

  Client({
    this.id = '',
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'] as num,
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }

  @override
  String toString() {
    return 'Client{id: $id, name: $name, email: $email, phone: $phone, address: $address}';
  }
}
