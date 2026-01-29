import 'package:flutter/material.dart';
import '../../../domain/entities/product_entity.dart';

class ProductItem {
  final String name;
  final String priceLabel;
  final String store;
  final Color color;
  final bool hasDiscount;

  ProductItem({
    required this.name,
    required this.priceLabel,
    required this.store,
    required this.color,
    this.hasDiscount = false,
  });

  factory ProductItem.fromEntity(ProductEntity e, {Color? colorOverride}) {
    final color = colorOverride ?? _colorForCategory(e.category);
    final priceLabel = '\$${e.finalPrice.toStringAsFixed(2)}';
    return ProductItem(
      name: e.name,
      priceLabel: priceLabel,
      store: e.category.isNotEmpty ? e.category : 'Tienda',
      color: color,
      hasDiscount: e.isOnSale,
    );
  }
}

Color _colorForCategory(String category) {
  switch (category.toLowerCase()) {
    case 'ropa':
      return Colors.purple[50]!;
    case 'comida':
      return Colors.orange[50]!;
    case 'accesorio':
      return Colors.pink[50]!;
    case 'hogar':
      return Colors.green[50]!;
    default:
      return Colors.blue[50]!;
  }
}
