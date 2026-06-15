import 'package:flutter/material.dart';

typedef BottomNavTap = void Function(int index);

class BottomNavCustom extends StatelessWidget {
  final int selectedIndex;
  final BottomNavTap? onTap;
  final VoidCallback? onCartTap;
  final int cartCount;

  const BottomNavCustom({
    super.key,
    this.selectedIndex = 0,
    this.onTap,
    this.onCartTap,
    this.cartCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF4B2AAD),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Navigation items
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 90),
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _item(context, Icons.home_outlined, 'Inicio', 0),
                ),
                Expanded(
                  child: _item(
                    context,
                    Icons.local_offer_outlined,
                    'Promos',
                    1,
                  ),
                ),
                const SizedBox(width: 72), // space for center button
                Expanded(
                  child: _item(
                    context,
                    Icons.inventory_2_outlined,
                    'Pedidos',
                    3,
                  ),
                ),
                Expanded(
                  child: _item(context, Icons.favorite_border, 'Favoritos', 4),
                ),
              ],
            ),
          ),
          // Center cart button
          Positioned(
            child: GestureDetector(
              onTap: () {
                if (onCartTap != null) onCartTap!();
              },
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    height: 72,
                    width: 72,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5C542),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  if (cartCount > 0)
                    Container(
                      height: 24,
                      width: 24,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          cartCount > 99 ? '99+' : cartCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, String label, int index) {
    final bool isActive = selectedIndex == index;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap?.call(index),
        splashColor: Colors.white.withOpacity(0.1),
        highlightColor: Colors.white.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? const Color(0xFFF5C542) : Colors.white,
                size: 28,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isActive ? const Color(0xFFF5C542) : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
