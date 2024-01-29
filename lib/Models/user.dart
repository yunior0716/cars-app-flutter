import 'package:first_app/Models/auth.dart';

class User extends Auth {
  final String name;

  User({
    String id = '',
    required String email,
    required String password,
    required this.name,
  }) : super(
          id: id,
          email: email,
          password: password,
        );

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['name'] = name;
    return data;
  }
}
