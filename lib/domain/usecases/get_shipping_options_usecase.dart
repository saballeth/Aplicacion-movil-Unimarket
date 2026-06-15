import '../entities/shipping_option_entity.dart';
import '../repositories/order_repository.dart';

class GetShippingOptionsUseCase {
  final OrderRepository repository;

  GetShippingOptionsUseCase(this.repository);

  Future<List<ShippingOptionEntity>> call() async {
    return await repository.getShippingOptions();
  }
}
