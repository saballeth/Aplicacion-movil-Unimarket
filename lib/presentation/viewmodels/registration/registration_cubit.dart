import 'package:flutter_bloc/flutter_bloc.dart';
import 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit() : super(RegistrationInitial());

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required bool acceptTerms,
  }) async {
    emit(RegistrationLoading());
    await Future.delayed(const Duration(seconds: 1));
    
    // Validaciones
    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      emit(RegistrationFailure('Por favor completa todos los campos'));
      return;
    }

    if (name.length < 3) {
      emit(RegistrationFailure('El nombre debe tener al menos 3 caracteres'));
      return;
    }

    if (!_isValidEmail(email)) {
      emit(RegistrationFailure('Correo inválido'));
      return;
    }

    if (!_isValidPhone(phone)) {
      emit(RegistrationFailure('Teléfono inválido (10 dígitos requeridos)'));
      return;
    }

    if (password.length < 6) {
      emit(RegistrationFailure('La contraseña debe tener al menos 6 caracteres'));
      return;
    }

    if (!_isStrongPassword(password)) {
      emit(RegistrationFailure('La contraseña debe contener letras, números y caracteres especiales'));
      return;
    }

    if (password != confirmPassword) {
      emit(RegistrationFailure('Las contraseñas no coinciden'));
      return;
    }

    if (!acceptTerms) {
      emit(RegistrationFailure('Debes aceptar los términos y condiciones'));
      return;
    }

    emit(RegistrationSuccess());
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\d{10}$');
    return phoneRegex.hasMatch(phone.replaceAll(RegExp(r'\D'), ''));
  }

  bool _isStrongPassword(String password) {
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'\d'));
    return hasUppercase && hasLowercase && hasDigits;
  }
}
