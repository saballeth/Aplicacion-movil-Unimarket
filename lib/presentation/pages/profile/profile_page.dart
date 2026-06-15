import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimarket/core/injection_container.dart';
import 'package:unimarket/domain/entities/user_role.dart';
import 'package:unimarket/presentation/viewmodels/profile/privacy_security_controller.dart';
import '../../viewmodels/profile/profile_cubit.dart';
import 'edit_profile_page.dart';
import 'ajustes_page.dart';
import 'entrepreneur_page.dart';
import '../../viewmodels/profile/profile_state.dart';
// Consumer pages
import 'consumer_pages/addresses_management_page.dart';
import 'consumer_pages/payment_methods_page.dart';
// Entrepreneur pages
import 'entrepreneur_pages/bank_data_page.dart';
import 'entrepreneur_pages/documents_page.dart';
// Admin pages
import 'admin_pages/manage_users_page.dart';
import 'admin_pages/manage_business_page.dart';
import 'admin_pages/manage_products_page.dart';
import 'admin_pages/reports_page.dart';
import 'package:unimarket/core/utils/notification_helper.dart';

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
            // Show different profile view based on user role
            switch (user.role) {
              case UserRole.consumer:
                return _buildConsumerProfile(context, user.name, user.email);
              case UserRole.entrepreneur:
                return _buildEntrepreneurProfile(
                  context,
                  user.name,
                  user.email,
                );
              case UserRole.admin:
                return _buildAdminProfile(context, user.name, user.email);
            }
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
      backgroundColor: Colors.white,
      elevation: 0,
      foregroundColor: Colors.black,
    );
  }

  // ==================== CONSUMER PROFILE WIDGETS ====================
  Widget _buildConsumerStats() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('12', 'Compras', Colors.blue)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('\$2,450', 'Gastado', Colors.green)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('4.8', 'Calificación', Colors.amber)),
      ],
    );
  }

  Widget _buildConsumerMenuOptions(BuildContext context) {
    final List<MenuItem> menuItems = [
      MenuItem(
        title: 'Mis pedidos',
        icon: Icons.shopping_bag_outlined,
        hasBadge: false,
        badgeCount: 0,
      ),
      MenuItem(
        title: 'Direcciones',
        icon: Icons.location_on_outlined,
        hasBadge: false,
        badgeCount: 0,
      ),
      MenuItem(
        title: 'Métodos de pago',
        icon: Icons.credit_card_outlined,
        hasBadge: false,
        badgeCount: 0,
      ),
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

  // ==================== ENTREPRENEUR PROFILE WIDGETS ====================
  Widget _buildBusinessInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Información del Negocio',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        _buildBusinessInfoCard('Nombre Negocio', 'Mi Emprendimiento'),
        _buildBusinessInfoCard('RUC/NIT', '12345678901'),
        _buildBusinessInfoCard('Categoría', 'Ropa y Accesorios'),
        _buildBusinessInfoCard('Banco', 'Banco del País'),
        _buildBusinessInfoCard('Cuenta Bancaria', '****2345'),
      ],
    );
  }

  Widget _buildBusinessInfoCard(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntrepreneurMenuOptions(BuildContext context) {
    final List<MenuItem> menuItems = [
      MenuItem(
        title: 'Datos bancarios',
        icon: Icons.account_balance_outlined,
        hasBadge: false,
        badgeCount: 0,
      ),
      MenuItem(
        title: 'Documentos',
        icon: Icons.description_outlined,
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

  // ==================== ADMIN PROFILE WIDGETS ====================
  Widget _buildAdminStats() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('1,234', 'Usuarios', Colors.blue)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('45', 'Negocios', Colors.purple)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('8.9K', 'Productos', Colors.orange)),
      ],
    );
  }

  Widget _buildAdminMenuOptions(BuildContext context) {
    final List<MenuItem> menuItems = [
      MenuItem(
        title: 'Gestionar usuarios',
        icon: Icons.people_outline,
        hasBadge: false,
        badgeCount: 0,
      ),
      MenuItem(
        title: 'Gestionar emprendimientos',
        icon: Icons.business_outlined,
        hasBadge: false,
        badgeCount: 0,
      ),
      MenuItem(
        title: 'Gestionar productos',
        icon: Icons.inventory_2_outlined,
        hasBadge: false,
        badgeCount: 0,
      ),
      MenuItem(
        title: 'Reportes',
        icon: Icons.assessment_outlined,
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

  Widget _buildStatCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsumerProfile(
    BuildContext context,
    String name,
    String email,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(context, name, email),
            const SizedBox(height: 24),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 24),
            // Consumer-specific stats
            _buildConsumerStats(),
            const SizedBox(height: 24),
            // Consumer menu options
            _buildConsumerMenuOptions(context),
            const SizedBox(height: 32),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEntrepreneurProfile(
    BuildContext context,
    String name,
    String email,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(context, name, email),
            const SizedBox(height: 24),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 24),
            // Entrepreneur-specific business info
            _buildBusinessInfo(),
            const SizedBox(height: 24),
            // Entrepreneur menu options
            _buildEntrepreneurMenuOptions(context),
            const SizedBox(height: 32),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminProfile(BuildContext context, String name, String email) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(context, name, email),
            const SizedBox(height: 24),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 24),
            // Admin-specific stats
            _buildAdminStats(),
            const SizedBox(height: 24),
            // Admin menu options
            _buildAdminMenuOptions(context),
            const SizedBox(height: 32),
            _buildLogoutButton(context),
          ],
        ),
      ),
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
            _buildUserInfo(context, name, email),
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

  Widget _buildUserInfo(BuildContext context, String name, String email) {
    final privacy = sl<PrivacySecurityController>();
    return AnimatedBuilder(
      animation: privacy,
      builder: (context, _) {
        return Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(75, 42, 173, 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                size: 40,
                color: Color(0xFF4B2AAD),
              ),
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
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildStatusChip(
                        privacy.publicProfile
                            ? 'Perfil público'
                            : 'Perfil privado',
                        privacy.publicProfile
                            ? Colors.green.shade600
                            : Colors.grey.shade700,
                      ),
                      _buildStatusChip(
                        privacy.twoFactorAuthentication
                            ? '2FA activa'
                            : '2FA inactiva',
                        privacy.twoFactorAuthentication
                            ? Colors.green.shade600
                            : Colors.orange.shade700,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // edit action removed (profile edited via menu item)
          ],
        );
      },
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
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
                Icon(item.icon, color: const Color(0xFF4B2AAD), size: 24),
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
                      color: const Color(0xFF4B2AAD),
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
    // Get current user role from ProfileCubit
    final profileCubit = context.read<ProfileCubit>();
    final profileState = profileCubit.state;
    final userRole = profileState is ProfileLoaded
        ? profileState.user.role
        : UserRole.consumer;

    switch (title) {
      // Consumer-specific options
      case 'Mis pedidos':
        NotificationHelper.showInfo(
          context: context,
          message: 'Abriendo mis pedidos...',
        );
        break;
      case 'Direcciones':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddressesManagementPage()),
        );
        break;
      case 'Métodos de pago':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const PaymentMethodsPage()));
        break;
      // Entrepreneur-specific options
      case 'Datos bancarios':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const BankDataPage()));
        break;
      case 'Documentos':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const DocumentsPage()));
        break;
      // Admin-specific options
      case 'Gestionar usuarios':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const ManageUsersPage()));
        break;
      case 'Gestionar emprendimientos':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const ManageBusinessPage()));
        break;
      case 'Gestionar productos':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const ManageProductsPage()));
        break;
      case 'Reportes':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const ReportsPage()));
        break;
      // Common options for all roles
      case 'Quiero ser emprendedor/a':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const EntrepreneurPage()));
        break;
      case 'Editar perfil':
        () async {
          final cubit = context.read<ProfileCubit>();
          final result = await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const EditarPerfilPage()));
          if (result is Map<String, String>) {
            cubit.updateProfile(name: result['name'], email: result['email']);
          }
        }();
        break;
      case 'Ayuda':
        NotificationHelper.showInfo(
          context: context,
          message: 'Abriendo centro de ayuda...',
        );
        break;
      case 'Ajustes':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const AjustesPage()));
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
