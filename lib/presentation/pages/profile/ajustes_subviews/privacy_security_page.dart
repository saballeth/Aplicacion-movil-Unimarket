import 'package:flutter/material.dart';

import 'package:unimarket/constants/app_colors.dart';
import 'package:unimarket/core/injection_container.dart';
import 'package:unimarket/presentation/viewmodels/profile/privacy_security_controller.dart';

class PrivacySecurityPage extends StatefulWidget {
  const PrivacySecurityPage({super.key});

  @override
  State<PrivacySecurityPage> createState() => _PrivacySecurityPageState();
}

class _PrivacySecurityPageState extends State<PrivacySecurityPage> {
  late final PrivacySecurityController prefs;

  @override
  void initState() {
    super.initState();
    prefs = sl<PrivacySecurityController>();
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
    return Scaffold(
      backgroundColor: const Color(0xFFF6F3FF),
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Privacidad y Seguridad',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
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
            'Visibilidad',
            'Controla qué información puede verse desde tu cuenta.',
          ),
          const SizedBox(height: 12),
          _buildToggleCard(
            icon: Icons.visibility_outlined,
            title: 'Perfil público',
            subtitle: 'Otros usuarios pueden ver tu perfil',
            value: prefs.publicProfile,
            onChanged: (val) async {
              await prefs.setPublicProfile(val);
              _showActionFeedback(
                context,
                val
                    ? 'Tu perfil ahora es público.'
                    : 'Tu perfil quedó restringido.',
              );
            },
          ),
          const SizedBox(height: 12),
          _buildToggleCard(
            icon: Icons.location_on_outlined,
            title: 'Mostrar ubicación',
            subtitle: 'Compartir ubicación con emprendedores',
            value: prefs.showLocation,
            onChanged: (val) async {
              await prefs.setShowLocation(val);
              _showActionFeedback(
                context,
                val
                    ? 'La ubicación se compartirá en pantallas que la usan.'
                    : 'La ubicación quedó oculta en la cuenta.',
              );
            },
          ),
          const SizedBox(height: 20),
          _buildSectionTitle(
            'Contacto y seguridad',
            'Define cómo pueden escribirte y el nivel de protección de tu cuenta.',
          ),
          const SizedBox(height: 12),
          _buildToggleCard(
            icon: Icons.chat_bubble_outline,
            title: 'Permitir contacto',
            subtitle: 'Que otros usuarios puedan contactarte',
            value: prefs.allowContact,
            onChanged: (val) async {
              await prefs.setAllowContact(val);
              _showActionFeedback(
                context,
                val
                    ? 'El contacto con otros usuarios está habilitado.'
                    : 'El contacto quedó deshabilitado.',
              );
            },
          ),
          const SizedBox(height: 12),
          _buildToggleCard(
            icon: Icons.shield_outlined,
            title: 'Autenticación de dos factores',
            subtitle: 'Mayor seguridad en tu cuenta',
            value: prefs.twoFactorAuthentication,
            onChanged: (val) async {
              if (val) {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Activar verificación en dos pasos'),
                    content: const Text(
                      'Esta opción agregará una capa extra de seguridad a tu cuenta. En esta versión se guarda la preferencia y se simula el flujo de activación.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext, false),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(dialogContext, true),
                        child: const Text('Activar'),
                      ),
                    ],
                  ),
                );

                if (confirmed != true) {
                  return;
                }
              }

              await prefs.setTwoFactorAuthentication(val);
              _showActionFeedback(
                context,
                val
                    ? 'La verificación en dos pasos fue activada.'
                    : 'La verificación en dos pasos fue desactivada.',
              );
            },
          ),
          const SizedBox(height: 20),
          _buildInfoCard(),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    final statusText = prefs.publicProfile
        ? 'Perfil visible para otros usuarios.'
        : 'Perfil privado y más restringido.';
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
              Icons.lock_outline,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Privacidad bajo control',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  statusText,
                  style: const TextStyle(
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
              'Estas opciones se guardan en el dispositivo y modifican la forma en que la app muestra tu información y protege tu cuenta.',
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

  void _showActionFeedback(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
