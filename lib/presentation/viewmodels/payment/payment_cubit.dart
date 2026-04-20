import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/payment_model.dart';
part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  PaymentMethod? _selectedMethod;

  PaymentMethod? get selectedMethod => _selectedMethod;

  Future<void> selectPaymentMethod(PaymentMethod method) async {
    emit(PaymentMethodSelected(method));
    _selectedMethod = method;
  }

  Future<void> processPayment({
    required PaymentMethod method,
    required double amount,
    Map<String, dynamic>? paymentDetails,
  }) async {
    emit(PaymentProcessing());
    try {
      // Simulated payment processing
      await Future.delayed(const Duration(seconds: 2));

      // Mock validation
      if ((method.type == PaymentType.creditCard || method.type == PaymentType.debitCard) && paymentDetails != null) {
        final cardNumber = paymentDetails['cardNumber'] as String? ?? '';
        if (cardNumber.length < 13) {
          emit(PaymentFailure('Número de tarjeta inválido'));
          return;
        }
      }

      final transactionId = 'TXN${DateTime.now().millisecondsSinceEpoch}';
      emit(PaymentSuccess(transactionId));
    } catch (e) {
      emit(PaymentFailure('Error procesando el pago: $e'));
    }
  }

  void reset() {
    _selectedMethod = null;
    emit(PaymentInitial());
  }
}
