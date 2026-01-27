// lib/presentation/views/product_grid_view.dart
import 'package:flutter/material.dart';
import '../../domain/entities/product_entity.dart';
import '../widgets/product_card.dart';

class ProductGridView extends StatelessWidget {
  final List<ProductEntity> products;
  final Function(ProductEntity) onProductTap;

  const ProductGridView({
    super.key,
    required this.products,
    required this.onProductTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onTap: () => onProductTap(product),
        );
      },
    );
  }
}