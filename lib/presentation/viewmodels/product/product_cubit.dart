// lib/presentation/viewmodels/product/product_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
export 'product_state.dart';
import '../../../domain/usecases/get_products_usecase.dart';
import '../../../domain/entities/product_entity.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProductsUseCase getProductsUseCase;

  ProductCubit(this.getProductsUseCase) : super(ProductInitial());

  Future<void> loadProducts() async {
    emit(ProductLoading());

    final result = await getProductsUseCase();

    result.fold((failure) => emit(ProductError(failure.toString())), (
      products,
    ) {
      if (products.isEmpty) {
        emit(ProductEmpty());
      } else {
        emit(ProductLoaded(products));
      }
    });
  }

  void filterByCategory(String category) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final filtered = currentState.products
          .where((product) => product.category == category)
          .toList();
      emit(ProductLoaded(filtered));
    }
  }

  void sortByPrice(bool ascending) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final sorted = List<ProductEntity>.from(currentState.products);
      sorted.sort(
        (a, b) => ascending
            ? a.finalPrice.compareTo(b.finalPrice)
            : b.finalPrice.compareTo(a.finalPrice),
      );
      emit(ProductLoaded(sorted));
    }
  }

  void searchProducts(String query) {
    if (state is ProductLoaded) {
      final originalState = state as ProductLoaded;
      final queryLower = query.toLowerCase();
      final filtered = originalState.products
          .where(
            (product) =>
                product.name.toLowerCase().contains(queryLower) ||
                product.description.toLowerCase().contains(queryLower) ||
                product.category.toLowerCase().contains(queryLower),
          )
          .toList();
      emit(ProductLoaded(filtered));
    }
  }

  /// Obtiene productos con descuentos activos (promos)
  List<ProductEntity> getPromoProducts() {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      return currentState.products
          .where((product) => product.isOnSale)
          .toList();
    }
    return [];
  }

  /// Obtiene productos destacados/principales para inicio
  List<ProductEntity> getFeaturedProducts() {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      return currentState.products
          .where((product) => product.isFeatured)
          .toList();
    }
    return [];
  }

  /// Obtiene todos los productos disponibles
  List<ProductEntity> getAllProducts() {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      return currentState.products;
    }
    return [];
  }
}
