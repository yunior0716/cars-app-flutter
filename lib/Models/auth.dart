class Auth {
  final String id;
  final String email;
  final String password;

  Auth({
    this.id = '',
    required this.email,
    required this.password,
  });

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      id: json['_id'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
