import 'package:flutter/material.dart';

import 'package:unimarket/constants/app_colors.dart';
import 'package:unimarket/core/injection_container.dart';
import 'package:unimarket/presentation/viewmodels/profile/order_preferences_controller.dart';

class OrderPreferencesPage extends StatefulWidget {
  const OrderPreferencesPage({super.key});

  @override
  State<OrderPreferencesPage> createState() => _OrderPreferencesPageState();
}

class _OrderPreferencesPageState extends State<OrderPreferencesPage> {
  late final OrderPreferencesController prefs;

  @override
  void initState() {
    super.initState();
    prefs = sl<OrderPreferencesController>();
    prefs.addListener(_onPrefsChanged);
  }

  void _onPrefsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    prefs.removeListener(_onPrefsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF6F3FF),
      appBar: AppBar(
        leading: BackButton(color: isDarkMode ? Colors.white : Colors.white),
        title: const Text(
          'Preferencias de Pedidos',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.purpleGradient),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 16),
          _buildSectionTitle(
            'Historial',
            'Controla qué pedidos se muestran y cómo se organizan.',
            isDarkMode,
          ),
          const SizedBox(height: 12),
          _buildToggleCard(
            icon: Icons.history_outlined,
            title: 'Mostrar pedidos antiguos',
            subtitle: 'Ver el historial de pedidos pasados',
            value: prefs.showOldOrders,
            onChanged: (val) async {
              await prefs.setShowOldOrders(val);
              _showFeedback(
                context,
                val
                    ? 'El historial de pedidos estará visible.'
                    : 'Se ocultaron los pedidos antiguos en la vista.',
              );
            },
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 12),
          _buildToggleCard(
            icon: Icons.storefront_outlined,
            title: 'Agrupar por emprendimiento',
            subtitle: 'Organizar pedidos por vendedor',
            value: prefs.groupByStore,
            onChanged: (val) async {
              await prefs.setGroupByStore(val);
              _showFeedback(
                context,
                val
                    ? 'Los pedidos se agruparán por emprendimiento.'
                    : 'Los pedidos volverán a mostrarse en una sola lista.',
              );
            },
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 20),
          _buildSectionTitle(
            'Seguimiento',
            'Recibe información útil mientras un pedido está en camino.',
            isDarkMode,
          ),
          const SizedBox(height: 12),
          _buildToggleCard(
            icon: Icons.schedule_outlined,
            title: 'Notificar tiempo estimado',
            subtitle: 'Recibir estimaciones de entrega',
            value: prefs.notifyEstimatedArrival,
            onChanged: (val) async {
              await prefs.setNotifyEstimatedArrival(val);
              _showFeedback(
                context,
                val
                    ? 'Se mostrarán avisos de tiempo estimado en seguimiento.'
                    : 'Se ocultarán los avisos de tiempo estimado.',
              );
            },
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 20),
          _buildInfoCard(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: isDarkMode ? Colors.grey[400] : Colors.grey.shade600,
            height: 1.35,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDarkMode,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        secondary: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(isDarkMode ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: isDarkMode ? Colors.grey[400] : Colors.grey.shade600,
              height: 1.3,
            ),
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
        activeThumbColor: AppColors.primary,
      ),
    );
  }

  Widget _buildInfoCard(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : AppColors.lightPanel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary.withOpacity(isDarkMode ? 0.12 : 0.08),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Estas opciones se guardan en el dispositivo y se aplican en la vista de pedidos y seguimiento.',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[300] : Colors.grey.shade800,
                height: 1.35,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFeedback(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
