import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimarket/core/injection_container.dart';
import '../../viewmodels/profile/profile_cubit.dart';
import '../../viewmodels/profile/profile_state.dart';
// orders page import removed; option no longer shown in profile

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileCubit>()..loadProfile(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProfileFailure) {
            return Center(child: Text(state.message));
          }
          if (state is ProfileLoaded) {
            final user = state.user;
            return _buildBody(context, user.name, user.email);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Perfil',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      actions: [
        IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {}),
      ],
    );
  }

  Widget _buildBody(BuildContext context, String name, String email) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información del usuario
            _buildUserInfo(name, email),
            const SizedBox(height: 24),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 24),
            // Opciones del menú
            _buildMenuOptions(context),
            const SizedBox(height: 32),
            // Botón de cerrar sesión
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(String name, String email) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Color.fromRGBO(245, 166, 35, 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person, size: 40, color: Color(0xFFF5A623)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Ver perfil completo',
                  style: TextStyle(
                    color: Color(0xFFF5A623),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.edit_outlined, color: Color(0xFFF5A623)),
        ),
      ],
    );
  }

  Widget _buildMenuOptions(BuildContext context) {
    final List<MenuItem> menuItems = [
      // 'Mis pedidos' removed from menu
      MenuItem(
        title: 'Quiero ser emprendedor/a',
        icon: Icons.business_center_outlined,
        hasBadge: false,
        badgeCount: 0,
      ),
      MenuItem(
        title: 'Editar perfil',
        icon: Icons.person_outline,
        hasBadge: false,
        badgeCount: 0,
      ),
      MenuItem(
        title: 'Ayuda',
        icon: Icons.help_outline,
        hasBadge: false,
        badgeCount: 0,
      ),
      MenuItem(
        title: 'Ajustes',
        icon: Icons.settings_outlined,
        hasBadge: false,
        badgeCount: 0,
      ),
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menuItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildMenuItem(context, menuItems[index]);
      },
    );
  }

  Widget _buildMenuItem(BuildContext context, MenuItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleMenuItemTap(context, item.title),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(item.icon, color: const Color(0xFFF5A623), size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                if (item.hasBadge && item.badgeCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5A623),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${item.badgeCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: Colors.grey, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red.shade400, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showLogoutConfirmation(context),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: Colors.red.shade400, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Cerrar Sesión',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleMenuItemTap(BuildContext context, String title) {
    switch (title) {
      // 'Mis pedidos' navigation removed (option not present)
      case 'Quiero ser emprendedor/a':
        break;
      case 'Editar perfil':
        break;
      case 'Ayuda':
        break;
      case 'Ajustes':
        break;
    }
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Cerrar Sesión',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          '¿Estás seguro de que quieres cerrar sesión?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItem {
  final String title;
  final IconData icon;
  final bool hasBadge;
  final int badgeCount;

  MenuItem({
    required this.title,
    required this.icon,
    required this.hasBadge,
    required this.badgeCount,
  });
}

// Placeholder removed; navigation now uses real OrdersPage
