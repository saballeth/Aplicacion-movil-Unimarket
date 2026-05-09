import 'package:equatable/equatable.dart';

/// Estados para el manejo de métodos de pago
abstract class PaymentMethodsState extends Equatable {
  const PaymentMethodsState();

  @override
  List<Object?> get props => [];
}

class PaymentMethodsInitial extends PaymentMethodsState {
  const PaymentMethodsInitial();
}

class PaymentMethodsLoading extends PaymentMethodsState {
  const PaymentMethodsLoading();
}

class PaymentMethodsLoaded extends PaymentMethodsState {
  final List<PaymentMethodModel> methods;
  final PaymentMethodModel? defaultMethod;

  const PaymentMethodsLoaded({required this.methods, this.defaultMethod});

  @override
  List<Object?> get props => [methods, defaultMethod];
}

class PaymentMethodAdded extends PaymentMethodsState {
  final PaymentMethodModel method;

  const PaymentMethodAdded(this.method);

  @override
  List<Object?> get props => [method];
}

class PaymentMethodDeleted extends PaymentMethodsState {
  final int methodId;

  const PaymentMethodDeleted(this.methodId);

  @override
  List<Object?> get props => [methodId];
}

class PaymentMethodsError extends PaymentMethodsState {
  final String message;

  const PaymentMethodsError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Modelo de método de pago
class PaymentMethodModel extends Equatable {
  final int id;
  final String type; // 'credit_card', 'debit_card', 'digital_wallet'
  final String lastDigits;
  final String issuer; // 'Visa', 'MasterCard', 'Amex'
  final bool isDefault;
  final String expiryDate; // 'MM/YY'
  final String holderName;
  final DateTime createdAt;

  const PaymentMethodModel({
    required this.id,
    required this.type,
    required this.lastDigits,
    required this.issuer,
    required this.isDefault,
    required this.expiryDate,
    required this.holderName,
    required this.createdAt,
  });

  PaymentMethodModel copyWith({
    int? id,
    String? type,
    String? lastDigits,
    String? issuer,
    bool? isDefault,
    String? expiryDate,
    String? holderName,
    DateTime? createdAt,
  }) {
    return PaymentMethodModel(
      id: id ?? this.id,
      type: type ?? this.type,
      lastDigits: lastDigits ?? this.lastDigits,
      issuer: issuer ?? this.issuer,
      isDefault: isDefault ?? this.isDefault,
      expiryDate: expiryDate ?? this.expiryDate,
      holderName: holderName ?? this.holderName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    lastDigits,
    issuer,
    isDefault,
    expiryDate,
    holderName,
    createdAt,
  ];
}
