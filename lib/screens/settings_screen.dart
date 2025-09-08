import 'package:flutter/material.dart';

/// Экран настроек приложения
/// Позволяет пользователю настраивать различные параметры приложения
class SettingsScreen extends StatefulWidget {
  final Map<String, dynamic> settings; // Текущие настройки приложения
  final Function(Map<String, dynamic>) onSettingsChanged; // Колбэк для сохранения настроек

  const SettingsScreen({super.key, 
    required this.settings, 
    required this.onSettingsChanged
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Map<String, dynamic> _currentSettings; // Локальная копия настроек для редактирования

  @override
  void initState() {
    super.initState();
    // Создаем копию настроек для безопасного редактирования
    _currentSettings = Map<String, dynamic>.from(widget.settings);
  }

  /// Сохранение настроек и возврат на предыдущий экран
  void _saveSettings() {
    widget.onSettingsChanged(_currentSettings); // Передаем обновленные настройки
    Navigator.pop(context); // Закрываем экран настроек
  }

  /// Показ диалога с информацией о приложении
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
          // Кнопка сохранения настроек
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

              // Карточка с настройкой темы
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
                          _currentSettings['theme'] = value; // Обновляем значение темы
                        });
                      },
                      dropdownColor: colorScheme.surfaceContainer,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'system',
                          child: Text('Системная'), // Следовать системной теме
                        ),
                        DropdownMenuItem(
                          value: 'light',
                          child: Text('Светлая'), // Всегда светлая тема
                        ),
                        DropdownMenuItem(
                          value: 'dark',
                          child: Text('Тёмная'), // Всегда темная тема
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

              // Карточка с настройками уведомлений
              _buildSettingsCard(
                children: [
                  SwitchListTile(
                    value: _currentSettings['notificationEnabled'],
                    onChanged: (value) {
                      setState(() {
                        _currentSettings['notificationEnabled'] = value; // Вкл/выкл уведомления
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
                          ? Icons.notifications_active // Иконка активных уведомлений
                          : Icons.notifications_off, // Иконка отключенных уведомлений
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

              // Карточка с настройками медиа
              _buildSettingsCard(
                children: [
                  SwitchListTile(
                    value: _currentSettings['mediaAutoDownload'],
                    onChanged: (value) {
                      setState(() {
                        _currentSettings['mediaAutoDownload'] = value; // Вкл/выкл авто-загрузку
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
                      Icons.download, // Иконка загрузки
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

              // Карточка с информацией о приложении
              _buildSettingsCard(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.info_outline, // Иконка информации
                      color: colorScheme.primary,
                    ),
                    title: Text(
                      'О приложении',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      'MaterialGram Client v1.0.0', // Версия приложения
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios, // Иконка перехода
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onTap: _showAboutDialog, // Показ диалога информации
                  ),
                ],
              ),

              const SizedBox(height: 32), // Отступ внизу экрана
            ],
          ),
        ),
      ),
    );
  }

  /// Вспомогательный метод для создания карточек настроек
  Widget _buildSettingsCard({required List<Widget> children}) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      elevation: 0, // Без тени для плоского дизайна
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Закругленные углы
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2), // Тонкая граница
          width: 1,
        ),
      ),
      color: theme.colorScheme.surfaceContainerLow, // Цвет фона карточки
      child: Column(
        children: children,
      ),
    );
  }
}

/// ============================================================================
/// ЧТО НУЖНО ДОДЕЛАТЬ ДЛЯ ПОЛНОЦЕННОЙ ФУНКЦИОНАЛЬНОСТИ:
/// ============================================================================

/// 1. ИНТЕГРАЦИЯ С СИСТЕМОЙ УВЕДОМЛЕНИЙ
/// ----------------------------------------------------------------------------
/// 
/// Реализовать реальное управление уведомлениями через платформенные API:
/// 
/// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
/// 
/// final FlutterLocalNotificationsPlugin notificationsPlugin = 
///     FlutterLocalNotificationsPlugin();
/// 
/// void _handleNotificationSetting(bool enabled) async {
///   if (enabled) {
///     // Запрос разрешений и настройка уведомлений
///     final settings = await notificationsPlugin.requestPermission();
///     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
///       // Настройка каналов уведомлений
///     }
///   } else {
///     // Отключение уведомлений
///   }
/// }
/// 

/// 2. РЕАЛЬНОЕ УПРАВЛЕНИЕ ТЕМОЙ
/// ----------------------------------------------------------------------------
/// 
/// Интегрировать с провайдером темы (Provider, Bloc, Riverpod):
/// 
/// void _changeTheme(String themeMode) {
///   final themeProvider = context.read<ThemeProvider>();
///   switch (themeMode) {
///     case 'system':
///       themeProvider.setThemeMode(ThemeMode.system);
///       break;
///     case 'light':
///       themeProvider.setThemeMode(ThemeMode.light);
///       break;
///     case 'dark':
///       themeProvider.setThemeMode(ThemeMode.dark);
///       break;
///   }
/// }
/// 

