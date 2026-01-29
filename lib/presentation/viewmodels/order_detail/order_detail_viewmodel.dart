import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OrderProduct {
  final String id;
  final String name;
  final String restaurant;
  int quantity;
  final double price;
  final String note;

  OrderProduct({
    required this.id,
    required this.name,
    required this.restaurant,
    required this.quantity,
    required this.price,
    this.note = '',
  });
}

class OrderDetailViewModel extends ChangeNotifier {
  String restaurantName = 'Jeikol Pizza';
  bool isDeliverySelected = true;
  String status = 'Entregado';
  String statusMessage = 'Tu pedido ha sido entregado exitosamente.';

  final List<OrderProduct> products = [
    OrderProduct(
      id: 'P01',
      name: 'Pizza de chorizo',
      restaurant: 'Jeikol Pizza',
      quantity: 2,
      price: 4000,
      note: 'Sin cebolla, por favor',
    ),
  ];

  double get subtotal => products.fold(0.0, (s, p) => s + p.price * p.quantity);
  double deliveryFee = 0.0;
  double tip = 0.0;

  double get total => subtotal + deliveryFee + tip;

  void toggleDelivery(bool delivery) {
    isDeliverySelected = delivery;
    notifyListeners();
  }

  void increaseQuantity(String productId) {
    final p = products.firstWhere((e) => e.id == productId);
    p.quantity += 1;
    notifyListeners();
  }

  void decreaseQuantity(String productId) {
    final p = products.firstWhere((e) => e.id == productId);
    if (p.quantity > 1) p.quantity -= 1;
    notifyListeners();
  }

  void setDeliveryFee(double fee) {
    deliveryFee = fee;
    notifyListeners();
  }

  void setTip(double value) {
    tip = value;
    notifyListeners();
  }

  void repeatOrder() {
    // TODO: implement repeat order flow (e.g., add items back to cart)
  }

  void shareOrder() {
    // TODO: integrate share logic
  }
}
