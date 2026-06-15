import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  Future<OrderEntity> call(OrderEntity order) async {
    // Validar que la orden tenga todos los datos necesarios
    if (order.items.isEmpty) {
      throw Exception('La orden debe tener al menos un producto');
    }
    if (order.totalAmount <= 0) {
      throw Exception('El total de la orden debe ser mayor a 0');
    }

    // Crear la orden en el repositorio
    return await repository.createOrder(order);
  }
}
