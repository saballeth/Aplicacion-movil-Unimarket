abstract class ShippingState {}

class ShippingInitial extends ShippingState {}

class ShippingLoading extends ShippingState {}

class ShippingLoaded extends ShippingState {
  final dynamic shippingOptions; // List<ShippingOptionEntity>
  final dynamic selectedShipping; // ShippingOptionEntity?

  ShippingLoaded({required this.shippingOptions, this.selectedShipping});
}

class ShippingError extends ShippingState {
  final String message;

  ShippingError(this.message);
}
