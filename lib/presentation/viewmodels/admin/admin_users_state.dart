import 'package:equatable/equatable.dart';

/// Estados para el manejo de usuarios del sistema
abstract class AdminUsersState extends Equatable {
  const AdminUsersState();

  @override
  List<Object?> get props => [];
}

class AdminUsersInitial extends AdminUsersState {
  const AdminUsersInitial();
}

class AdminUsersLoading extends AdminUsersState {
  const AdminUsersLoading();
}

class AdminUsersLoaded extends AdminUsersState {
  final List<AdminUserModel> users;
  final int totalCount;
  final int currentPage;

  const AdminUsersLoaded({
    required this.users,
    required this.totalCount,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [users, totalCount, currentPage];
}

class AdminUserUpdated extends AdminUsersState {
  final AdminUserModel user;

  const AdminUserUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

class AdminUserDeleted extends AdminUsersState {
  final int userId;

  const AdminUserDeleted(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AdminUsersError extends AdminUsersState {
  final String message;

  const AdminUsersError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Modelo de usuario para administración
class AdminUserModel extends Equatable {
  final int id;
  final String name;
  final String email;
  final String role; // 'Consumidor', 'Emprendedor', 'Administrador'
  final String status; // 'Activo', 'Inactivo', 'Suspendido'
  final DateTime joinDate;
  final DateTime? lastActiveDate;
  final int totalOrders;
  final double totalSpent;

  const AdminUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.joinDate,
    this.lastActiveDate,
    required this.totalOrders,
    required this.totalSpent,
  });

  bool get isActive => status == 'Activo';

  AdminUserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    String? status,
    DateTime? joinDate,
    DateTime? lastActiveDate,
    int? totalOrders,
    double? totalSpent,
  }) {
    return AdminUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      joinDate: joinDate ?? this.joinDate,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      totalOrders: totalOrders ?? this.totalOrders,
      totalSpent: totalSpent ?? this.totalSpent,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    role,
    status,
    joinDate,
    lastActiveDate,
    totalOrders,
    totalSpent,
  ];
}
