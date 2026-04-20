import 'package:flutter/material.dart';

class PrivacySecurityPage extends StatefulWidget {
  const PrivacySecurityPage({super.key});

  @override
  State<PrivacySecurityPage> createState() => _PrivacySecurityPageState();
}

class _PrivacySecurityPageState extends State<PrivacySecurityPage> {
  bool perfilPublico = false;
  bool mostrarUbicacion = true;
  bool permitirContacto = true;
  bool autenticacionDos = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(
          'Privacidad y Seguridad',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Perfil público'),
            subtitle: const Text('Otros usuarios pueden ver tu perfil'),
            value: perfilPublico,
            onChanged: (val) => setState(() => perfilPublico = val),
            activeThumbColor: const Color(0xFF4B2AAD),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Mostrar ubicación'),
            subtitle: const Text('Compartir ubicación con emprendedores'),
            value: mostrarUbicacion,
            onChanged: (val) => setState(() => mostrarUbicacion = val),
            activeThumbColor: const Color(0xFF4B2AAD),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Permitir contacto'),
            subtitle: const Text('Que otros usuarios puedan contactarte'),
            value: permitirContacto,
            onChanged: (val) => setState(() => permitirContacto = val),
            activeThumbColor: const Color(0xFF4B2AAD),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Autenticación de dos factores'),
            subtitle: const Text('Mayor seguridad en tu cuenta'),
            value: autenticacionDos,
            onChanged: (val) => setState(() => autenticacionDos = val),
            activeThumbColor: const Color(0xFF4B2AAD),
          ),
        ],
      ),
    );
  }
}
