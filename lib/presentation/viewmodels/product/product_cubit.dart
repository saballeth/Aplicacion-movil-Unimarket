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
    
    result.fold(
      (failure) => emit(ProductError(failure.toString())),
      (products) {
        if (products.isEmpty) {
          emit(ProductEmpty());
        } else {
          emit(ProductLoaded(products));
        }
      },
    );
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
      sorted.sort((a, b) => ascending 
          ? a.finalPrice.compareTo(b.finalPrice)
          : b.finalPrice.compareTo(a.finalPrice));
      emit(ProductLoaded(sorted));
    }
  }
}