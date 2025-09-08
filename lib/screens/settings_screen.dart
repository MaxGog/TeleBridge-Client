import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final Map<String, dynamic> settings;
  final Function(Map<String, dynamic>) onSettingsChanged;

  const SettingsScreen({super.key, required this.settings, required this.onSettingsChanged});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Map<String, dynamic> _currentSettings;

  @override
  void initState() {
    super.initState();
    _currentSettings = Map<String, dynamic>.from(widget.settings);
  }

  void _saveSettings() {
    widget.onSettingsChanged(_currentSettings);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Тема'),
            trailing: DropdownButton<String>(
              value: _currentSettings['theme'],
              onChanged: (value) {
                setState(() {
                  _currentSettings['theme'] = value;
                });
              },
              items: const [
                DropdownMenuItem(value: 'system', child: Text('Системная')),
                DropdownMenuItem(value: 'light', child: Text('Светлая')),
                DropdownMenuItem(value: 'dark', child: Text('Тёмная')),
              ],
            ),
          ),
          SwitchListTile(
            title: const Text('Уведомления'),
            value: _currentSettings['notificationEnabled'],
            onChanged: (value) {
              setState(() {
                _currentSettings['notificationEnabled'] = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Авто-загрузка медиа'),
            value: _currentSettings['mediaAutoDownload'],
            onChanged: (value) {
              setState(() {
                _currentSettings['mediaAutoDownload'] = value;
              });
            },
          ),
          ListTile(
            title: const Text('О приложении'),
            subtitle: const Text('MaterialGram Client v1.0.0'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'MaterialGram Client',
                applicationVersion: '1.0.0',
              );
            },
          ),
        ],
      ),
    );
  }
}