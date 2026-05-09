import 'package:flutter_bloc/flutter_bloc.dart';
import 'payment_methods_state.dart';

class PaymentMethodsCubit extends Cubit<PaymentMethodsState> {
  PaymentMethodsCubit() : super(const PaymentMethodsInitial());

  // Sample data - replace with backend API calls
  final List<PaymentMethodModel> _methods = [
    PaymentMethodModel(
      id: 1,
      type: 'credit_card',
      lastDigits: '4242',
      issuer: 'Visa',
      isDefault: true,
      expiryDate: '12/25',
      holderName: 'Juan Pérez',
      createdAt: DateTime.now(),
    ),
    PaymentMethodModel(
      id: 2,
      type: 'credit_card',
      lastDigits: '5555',
      issuer: 'MasterCard',
      isDefault: false,
      expiryDate: '08/26',
      holderName: 'Juan Pérez',
      createdAt: DateTime.now(),
    ),
  ];

  /// Load all payment methods
  void loadPaymentMethods() {
    emit(const PaymentMethodsLoading());
    try {
      // TODO: Replace with actual API call
      // final methods = await paymentRepository.getPaymentMethods();
      final defaultMethod = _methods.firstWhere(
        (method) => method.isDefault,
        orElse: () => _methods.isNotEmpty
            ? _methods.first
            : PaymentMethodModel(
                id: 0,
                type: '',
                lastDigits: '',
                issuer: '',
                isDefault: false,
                expiryDate: '',
                holderName: '',
                createdAt: DateTime.now(),
              ),
      );
      emit(
        PaymentMethodsLoaded(methods: _methods, defaultMethod: defaultMethod),
      );
    } catch (e) {
      emit(
        PaymentMethodsError('Error al cargar métodos de pago: ${e.toString()}'),
      );
    }
  }

  /// Add new payment method
  void addPaymentMethod({
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String holderName,
  }) {
    emit(const PaymentMethodsLoading());
    try {
      // TODO: Replace with actual API call
      // Validate card number
      if (cardNumber.length < 13) {
        throw Exception('Número de tarjeta inválido');
      }

      final lastDigits = cardNumber.substring(cardNumber.length - 4);
      final newMethod = PaymentMethodModel(
        id: _methods.length + 1,
        type: 'credit_card',
        lastDigits: lastDigits,
        issuer: _getCardIssuer(cardNumber),
        isDefault: _methods.isEmpty,
        expiryDate: expiryDate,
        holderName: holderName,
        createdAt: DateTime.now(),
      );
      _methods.add(newMethod);
      emit(PaymentMethodAdded(newMethod));
      loadPaymentMethods();
    } catch (e) {
      emit(
        PaymentMethodsError('Error al agregar método de pago: ${e.toString()}'),
      );
    }
  }

  /// Delete payment method
  void deletePaymentMethod(int id) {
    emit(const PaymentMethodsLoading());
    try {
      // TODO: Replace with actual API call
      _methods.removeWhere((method) => method.id == id);
      emit(PaymentMethodDeleted(id));
      loadPaymentMethods();
    } catch (e) {
      emit(
        PaymentMethodsError(
          'Error al eliminar método de pago: ${e.toString()}',
        ),
      );
    }
  }

  /// Set default payment method
  void setDefaultPaymentMethod(int id) {
    emit(const PaymentMethodsLoading());
    try {
      // TODO: Replace with actual API call
      for (var method in _methods) {
        if (method.id == id) {
          final index = _methods.indexOf(method);
          _methods[index] = method.copyWith(isDefault: true);
        } else {
          final index = _methods.indexOf(method);
          _methods[index] = method.copyWith(isDefault: false);
        }
      }
      loadPaymentMethods();
    } catch (e) {
      emit(
        PaymentMethodsError(
          'Error al establecer método predeterminado: ${e.toString()}',
        ),
      );
    }
  }

  /// Get card issuer based on card number
  String _getCardIssuer(String cardNumber) {
    if (cardNumber.startsWith('4')) {
      return 'Visa';
    } else if (cardNumber.startsWith('5')) {
      return 'MasterCard';
    } else if (cardNumber.startsWith('3')) {
      return 'Amex';
    }
    return 'Otro';
  }
}
