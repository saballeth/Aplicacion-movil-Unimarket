abstract class ProductDetailState {}

class ProductDetailInitial extends ProductDetailState {
  final int quantity;
  ProductDetailInitial({this.quantity = 1});
}

class ProductDetailUpdating extends ProductDetailState {
  final int quantity;
  ProductDetailUpdating(this.quantity);
}

class ProductDetailAddToCartSuccess extends ProductDetailState {
  final int quantity;
  ProductDetailAddToCartSuccess(this.quantity);
}

class ProductDetailFailure extends ProductDetailState {
  final String message;
  ProductDetailFailure(this.message);
}
