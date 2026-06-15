import '../entities/order_entity.dart';
import '../entities/shipping_option_entity.dart';

abstract class OrderRepository {
  Future<List<OrderEntity>> getOrdersByUserId(String userId);
  Future<OrderEntity?> getOrderById(String orderId);
  Future<List<ShippingOptionEntity>> getShippingOptions();
  Future<OrderEntity> createOrder(OrderEntity order);
  Future<void> updateOrder(OrderEntity order);
  Future<void> updateOrderStatus(String orderId, OrderStatus status);
  Future<void> addOrderReview(String orderId, double rating, String review);
}
