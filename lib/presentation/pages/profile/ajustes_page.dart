import 'package:flutter/material.dart';
import '../../viewmodels/profile/settings_viewmodel.dart';

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
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Notificaciones'),
            value: vm.notifications,
            onChanged: vm.toggleNotifications,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          const Divider(height: 1, thickness: 0.6, indent: 20, endIndent: 20),
          SwitchListTile(
            title: const Text('Preferencias de pedidos'),
            value: vm.orderPreferences,
            onChanged: vm.toggleOrderPreferences,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          const Divider(height: 1, thickness: 0.6, indent: 20, endIndent: 20),
          SwitchListTile(
            title: const Text('Privacidad y Seguridad'),
            value: vm.privacyAndSecurity,
            onChanged: vm.togglePrivacyAndSecurity,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          const Divider(height: 1, thickness: 0.6, indent: 20, endIndent: 20),
          ListTile(
            title: const Text('Legal y politicas'),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            onTap: () {},
            minVerticalPadding: 18,
          ),
          const Divider(height: 1, thickness: 0.6, indent: 20, endIndent: 20),
          SwitchListTile(
            title: const Text('Preferencias de la app'),
            value: vm.appPreferences,
            onChanged: vm.toggleAppPreferences,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          ),
        ],
      ),
    );
  }
}
