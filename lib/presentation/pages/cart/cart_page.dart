import 'package:flutter/material.dart';
import 'package:unimarket/presentation/pages/order_tracking/order_tracking_page.dart';

class CartItem {
  final String id;
  final String name;
  final int quantity;
  final double price;

  CartItem({required this.id, required this.name, required this.quantity, required this.price});
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  // Mock items for demo purposes
  List<CartItem> get _mockItems => [
        CartItem(id: 'P001', name: 'Camisa Azul', quantity: 1, price: 29.99),
        CartItem(id: 'P002', name: 'Pizza Familiar', quantity: 2, price: 45.50),
      ];

  @override
  Widget build(BuildContext context) {
    final items = _mockItems;

    return Scaffold(
      appBar: AppBar(title: const Text('Carrito')),
      body: items.isEmpty
          ? const Center(child: Text('Tu carrito está vacío'))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final it = items[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text(it.quantity.toString())),
                    title: Text(it.name),
                    subtitle: Text('S/ ${it.price.toStringAsFixed(2)}'),
                    trailing: Text('x${it.quantity}'),
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OrderTrackingPage()));
          },
          child: const Text('Pagar'),
        ),
      ),
    );
  }
}
