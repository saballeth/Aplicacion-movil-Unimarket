import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimarket/presentation/pages/search/search_page.dart';
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
import 'package:unimarket/presentation/viewmodels/orders/orders_cubit.dart';
import 'package:unimarket/presentation/viewmodels/orders/orders_state.dart';
import 'package:unimarket/presentation/viewmodels/profile/profile_cubit.dart';
import 'package:unimarket/presentation/viewmodels/profile/profile_state.dart';
import 'package:unimarket/presentation/viewmodels/login/login_cubit.dart';
import 'package:unimarket/presentation/viewmodels/product/product_cubit.dart';
import '../viewmodels/addresses/addresses_viewmodel.dart';
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
  final AddressesViewModel _addrVm = sl<AddressesViewModel>();
  late final OrdersCubit _ordersCubit;
  int _pendingOrders = 0;
  late final ProfileCubit _profileCubit;
  String _userName = '';
  
  // Filter variables
  double _minPrice = 0;
  double _maxPrice = 500;
  double _selectedMinPrice = 0;
  double _selectedMaxPrice = 500;
  bool _onlyDiscounted = false;
  double _minRating = 0;

  @override
  void initState() {
    super.initState();
    _addrVm.addListener(_onAddressChanged);
    _ordersCubit = OrdersCubit()..loadOrders();
    _ordersCubit.stream.listen((s) {
      if (s is OrdersLoaded) {
        final pending = s.orders
            .where((o) => o.status.toLowerCase() != 'entregado')
            .length;
        setState(() => _pendingOrders = pending);
      }
    });
    _profileCubit = ProfileCubit();
    _profileCubit.loadProfile();
    _profileCubit.stream.listen((s) {
      if (s is ProfileLoaded) setState(() => _userName = s.user.name);
    });
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

  void _onAddressChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const OrdersPage())),
          icon: Stack(
            children: [
              const Icon(Icons.notifications_none, color: Colors.black),
              if (_pendingOrders > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$_pendingOrders',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const ProfilePage())),
            icon: const Icon(Icons.person, color: Colors.black),
          ),
        ],
        // original leading/actions removed in favor of custom bell/profile
      ),
      body: _buildCurrentPage(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  @override
  void dispose() {
    _addrVm.removeListener(_onAddressChanged);
    super.dispose();
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Hola. ${_userName.isNotEmpty ? _userName : ''}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchPage()),
              );
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 8),
                    const Expanded(child: Text('Buscar productos...')),
                    IconButton(
                      onPressed: _showFiltersBottomSheet,
                      icon: const Icon(Icons.filter_list),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Promo banner
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Promociona tu emprendimiento',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Agrega una promoción y llega a más clientes'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B2AAD),
                    ),
                    child: const Text('Agregar'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Popular entrepreneurs (horizontal)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Emprendimientos populares',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text('Ver todo', style: TextStyle(color: Colors.blue)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: products.length >= 6 ? 6 : products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return Container(
                width: 220,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          p.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Categories title and selector

        // Comidas destacables
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Comidas destacables',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text('Ver todo', style: TextStyle(color: Colors.blue)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: products.where((p) => p.category.toLowerCase().contains('comida')).length.clamp(0, 6),
            itemBuilder: (context, index) {
              final p = products.where((p) => p.category.toLowerCase().contains('comida')).toList()[index];
              return _buildCategoryProductCard(p);
            },
          ),
        ),
        const SizedBox(height: 16),

        // Ropa destacable
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Ropa destacable',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text('Ver todo', style: TextStyle(color: Colors.blue)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: products.where((p) => p.category.toLowerCase().contains('ropa')).length.clamp(0, 6),
            itemBuilder: (context, index) {
              final p = products.where((p) => p.category.toLowerCase().contains('ropa')).toList()[index];
              return _buildCategoryProductCard(p);
            },
          ),
        ),
        const SizedBox(height: 16),

        // Accesorios destacables
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Accesorios destacables',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text('Ver todo', style: TextStyle(color: Colors.blue)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: products.where((p) => p.category.toLowerCase().contains('accesorio')).length.clamp(0, 6),
            itemBuilder: (context, index) {
              final p = products.where((p) => p.category.toLowerCase().contains('accesorio')).toList()[index];
              return _buildCategoryProductCard(p);
            },
          ),
        ),
        const SizedBox(height: 16),

        // Título Descuentos
        const Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
          child: Text(
            'Descuentos',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),

        // Categorías horizontal
        SizedBox(
          height: 40,
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
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
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
        ),

        // Grid de productos
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length > 8 ? 8 : products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final entity = products[index];
              final item = ProductItem.fromEntity(entity);
              return _buildProductCardFromItem(item, entity);
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
      ),
    );
  }

  Widget _buildCategoryProductCard(ProductEntity product) {
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
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
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
              child: const Icon(Icons.shopping_bag, size: 40, color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('\$${product.price}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue[800])),
                ],
              ),
            ),
          ],
        ),
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
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
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

  void _showFiltersBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filtros',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Price Range Filter
                    const Text(
                      'Rango de Precio',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    RangeSlider(
                      values: RangeValues(_selectedMinPrice, _selectedMaxPrice),
                      min: 0,
                      max: 500,
                      divisions: 50,
                      labels: RangeLabels(
                        '\$${_selectedMinPrice.toStringAsFixed(0)}',
                        '\$${_selectedMaxPrice.toStringAsFixed(0)}',
                      ),
                      onChanged: (RangeValues values) {
                        setModalState(() {
                          _selectedMinPrice = values.start;
                          _selectedMaxPrice = values.end;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Only Discounted
                    CheckboxListTile(
                      title: const Text('Solo con descuento'),
                      value: _onlyDiscounted,
                      activeColor: const Color(0xFF4B2AAD),
                      onChanged: (value) {
                        setModalState(() {
                          _onlyDiscounted = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Rating Filter
                    const Text(
                      'Calificación Mínima',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: _minRating,
                            min: 0,
                            max: 5,
                            divisions: 5,
                            label: _minRating.toStringAsFixed(1),
                            activeColor: Colors.amber,
                            onChanged: (value) {
                              setModalState(() {
                                _minRating = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            Text(_minRating.toStringAsFixed(1)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setModalState(() {
                                _selectedMinPrice = 0;
                                _selectedMaxPrice = 500;
                                _onlyDiscounted = false;
                                _minRating = 0;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.black,
                            ),
                            child: const Text('Limpiar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                // Apply filters
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4B2AAD),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Aplicar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
