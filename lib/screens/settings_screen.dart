import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  String _units = 'Celsius';
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _darkMode,
            onChanged: (val) {
              setState(() {
                _darkMode = val;
              });
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Units'),
            trailing: DropdownButton<String>(
              value: _units,
              items: const [
                DropdownMenuItem(value: 'Celsius', child: Text('Celsius (°C)')),
                DropdownMenuItem(value: 'Fahrenheit', child: Text('Fahrenheit (°F)')),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _units = val;
                  });
                }
              },
            ),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: _notifications,
            onChanged: (val) {
              setState(() {
                _notifications = val;
              });
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('About'),
            subtitle: const Text('Weather Guard v1.0.0'),
          ),
        ],
      ),
    );
  }
} 