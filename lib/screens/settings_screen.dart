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

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'О приложении',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MaterialGram Client',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Версия 1.0.0',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Клиент для работы с Telegram API с современным интерфейсом '
              'в стиле Material Design 3.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Настройки',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 3,
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: colorScheme.primary),
            onPressed: _saveSettings,
            tooltip: 'Сохранить настройки',
          ),
        ],
      ),
      body: Material(
        color: colorScheme.surface,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок раздела внешнего вида
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Text(
                  'Внешний вид',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ),

              // Настройка темы
              _buildSettingsCard(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.palette_outlined,
                      color: colorScheme.primary,
                    ),
                    title: Text(
                      'Тема приложения',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      'Выберите preferred тему интерфейса',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: DropdownButton<String>(
                      value: _currentSettings['theme'],
                      onChanged: (value) {
                        setState(() {
                          _currentSettings['theme'] = value;
                        });
                      },
                      dropdownColor: colorScheme.surfaceContainer,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'system',
                          child: Text('Системная'),
                        ),
                        DropdownMenuItem(
                          value: 'light',
                          child: Text('Светлая'),
                        ),
                        DropdownMenuItem(
                          value: 'dark',
                          child: Text('Тёмная'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Заголовок раздела уведомлений
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                child: Text(
                  'Уведомления',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ),

              // Настройки уведомлений
              _buildSettingsCard(
                children: [
                  SwitchListTile(
                    value: _currentSettings['notificationEnabled'],
                    onChanged: (value) {
                      setState(() {
                        _currentSettings['notificationEnabled'] = value;
                      });
                    },
                    activeColor: colorScheme.primary,
                    activeTrackColor: colorScheme.primary.withOpacity(0.3),
                    inactiveTrackColor: colorScheme.outline.withOpacity(0.3),
                    title: Text(
                      'Уведомления',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      'Включить push-уведомления',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    secondary: Icon(
                      _currentSettings['notificationEnabled']
                          ? Icons.notifications_active
                          : Icons.notifications_off,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),

              // Заголовок раздела медиа
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                child: Text(
                  'Медиа',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ),

              // Настройки медиа
              _buildSettingsCard(
                children: [
                  SwitchListTile(
                    value: _currentSettings['mediaAutoDownload'],
                    onChanged: (value) {
                      setState(() {
                        _currentSettings['mediaAutoDownload'] = value;
                      });
                    },
                    activeColor: colorScheme.primary,
                    activeTrackColor: colorScheme.primary.withOpacity(0.3),
                    inactiveTrackColor: colorScheme.outline.withOpacity(0.3),
                    title: Text(
                      'Авто-загрузка медиа',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      'Автоматически загружать изображения и видео',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    secondary: Icon(
                      Icons.download,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),

              // Заголовок раздела информации
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                child: Text(
                  'Информация',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ),

              // Информация о приложении
              _buildSettingsCard(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: colorScheme.primary,
                    ),
                    title: Text(
                      'О приложении',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      'MaterialGram Client v1.0.0',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onTap: _showAboutDialog,
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      color: theme.colorScheme.surfaceContainerLow,
      child: Column(
        children: children,
      ),
    );
  }
}