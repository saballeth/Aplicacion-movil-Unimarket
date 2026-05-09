import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimarket/core/injection_container.dart';
import 'package:unimarket/domain/entities/product_entity.dart';
import 'package:unimarket/presentation/pages/product_detail/product_detail_page.dart';
import 'package:unimarket/presentation/viewmodels/cart/cart_cubit.dart';
import 'package:unimarket/presentation/viewmodels/favorites/favorites_cubit.dart';

class PromosPage extends StatelessWidget {
  const PromosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<CartCubit>()),
        BlocProvider(create: (_) => sl<FavoritesCubit>()),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Promociones',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: null,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(child: Text('Buscar promociones...')),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Descuentos destacables
          const Padding(
            padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text(
              'Descuentos destacados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _getPromoProducts().length > 6
                  ? 6
                  : _getPromoProducts().length,
              itemBuilder: (context, index) {
                final p = _getPromoProducts()[index];
                return _buildPromoCard(context, p);
              },
            ),
          ),

          const SizedBox(height: 16),

          // Categorías
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Todas las promociones',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('Ver todo', style: TextStyle(color: Colors.blue)),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Grid de productos
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _getPromoProducts().length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final product = _getPromoProducts()[index];
                return _buildProductCard(context, product);
              },
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPromoCard(BuildContext context, ProductEntity product) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)),
      ),
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.shopping_bag,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '-20%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: BlocBuilder<CartCubit, CartState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: () {
                                context.read<CartCubit>().addToCart(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${product.name} agregado al carrito',
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4B2AAD),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Icon(Icons.shopping_cart, size: 14),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 6),
                      BlocBuilder<FavoritesCubit, FavoritesState>(
                        builder: (context, state) {
                          final isFavorite = state is FavoritesLoaded
                              ? state.isFavorite(product.id)
                              : false;
                          return IconButton(
                            onPressed: () {
                              context.read<FavoritesCubit>().toggleFavorite(
                                product,
                              );
                            },
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                              size: 18,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, ProductEntity product) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.06),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.shopping_bag,
                        size: 60,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Oferta',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${product.price}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue[800],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CartCubit>().addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${product.name} agregado al carrito',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4B2AAD),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: const Color(0xFF4B2AAD).withOpacity(0.5),
                      ),
                      child: const Text(
                        'Agregar al carrito',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
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

  List<ProductEntity> _getPromoProducts() {
    // Retorna productos de prueba con descuentos
    return [
      ProductEntity(
        id: '1',
        name: 'Buzo Caqui',
        description: 'Buzo cómodo y cálido',
        price: 32600,
        category: 'Ropa',
        imageUrl: '',
        stock: 10,
        rating: 4.5,
        isFeatured: true,
        createdAt: DateTime.now(),
      ),
      ProductEntity(
        id: '2',
        name: 'Airpods Pro',
        description: 'Auriculares inalámbricos',
        price: 18000,
        category: 'Accesorios',
        imageUrl: '',
        stock: 15,
        rating: 4.8,
        isFeatured: true,
        createdAt: DateTime.now(),
      ),
      ProductEntity(
        id: '3',
        name: 'Zapatillas Nike',
        description: 'Zapatillas deportivas',
        price: 25000,
        category: 'Ropa',
        imageUrl: '',
        stock: 8,
        rating: 4.6,
        isFeatured: false,
        createdAt: DateTime.now(),
      ),
      ProductEntity(
        id: '4',
        name: 'Pizza Margherita',
        description: 'Pizza fresca y deliciosa',
        price: 8500,
        category: 'Comida',
        imageUrl: '',
        stock: 20,
        rating: 4.7,
        isFeatured: true,
        createdAt: DateTime.now(),
      ),
      ProductEntity(
        id: '5',
        name: 'Reloj Smartwatch',
        description: 'Reloj inteligente con monitor cardíaco',
        price: 15000,
        category: 'Accesorios',
        imageUrl: '',
        stock: 5,
        rating: 4.4,
        isFeatured: false,
        createdAt: DateTime.now(),
      ),
      ProductEntity(
        id: '6',
        name: 'Jeans Premium',
        description: 'Jeans de alta calidad',
        price: 22000,
        category: 'Ropa',
        imageUrl: '',
        stock: 12,
        rating: 4.5,
        isFeatured: false,
        createdAt: DateTime.now(),
      ),
    ];
  }
}
