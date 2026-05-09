part of 'cart_cubit.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoaded extends CartState {
  final List<CartItem> items;

  const CartLoaded({required this.items});

  double get total => items.fold(0, (sum, item) => sum + item.totalPrice);

  int get itemCount => items.length;

  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  @override
  List<Object> get props => [items];
}

class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object> get props => [message];
}
