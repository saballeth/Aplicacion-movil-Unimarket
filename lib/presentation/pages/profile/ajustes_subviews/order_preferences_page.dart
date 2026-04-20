import 'package:flutter/material.dart';

class OrderPreferencesPage extends StatefulWidget {
  const OrderPreferencesPage({super.key});

  @override
  State<OrderPreferencesPage> createState() => _OrderPreferencesPageState();
}

class _OrderPreferencesPageState extends State<OrderPreferencesPage> {
  bool mostrarPedidosAntiguos = true;
  bool agruparPorEmprendimiento = true;
  bool notificarEstimadoLlegada = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(
          'Preferencias de Pedidos',
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
            title: const Text('Mostrar pedidos antiguos'),
            subtitle: const Text('Ver el historial de pedidos pasados'),
            value: mostrarPedidosAntiguos,
            onChanged: (val) => setState(() => mostrarPedidosAntiguos = val),
            activeThumbColor: const Color(0xFF4B2AAD),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Agrupar por emprendimiento'),
            subtitle: const Text('Organizar pedidos por vendedor'),
            value: agruparPorEmprendimiento,
            onChanged: (val) => setState(() => agruparPorEmprendimiento = val),
            activeThumbColor: const Color(0xFF4B2AAD),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Notificar tiempo estimado'),
            subtitle: const Text('Recibir estimaciones de entrega'),
            value: notificarEstimadoLlegada,
            onChanged: (val) => setState(() => notificarEstimadoLlegada = val),
            activeThumbColor: const Color(0xFF4B2AAD),
          ),
        ],
      ),
    );
  }
}
