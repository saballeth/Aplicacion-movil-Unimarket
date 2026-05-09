import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimarket/domain/entities/product_entity.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(const FavoritesInitial());

  List<ProductEntity> _items = [];

  List<ProductEntity> get items => _items;

  void loadFavorites() {
    emit(const FavoritesLoading());
    try {
      // TODO: Load favorites from local storage or API
      emit(FavoritesLoaded(items: _items));
    } catch (e) {
      emit(FavoritesError(message: e.toString()));
    }
  }

  void addToFavorites(ProductEntity product) {
    try {
      if (!_items.any((item) => item.id == product.id)) {
        _items.add(product);
      }
      emit(FavoritesLoaded(items: List.from(_items)));
    } catch (e) {
      emit(FavoritesError(message: 'Error al agregar a favoritos: $e'));
    }
  }

  void removeFromFavorites(String productId) {
    try {
      _items.removeWhere((item) => item.id == productId);
      emit(FavoritesLoaded(items: List.from(_items)));
    } catch (e) {
      emit(FavoritesError(message: 'Error al eliminar de favoritos: $e'));
    }
  }

  void toggleFavorite(ProductEntity product) {
    try {
      if (_items.any((item) => item.id == product.id)) {
        removeFromFavorites(product.id);
      } else {
        addToFavorites(product);
      }
    } catch (e) {
      emit(FavoritesError(message: 'Error al cambiar favorito: $e'));
    }
  }

  bool isFavorite(String productId) =>
      _items.any((item) => item.id == productId);

  void clearFavorites() {
    try {
      _items.clear();
      emit(FavoritesLoaded(items: List.from(_items)));
    } catch (e) {
      emit(FavoritesError(message: 'Error al limpiar favoritos: $e'));
    }
  }
}
