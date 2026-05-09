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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(
          'Ajustes',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: isDarkMode ? const Color(0xFF1B1B1B) : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        elevation: 0,
      ),
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMenuItem(context, 'Notificaciones', Icons.notifications_none, isDarkMode),
              const SizedBox(height: 12),
              _buildMenuItem(context, 'Preferencias de pedidos', Icons.receipt_long, isDarkMode),
              const SizedBox(height: 12),
              _buildMenuItem(context, 'Privacidad y Seguridad', Icons.lock_outline, isDarkMode),
              const SizedBox(height: 12),
              _buildMenuItem(context, 'Preferencias de la app', Icons.settings, isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
        ),
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: isDarkMode ? Colors.grey.shade600 : Colors.grey,
                  size: 24,
                ),
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
