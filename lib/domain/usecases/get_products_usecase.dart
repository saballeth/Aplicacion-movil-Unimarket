import '../repositories/product_repository.dart';
import '../entities/product_entity.dart';
import '../../core/errors/failures.dart';
import 'package:dartz/dartz.dart';

class GetProductsUseCase {
  final ProductRepository repository;
  
  GetProductsUseCase(this.repository);
  
  Future<Either<Failure, List<ProductEntity>>> call() async {
    return await repository.getProducts();
  }
}