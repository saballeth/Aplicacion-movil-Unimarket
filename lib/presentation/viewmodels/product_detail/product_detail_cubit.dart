import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimarket/domain/entities/product_entity.dart';
import 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit() : super(ProductDetailInitial());

  void setQuantity(int q) {
    if (q < 1) q = 1;
    emit(ProductDetailUpdating(q));
    emit(ProductDetailInitial(quantity: q));
  }

  void increment() {
    final current = (state is ProductDetailInitial) ? (state as ProductDetailInitial).quantity : 1;
    setQuantity(current + 1);
  }

  void decrement() {
    final current = (state is ProductDetailInitial) ? (state as ProductDetailInitial).quantity : 1;
    if (current > 1) setQuantity(current - 1);
  }

  Future<void> addToCart(ProductEntity product) async {
    final qty = (state is ProductDetailInitial) ? (state as ProductDetailInitial).quantity : 1;
    emit(ProductDetailUpdating(qty));
    try {
      // Simulate add to cart (replace with real use-case)
      await Future.delayed(const Duration(milliseconds: 500));
      emit(ProductDetailAddToCartSuccess(qty));
    } catch (e) {
      emit(ProductDetailFailure('No se pudo agregar al carrito'));
    }
  }
}
