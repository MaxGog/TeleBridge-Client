import 'package:flutter/material.dart';
import 'screens/chat_list_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/add_account_screen.dart';
import 'models/account.dart';

void main() => runApp(const MaterialGramClient());

class MaterialGramClient extends StatefulWidget {
  const MaterialGramClient({super.key});

  @override
  _MaterialGramClientState createState() => _MaterialGramClientState();
}

class _MaterialGramClientState extends State<MaterialGramClient> {
  List<Account> accounts = [];
  Account? currentAccount;

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MaterialGram',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: currentAccount == null
          ? AddAccountScreen(onAddAccount: _addAccount)
          : ChatListScreen(
              accounts: accounts,
              currentAccount: currentAccount!,
              onAccountChanged: _switchAccount,
              onAddAccount: _addAccount,
            ),
      routes: {
        '/chat': (context) => const ChatScreen(),
      },
    );
  }
}
