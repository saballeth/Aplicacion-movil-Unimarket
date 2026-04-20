import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool notificacionesEmail = false;
  bool notificacionesPromos = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(
          'Notificaciones',
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
            title: const Text('Notificaciones por Email'),
            subtitle: const Text('Recibe alertas en tu correo'),
            value: notificacionesEmail,
            onChanged: (val) => setState(() => notificacionesEmail = val),
            activeThumbColor: const Color(0xFF4B2AAD),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Promociones y Ofertas'),
            subtitle: const Text('Enteráte de descuentos y promociones'),
            value: notificacionesPromos,
            onChanged: (val) => setState(() => notificacionesPromos = val),
            activeThumbColor: const Color(0xFF4B2AAD),
          ),
        ],
      ),
    );
  }
}
