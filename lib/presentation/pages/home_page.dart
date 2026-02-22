import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimarket/core/injection_container.dart';
import 'package:unimarket/domain/entities/product_entity.dart';
import 'package:unimarket/presentation/pages/login/login_page.dart';
import 'package:unimarket/presentation/pages/orders/orders_page.dart';
import 'package:unimarket/presentation/pages/product_detail/product_detail_page.dart';
import 'package:unimarket/presentation/pages/profile/profile_page.dart';
import 'package:unimarket/presentation/pages/promos/promos_page.dart';
import '../widgets/bottom_nav_custom.dart';
import 'package:unimarket/presentation/pages/cart/cart_page.dart';
import 'package:unimarket/presentation/pages/favorites/favorites_page.dart';
import 'package:unimarket/presentation/viewmodels/auth/auth_cubit.dart';
import 'package:unimarket/presentation/viewmodels/login/login_cubit.dart';
import 'package:unimarket/presentation/viewmodels/product/product_cubit.dart';
import 'package:unimarket/presentation/viewmodels/product/product_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String _selectedCategory = 'Todos';
  final List<String> categories = ['Todos', 'Ropa', 'Comida', 'Accesorio'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = sl<AuthCubit>();
      if (!auth.isAuthenticated()) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => sl<LoginCubit>(),
                child: const LoginPage(),
              ),
            ),
          );
        }
        return;
      }

      context.read<ProductCubit>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'ENTREGAR A Bloque 8',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.person, color: Colors.black),
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildCurrentPage(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF5A623),
        child: const Icon(Icons.shopping_cart),
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const CartPage()));
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return _buildPromosPage();
      case 2:
        return _buildCartPage();
      case 3:
        return _buildOrdersPage();
      case 4:
        return _buildFavoritesPage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return BlocConsumer<ProductCubit, ProductState>(
      listener: (context, state) {
        if (state is ProductError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
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
          final products = state.products;
          return _buildProductGrid(products);
        }

        return Center(
          child: ElevatedButton(
            onPressed: () => context.read<ProductCubit>().loadProducts(),
            child: const Text('Cargar Productos'),
          ),
        );
      },
    );
  }

  Widget _buildProductGrid(List<ProductEntity> products) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;

      int crossAxisCount;
      double childAspectRatio;

      if (width < 600) {
        // 📱 Teléfonos
        crossAxisCount = 2;
        childAspectRatio = 0.72;
      } else if (width < 1000) {
        // 📱 Tablets
        crossAxisCount = 3;
        childAspectRatio = 0.75;
      } else {
        // 💻 Desktop/Web
        crossAxisCount = 4;
        childAspectRatio = 0.85;
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
            child: Text(
              'Descuentos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          _buildCategories(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width < 600 ? 16 : width * 0.05,
                vertical: 16,
              ),
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: childAspectRatio,
                ),
                itemBuilder: (context, index) {
                  final entity = products[index];
                  final item = ProductItem.fromEntity(entity);
                  return _buildProductCardFromItem(item, entity);
                },
              ),
            ),
          ),
        ],
      );
    },
  );
}

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
              Text(
                'Buscar',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final selected = _selectedCategory == cat;

          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 16.0 : 8.0,
              right: index == categories.length - 1 ? 16.0 : 0,
            ),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedCategory = cat);
                if (cat == 'Todos') {
                  context.read<ProductCubit>().loadProducts();
                } else {
                  context.read<ProductCubit>().filterByCategory(cat);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: selected ? Colors.blue : Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  cat,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCardFromItem(ProductItem item, ProductEntity entity) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ProductDetailPage(product: entity)),
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
                      color: item.color,
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
                  if (item.hasDiscount)
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
                    item.name,
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
                    item.priceLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue[800],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.store,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Comprar',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
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

  Widget _buildPromosPage() {
    return const PromosPage();
  }

  Widget _buildOrdersPage() {
    return const OrdersPage();
  }
  
  Widget _buildFavoritesPage() {
      return const FavoritesPage();
  }

  Widget _buildBottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: const Color.fromRGBO(0, 0, 0, 0.08), blurRadius: 20, offset: const Offset(0, 8)),
          ],
        ),
        child: BottomNavCustom(
          selectedIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          onCartTap: () => setState(() => _currentIndex = 2),
        ),
      ),
    );
  }

  Widget _buildCartPage() {
    return const CartPage();
  }
}
