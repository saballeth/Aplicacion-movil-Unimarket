import 'package:flutter/material.dart';
import '../../viewmodels/promos/promos_viewmodel.dart';

class ProductDetailsViewModel extends ChangeNotifier {
  final PromoProduct product;
  int quantity = 1;

  ProductDetailsViewModel({required this.product});

  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    if (quantity > 1) {
      quantity--;
      notifyListeners();
    }
  }

  double get total => product.price * quantity;
}
