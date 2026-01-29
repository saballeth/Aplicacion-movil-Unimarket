import 'package:flutter_bloc/flutter_bloc.dart';
import 'email_confirmation_state.dart';

class EmailConfirmationCubit extends Cubit<EmailConfirmationState> {
  EmailConfirmationCubit() : super(EmailConfirmationInitial());

  Future<void> resendEmail(String email) async {
    if (email.isEmpty) {
      emit(EmailConfirmationFailure('Correo vacío'));
      return;
    }
    emit(EmailConfirmationLoading());
    try {
      // Simular envío
      await Future.delayed(const Duration(seconds: 2));
      emit(EmailConfirmationResent('Correo reenviado a $email'));
    } catch (e) {
      emit(EmailConfirmationFailure('Error al reenviar el correo'));
    }
  }

  void reset() => emit(EmailConfirmationInitial());
}
