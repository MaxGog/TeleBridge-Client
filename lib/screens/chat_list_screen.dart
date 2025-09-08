import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:materialgramclient/screens/add_account_screen.dart';
import '../models/account.dart';
import '../models/chat_folder.dart';

class ChatListScreen extends StatelessWidget {
  final List<Account> accounts;
  final Account currentAccount;
  final Function(Account) onAccountChanged;
  final Function(Account) onAddAccount;
  final List<ChatFolder> folders;
  final String currentFolderId;
  final Function(String) onChangeFolder;
  final Function(String) onAddFolder;

  const ChatListScreen({super.key, 
    required this.accounts,
    required this.currentAccount,
    required this.onAccountChanged,
    required this.onAddAccount,
    required this.folders,
    required this.currentFolderId,
    required this.onChangeFolder,
    required this.onAddFolder,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MaterialGram'),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder),
            onPressed: () => Navigator.pushNamed(context, '/folders'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddAccountScreen(onAddAccount: onAddAccount),
              ),
            ),
          ),
          if (accounts.isNotEmpty)
            PopupMenuButton<Account>(
              onSelected: onAccountChanged,
              itemBuilder: (BuildContext context) {
                return accounts.map((Account account) {
                  return PopupMenuItem<Account>(
                    value: account,
                    child: Text(account.name),
                  );
                }).toList();
              },
            ),
        ],
      ),
      body: Column(
        children: [
          if (folders.isNotEmpty)
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: folders.length,
                itemBuilder: (context, index) {
                  final folder = folders[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: ChoiceChip(
                      label: Text(folder.name),
                      selected: currentFolderId == folder.id,
                      onSelected: (selected) {
                        if (selected) {
                          onChangeFolder(folder.id);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) => ListTile(
                leading: const CircleAvatar(
                  // Добавьте проверку на существование ассета
                  child: Icon(Icons.person),
                ),
                title: Text('Чат ${index + 1}'),
                subtitle: Text('Последнее сообщение в чате ${index + 1}'),
                trailing: Text('12:${index % 60}'),
                onTap: () {
                  try {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(title: Text('Чат ${index + 1}')),
                          body: Center(child: Text('Содержимое чата ${index + 1}')),
                        ),
                      ),
                    );
                  } catch (e) {
                    if (kDebugMode) {
                      print('Ошибка навигации: $e');
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Не удалось открыть чат')),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}