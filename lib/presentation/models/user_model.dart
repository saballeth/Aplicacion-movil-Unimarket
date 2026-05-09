import 'package:unimarket/domain/entities/user_role.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final UserRole role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.role = UserRole.consumer,
  });

  /// Create a copy of UserModel with optional field overrides
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    UserRole? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
    );
  }
}
