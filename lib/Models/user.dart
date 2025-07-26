import 'package:car_app/Models/auth.dart';

class User extends Auth {
  final String name;
  final List<String> roles;

  User({
    super.id,
    required super.email,
    required super.password,
    required this.name,
    List<String>? roles,
  }) : roles = roles ?? ['user'];

  factory User.fromJson(Map<String, dynamic> json) {
    final rolesFromJson =
        (json['roles'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
            ['user']; // Si viene null, pon ['user'] como valor por defecto

    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      roles: rolesFromJson,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['name'] = name;
    data['roles'] = roles;
    return data;
  }

  bool get isAdmin => roles.contains('admin');

  String get role => roles.isNotEmpty ? roles[0] : 'user';
}
