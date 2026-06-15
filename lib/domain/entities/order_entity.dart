import 'package:equatable/equatable.dart';
import 'address_entity.dart';
import 'shipping_option_entity.dart';

enum OrderStatus { pending, confirmed, shipped, delivered, cancelled }

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pendiente';
      case OrderStatus.confirmed:
        return 'Confirmada';
      case OrderStatus.shipped:
        return 'Enviada';
      case OrderStatus.delivered:
        return 'Entregada';
      case OrderStatus.cancelled:
        return 'Cancelada';
    }
  }

  String get displayNameShort {
    switch (this) {
      case OrderStatus.pending:
        return 'En progreso';
      case OrderStatus.confirmed:
        return 'Confirmada';
      case OrderStatus.shipped:
        return 'En progreso';
      case OrderStatus.delivered:
        return 'Entregados';
      case OrderStatus.cancelled:
        return 'Cancelada';
    }
  }
}

class OrderItemEntity extends Equatable {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String? imageUrl;

  const OrderItemEntity({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });

  double get subtotal => price * quantity;

  @override
  List<Object?> get props => [
    productId,
    productName,
    price,
    quantity,
    imageUrl,
  ];
}

class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final String storeId;
  final String storeName;
  final List<OrderItemEntity> items;
  final AddressEntity deliveryAddress;
  final ShippingOptionEntity shippingOption;
  final double subtotal;
  final double shippingCost;
  final double taxAmount;
  final double totalAmount;
  final OrderStatus status;
  final String paymentMethod;
  final String? trackingNumber;
  final DateTime createdAt;
  final DateTime? deliveredAt;
  final double? rating;
  final String? review;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.storeId,
    required this.storeName,
    required this.items,
    required this.deliveryAddress,
    required this.shippingOption,
    required this.subtotal,
    required this.shippingCost,
    required this.taxAmount,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    this.trackingNumber,
    required this.createdAt,
    this.deliveredAt,
    this.rating,
    this.review,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  @override
  List<Object?> get props => [
    id,
    userId,
    storeId,
    storeName,
    items,
    deliveryAddress,
    shippingOption,
    subtotal,
    shippingCost,
    taxAmount,
    totalAmount,
    status,
    paymentMethod,
    trackingNumber,
    createdAt,
    deliveredAt,
    rating,
    review,
  ];
}
