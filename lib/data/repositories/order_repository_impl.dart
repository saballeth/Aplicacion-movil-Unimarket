import '../../domain/entities/order_entity.dart';
import '../../domain/entities/shipping_option_entity.dart';
import '../../domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  @override
  Future<List<OrderEntity>> getOrdersByUserId(String userId) async {
    // TODO: Conectar a API real
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }

  @override
  Future<OrderEntity?> getOrderById(String orderId) async {
    // TODO: Conectar a API real
    await Future.delayed(const Duration(milliseconds: 500));
    return null;
  }

  @override
  Future<List<ShippingOptionEntity>> getShippingOptions() async {
    // TODO: Conectar a API real
    // Mock data para desarrollo
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      const ShippingOptionEntity(
        id: '1',
        name: 'Envío Estándar',
        description: 'Entrega en 5-7 días',
        cost: 15000,
        estimatedDays: 6,
      ),
      const ShippingOptionEntity(
        id: '2',
        name: 'Envío Express',
        description: 'Entrega en 2-3 días',
        cost: 35000,
        estimatedDays: 2,
      ),
      const ShippingOptionEntity(
        id: '3',
        name: 'Recogida en Tienda',
        description: 'Recoge en la tienda',
        cost: 0,
        estimatedDays: 0,
      ),
    ];
  }

  @override
  Future<OrderEntity> createOrder(OrderEntity order) async {
    // TODO: Conectar a API real para guardar la orden en base de datos
    // Por ahora solo retornamos la orden con un ID generado
    await Future.delayed(const Duration(milliseconds: 1000));
    return order;
  }

  @override
  Future<void> updateOrder(OrderEntity order) async {
    // TODO: Conectar a API real
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    // TODO: Conectar a API real
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> addOrderReview(
    String orderId,
    double rating,
    String review,
  ) async {
    // TODO: Conectar a API real
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
