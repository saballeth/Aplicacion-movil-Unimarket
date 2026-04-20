import 'package:flutter_bloc/flutter_bloc.dart';

import 'password_recovery_state.dart';

class PasswordRecoveryCubit extends Cubit<PasswordRecoveryState> {
  PasswordRecoveryCubit() : super(PasswordRecoveryInitial());

  String? _generatedCode;
  String? _recoveryEmail;
  int _codeAttempts = 0;

  /// Simula el envío del correo de recuperación
  Future<void> recoverPassword(String email) async {
    if (email.isEmpty) {
      emit(PasswordRecoveryFailure('Por favor ingresa tu correo electrónico'));
      return;
    }

    if (!_isValidEmail(email)) {
      emit(PasswordRecoveryFailure('Correo inválido'));
      return;
    }

    emit(PasswordRecoveryLoading());

    try {
      await Future.delayed(const Duration(seconds: 2));
      _generatedCode = _generateCode();
      _recoveryEmail = email;
      _codeAttempts = 0;
      emit(PasswordRecoveryCodeSent(email));
    } catch (e) {
      emit(PasswordRecoveryFailure('Error al enviar el correo. Intenta de nuevo.'));
    }
  }

  /// Verifica el código de recuperación
  Future<void> verifyCode(String code) async {
    if (code.isEmpty) {
      emit(PasswordRecoveryFailure('Por favor ingresa el código'));
      return;
    }

    _codeAttempts++;

    if (_codeAttempts > 3) {
      emit(PasswordRecoveryFailure('Demasiados intentos fallidos. Intenta de nuevo más tarde.'));
      return;
    }

    if (code != _generatedCode) {
      emit(PasswordRecoveryFailure('Código incorrecto. Intenta de nuevo.'));
      return;
    }

    emit(PasswordRecoveryCodeVerified());
  }

  /// Restablece la contraseña
  Future<void> resetPassword(String newPassword, String confirmPassword) async {
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      emit(PasswordRecoveryFailure('Por favor completa todos los campos'));
      return;
    }

    if (newPassword.length < 6) {
      emit(PasswordRecoveryFailure('La contraseña debe tener al menos 6 caracteres'));
      return;
    }

    if (!_isStrongPassword(newPassword)) {
      emit(PasswordRecoveryFailure('La contraseña debe contener letras, números y caracteres especiales'));
      return;
    }

    if (newPassword != confirmPassword) {
      emit(PasswordRecoveryFailure('Las contraseñas no coinciden'));
      return;
    }

    emit(PasswordRecoveryLoading());

    try {
      await Future.delayed(const Duration(seconds: 2));
      _generatedCode = null;
      _recoveryEmail = null;
      emit(PasswordRecoverySuccess(_recoveryEmail ?? ''));
    } catch (e) {
      emit(PasswordRecoveryFailure('Error al restablecer la contraseña. Intenta de nuevo.'));
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool _isStrongPassword(String password) {
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'\d'));
    return hasUppercase && hasLowercase && hasDigits;
  }

  String _generateCode() {
    return (100000 + (DateTime.now().millisecondsSinceEpoch % 900000)).toString();
  }

  /// Resetea el estado al inicial
  void reset() => emit(PasswordRecoveryInitial());
}
