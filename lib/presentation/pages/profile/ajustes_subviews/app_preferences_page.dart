import 'package:flutter/material.dart';

import 'package:unimarket/core/injection_container.dart';
import 'package:unimarket/presentation/viewmodels/profile/app_preferences_controller.dart';

class AppPreferencesPage extends StatefulWidget {
  const AppPreferencesPage({super.key});

  @override
  State<AppPreferencesPage> createState() => _AppPreferencesPageState();
}

class _AppPreferencesPageState extends State<AppPreferencesPage> {
  late final AppPreferencesController prefs;

  @override
  void initState() {
    super.initState();
    prefs = sl<AppPreferencesController>();
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
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(
          'Preferencias',
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
            title: const Text('Modo oscuro'),
            subtitle: const Text('Activa el tema oscuro de la aplicación'),
            value: prefs.darkMode,
            onChanged: (val) => prefs.toggleDarkMode(val),
            activeThumbColor: const Color(0xFF4B2AAD),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Reproducción automática'),
            subtitle: const Text('Recarga el catálogo automáticamente al volver a Inicio'),
            value: prefs.autoPlay,
            onChanged: (val) => prefs.toggleAutoPlay(val),
            activeThumbColor: const Color(0xFF4B2AAD),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Mantener historial de búsqueda'),
            subtitle: const Text('Guarda tus búsquedas anteriores'),
            value: prefs.keepSearchHistory,
            onChanged: (val) => prefs.toggleKeepSearchHistory(val),
            activeThumbColor: const Color(0xFF4B2AAD),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Recomendaciones personalizadas'),
            subtitle: const Text('Recibe sugerencias basadas en tus gustos'),
            value: prefs.personalizedRecommendations,
            onChanged: (val) => prefs.togglePersonalizedRecommendations(val),
            activeThumbColor: const Color(0xFF4B2AAD),
          ),
          const Divider(),
          ListTile(
            title: const Text('Tamaño de texto'),
            subtitle: Text(prefs.textSize),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Selecciona el tamaño de texto'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: ['Pequeño', 'Normal', 'Grande', 'Muy grande'].map((tam) {
                      return RadioListTile(
                        title: Text(tam),
                        value: tam,
                        groupValue: prefs.textSize,
                        onChanged: (val) {
                          prefs.setTextSize(val!);
                          Navigator.pop(ctx);
                        },
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Idioma'),
            subtitle: Text(prefs.languageLabel),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Selecciona un idioma'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: ['Español', 'English', 'Português'].map((lang) {
                      final value = switch (lang) {
                        'English' => 'en',
                        'Português' => 'pt',
                        _ => 'es',
                      };
                      return RadioListTile(
                        title: Text(lang),
                        value: value,
                        groupValue: prefs.languageCode,
                        onChanged: (val) {
                          prefs.setLanguage(val!);
                          Navigator.pop(ctx);
                        },
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
