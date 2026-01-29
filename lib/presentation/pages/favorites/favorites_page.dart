import 'package:flutter/material.dart';
import '../../viewmodels/favorites/favorites_viewmodel.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoritesViewModel vm = FavoritesViewModel();

  @override
  void initState() {
    super.initState();
    vm.addListener(_vmChanged);
  }

  void _vmChanged() => setState(() {});

  @override
  void dispose() {
    vm.removeListener(_vmChanged);
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        '9:41',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 1,
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBody() {
    final items = vm.items;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 12),
                    Text(
                      'Buscar',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Favoritos',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Filtros',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 24),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) => const Divider(height: 32, color: Colors.grey),
              itemBuilder: (context, index) {
                final it = items[index];
                return _buildFavoriteItem(it);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteItem(FavoriteItemModel item) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: item.isFood ? const Color.fromRGBO(245, 166, 35, 0.1) : Colors.blue.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.isFood ? Icons.restaurant : Icons.shopping_bag, size: 40, color: item.isFood ? const Color(0xFFF5A623) : Colors.blue),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.storeName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),

                  if (item.productName != null) ...[
                    const SizedBox(height: 4),
                    Text(item.productName!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
                  ],

                  if (item.price != null) ...[
                    const SizedBox(height: 8),
                    Text('\$ ${item.price!.toStringAsFixed(0).replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),(Match m) => '${m[1]}.')}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                  ],

                  if (item.rating != null && item.reviewCount != null) ...[
                    const SizedBox(height: 8),
                    Row(children: [
                      Row(children: List.generate(5, (starIndex) => Icon(starIndex < item.rating!.floor() ? Icons.star : Icons.star_border, size: 16, color: const Color(0xFFF5A623)))),
                      const SizedBox(width: 4),
                      Text('${item.rating!.toStringAsFixed(1)} (${item.reviewCount})', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                    ]),
                  ],

                  if (item.price == null && item.rating == null) ...[
                    const SizedBox(height: 8),
                    Text(item.productName ?? '', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                  ],
                ],
              ),
            ),

            IconButton(
              onPressed: () => vm.remove(item.id),
              icon: const Icon(Icons.favorite, color: Colors.red, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 3,
      onTap: (index) {},
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFFF5A623),
      unselectedItemColor: Colors.grey.shade600,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
      elevation: 4,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.local_offer_outlined), activeIcon: Icon(Icons.local_offer), label: 'Promos'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), activeIcon: Icon(Icons.shopping_bag), label: 'Pedidos'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_outlined), activeIcon: Icon(Icons.favorite), label: 'Favoritos'),
      ],
    );
  }
}
