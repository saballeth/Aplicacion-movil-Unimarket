import 'package:flutter/material.dart';

class PromoProduct {
  final String id;
  final String name;
  final double price;
  final int discount;
  final String store;
  final String category;
  final Color imageColor;

  PromoProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.discount,
    required this.store,
    required this.category,
    required this.imageColor,
  });
}

class PromosViewModel extends ChangeNotifier {
  String selectedCategory = 'Todos';

  final List<String> categories = ['Todos', 'Ropa', 'Comida', 'Accesorios'];

  final List<PromoProduct> featuredProducts = [
    PromoProduct(
      id: '1',
      name: 'Buzo Caqui',
      price: 32600,
      discount: 5,
      store: 'Ardoris Boutique',
      category: 'Ropa',
      imageColor: Colors.brown,
    ),
    PromoProduct(
      id: '2',
      name: 'Airpods Pro',
      price: 18000,
      discount: 6,
      store: 'Ortola Inc.',
      category: 'Accesorios',
      imageColor: Colors.blue,
    ),
    PromoProduct(
      id: '3',
      name: 'Fun',
      price: 18000,
      discount: 6,
      store: 'Avisa',
      category: 'Comida',
      imageColor: Colors.red,
    ),
  ];

  final List<PromoProduct> regularProducts = [
    PromoProduct(
      id: '4',
      name: 'Buzo Caqui',
      price: 44900,
      discount: 6,
      store: 'Tania Torres Step',
      category: 'Ropa',
      imageColor: Colors.green,
    ),
    PromoProduct(
      id: '5',
      name: 'Airpods Pro',
      price: 5000,
      discount: 10,
      store: 'Patricio Pineda',
      category: 'Accesorios',
      imageColor: Colors.purple,
    ),
    PromoProduct(
      id: '6',
      name: 'Terrenos',
      price: 54900,
      discount: 6,
      store: 'Logitech',
      category: 'Accesorios',
      imageColor: Colors.orange,
    ),
  ];

  List<PromoProduct> get filteredRegularProducts {
    if (selectedCategory == 'Todos') return regularProducts;
    return regularProducts.where((p) => p.category.toLowerCase() == selectedCategory.toLowerCase()).toList();
  }

  List<PromoProduct> get filteredFeaturedProducts {
    if (selectedCategory == 'Todos') return featuredProducts;
    return featuredProducts.where((p) => p.category.toLowerCase() == selectedCategory.toLowerCase()).toList();
  }

  void selectCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }
}
