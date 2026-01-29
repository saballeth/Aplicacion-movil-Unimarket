abstract class PasswordRecoveryState {}

class PasswordRecoveryInitial extends PasswordRecoveryState {}

class PasswordRecoveryLoading extends PasswordRecoveryState {}

class PasswordRecoverySuccess extends PasswordRecoveryState {
  final String email;
  PasswordRecoverySuccess(this.email);
}

class PasswordRecoveryFailure extends PasswordRecoveryState {
  final String message;
  PasswordRecoveryFailure(this.message);
}