/// 3. НАСТРОЙКИ АВТОЗАГРУЗКИ МЕДИА
/// ----------------------------------------------------------------------------
/// 
/// Добавить гранулярные настройки для разных типов медиа:
/// 
/// Map<String, dynamic> mediaSettings = {
///   'autoDownloadPhotos': true,
///   'autoDownloadVideos': false,
///   'autoDownloadDocuments': false,
///   'maxFileSize': 10, // в MB
///   'wifiOnly': true,
/// };
/// 

/// 4. НАСТРОЙКИ БЕЗОПАСНОСТИ И КОНФИДЕНЦИАЛЬНОСТИ
/// ----------------------------------------------------------------------------
/// 
/// Добавить раздел с настройками безопасности:
/// 
/// - Блокировка приложения (биометрия/пароль)
/// - Скрытие содержимого в уведомлениях
/// - Автоматическое удаление сообщений
/// - Очистка кэша
/// 

/// 5. УПРАВЛЕНИЕ АККАУНТАМИ
/// ----------------------------------------------------------------------------
/// 
/// Добавить настройки для управления подключенными аккаунтами:
/// 
/// - Переключение между аккаунтами
/// - Настройки синхронизации
/// - Управление сессиями
/// - Экспорт/импорт данных
/// 

/// 6. НАСТРОЙКИ СЕТИ И СИНХРОНИЗАЦИИ
/// ----------------------------------------------------------------------------
/// 
/// Добавить параметры работы с сетью:
/// 
/// - Использование прокси
/// - Режим экономии трафика
/// - Интервал синхронизации
/// - Настройки подключения к серверам
/// 

/// 7. РЕЗЕРВНОЕ КОПИРОВАНИЕ И ВОССТАНОВЛЕНИЕ
/// ----------------------------------------------------------------------------
/// 
/// Добавить функционал для бэкапа данных:
/// 
/// - Автоматическое резервное копирование
/// - Ручное создание бэкапов
/// - Восстановление из бэкапа
/// - Интеграция с облачными хранилищами
/// 

/// 8. ЯЗЫК И РЕГИОНАЛЬНЫЕ НАСТРОЙКИ
/// ----------------------------------------------------------------------------
/// 
/// Добавить поддержку нескольких языков:
/// 
/// - Выбор языка интерфейса
/// - Форматы даты и времени
/// - Региональные особенности
/// 

/// 9. НАСТРОЙКИ ДОСТУПНОСТИ
/// ----------------------------------------------------------------------------
/// 
/// Добавить функции доступности:
/// 
/// - Размер шрифта
/// - Высококонтрастный режим
/// - Озвучивание интерфейса
/// - Упрощенная навигация
/// 

/// 10. СТАТИСТИКА И ДИАГНОСТИКА
/// ----------------------------------------------------------------------------
/// 
/// Добавить информацию о работе приложения:
/// 
/// - Использование памяти
/// - Размер базы данных
/// - Статистика сети
/// - Логи ошибок
/// - Диагностические инструменты
/// 

/// 11. ОБНОВЛЕНИЕ ПРИЛОЖЕНИЯ
/// ----------------------------------------------------------------------------
/// 
/// Добавить проверку обновлений:
/// 
/// - Автопроверка обновлений
/// - Ручная проверка
/// - Канал обновлений (beta/stable)
/// - Changelog
/// 

/// 12. ЭКСПОРТ ДАННЫХ
/// ----------------------------------------------------------------------------
/// 
/// Добавить возможность экспорта:
/// 
/// - Экспорт истории чатов
/// - Экспорт медиафайлов
/// - Экспорт настроек
/// - Поддержка различных форматов
/// 

/// 13. ИНТЕГРАЦИЯ С ВНЕШНИМИ СЕРВИСАМИ
/// ----------------------------------------------------------------------------
/// 
/// Добавить настройки интеграций:
/// 
/// - Подключение облачных хранилищ
/// - Интеграция с календарем
/// - Синхронизация с контактами
/// - Веб-версия приложения
/// 

/// 14. РАСШИРЕННЫЕ НАСТРОЙКИ
/// ----------------------------------------------------------------------------
/// 
/// Добавить раздел для опытных пользователей:
/// 
/// - Настройки API
/// - Кастомные серверы
/// - Экспериментальные функции
/// - Режим разработчика
/// 

/// 15. ОБРАТНАЯ СВЯЗЬ И ПОДДЕРЖКА
/// ----------------------------------------------------------------------------
/// 
/// Добавить способы связи:
/// 
/// - Форма обратной связи
/// - FAQ и база знаний
/// - Поддержка пользователей
/// - Сообщение об ошибках
/// 

/// ВАЖНО: При добавлении новых настроек необходимо:
/// 1. Обновить модель настроек
/// 2. Добавить миграцию для существующих пользователей
/// 3. Обновить логику сохранения/загрузки
/// 4. Протестировать на разных платформах