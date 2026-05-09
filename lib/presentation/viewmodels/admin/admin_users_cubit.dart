import 'package:flutter_bloc/flutter_bloc.dart';
import 'admin_users_state.dart';

class AdminUsersCubit extends Cubit<AdminUsersState> {
  AdminUsersCubit() : super(const AdminUsersInitial());

  // Sample data - replace with backend API calls
  final List<AdminUserModel> _users = [
    AdminUserModel(
      id: 1,
      name: 'Juan Pérez',
      email: 'juan@email.com',
      role: 'Consumidor',
      status: 'Activo',
      joinDate: DateTime(2024, 1, 10),
      lastActiveDate: DateTime.now(),
      totalOrders: 15,
      totalSpent: 450.00,
    ),
    AdminUserModel(
      id: 2,
      name: 'María García',
      email: 'maria@email.com',
      role: 'Emprendedor',
      status: 'Activo',
      joinDate: DateTime(2024, 2, 5),
      lastActiveDate: DateTime.now().subtract(const Duration(hours: 2)),
      totalOrders: 45,
      totalSpent: 0.00,
    ),
    AdminUserModel(
      id: 3,
      name: 'Carlos López',
      email: 'carlos@email.com',
      role: 'Consumidor',
      status: 'Inactivo',
      joinDate: DateTime(2023, 12, 20),
      lastActiveDate: DateTime.now().subtract(const Duration(days: 30)),
      totalOrders: 3,
      totalSpent: 120.00,
    ),
  ];

  /// Load all users
  void loadUsers({int page = 1, int pageSize = 10}) {
    emit(const AdminUsersLoading());
    try {
      // TODO: Replace with actual API call
      // final response = await adminRepository.getUsers(page, pageSize);
      emit(
        AdminUsersLoaded(
          users: _users,
          totalCount: _users.length,
          currentPage: page,
        ),
      );
    } catch (e) {
      emit(AdminUsersError('Error al cargar usuarios: ${e.toString()}'));
    }
  }

  /// Suspend user
  void suspendUser(int userId) {
    emit(const AdminUsersLoading());
    try {
      // TODO: Replace with actual API call
      final index = _users.indexWhere((user) => user.id == userId);
      if (index != -1) {
        _users[index] = _users[index].copyWith(status: 'Suspendido');
        emit(AdminUserUpdated(_users[index]));
        loadUsers();
      }
    } catch (e) {
      emit(AdminUsersError('Error al suspender usuario: ${e.toString()}'));
    }
  }

  /// Activate user
  void activateUser(int userId) {
    emit(const AdminUsersLoading());
    try {
      // TODO: Replace with actual API call
      final index = _users.indexWhere((user) => user.id == userId);
      if (index != -1) {
        _users[index] = _users[index].copyWith(status: 'Activo');
        emit(AdminUserUpdated(_users[index]));
        loadUsers();
      }
    } catch (e) {
      emit(AdminUsersError('Error al activar usuario: ${e.toString()}'));
    }
  }

  /// Delete user
  void deleteUser(int userId) {
    emit(const AdminUsersLoading());
    try {
      // TODO: Replace with actual API call
      _users.removeWhere((user) => user.id == userId);
      emit(AdminUserDeleted(userId));
      loadUsers();
    } catch (e) {
      emit(AdminUsersError('Error al eliminar usuario: ${e.toString()}'));
    }
  }

  /// Search users by name or email
  void searchUsers(String query) {
    emit(const AdminUsersLoading());
    try {
      final filtered = _users
          .where(
            (user) =>
                user.name.toLowerCase().contains(query.toLowerCase()) ||
                user.email.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
      emit(
        AdminUsersLoaded(
          users: filtered,
          totalCount: filtered.length,
          currentPage: 1,
        ),
      );
    } catch (e) {
      emit(AdminUsersError('Error al buscar usuarios: ${e.toString()}'));
    }
  }

  /// Filter users by role
  void filterByRole(String role) {
    emit(const AdminUsersLoading());
    try {
      final filtered = _users.where((user) => user.role == role).toList();
      emit(
        AdminUsersLoaded(
          users: filtered,
          totalCount: filtered.length,
          currentPage: 1,
        ),
      );
    } catch (e) {
      emit(AdminUsersError('Error al filtrar usuarios: ${e.toString()}'));
    }
  }

  /// Get user statistics
  Map<String, int> getUserStatistics() {
    return {
      'totalUsers': _users.length,
      'activeUsers': _users.where((u) => u.isActive).length,
      'consumers': _users.where((u) => u.role == 'Consumidor').length,
      'entrepreneurs': _users.where((u) => u.role == 'Emprendedor').length,
    };
  }
}
