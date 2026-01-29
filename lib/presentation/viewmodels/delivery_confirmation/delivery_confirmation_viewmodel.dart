import 'package:flutter/material.dart';

class DeliveryProduct {
  final String id;
  final String name;
  final String restaurant;
  int quantity;
  final double price;

  DeliveryProduct({
    required this.id,
    required this.name,
    required this.restaurant,
    required this.quantity,
    required this.price,
  });
}

class DeliveryConfirmationViewModel extends ChangeNotifier {
  bool isDeliverySelected = true;
  int quantity = 2;

  String addressTitle = 'Hangar A, Unimag';
  String addressSubtitle = 'Atras de tableros';

  final List<DeliveryProduct> products = [
    DeliveryProduct(id: 'P01', name: 'Pizza de chorizo', restaurant: 'Jeikol Pizza', quantity: 2, price: 4000),
  ];

  double get subtotal => products.fold(0.0, (s, p) => s + p.price * p.quantity);
  double deliveryFee = 0.0;
  double tip = 0.0;

  double get total => subtotal + deliveryFee + tip;

  void toggleDelivery(bool delivery) {
    isDeliverySelected = delivery;
    notifyListeners();
  }

  void setQuantity(int q) {
    quantity = q;
    if (products.isNotEmpty) products[0].quantity = q;
    notifyListeners();
  }

  void setAddress(String title, String subtitle) {
    addressTitle = title;
    addressSubtitle = subtitle;
    notifyListeners();
  }

  void setDeliveryFee(double fee) {
    deliveryFee = fee;
    notifyListeners();
  }

  void setTip(double t) {
    tip = t;
    notifyListeners();
  }

  void confirmOrder() {
    // Placeholder: trigger confirm flow / usecase
  }
}
