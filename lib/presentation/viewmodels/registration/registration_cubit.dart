import 'package:flutter_bloc/flutter_bloc.dart';
import 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit() : super(RegistrationInitial());

  Future<void> register(String name, String email, String password) async {
    emit(RegistrationLoading());
    await Future.delayed(const Duration(seconds: 1));
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      emit(RegistrationFailure('Por favor completa todos los campos'));
      return;
    }
    if (!email.contains('@')) {
      emit(RegistrationFailure('Correo inválido'));
      return;
    }
    emit(RegistrationSuccess());
  }
}
