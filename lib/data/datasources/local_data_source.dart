import '../models/product_model.dart';
import '../models/user_model.dart';
import '../../core/database/database_helper.dart';

/// Interfaz para Datasource Local
abstract class LocalDataSource {
  // Products
  Future<ProductModel?> getProduct(String id);
  Future<List<ProductModel>> getProducts();
  Future<void> saveProducts(List<ProductModel> products);
  Future<void> saveProduct(ProductModel product);
  Future<void> deleteProduct(String id);
  Future<void> clearProducts();

  // Users
  Future<UserModel?> getUser(String id);
  Future<void> saveUser(UserModel user);
  Future<void> deleteUser(String id);

  // Cache management
  Future<void> clearAll();
}

/// Implementación de Datasource Local con SQLite
class LocalDataSourceImpl implements LocalDataSource {
  final DatabaseHelper databaseHelper;

  LocalDataSourceImpl({required this.databaseHelper});

  // ==================== PRODUCTS ====================

  @override
  Future<ProductModel?> getProduct(String id) async {
    try {
      final result = await databaseHelper.queryFirstRow('products', 'id = ?', [
        id,
      ]);
      return result != null ? ProductModel.fromJson(result) : null;
    } catch (e) {
      throw Exception('Error getting product from local database: $e');
    }
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final results = await databaseHelper.query(
        'products',
        where: 'is_active = ?',
        whereArgs: [1],
      );
      return results.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error getting products from local database: $e');
    }
  }

  @override
  Future<void> saveProducts(List<ProductModel> products) async {
    try {
      await databaseHelper.transaction((txn) async {
        for (final product in products) {
          await txn.insert(
            'products',
            product.toJson(),
          );
        }
      });
    } catch (e) {
      throw Exception('Error saving products to local database: $e');
    }
  }

  @override
  Future<void> saveProduct(ProductModel product) async {
    try {
      await databaseHelper.insert('products', product.toJson());
    } catch (e) {
      throw Exception('Error saving product to local database: $e');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await databaseHelper.delete('products', 'id = ?');
    } catch (e) {
      throw Exception('Error deleting product from local database: $e');
    }
  }

  @override
  Future<void> clearProducts() async {
    try {
      await databaseHelper.delete('products', '1=1');
    } catch (e) {
      throw Exception('Error clearing products from local database: $e');
    }
  }

  // ==================== USERS ====================

  @override
  Future<UserModel?> getUser(String id) async {
    try {
      final result = await databaseHelper.queryFirstRow('users', 'id = ?', [
        id,
      ]);
      return result != null ? UserModel.fromJson(result) : null;
    } catch (e) {
      throw Exception('Error getting user from local database: $e');
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      await databaseHelper.insert('users', user.toJson());
    } catch (e) {
      throw Exception('Error saving user to local database: $e');
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      await databaseHelper.delete('users', 'id = ?');
    } catch (e) {
      throw Exception('Error deleting user from local database: $e');
    }
  }

  // ==================== CACHE MANAGEMENT ====================

  @override
  Future<void> clearAll() async {
    try {
      await databaseHelper.transaction((txn) async {
        await txn.delete('products');
        await txn.delete('users');
        await txn.delete('cart_items');
        await txn.delete('favorites');
        // Agregar más tablas según sea necesario
      });
    } catch (e) {
      throw Exception('Error clearing local database: $e');
    }
  }
}

/// Extensión para sqflite ConflictAlgorithm
enum ConflictAlgorithm { rollback, abort, fail, ignore, replace }
