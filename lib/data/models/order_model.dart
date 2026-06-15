import 'package:equatable/equatable.dart';

/// Modelo de Orden para la Base de Datos
class OrderModel extends Equatable {
  final String id;
  final String userId;
  final double totalAmount;
  final String status; // pending, confirmed, shipped, delivered, cancelled
  final String paymentStatus; // pending, completed, failed, refunded
  final Map<String, dynamic> shippingAddress; // Serializado como JSON
  final String? trackingNumber;
  final DateTime? deliveryDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.totalAmount,
    this.status = 'pending',
    this.paymentStatus = 'pending',
    required this.shippingAddress,
    this.trackingNumber,
    this.deliveryDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      paymentStatus: json['payment_status'] ?? 'pending',
      shippingAddress: json['shipping_address'] is String
          ? {} // Manejo de serialización
          : json['shipping_address'] ?? {},
      trackingNumber: json['tracking_number'],
      deliveryDate: json['delivery_date'] != null
          ? DateTime.parse(json['delivery_date'])
          : null,
      notes: json['notes'],
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'total_amount': totalAmount,
      'status': status,
      'payment_status': paymentStatus,
      'shipping_address': shippingAddress,
      'tracking_number': trackingNumber,
      'delivery_date': deliveryDate?.toIso8601String(),
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  OrderModel copyWith({
    String? id,
    String? userId,
    double? totalAmount,
    String? status,
    String? paymentStatus,
    Map<String, dynamic>? shippingAddress,
    String? trackingNumber,
    DateTime? deliveryDate,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    totalAmount,
    status,
    paymentStatus,
    shippingAddress,
    trackingNumber,
    deliveryDate,
    notes,
    createdAt,
    updatedAt,
  ];
}

/// Modelo de Items de Orden
class OrderItemModel extends Equatable {
  final String id;
  final String orderId;
  final String productId;
  final int quantity;
  final double unitPrice;
  final double subtotal;
  final DateTime createdAt;

  const OrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    required this.createdAt,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] ?? '',
      orderId: json['order_id'] ?? '',
      productId: json['product_id'] ?? '',
      quantity: json['quantity'] ?? 0,
      unitPrice: (json['unit_price'] ?? 0).toDouble(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'subtotal': subtotal,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    orderId,
    productId,
    quantity,
    unitPrice,
    subtotal,
    createdAt,
  ];
}
