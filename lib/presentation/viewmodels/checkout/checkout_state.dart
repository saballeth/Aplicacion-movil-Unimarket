abstract class CheckoutState {}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutStep1Addresses extends CheckoutState {
  final dynamic addresses; // List<AddressEntity>
  final dynamic selectedAddress; // AddressEntity?

  CheckoutStep1Addresses({required this.addresses, this.selectedAddress});
}

class CheckoutStep2Shipping extends CheckoutState {
  final dynamic address; // AddressEntity
  final dynamic shippingOptions; // List<ShippingOptionEntity>
  final dynamic selectedShipping; // ShippingOptionEntity?
  final double subtotal;

  CheckoutStep2Shipping({
    required this.address,
    required this.shippingOptions,
    this.selectedShipping,
    required this.subtotal,
  });
}

class CheckoutStep3Payment extends CheckoutState {
  final dynamic address; // AddressEntity
  final dynamic shippingOption; // ShippingOptionEntity
  final double subtotal;
  final double shippingCost;
  final double taxAmount;
  final double totalAmount;

  CheckoutStep3Payment({
    required this.address,
    required this.shippingOption,
    required this.subtotal,
    required this.shippingCost,
    required this.taxAmount,
    required this.totalAmount,
  });
}

class CheckoutProcessing extends CheckoutState {}

class CheckoutSuccess extends CheckoutState {
  final dynamic order; // OrderEntity

  CheckoutSuccess(this.order);
}

class CheckoutError extends CheckoutState {
  final String message;

  CheckoutError(this.message);
}
