import 'package:equatable/equatable.dart';

/// Modelo de Usuario para la Base de Datos
class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String roleId;
  final String? profilePicUrl;
  final bool emailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLogin;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.roleId,
    this.profilePicUrl,
    this.emailVerified = false,
    required this.createdAt,
    required this.updatedAt,
    this.lastLogin,
  });

  // Convertir JSON a Modelo
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      roleId: json['role_id'] ?? '',
      profilePicUrl: json['profile_pic_url'],
      emailVerified: json['email_verified'] ?? false,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'])
          : null,
    );
  }

  // Convertir Modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'role_id': roleId,
      'profile_pic_url': profilePicUrl,
      'email_verified': emailVerified,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? roleId,
    String? profilePicUrl,
    bool? emailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLogin,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      roleId: roleId ?? this.roleId,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    phone,
    roleId,
    profilePicUrl,
    emailVerified,
    createdAt,
    updatedAt,
    lastLogin,
  ];
}
