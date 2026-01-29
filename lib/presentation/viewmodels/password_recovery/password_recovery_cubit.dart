import 'package:flutter_bloc/flutter_bloc.dart';

import 'password_recovery_state.dart';

class PasswordRecoveryCubit extends Cubit<PasswordRecoveryState> {
  PasswordRecoveryCubit() : super(PasswordRecoveryInitial());

  /// Simula el envío del correo de recuperación
  Future<void> recoverPassword(String email) async {
    if (email.isEmpty) {
      emit(PasswordRecoveryFailure('Por favor ingresa tu correo electrónico'));
      return;
    }

    emit(PasswordRecoveryLoading());

    try {
      // Aquí iría la llamada al caso de uso / repositorio real.
      await Future.delayed(const Duration(seconds: 2));
      emit(PasswordRecoverySuccess(email));
    } catch (e) {
      emit(PasswordRecoveryFailure('Error al enviar el correo. Intenta de nuevo.'));
    }
  }

  /// Resetea el estado al inicial
  void reset() => emit(PasswordRecoveryInitial());
}
