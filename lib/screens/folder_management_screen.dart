import 'package:flutter/material.dart';
import '../models/chat_folder.dart';

class FolderManagementScreen extends StatefulWidget {
  final List<ChatFolder> folders;
  final Function(String) onAddFolder;

  const FolderManagementScreen({super.key, required this.folders, required this.onAddFolder});

  @override
  _FolderManagementScreenState createState() => _FolderManagementScreenState();
}

class _FolderManagementScreenState extends State<FolderManagementScreen> {
  final TextEditingController _folderNameController = TextEditingController();

  void _addFolder() {
    if (_folderNameController.text.isNotEmpty) {
      widget.onAddFolder(_folderNameController.text);
      _folderNameController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Папка добавлена')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Управление папками')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _folderNameController,
                    decoration: const InputDecoration(
                      labelText: 'Название папки',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addFolder,
                  child: const Text('Добавить'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.folders.length,
              itemBuilder: (context, index) {
                final folder = widget.folders[index];
                return ListTile(
                  title: Text(folder.name),
                  trailing: folder.isDefault ? null : IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Логика удаления папки
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}