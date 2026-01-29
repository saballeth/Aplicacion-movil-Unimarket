import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:unimarket/presentation/viewmodels/product_detail/product_detail_cubit.dart';
import 'package:unimarket/presentation/viewmodels/product_detail/product_detail_state.dart';
import 'package:unimarket/domain/entities/product_entity.dart';
import 'package:unimarket/core/injection_container.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductEntity product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductDetailCubit>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(product.name, style: const TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Container(
                  width: double.infinity,
                  height: 240,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: product.imageUrl.isNotEmpty
                      ? Image.network(product.imageUrl, fit: BoxFit.cover)
                      : const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    Row(children: [const Icon(Icons.star, color: Colors.amber), Text(product.rating.toString())]),
                  ],
                ),
                const SizedBox(height: 8),
                Text(product.description, style: const TextStyle(fontSize: 16, color: Colors.black54)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text('\$${product.finalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                    const SizedBox(width: 8),
                    if (product.isOnSale)
                      Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Cantidad', style: TextStyle(fontSize: 14, color: Colors.grey[800])),
                const SizedBox(height: 8),
                BlocBuilder<ProductDetailCubit, ProductDetailState>(
                  builder: (context, state) {
                    final qty = state is ProductDetailInitial ? state.quantity : 1;
                    final isLoading = state is ProductDetailUpdating;
                    return Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[300]!)),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: isLoading ? null : () => context.read<ProductDetailCubit>().decrement(),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              SizedBox(width: 30, child: Text(qty.toString(), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: isLoading ? null : () => context.read<ProductDetailCubit>().increment(),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isLoading ? null : () => context.read<ProductDetailCubit>().addToCart(product),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800], padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            child: isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Agregar al carrito', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text('Stock disponible: ${product.stock}', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
