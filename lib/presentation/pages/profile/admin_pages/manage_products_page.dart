import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimarket/core/injection_container.dart';
import 'package:unimarket/presentation/viewmodels/admin/admin_businesses_products_cubit.dart';
import 'package:unimarket/presentation/viewmodels/admin/admin_businesses_products_state.dart';

class ManageProductsPage extends StatelessWidget {
  const ManageProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AdminProductsCubit>()..loadProducts(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Gestionar Productos'),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: BlocConsumer<AdminProductsCubit, AdminProductsState>(
          listener: (context, state) {
            if (state is AdminProductsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AdminProductsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AdminProductsLoaded) {
              final products = state.products;

              if (products.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay productos',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                itemBuilder: (context, index) =>
                    _buildProductCard(context, products[index]),
              );
            }

            if (state is AdminProductsError) {
              return Center(child: Text('Error: ${state.message}'));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, AdminProductModel product) {
    Color statusColor = product.status == 'Activo'
        ? Colors.green
        : (product.status == 'Rechazado' ? Colors.red : Colors.orange);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Vendedor: ${product.seller}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  product.status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B2AAD),
                    ),
                  ),
                  Text(
                    'Stock: ${product.stock}',
                    style: TextStyle(
                      fontSize: 12,
                      color: product.stock > 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (i) => Icon(
                          Icons.star,
                          color: i < product.rating.toInt()
                              ? Colors.amber
                              : Colors.grey[300],
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${product.rating} (${product.reviewCount} opiniones)',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Chip(
            label: Text(product.category),
            backgroundColor: Colors.blue[100],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showProductDetailsDialog(context, product),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('Ver'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4B2AAD),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _toggleProductStatus(context, product),
                  icon: Icon(
                    product.status == 'Activo'
                        ? Icons.remove_circle
                        : Icons.check_circle,
                    size: 16,
                  ),
                  label: Text(
                    product.status == 'Activo' ? 'Rechazar' : 'Aprobar',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: product.status == 'Activo'
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showProductDetailsDialog(
    BuildContext context,
    AdminProductModel product,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(product.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Vendedor:', product.seller),
            _buildDetailRow('Categoría:', product.category),
            _buildDetailRow('Precio:', '\$${product.price}'),
            _buildDetailRow('Stock:', '${product.stock} unidades'),
            _buildDetailRow('Rating:', '${product.rating} ⭐'),
            _buildDetailRow('Estado:', product.status),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  void _toggleProductStatus(BuildContext context, AdminProductModel product) {
    if (product.status == 'Activo') {
      context.read<AdminProductsCubit>().rejectProduct(product.id);
    } else {
      context.read<AdminProductsCubit>().approveProduct(product.id);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          product.status == 'Activo'
              ? 'Producto rechazado'
              : 'Producto aprobado',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
