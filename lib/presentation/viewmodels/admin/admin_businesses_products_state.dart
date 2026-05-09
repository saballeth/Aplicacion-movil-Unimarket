import 'package:equatable/equatable.dart';

// ==================== BUSINESSES ====================
abstract class AdminBusinessesState extends Equatable {
  const AdminBusinessesState();
  @override
  List<Object?> get props => [];
}

class AdminBusinessesInitial extends AdminBusinessesState {
  const AdminBusinessesInitial();
}

class AdminBusinessesLoading extends AdminBusinessesState {
  const AdminBusinessesLoading();
}

class AdminBusinessesLoaded extends AdminBusinessesState {
  final List<AdminBusinessModel> businesses;
  final int totalCount;

  const AdminBusinessesLoaded({
    required this.businesses,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [businesses, totalCount];
}

class AdminBusinessesError extends AdminBusinessesState {
  final String message;
  const AdminBusinessesError(this.message);
  @override
  List<Object?> get props => [message];
}

class AdminBusinessModel extends Equatable {
  final int id;
  final String name;
  final String owner;
  final String category;
  final String status; // 'Activo', 'Suspendido'
  final int products;
  final int sales;
  final double rating;
  final double revenue;
  final DateTime createdAt;

  const AdminBusinessModel({
    required this.id,
    required this.name,
    required this.owner,
    required this.category,
    required this.status,
    required this.products,
    required this.sales,
    required this.rating,
    required this.revenue,
    required this.createdAt,
  });

  AdminBusinessModel copyWith({
    String? status,
    int? products,
    int? sales,
    double? rating,
    double? revenue,
  }) {
    return AdminBusinessModel(
      id: id,
      name: name,
      owner: owner,
      category: category,
      status: status ?? this.status,
      products: products ?? this.products,
      sales: sales ?? this.sales,
      rating: rating ?? this.rating,
      revenue: revenue ?? this.revenue,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    owner,
    category,
    status,
    products,
    sales,
    rating,
    revenue,
    createdAt,
  ];
}

// ==================== PRODUCTS ====================
abstract class AdminProductsState extends Equatable {
  const AdminProductsState();
  @override
  List<Object?> get props => [];
}

class AdminProductsInitial extends AdminProductsState {
  const AdminProductsInitial();
}

class AdminProductsLoading extends AdminProductsState {
  const AdminProductsLoading();
}

class AdminProductsLoaded extends AdminProductsState {
  final List<AdminProductModel> products;
  final int totalCount;

  const AdminProductsLoaded({required this.products, required this.totalCount});

  @override
  List<Object?> get props => [products, totalCount];
}

class AdminProductsError extends AdminProductsState {
  final String message;
  const AdminProductsError(this.message);
  @override
  List<Object?> get props => [message];
}

class AdminProductModel extends Equatable {
  final int id;
  final String name;
  final String seller;
  final String category;
  final String status; // 'Activo', 'Rechazado', 'Pendiente'
  final double price;
  final int stock;
  final double rating;
  final int reviewCount;
  final DateTime createdAt;

  const AdminProductModel({
    required this.id,
    required this.name,
    required this.seller,
    required this.category,
    required this.status,
    required this.price,
    required this.stock,
    required this.rating,
    required this.reviewCount,
    required this.createdAt,
  });

  AdminProductModel copyWith({String? status, int? stock, double? rating}) {
    return AdminProductModel(
      id: id,
      name: name,
      seller: seller,
      category: category,
      status: status ?? this.status,
      price: price,
      stock: stock ?? this.stock,
      rating: rating ?? this.rating,
      reviewCount: reviewCount,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    seller,
    category,
    status,
    price,
    stock,
    rating,
    reviewCount,
    createdAt,
  ];
}
