import 'package:flutter/material.dart';

import 'package:unimarket/constants/app_colors.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool notificacionesEmail = false;
  bool notificacionesPromos = true;
  bool notificacionesPedidos = true;
  bool recordatoriosCarrito = false;
  bool resumenSemanal = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F3FF),
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Notificaciones',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors.purpleGradient),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeaderCard(),
          const SizedBox(height: 16),
          _buildSectionTitle(
            'Canales principales',
            'Elige dónde quieres recibir las alertas más importantes.',
          ),
          const SizedBox(height: 12),
          _buildToggleCard(
            icon: Icons.email_outlined,
            title: 'Notificaciones por email',
            subtitle: 'Recibe alertas en tu correo',
            value: notificacionesEmail,
            onChanged: (val) => setState(() => notificacionesEmail = val),
          ),
          const SizedBox(height: 12),
          _buildToggleCard(
            icon: Icons.shopping_bag_outlined,
            title: 'Actualizaciones de pedidos',
            subtitle: 'Cambios de estado, despacho y entrega',
            value: notificacionesPedidos,
            onChanged: (val) => setState(() => notificacionesPedidos = val),
          ),
          const SizedBox(height: 20),
          _buildSectionTitle(
            'Promociones y recordatorios',
            'Mantén el control de ofertas, carritos y novedades.',
          ),
          const SizedBox(height: 12),
          _buildToggleCard(
            icon: Icons.local_offer_outlined,
            title: 'Promociones y ofertas',
            subtitle: 'Descuentos, campañas y lanzamientos',
            value: notificacionesPromos,
            onChanged: (val) => setState(() => notificacionesPromos = val),
          ),
          const SizedBox(height: 12),
          _buildToggleCard(
            icon: Icons.shopping_cart_outlined,
            title: 'Recordatorios de carrito',
            subtitle: 'Te avisamos si dejas productos pendientes',
            value: recordatoriosCarrito,
            onChanged: (val) => setState(() => recordatoriosCarrito = val),
          ),
          const SizedBox(height: 12),
          _buildToggleCard(
            icon: Icons.event_note_outlined,
            title: 'Resumen semanal',
            subtitle: 'Un resumen con actividad y recomendaciones',
            value: resumenSemanal,
            onChanged: (val) => setState(() => resumenSemanal = val),
          ),
          const SizedBox(height: 20),
          _buildInfoCard(),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.purpleGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.22),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.notifications_active_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Administra tus alertas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Ajusta qué avisos quieres recibir para mantener una experiencia más clara y útil.',
                  style: TextStyle(
                    color: Colors.white,
                    height: 1.35,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
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

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightPanel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withOpacity(0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Puedes volver a esta pantalla cuando quieras para adaptar las notificaciones a tu rutina de compra.',
              style: TextStyle(
                color: Colors.grey.shade800,
                height: 1.35,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
