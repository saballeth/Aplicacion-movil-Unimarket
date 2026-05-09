import 'package:unimarket/domain/entities/user_role.dart';

class AuthUser {
  final String email;
  final UserRole role;

  AuthUser({
    required this.email,
    this.role = UserRole.consumer,
  });
}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final AuthUser user;
  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}
