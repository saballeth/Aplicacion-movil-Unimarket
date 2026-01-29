import 'package:flutter/material.dart';

class FavoriteItemModel {
  final String id;
  final String storeName;
  final String? productName;
  final double? price;
  final double? rating;
  final int? reviewCount;
  final String category;
  final bool isFood;

  FavoriteItemModel({
    required this.id,
    required this.storeName,
    this.productName,
    this.price,
    this.rating,
    this.reviewCount,
    required this.category,
    required this.isFood,
  });
}

class FavoritesViewModel extends ChangeNotifier {
  final List<FavoriteItemModel> _items = [
    FavoriteItemModel(
      id: '1',
      storeName: 'Pizza de chorizo',
      productName: null,
      price: 20000,
      rating: 4.0,
      reviewCount: 200,
      category: 'Comida',
      isFood: true,
    ),
    FavoriteItemModel(
      id: '2',
      storeName: 'Sandwiches Otto',
      productName: 'Sandwich de Pollo',
      price: 8000,
      rating: 4.9,
      reviewCount: 330,
      category: 'Comida',
      isFood: true,
    ),
    FavoriteItemModel(
      id: '3',
      storeName: 'Pastelería Askim',
      productName: 'Torta de Chocolate',
      price: 50000,
      rating: 4.8,
      reviewCount: 348,
      category: 'Comida',
      isFood: true,
    ),
    FavoriteItemModel(
      id: '4',
      storeName: 'Mr FOX',
      productName: 'Hamburguesa Doble',
      price: 14000,
      rating: 4.8,
      reviewCount: 249,
      category: 'Comida',
      isFood: true,
    ),
    FavoriteItemModel(
      id: '5',
      storeName: 'Accesorios Martina',
      productName: 'Manilla de Pareja',
      price: null,
      rating: null,
      reviewCount: null,
      category: 'Accesorios',
      isFood: false,
    ),
  ];

  List<FavoriteItemModel> get items => List.unmodifiable(_items);

  void remove(String id) {
    _items.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  void add(FavoriteItemModel item) {
    _items.add(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
