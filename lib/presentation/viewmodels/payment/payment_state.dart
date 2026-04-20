part of 'payment_cubit.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentMethodSelected extends PaymentState {
  final PaymentMethod method;
  PaymentMethodSelected(this.method);
}

class PaymentProcessing extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final String transactionId;
  PaymentSuccess(this.transactionId);
}

class PaymentFailure extends PaymentState {
  final String message;
  PaymentFailure(this.message);
}
