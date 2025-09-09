import 'package:flutter/material.dart';
import 'screens/chat_list_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/add_account_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/folder_management_screen.dart';
import 'core/models/account.dart';
import 'core/models/chat_folder.dart';

void main() => runApp(MaterialGramClient());

/// Главный виджет приложения MaterialGramClient
/// Управляет состоянием всего приложения: аккаунтами, настройками, папками
class MaterialGramClient extends StatefulWidget {
  @override
  _MaterialGramClientState createState() => _MaterialGramClientState();
}

class _MaterialGramClientState extends State<MaterialGramClient> {
  // Список всех добавленных аккаунтов
  List<Account> accounts = [];
  
  // Текущий выбранный аккаунт (может быть null если аккаунтов нет)
  Account? currentAccount;
  
  // Список папок для организации чатов
  List<ChatFolder> folders = [
    ChatFolder(id: '1', name: 'Все чаты', isDefault: true),
    ChatFolder(id: '2', name: 'Личные', isDefault: false),
    ChatFolder(id: '3', name: 'Работа', isDefault: false),
  ];
  
  // ID текущей выбранной папки
  String currentFolderId = '1';
  
  // Настройки приложения с значениями по умолчанию
  Map<String, dynamic> appSettings = {
    'theme': 'system',           // Тема: system, dark, light
    'notificationEnabled': true, // Включены ли уведомления
    'mediaAutoDownload': true,   // Автозагрузка медиа
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MaterialGram',
      theme: _getTheme(), // Применяем текущую тему
      
      // УПРОЩЕННАЯ ЛОГИКА - убираем все сложные проверки
      // Определяем стартовый экран в зависимости от наличия аккаунтов
      home: currentAccount == null
          ? AddAccountScreen(onAddAccount: _addAccount) // Экран добавления аккаунта если нет текущего
          : ChatListScreen( // Основной экран списка чатов если аккаунт есть
              accounts: accounts,
              currentAccount: currentAccount!,
              onAccountChanged: _switchAccount,
              onAddAccount: _addAccount,
              folders: folders,
              currentFolderId: currentFolderId,
              onChangeFolder: _changeFolder,
              onAddFolder: _addFolder,
            ),
      
      // Маршруты для навигации между экранами
      routes: {
        '/chat': (context) => const ChatScreen(), // Экран чата
        '/settings': (context) => SettingsScreen( // Экран настроек
              settings: appSettings,
              onSettingsChanged: _updateSettings,
            ),
        '/folders': (context) => FolderManagementScreen( // Экран управления папками
              folders: folders,
              onAddFolder: _addFolder,
            ),
      },
    );
  }

  /// Добавляет новый аккаунт и устанавливает его как текущий
  void _addAccount(Account account) {
    setState(() {
      accounts.add(account);
      currentAccount = account;
    });
  }

  /// Переключает текущий аккаунт
  void _switchAccount(Account account) {
    setState(() {
      currentAccount = account;
    });
  }

  /// Изменяет текущую папку для отображения чатов
  void _changeFolder(String folderId) {
    setState(() {
      currentFolderId = folderId;
    });
  }

  /// Добавляет новую папку для организации чатов
  void _addFolder(String folderName) {
    setState(() {
      folders.add(ChatFolder(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Генерация уникального ID
        name: folderName,
        isDefault: false, // Новая папка не является папкой по умолчанию
      ));
    });
  }

  /// Обновляет настройки приложения
  void _updateSettings(Map<String, dynamic> newSettings) {
    setState(() {
      appSettings = newSettings;
    });
  }

  /// Возвращает тему приложения в зависимости от настроек
  ThemeData _getTheme() {
    switch (appSettings['theme']) {
      case 'dark':
        return ThemeData.dark(); // Темная тема
      case 'light':
        return ThemeData.light(); // Светлая тема
      default:
        return ThemeData.light(); // По умолчанию светлая тема
    }
  }
}