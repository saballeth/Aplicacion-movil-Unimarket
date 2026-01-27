// lib/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product_entity.dart';
import '../viewmodels/product/product_cubit.dart';
import '../views/product_grid_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UNIMARKET'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Image.asset(
              'lib/assets/images/Bienvenida.png',
              width: 24,
              height: 24,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ProductCubit>().loadProducts(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          
          if (state is ProductEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No hay productos disponibles',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          
          if (state is ProductLoaded) {
            return Column(
              children: [
                // Filtros
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.grey[100],
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: 'Todos',
                          items: ['Todos', 'Electrónica', 'Ropa', 'Hogar']
                              .map((category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != 'Todos') {
                              context.read<ProductCubit>().filterByCategory(value!);
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'Categoría',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.sort),
                        onPressed: () {
                          // Implementar ordenamiento
                        },
                      ),
                    ],
                  ),
                ),
                
                // Lista de productos
                Expanded(
                  child: ProductGridView(
                    products: state.products,
                    onProductTap: (product) {
                      _showProductDetail(context, product);
                    },
                  ),
                ),
              ],
            );
          }
          
          return Center(
            child: ElevatedButton(
              onPressed: () => context.read<ProductCubit>().loadProducts(),
              child: const Text('Cargar Productos'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<ProductCubit>().loadProducts(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
  
  void _showProductDetail(BuildContext context, ProductEntity product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.description),
            const SizedBox(height: 16),
            Text('Precio: \$${product.finalPrice.toStringAsFixed(2)}'),
            Text('Stock disponible: ${product.stock}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Agregar al carrito
              Navigator.pop(context);
            },
            child: const Text('Agregar al Carrito'),
          ),
        ],
      ),
    );
  }
}