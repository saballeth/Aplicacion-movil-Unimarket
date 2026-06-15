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
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: isDarkMode ? const Color(0xFF1B1B1B) : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        elevation: 0,
      ),
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Descripción general
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Configuración General',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            // Sección Notificaciones
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildSettingCard(
                context,
                'Notificaciones',
                'Gestiona alertas y notificaciones',
                Icons.notifications_none,
                isDarkMode,
                () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const NotificationsPage()),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Sección Preferencias de Pedidos
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildSettingCard(
                context,
                'Preferencias de Pedidos',
                'Configura opciones de entrega y compra',
                Icons.receipt_long,
                isDarkMode,
                () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const OrderPreferencesPage(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Divisor
            Divider(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              height: 1,
              thickness: 1,
            ),
            const SizedBox(height: 16),
            // Descripción privacidad
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Privacidad y Seguridad',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Sección Privacidad y Seguridad
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildSettingCard(
                context,
                'Privacidad y Seguridad',
                'Protege tu cuenta y datos personales',
                Icons.lock_outline,
                isDarkMode,
                () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PrivacySecurityPage(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Divisor
            Divider(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              height: 1,
              thickness: 1,
            ),
            const SizedBox(height: 16),
            // Descripción app
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Experiencia de la Aplicación',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Sección Preferencias de la App
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildSettingCard(
                context,
                'Preferencias de la App',
                'Idioma, tema y preferencias visuales',
                Icons.settings,
                isDarkMode,
                () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AppPreferencesPage()),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool isDarkMode,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4B2AAD).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: const Color(0xFF4B2AAD), size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDarkMode
                              ? Colors.grey[400]
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  color: isDarkMode
                      ? Colors.grey.shade600
                      : Colors.grey.shade400,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
