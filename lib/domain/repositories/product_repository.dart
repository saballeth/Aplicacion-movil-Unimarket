import '../entities/product_entity.dart';
import '../../core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts();
  Future<Either<Failure, ProductEntity>> getProductById(String id);
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(String category);
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query);
  Future<Either<Failure, List<ProductEntity>>> getFeaturedProducts();
}