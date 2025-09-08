import 'package:flutter/material.dart';
import '../models/chat_folder.dart';

/// Экран управления папками чатов
/// Позволяет создавать, просматривать и удалять папки для организации чатов
class FolderManagementScreen extends StatefulWidget {
  final List<ChatFolder> folders; // Список существующих папок
  final Function(String) onAddFolder; // Колбэк для добавления новой папки

  const FolderManagementScreen({super.key, 
    required this.folders, 
    required this.onAddFolder
  });

  @override
  _FolderManagementScreenState createState() => _FolderManagementScreenState();
}

class _FolderManagementScreenState extends State<FolderManagementScreen> {
  final TextEditingController _folderNameController = TextEditingController(); // Контроллер для поля ввода названия папки
  final _formKey = GlobalKey<FormState>(); // Ключ для управления формой

  /// Добавление новой папки
  /// Валидирует форму и вызывает колбэк onAddFolder
  void _addFolder() {
    if (_formKey.currentState!.validate()) {
      widget.onAddFolder(_folderNameController.text); // Передаем название новой папки
      _folderNameController.clear(); // Очищаем поле ввода
      // Показываем уведомление об успешном добавлении
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

  /// Удаление папки с подтверждением
  /// Не позволяет удалять системные папки (isDefault = true)
  void _deleteFolder(int index) {
    final folder = widget.folders[index];
    if (!folder.isDefault) { // Проверяем, что папка не системная
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Удалить папку'),
          content: Text('Вы уверены, что хотите удалить папку "${folder.name}"?'),
          actions: [
            // Кнопка отмены
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            // Кнопка подтверждения удаления
            FilledButton(
              onPressed: () {
                // TODO: Реализовать логику удаления папки
                // widget.onDeleteFolder(folder.id); // Нужно добавить колбэк для удаления
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
                backgroundColor: Theme.of(context).colorScheme.error, // Красный цвет для опасного действия
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
          // Форма добавления новой папки
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
                  // Поле ввода названия папки
                  Expanded(
                    child: TextFormField(
                      controller: _folderNameController,
                      decoration: InputDecoration(
                        labelText: 'Название папки',
                        hintText: 'Введите название папки',
                        prefixIcon: Icon(Icons.folder, color: colorScheme.primary), // Иконка папки
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: colorScheme.surfaceVariant.withOpacity(0.4),
                      ),
                      style: TextStyle(color: colorScheme.onSurface),
                      validator: (value) {
                        // Валидация: поле не должно быть пустым
                        if (value?.isEmpty ?? true) return 'Введите название папки';
                        // Валидация: папка с таким именем не должна существовать
                        if (widget.folders.any((folder) => folder.name == value)) {
                          return 'Папка с таким названием уже существует';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Кнопка добавления папки
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

          // Заголовок списка папок с счетчиком
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
                // Бейдж с количеством папок
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

          // Список существующих папок
          Expanded(
            child: Material(
              color: colorScheme.surface,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: widget.folders.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  thickness: 1,
                  indent: 60, // Отступ для выравнивания с иконками
                  endIndent: 0,
                  color: colorScheme.outline.withOpacity(0.1),
                ),
                itemBuilder: (context, index) {
                  final folder = widget.folders[index];
                  return Dismissible(
                    key: Key(folder.id), // Уникальный ключ для анимации dismiss
                    direction: folder.isDefault ? DismissDirection.none : DismissDirection.endToStart, // Запрещаем свайп системных папок
                    background: Container(
                      color: colorScheme.error, // Красный фон при свайпе
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: Icon(
                        Icons.delete,
                        color: colorScheme.onError,
                        size: 24,
                      ),
                    ),
                    onDismissed: folder.isDefault ? null : (direction) => _deleteFolder(index), // Обработчик свайпа
                    confirmDismiss: folder.isDefault ? null : (direction) async {
                      // Диалог подтверждения удаления
                      return await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Удалить папку'),
                          content: Text('Вы уверены, что хотите удалить папку "${folder.name}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false), // Отмена
                              child: const Text('Отмена'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(context, true), // Подтверждение
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
                              ? colorScheme.primaryContainer // Особый цвет для системных папок
                              : colorScheme.surfaceVariant, // Обычный цвет для пользовательских
                        ),
                        child: Icon(
                          folder.isDefault ? Icons.favorite : Icons.folder, // Разные иконки
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
                              'Системная папка', // Подпись для системных папок
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            )
                          : null,
                      trailing: folder.isDefault
                          ? null // У системных папок нет кнопки удаления
                          : IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              onPressed: () => _deleteFolder(index), // Удаление по кнопке
                              tooltip: 'Удалить папку',
                            ),
                      onTap: () {
                        // TODO: Реализовать переход к редактированию папки или просмотру содержимого
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),

      // Информационная панель внизу экрана
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
                'Системные папки нельзя удалить.', // Поясняющий текст
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
    _folderNameController.dispose(); // Очистка контроллера
    super.dispose();
  }
}

/// ============================================================================
/// ЧТО НУЖНО ДОДЕЛАТЬ ДЛЯ ПОЛНОЦЕННОЙ ФУНКЦИОНАЛЬНОСТИ:
/// ============================================================================

/// 1. ДОБАВИТЬ КОЛБЭК ДЛЯ УДАЛЕНИЯ ПАПОК
/// ----------------------------------------------------------------------------
/// 
/// В текущем коде есть диалог подтверждения удаления, но нет реализации
/// самого удаления. Нужно:
/// 
/// class FolderManagementScreen extends StatefulWidget {
///   final Function(String) onDeleteFolder; // Добавить колбэк для удаления
/// 
///   const FolderManagementScreen({
///     required this.onDeleteFolder,
///     // ... остальные параметры
///   });
/// }
/// 
/// Затем в _deleteFolder вызывать:
/// widget.onDeleteFolder(folder.id);
/// 

/// 2. РЕАЛИЗОВАТЬ РЕДАКТИРОВАНИЕ ПАПОК
/// ----------------------------------------------------------------------------
/// 
/// Добавить возможность редактирования названия папок:
/// 
/// void _editFolder(int index) {
///   final folder = widget.folders[index];
///   showDialog(
///     context: context,
///     builder: (context) => AlertDialog(
///       title: Text('Редактировать папку'),
///       content: TextFormField(
///         controller: TextEditingController(text: folder.name),
///         // ... валидация
///       ),
///       actions: [
///         // Кнопки сохранить/отменить
///       ],
///     ),
///   );
/// }
/// 

/// 3. ДОБАВИТЬ ПЕРЕТАСКИВАНИЕ ДЛЯ ИЗМЕНЕНИЯ ПОРЯДКА ПАПОК
/// ----------------------------------------------------------------------------
/// 
/// Использовать ReorderableListView вместо ListView.separated:
/// 
/// ReorderableListView(
///   onReorder: (oldIndex, newIndex) {
///     // Логика изменения порядка
///     widget.onReorderFolders(oldIndex, newIndex);
///   },
///   children: [
///     // ... элементы с ключами
///   ],
/// )
/// 

/// 4. ИНТЕГРАЦИЯ С РЕАЛЬНЫМИ ДАННЫМИ TELEGRAM
/// ----------------------------------------------------------------------------
/// 
/// Связать папки с реальными фильтрами чатов в Telegram API:
/// 
/// - Добавить поле criteria для хранения критериев фильтрации
/// - Реализовать применение фильтров при выборе папки
/// - Синхронизировать с Telegram Folders API (если доступно)
/// 

/// 5. ДОБАВИТЬ ВОЗМОЖНОСТЬ ПЕРЕМЕЩЕНИЯ ЧАТОВ МЕЖДУ ПАПКАМИ
/// ----------------------------------------------------------------------------
/// 
/// Реализовать drag-and-drop чатов между папками
/// или контекстное меню для перемещения
/// 

/// 6. ДОБАВИТЬ ПОДДЕРЖКУ ИКОНОК ДЛЯ ПАПОК
/// ----------------------------------------------------------------------------
/// 
/// Расширить модель ChatFolder:
/// 
/// class ChatFolder {
///   final String icon; // или IconData
///   // ... остальные поля
/// }
/// 

/// 7. РЕАЛИЗОВАТЬ ЦВЕТОВЫЕ ТЕМЫ ДЛЯ ПАПОК
/// ----------------------------------------------------------------------------
/// 
/// Добавить возможность выбора цвета для пользовательских папок
/// 

/// 8. ДОБАВИТЬ ПОДСКАЗКИ И ВАЛИДАЦИЮ
/// ----------------------------------------------------------------------------
/// 
/// - Ограничение длины названия папки
/// - Запрещенные символы в названиях
/// - Подсказки при наведении
/// 

/// 9. РЕАЛИЗОВАТЬ ЭКСПОРТ/ИМПОРТ НАСТРОЕК ПАПОК
/// ----------------------------------------------------------------------------
/// 
/// Возможность сохранить и восстановить структуру папок
/// 

/// 10. ДОБАВИТЬ ПОДДЕРЖКУ ВЛОЖЕННЫХ ПАПОК
/// ----------------------------------------------------------------------------
/// 
/// Реализовать иерархическую структуру папок
/// 