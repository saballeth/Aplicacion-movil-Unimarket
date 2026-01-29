import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    await Future.delayed(const Duration(milliseconds: 800));
    if (email.isEmpty || password.isEmpty) {
      emit(LoginFailure('Por favor completa todos los campos'));
      return;
    }
    if (!email.contains('@')) {
      emit(LoginFailure('Correo inválido'));
      return;
    }
    // Aquí iría la lógica real (caso de uso / repositorio)
    emit(LoginSuccess());
  }
}
