import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimarket/domain/entities/product_entity.dart';
import 'package:unimarket/presentation/models/cart_item.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartInitial());

  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void loadCart() {
    emit(const CartLoading());
    try {
      // TODO: Load cart from local storage or API
      emit(CartLoaded(items: _items));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  void addToCart(ProductEntity product) {
    try {
      final existingIndex =
          _items.indexWhere((item) => item.product.id == product.id);

      if (existingIndex >= 0) {
        _items[existingIndex] = _items[existingIndex].copyWith(
          quantity: _items[existingIndex].quantity + 1,
        );
      } else {
        _items.add(CartItem(product: product, quantity: 1));
      }

      emit(CartLoaded(items: List.from(_items)));
    } catch (e) {
      emit(CartError(message: 'Error al agregar al carrito: $e'));
    }
  }

  void removeFromCart(String productId) {
    try {
      _items.removeWhere((item) => item.product.id == productId);
      emit(CartLoaded(items: List.from(_items)));
    } catch (e) {
      emit(CartError(message: 'Error al eliminar del carrito: $e'));
    }
  }

  void updateQuantity(String productId, int quantity) {
    try {
      if (quantity <= 0) {
        removeFromCart(productId);
        return;
      }

      final index = _items.indexWhere((item) => item.product.id == productId);
      if (index >= 0) {
        _items[index] = _items[index].copyWith(quantity: quantity);
        emit(CartLoaded(items: List.from(_items)));
      }
    } catch (e) {
      emit(CartError(message: 'Error al actualizar cantidad: $e'));
    }
  }

  void clearCart() {
    try {
      _items.clear();
      emit(CartLoaded(items: List.from(_items)));
    } catch (e) {
      emit(CartError(message: 'Error al limpiar carrito: $e'));
    }
  }

  double getTotal() {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }
}
