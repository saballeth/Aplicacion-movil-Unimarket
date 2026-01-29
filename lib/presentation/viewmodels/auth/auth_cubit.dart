import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  /// Mock: in a real app validate against backend.
  /// For testing, only accept the explicit test account below.
  /// Test credentials: probar@unimarket.test / password123
  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    const testEmail = 'probar@unimarket.test';
    const testPassword = 'password123';

    if (email == testEmail && password == testPassword) {
      emit(Authenticated(AuthUser(email: email, role: 'standard')));
      return;
    }

    // Otherwise unauthenticated
    emit(Unauthenticated());
  }

  void logout() => emit(Unauthenticated());

  bool isAuthenticated() => state is Authenticated;

  AuthUser? get currentUser => state is Authenticated ? (state as Authenticated).user : null;
}
