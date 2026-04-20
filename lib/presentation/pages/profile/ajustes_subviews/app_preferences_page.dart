import 'package:flutter/material.dart';

class AppPreferencesPage extends StatefulWidget {
  const AppPreferencesPage({super.key});

  @override
  State<AppPreferencesPage> createState() => _AppPreferencesPageState();
}

class _AppPreferencesPageState extends State<AppPreferencesPage> {
  bool modoOscuro = false;
  bool autoPlay = true;
  bool mantenerHistorial = true;
  bool recomendaciones = true;
  String idioma = 'Español';
  String tamanoTexto = 'Normal';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(
          'Preferencias de la App',
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
            subtitle: const Text('Activa el tema oscuro'),
            value: modoOscuro,
            onChanged: (val) => setState(() => modoOscuro = val),
            activeThumbColor: const Color(0xFF4B2AAD),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Reproducción automática'),
            subtitle: const Text('Reproducir videos de forma automática'),
            value: autoPlay,
            onChanged: (val) => setState(() => autoPlay = val),
            activeThumbColor: const Color(0xFF4B2AAD),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Mantener historial de búsqueda'),
            subtitle: const Text('Guarda tus búsquedas anteriores'),
            value: mantenerHistorial,
            onChanged: (val) => setState(() => mantenerHistorial = val),
            activeThumbColor: const Color(0xFF4B2AAD),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Recomendaciones personalizadas'),
            subtitle: const Text('Recibe sugerencias basadas en tus gustos'),
            value: recomendaciones,
            onChanged: (val) => setState(() => recomendaciones = val),
            activeThumbColor: const Color(0xFF4B2AAD),
          ),
          const Divider(),
          ListTile(
            title: const Text('Tamaño de texto'),
            subtitle: Text(tamanoTexto),
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
                        groupValue: tamanoTexto,
                        onChanged: (val) {
                          setState(() => tamanoTexto = val!);
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
            subtitle: Text(idioma),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Selecciona un idioma'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: ['Español', 'English', 'Português'].map((lang) {
                      return RadioListTile(
                        title: Text(lang),
                        value: lang,
                        groupValue: idioma,
                        onChanged: (val) {
                          setState(() => idioma = val!);
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
