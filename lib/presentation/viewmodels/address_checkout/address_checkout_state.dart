abstract class AddressCheckoutState {}

class AddressCheckoutInitial extends AddressCheckoutState {}

class AddressCheckoutLoading extends AddressCheckoutState {}

class AddressCheckoutLoaded extends AddressCheckoutState {
  final dynamic addresses; // List<AddressEntity>
  final dynamic selectedAddress; // AddressEntity?

  AddressCheckoutLoaded({required this.addresses, this.selectedAddress});
}

class AddressCheckoutError extends AddressCheckoutState {
  final String message;

  AddressCheckoutError(this.message);
}
