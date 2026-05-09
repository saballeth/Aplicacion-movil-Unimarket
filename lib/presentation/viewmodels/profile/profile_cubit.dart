import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimarket/core/injection_container.dart';
import 'package:unimarket/domain/entities/user_role.dart';
import '../../models/user_model.dart';
import '../auth/auth_cubit.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Get the authenticated user from AuthCubit
      final authCubit = sl<AuthCubit>();
      final authUser = authCubit.currentUser;
      
      if (authUser == null) {
        emit(ProfileFailure('Usuario no autenticado'));
        return;
      }
      
      // Create user profile with actual role from authenticated user
      final user = UserModel(
        id: 'USR${authUser.email}',
        name: _getNameForRole(authUser.email, authUser.role),
        email: authUser.email,
        avatarUrl: null,
        role: authUser.role,
      );
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileFailure('No se pudo cargar el perfil'));
    }
  }

  /// Returns display name based on role and email
  String _getNameForRole(String email, UserRole role) {
    switch (email) {
      case 'admin':
        return 'Administrador';
      case 'emp':
        return 'Emprendedor';
      case '1234':
        return 'Universitario';
      default:
        return 'Usuario ${role.displayName}';
    }
  }

  void updateProfile({
    String? name,
    String? email,
    String? avatarUrl,
    UserRole? role,
  }) {
    final current = state;
    if (current is ProfileLoaded) {
      final user = current.user;
      final updated = UserModel(
        id: user.id,
        name: name ?? user.name,
        email: email ?? user.email,
        avatarUrl: avatarUrl ?? user.avatarUrl,
        role: role ?? user.role,
      );
      emit(ProfileLoaded(updated));
    }
  }
}
