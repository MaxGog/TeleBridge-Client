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
  final _formKey = GlobalKey<FormState>();

  void _addFolder() {
    if (_formKey.currentState!.validate()) {
      widget.onAddFolder(_folderNameController.text);
      _folderNameController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Папка добавлена'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _deleteFolder(int index) {
    final folder = widget.folders[index];
    if (!folder.isDefault) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Удалить папку'),
          content: Text('Вы уверены, что хотите удалить папку "${folder.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () {
                // Логика удаления папки
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Папка "${folder.name}" удалена'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Удалить'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Управление папками',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 3,
      ),
      body: Column(
        children: [
          // Форма добавления папки
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Form(
              key: _formKey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _folderNameController,
                      decoration: InputDecoration(
                        labelText: 'Название папки',
                        hintText: 'Введите название папки',
                        prefixIcon: Icon(Icons.folder, color: colorScheme.primary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: colorScheme.surfaceVariant.withOpacity(0.4),
                      ),
                      style: TextStyle(color: colorScheme.onSurface),
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Введите название папки';
                        if (widget.folders.any((folder) => folder.name == value)) {
                          return 'Папка с таким названием уже существует';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 56,
                    child: FilledButton(
                      onPressed: _addFolder,
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, size: 20),
                          SizedBox(width: 8),
                          Text('Добавить'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Заголовок списка папок
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              children: [
                Text(
                  'Мои папки',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.folders.length.toString(),
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Список папок
          Expanded(
            child: Material(
              color: colorScheme.surface,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: widget.folders.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  thickness: 1,
                  indent: 60,
                  endIndent: 0,
                  color: colorScheme.outline.withOpacity(0.1),
                ),
                itemBuilder: (context, index) {
                  final folder = widget.folders[index];
                  return Dismissible(
                    key: Key(folder.id),
                    direction: folder.isDefault ? DismissDirection.none : DismissDirection.endToStart,
                    background: Container(
                      color: colorScheme.error,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: Icon(
                        Icons.delete,
                        color: colorScheme.onError,
                        size: 24,
                      ),
                    ),
                    onDismissed: folder.isDefault ? null : (direction) => _deleteFolder(index),
                    confirmDismiss: folder.isDefault ? null : (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Удалить папку'),
                          content: Text('Вы уверены, что хотите удалить папку "${folder.name}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Отмена'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: FilledButton.styleFrom(
                                backgroundColor: colorScheme.error,
                              ),
                              child: const Text('Удалить'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: folder.isDefault
                              ? colorScheme.primaryContainer
                              : colorScheme.surfaceVariant,
                        ),
                        child: Icon(
                          folder.isDefault ? Icons.favorite : Icons.folder,
                          color: folder.isDefault
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSurfaceVariant,
                          size: 24,
                        ),
                      ),
                      title: Text(
                        folder.name,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      subtitle: folder.isDefault
                          ? Text(
                              'Системная папка',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            )
                          : null,
                      trailing: folder.isDefault
                          ? null
                          : IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              onPressed: () => _deleteFolder(index),
                              tooltip: 'Удалить папку',
                            ),
                      onTap: () {
                        // Действие при нажатии на папку
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),

      // Информационная панель
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant.withOpacity(0.3),
          border: Border(
            top: BorderSide(
              color: colorScheme.outline.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 20,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Создавайте папки для организации ваших чатов. '
                'Системные папки нельзя удалить.',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _folderNameController.dispose();
    super.dispose();
  }
}