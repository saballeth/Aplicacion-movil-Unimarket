class AuthUser {
  final String email;
  final String role;
  AuthUser({required this.email, required this.role});
}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final AuthUser user;
  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}
