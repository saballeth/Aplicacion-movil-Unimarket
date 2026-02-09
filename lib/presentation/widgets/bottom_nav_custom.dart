import 'package:flutter/material.dart';

typedef BottomNavTap = void Function(int index);

class BottomNavCustom extends StatelessWidget {
  final int selectedIndex;
  final BottomNavTap? onTap;
  final VoidCallback? onCartTap;

  const BottomNavCustom({
    super.key,
    this.selectedIndex = 0,
    this.onTap,
    this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Purple bar
          Container(
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFF4B2AAD),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _item(context, Icons.home_outlined, 'Inicio', 0),
                _item(context, Icons.local_offer_outlined, 'Promos', 1),
                const SizedBox(width: 40), // space for center button
                _item(context, Icons.inventory_2_outlined, 'Pedidos', 3),
                _item(context, Icons.favorite_border, 'Favoritos', 4),
              ],
            ),
          ),

          // Center cart button
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: () {
                if (onCartTap != null) onCartTap!();
              },
              child: Container(
                height: 64,
                width: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5C542),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, String label, int index) {
    final bool isActive = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTap?.call(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? const Color(0xFFF5C542) : Colors.white, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFFF5C542) : Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
