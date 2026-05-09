import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimarket/domain/entities/user_role.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  /// Mock: in a real app validate against backend.
  /// Test credentials:
  /// - Consumer: 1234 / 1234
  /// - Entrepreneur: emp / emp
  /// - Admin: admin / admin
  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Determine role based on credentials
    UserRole role;
    
    if (email == '1234' && password == '1234') {
      role = UserRole.consumer;
    } else if (email == 'emp' && password == 'emp') {
      role = UserRole.entrepreneur;
    } else if (email == 'admin' && password == 'admin') {
      role = UserRole.admin;
    } else {
      emit(Unauthenticated());
      return;
    }

    emit(Authenticated(AuthUser(email: email, role: role)));
  }

  void logout() => emit(Unauthenticated());

  bool isAuthenticated() => state is Authenticated;

  AuthUser? get currentUser => state is Authenticated ? (state as Authenticated).user : null;
}
