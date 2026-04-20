import 'package:flutter/material.dart';
import '../../viewmodels/product/product_details_viewmodel.dart';
import '../../viewmodels/promos/promos_viewmodel.dart';

class ProductDetailsPage extends StatefulWidget {
  final PromoProduct product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late final ProductDetailsViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = ProductDetailsViewModel(product: widget.product);
    vm.addListener(_onVmChanged);
  }

  void _onVmChanged() => setState(() {});

  @override
  void dispose() {
    vm.removeListener(_onVmChanged);
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      appBar: AppBar(
        title: Text(p.name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                color: p.imageColor.withAlpha(51),
              ),
              child: Center(
                child: Icon(
                  _getProductIcon(p.category),
                  size: 120,
                  color: p.imageColor,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '\$${p.price.toStringAsFixed(0)}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                        child: Text('+${p.discount}% OFF', style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(p.store, style: TextStyle(color: Colors.grey.shade600)),
                  const SizedBox(height: 16),
                  const Text('Descripción', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Aquí va la descripción del producto. Agrega detalles relevantes para el cliente.'),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(onPressed: vm.decrement, icon: const Icon(Icons.remove)),
                          Text(vm.quantity.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          IconButton(onPressed: vm.increment, icon: const Icon(Icons.add)),
                        ],
                      ),
                      Text('Total: \$${vm.total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${widget.product.name} fue agregado al carrito'),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'Deshacer',
                              onPressed: () {},
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4B2AAD), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: const Text('Comprar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Productos relacionados
                  const Text('Productos Relacionados', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 140,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _getRelatedProducts(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getRelatedProducts() {
    final relatedProducts = [
      {'name': 'Producto Similar 1', 'price': 29.99, 'category': widget.product.category},
      {'name': 'Producto Similar 2', 'price': 39.99, 'category': widget.product.category},
      {'name': 'Producto Similar 3', 'price': 34.99, 'category': widget.product.category},
      {'name': 'Producto Similar 4', 'price': 44.99, 'category': widget.product.category},
    ];

    return relatedProducts.map((product) {
      return Container(
        width: 130,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Center(
                child: Icon(
                  _getProductIcon(product['category'] as String),
                  size: 40,
                  color: Colors.purple.shade300,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] as String,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product['price']}',
                    style: TextStyle(fontSize: 11, color: Colors.purple.shade700, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  IconData _getProductIcon(String category) {
    switch (category.toLowerCase()) {
      case 'ropa':
        return Icons.checkroom;
      case 'comida':
        return Icons.restaurant;
      case 'accesorios':
        return Icons.headphones;
      default:
        return Icons.shopping_bag;
    }
  }
}
