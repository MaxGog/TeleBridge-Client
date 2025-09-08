import 'package:flutter/material.dart';
import 'package:materialgramclient/screens/add_account_screen.dart';
import '../models/account.dart';

class ChatListScreen extends StatelessWidget {
  final List<Account> accounts;
  final Account currentAccount;
  final Function(Account) onAccountChanged;
  final Function(Account) onAddAccount;

  const ChatListScreen({super.key, 
    required this.accounts,
    required this.currentAccount,
    required this.onAccountChanged,
    required this.onAddAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MaterialGram'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddAccountScreen(onAddAccount: onAddAccount),
              ),
            ),
          ),
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
      body: ListView.builder(
        itemCount: 20, // Заглушка для чатов
        itemBuilder: (context, index) => ListTile(
          leading: const CircleAvatar(),
          title: Text('Чат ${index + 1}'),
          subtitle: Text('Последнее сообщение в чате ${index + 1}'),
          trailing: Text('12:${index % 60}'),
          onTap: () => Navigator.pushNamed(context, '/chat'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.edit),
      ),
    );
  }
}