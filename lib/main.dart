import 'package:flutter/material.dart';
import 'screens/chat_list_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/add_account_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/folder_management_screen.dart';
import 'models/account.dart';
import 'models/chat_folder.dart';

void main() => runApp(MaterialGramClient());

class MaterialGramClient extends StatefulWidget {
  @override
  _MaterialGramClientState createState() => _MaterialGramClientState();
}

class _MaterialGramClientState extends State<MaterialGramClient> {
  List<Account> accounts = [];
  Account? currentAccount;
  List<ChatFolder> folders = [
    ChatFolder(id: '1', name: 'Все чаты', isDefault: true),
    ChatFolder(id: '2', name: 'Личные', isDefault: false),
    ChatFolder(id: '3', name: 'Работа', isDefault: false),
  ];
  String currentFolderId = '1';
  Map<String, dynamic> appSettings = {
    'theme': 'system',
    'notificationEnabled': true,
    'mediaAutoDownload': true,
  };

  void _addAccount(Account account) {
    setState(() {
      accounts.add(account);
      currentAccount ??= account;
    });
  }

  void _switchAccount(Account account) {
    setState(() {
      currentAccount = account;
    });
  }

  void _changeFolder(String folderId) {
    setState(() {
      currentFolderId = folderId;
    });
  }

  void _addFolder(String folderName) {
    setState(() {
      folders.add(ChatFolder(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: folderName,
        isDefault: false,
      ));
    });
  }

  void _updateSettings(Map<String, dynamic> newSettings) {
    setState(() {
      appSettings = newSettings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MaterialGram',
      theme: _getTheme(),
      home: currentAccount == null
          ? AddAccountScreen(onAddAccount: _addAccount)
          : ChatListScreen(
              accounts: accounts,
              currentAccount: currentAccount!,
              onAccountChanged: _switchAccount,
              onAddAccount: _addAccount,
              folders: folders,
              currentFolderId: currentFolderId,
              onChangeFolder: _changeFolder,
              onAddFolder: _addFolder,
            ),
      routes: {
        '/chat': (context) => ChatScreen(),
        '/settings': (context) => SettingsScreen(
              settings: appSettings,
              onSettingsChanged: _updateSettings,
            ),
        '/folders': (context) => FolderManagementScreen(
              folders: folders,
              onAddFolder: _addFolder,
            ),
      },
    );
  }

  ThemeData _getTheme() {
    switch (appSettings['theme']) {
      case 'dark':
        return ThemeData.dark();
      case 'light':
        return ThemeData.light();
      default:
        return ThemeData.light();
    }
  }
}