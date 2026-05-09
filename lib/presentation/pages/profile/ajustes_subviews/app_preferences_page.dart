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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(
          'Preferencias',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: isDarkMode ? const Color(0xFF1B1B1B) : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        elevation: 0,
      ),
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: Text(
              'Modo oscuro',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Text(
              'Activa el tema oscuro de la aplicación',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            value: prefs.darkMode,
            onChanged: (val) => prefs.toggleDarkMode(val),
            activeThumbColor: const Color(0xFF4B2AAD),
          ),
          Divider(color: isDarkMode ? Colors.grey[700] : Colors.grey[300]),
          SwitchListTile(
            title: Text(
              'Reproducción automática',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Text(
              'Recarga el catálogo automáticamente al volver a Inicio',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            value: prefs.autoPlay,
            onChanged: (val) => prefs.toggleAutoPlay(val),
            activeThumbColor: const Color(0xFF4B2AAD),
          ),
          Divider(color: isDarkMode ? Colors.grey[700] : Colors.grey[300]),
          SwitchListTile(
            title: Text(
              'Mantener historial de búsqueda',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Text(
              'Guarda tus búsquedas anteriores',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            value: prefs.keepSearchHistory,
            onChanged: (val) => prefs.toggleKeepSearchHistory(val),
            activeThumbColor: const Color(0xFF4B2AAD),
          ),
          Divider(color: isDarkMode ? Colors.grey[700] : Colors.grey[300]),
          SwitchListTile(
            title: Text(
              'Recomendaciones personalizadas',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Text(
              'Recibe sugerencias basadas en tus gustos',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            value: prefs.personalizedRecommendations,
            onChanged: (val) => prefs.togglePersonalizedRecommendations(val),
            activeThumbColor: const Color(0xFF4B2AAD),
          ),
          Divider(color: isDarkMode ? Colors.grey[700] : Colors.grey[300]),
          ListTile(
            title: Text(
              'Idioma',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Text(
              prefs.languageLabel,
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                  title: Text(
                    'Selecciona un idioma',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: ['Español', 'English', 'Português'].map((lang) {
                      final value = switch (lang) {
                        'English' => 'en',
                        'Português' => 'pt',
                        _ => 'es',
                      };
                      return RadioListTile(
                        title: Text(
                          lang,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
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
