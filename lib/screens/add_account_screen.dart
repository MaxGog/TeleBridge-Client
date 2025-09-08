import 'package:flutter/material.dart';
import '../models/account.dart';

class AddAccountScreen extends StatefulWidget {
  final Function(Account) onAddAccount;

  AddAccountScreen({required this.onAddAccount});

  @override
  _AddAccountScreenState createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добавить аккаунт')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Имя аккаунта'),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Введите имя';
                  return null;
                },
              ),
              TextFormField(
                controller: _tokenController,
                decoration: const InputDecoration(labelText: 'Токен бота'),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Введите токен';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onAddAccount(Account(
                      token: _tokenController.text,
                      name: _nameController.text,
                    ));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Добавить аккаунт'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}