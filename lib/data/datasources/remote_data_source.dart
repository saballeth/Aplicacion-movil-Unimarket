import 'package:dio/dio.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

/// Interfaz para Datasource Remoto
abstract class RemoteDataSource {
  Future<ProductModel> getProduct(String id);
  Future<List<ProductModel>> getProducts({int page = 1, int pageSize = 20});
  Future<List<ProductModel>> getProductsByCategory(String categoryId);
  Future<List<ProductModel>> searchProducts(String query);
  Future<UserModel> getUserProfile(String userId);
  Future<void> updateUserProfile(UserModel user);
}

/// Implementación de Datasource Remoto con Dio
class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio dio;

  RemoteDataSourceImpl({required this.dio});

  @override
  Future<ProductModel> getProduct(String id) async {
    try {
      final response = await dio.get('/products/$id');
      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Error fetching product: ${e.message}');
    }
  }

  @override
  Future<List<ProductModel>> getProducts({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await dio.get(
        '/products',
        queryParameters: {'page': page, 'pageSize': pageSize},
      );
      final products = (response.data as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
      return products;
    } on DioException catch (e) {
      throw Exception('Error fetching products: ${e.message}');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    try {
      final response = await dio.get('/products/category/$categoryId');
      final products = (response.data as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
      return products;
    } on DioException catch (e) {
      throw Exception('Error fetching products by category: ${e.message}');
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await dio.get(
        '/products/search',
        queryParameters: {'q': query},
      );
      final products = (response.data as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
      return products;
    } on DioException catch (e) {
      throw Exception('Error searching products: ${e.message}');
    }
  }

  @override
  Future<UserModel> getUserProfile(String userId) async {
    try {
      final response = await dio.get('/users/$userId');
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Error fetching user profile: ${e.message}');
    }
  }

  @override
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await dio.put('/users/${user.id}', data: user.toJson());
    } on DioException catch (e) {
      throw Exception('Error updating user profile: ${e.message}');
    }
  }
}
