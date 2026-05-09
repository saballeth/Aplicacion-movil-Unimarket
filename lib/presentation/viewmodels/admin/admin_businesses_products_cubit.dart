import 'package:flutter_bloc/flutter_bloc.dart';
import 'admin_businesses_products_state.dart';

// ==================== BUSINESSES CUBIT ====================
class AdminBusinessesCubit extends Cubit<AdminBusinessesState> {
  AdminBusinessesCubit() : super(const AdminBusinessesInitial());

  final List<AdminBusinessModel> _businesses = [
    AdminBusinessModel(
      id: 1,
      name: 'Tienda de Ropa María',
      owner: 'María García',
      category: 'Ropa y Accesorios',
      status: 'Activo',
      products: 45,
      sales: 234,
      rating: 4.8,
      revenue: 12450.00,
      createdAt: DateTime(2024, 1, 15),
    ),
    AdminBusinessModel(
      id: 2,
      name: 'Comidas Caseras Juan',
      owner: 'Juan López',
      category: 'Comida',
      status: 'Activo',
      products: 12,
      sales: 89,
      rating: 4.5,
      revenue: 5670.00,
      createdAt: DateTime(2024, 2, 1),
    ),
    AdminBusinessModel(
      id: 3,
      name: 'Tech Shop',
      owner: 'Carlos Peña',
      category: 'Tecnología',
      status: 'Suspendido',
      products: 78,
      sales: 156,
      rating: 4.3,
      revenue: 8900.00,
      createdAt: DateTime(2023, 11, 20),
    ),
  ];

  void loadBusinesses() {
    emit(const AdminBusinessesLoading());
    try {
      emit(
        AdminBusinessesLoaded(
          businesses: _businesses,
          totalCount: _businesses.length,
        ),
      );
    } catch (e) {
      emit(
        AdminBusinessesError(
          'Error al cargar emprendimientos: ${e.toString()}',
        ),
      );
    }
  }

  void suspendBusiness(int businessId) {
    emit(const AdminBusinessesLoading());
    try {
      final index = _businesses.indexWhere((b) => b.id == businessId);
      if (index != -1) {
        _businesses[index] = _businesses[index].copyWith(status: 'Suspendido');
      }
      loadBusinesses();
    } catch (e) {
      emit(
        AdminBusinessesError(
          'Error al suspender emprendimiento: ${e.toString()}',
        ),
      );
    }
  }

  void activateBusiness(int businessId) {
    emit(const AdminBusinessesLoading());
    try {
      final index = _businesses.indexWhere((b) => b.id == businessId);
      if (index != -1) {
        _businesses[index] = _businesses[index].copyWith(status: 'Activo');
      }
      loadBusinesses();
    } catch (e) {
      emit(
        AdminBusinessesError(
          'Error al activar emprendimiento: ${e.toString()}',
        ),
      );
    }
  }

  void deleteBusiness(int businessId) {
    emit(const AdminBusinessesLoading());
    try {
      _businesses.removeWhere((b) => b.id == businessId);
      loadBusinesses();
    } catch (e) {
      emit(
        AdminBusinessesError(
          'Error al eliminar emprendimiento: ${e.toString()}',
        ),
      );
    }
  }

  Map<String, dynamic> getBusinessStatistics() {
    return {
      'totalBusinesses': _businesses.length,
      'activeBusinesses': _businesses.where((b) => b.status == 'Activo').length,
      'totalRevenue': _businesses.fold<double>(0, (sum, b) => sum + b.revenue),
      'averageRating': _businesses.isNotEmpty
          ? _businesses.fold<double>(0, (sum, b) => sum + b.rating) /
                _businesses.length
          : 0,
    };
  }
}

// ==================== PRODUCTS CUBIT ====================
class AdminProductsCubit extends Cubit<AdminProductsState> {
  AdminProductsCubit() : super(const AdminProductsInitial());

  final List<AdminProductModel> _products = [
    AdminProductModel(
      id: 1,
      name: 'Camiseta Estampada',
      seller: 'Tienda de Ropa María',
      category: 'Ropa',
      status: 'Activo',
      price: 25000,
      stock: 45,
      rating: 4.8,
      reviewCount: 34,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    AdminProductModel(
      id: 2,
      name: 'Zapatos Deportivos',
      seller: 'Tienda de Ropa María',
      category: 'Calzado',
      status: 'Activo',
      price: 85000,
      stock: 12,
      rating: 4.5,
      reviewCount: 28,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    AdminProductModel(
      id: 3,
      name: 'Accesorio Electrónico',
      seller: 'Tech Shop',
      category: 'Tecnología',
      status: 'Rechazado',
      price: 150000,
      stock: 0,
      rating: 3.2,
      reviewCount: 12,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  void loadProducts() {
    emit(const AdminProductsLoading());
    try {
      emit(
        AdminProductsLoaded(products: _products, totalCount: _products.length),
      );
    } catch (e) {
      emit(AdminProductsError('Error al cargar productos: ${e.toString()}'));
    }
  }

  void approveProduct(int productId) {
    emit(const AdminProductsLoading());
    try {
      final index = _products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        _products[index] = _products[index].copyWith(status: 'Activo');
      }
      loadProducts();
    } catch (e) {
      emit(AdminProductsError('Error al aprobar producto: ${e.toString()}'));
    }
  }

  void rejectProduct(int productId) {
    emit(const AdminProductsLoading());
    try {
      final index = _products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        _products[index] = _products[index].copyWith(status: 'Rechazado');
      }
      loadProducts();
    } catch (e) {
      emit(AdminProductsError('Error al rechazar producto: ${e.toString()}'));
    }
  }

  void deleteProduct(int productId) {
    emit(const AdminProductsLoading());
    try {
      _products.removeWhere((p) => p.id == productId);
      loadProducts();
    } catch (e) {
      emit(AdminProductsError('Error al eliminar producto: ${e.toString()}'));
    }
  }

  Map<String, dynamic> getProductStatistics() {
    return {
      'totalProducts': _products.length,
      'activeProducts': _products.where((p) => p.status == 'Activo').length,
      'pendingApproval': _products.where((p) => p.status == 'Pendiente').length,
      'rejectedProducts': _products
          .where((p) => p.status == 'Rechazado')
          .length,
      'averageRating': _products.isNotEmpty
          ? _products.fold<double>(0, (sum, p) => sum + p.rating) /
                _products.length
          : 0,
    };
  }
}
