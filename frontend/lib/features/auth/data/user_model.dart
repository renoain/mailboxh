// Model JSON profil user dari endpoint auth.

import '../domain/auth_models.dart';

/// Representasi objek `user` pada respons register, login, dan `/api/me`.
class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        role: json['role'] as String? ?? 'user',
      );

  final int id;
  final String name;
  final String email;
  final String role;

  AuthUser toEntity() =>
      AuthUser(id: id, name: name, email: email, role: role);
}
