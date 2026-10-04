import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _darkMode;

  @override
  void initState() {
    super.initState();
    _darkMode = widget.isDark;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: SwitchListTile.adaptive(
              value: _darkMode,
              title: const Text('Dark mode'),
              subtitle: const Text('Switch the app theme instantly.'),
              secondary: const Icon(Icons.dark_mode_outlined),
              onChanged: (value) {
                setState(() => _darkMode = value);
                widget.onThemeChanged(value);
              },
            ),
          ),
          const SizedBox(height: 12),
          const Card(
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Weatherly'),
              subtitle: Text('UID Flutter Project • REST + Provider'),
            ),
          ),
        ],
      ),
    );
  }
}
