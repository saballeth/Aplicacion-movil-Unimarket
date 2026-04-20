import 'package:flutter/material.dart';
import '../../viewmodels/profile/settings_viewmodel.dart';
import 'ajustes_subviews/notifications_page.dart';
import 'ajustes_subviews/order_preferences_page.dart';
import 'ajustes_subviews/privacy_security_page.dart';
import 'ajustes_subviews/app_preferences_page.dart';

class AjustesPage extends StatefulWidget {
  const AjustesPage({super.key});

  @override
  State<AjustesPage> createState() => _AjustesPageState();
}

class _AjustesPageState extends State<AjustesPage> {
  late final SettingsViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = SettingsViewModel();
    vm.addListener(_onVm);
    vm.load();
  }

  void _onVm() => setState(() {});

  @override
  void dispose() {
    vm.removeListener(_onVm);
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(
          'Ajustes',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMenuItem(context, 'Notificaciones', Icons.notifications_none),
              const SizedBox(height: 12),
              _buildMenuItem(context, 'Preferencias de pedidos', Icons.receipt_long),
              const SizedBox(height: 12),
              _buildMenuItem(context, 'Privacidad y Seguridad', Icons.lock_outline),
              const SizedBox(height: 12),
              _buildMenuItem(context, 'Preferencias de la app', Icons.settings),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleMenuItemTap(context, title),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF4B2AAD), size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
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

  void _handleMenuItemTap(BuildContext context, String title) {
    switch (title) {
      case 'Notificaciones':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsPage()));
        break;
      case 'Preferencias de pedidos':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OrderPreferencesPage()));
        break;
      case 'Privacidad y Seguridad':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PrivacySecurityPage()));
        break;
      case 'Preferencias de la app':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AppPreferencesPage()));
        break;
    }
  }
}
